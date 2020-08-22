#!/bin/bash
set -e -u -x


ls -al /opt/python/
rm -rf /opt/python/cp27-*
rm -rf /opt/python/cp35-*
ls -al /opt/python/


function repair_wheel {
    wheel="$1"
    if ! auditwheel show "$wheel"; then
        echo "Skipping non-platform wheel $wheel"
    else
        auditwheel repair "$wheel" --plat "$PLAT" -w /io/wheelhouse/
    fi
}


# Compile wheels
for PYBIN in /opt/python/*/bin; do
    "${PYBIN}/pip" wheel /io/ --no-deps -w wheelhouse/
done


# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    repair_wheel "$whl"
done

# Test install packages
for PYBIN in /opt/python/*/bin/; do
    # check if the package can be pip installed
    "${PYBIN}/pip" install filediffs --no-index -f /io/wheelhouse
    # run the tests for each python version.
    # prepare packages
    "${PYBIN}/pip" install pytest
    "${PYBIN}/pip" install pytest-cython
    "${PYBIN}/pip" install pipenv
    ls -al ${PYBIN}
    # set up pipenv environment
    # spawn pipenv shell
    cd /io/
    echo PYBIN=${PYBIN} >.env
    "${PYBIN}/pipenv" shell --python $PYBIN/python
    # install dependencies
    "${PYBIN}/pipenv" install --dev --skip-lock
    # build cython extensions
    "${PYBIN}/pipenv" run python setup.py build_ext --inplace
    # install filediffs package
    "${PYBIN}/pipenv" install -e . --skip-lock
    # run pytest
    "${PYBIN}/pipenv" run pytest filediffs/tests/test_filediffs.py --doctest-cython -v
    # clean up environment
    "${PYBIN}/pipenv" --rm

done

# publish
## install twine for publishing
#/opt/python/cp38-cp38/bin/pip install twine
#
## build source distribution and add it to the wheelhouse which contains all files that should be published
#/opt/python/cp38-cp38/bin/pip install 'cython==0.29.20'
#cd /io/
#/opt/python/cp38-cp38/bin/python /io/setup.py sdist
#cp /io/dist/* /io/wheelhouse/
#
## publish wheels to pypi
#/opt/python/cp38-cp38/bin/twine upload /io/wheelhouse/* --non-interactive --skip-existing

