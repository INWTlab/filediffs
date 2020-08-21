# coding: utf-8
import os

from Cython.Build import cythonize
from setuptools import setup, find_packages, Extension
from setuptools.command.build_py import build_py

EXCLUDE_FILES = [os.path.join('filediffs', 'filediffs.py'),
                 os.path.join('filediffs', '__init__.py'),
                 os.path.join('filediffs', 'filediffs_script.py'),
                 os.path.join('filediffs', 'tests', '__init__.py'),
                 os.path.join('filediffs', 'tests', 'test_filediffs.py')]


def get_ext_paths(root_dir, exclude_files):
    """get filepaths for compilation"""
    paths = []

    for root, dirs, files in os.walk(root_dir):
        for filename in files:
            if os.path.splitext(filename)[1] != '.pyx':
                continue

            file_path = os.path.join(root, filename)
            if file_path in exclude_files:
                continue

            paths.append(file_path)
    return paths


def read(f):
    """Open a file"""
    return open(f, encoding='utf-8').read()


setup(
    name='filediffs',
    version='0.1.5',
    include_package_data=True,
    description="Separate two files into three files, each containing "
                "lines observed in both files/first file only/second file only. Programmed using Cython.",
    long_description=read('README.md'),
    author='Sebastian Cattes',
    author_email='sebastian.cattes@inwt-statistics.de',
    long_description_content_type="text/markdown",
    url='https://github.com/INWTlab/filediffs',
    packages=find_packages(),
    ext_modules=cythonize(Extension("filediffs",
                                    get_ext_paths('filediffs', EXCLUDE_FILES)),
                          compiler_directives={'language_level': 3}
                          ),
    cmdclass={'build_py': build_py},
    scripts=['bin/filediffs'],
    requires=['cython'],
    license='MIT',
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Intended Audience :: Developers',
        'Natural Language :: English',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.8',
    ],
)
