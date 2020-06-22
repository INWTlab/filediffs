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

# Install packages
for PYBIN in /opt/python/*/bin/; do
    "${PYBIN}/pip" install filediffs --no-index -f /io/wheelhouse
done

# publish wheels
/opt/python/cp38-cp38/bin/pip install twine
/opt/python/cp38-cp38/bin/twine upload /io/wheelhouse/* --non-interactive --skip-existing

