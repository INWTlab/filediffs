# The `filediffs` package
[![Build Status](https://travis-ci.org/INWTlab/filediffs.svg?branch=master)](https://travis-ci.org/INWTlab/filediffs)

`filediffs` takes two files and separates them into 
1. lines found in both files
2. lines found only in file 1
3. lines found only in file 2

Code inspired by https://www.splinter.com.au/reconcilingcomparing-huge-data-sets-with-c/
and implemented using [Cython](https://cython.readthedocs.io/en/latest/)

Lines found in both files are not kept in memory but written to
 disk every 5.000.000 lines to preserve memory. 
 
This way, even very large files can be separated.
Only the diff has to fit in memory.


# 1. Installation
## 1.1 Pypi:
filediffs is available on [pypi](https://pypi.org/project/filediffs/) and can therefore be installed via pip
```
pip install filediffs
```
Currently, **only wheels for Linux** are build using [manylinux](https://github.com/pypa/manylinux).

On other OS, please install the package as described in the following section.

## 1.2 Github:
You can clone the package from Github and transpile the Cython code to C++ on
your machine. 

For Dependency management, [Pipenv](https://github.com/pypa/pipenv) is used.

The Pipfile defines the python version and package requirements.

You can create a virtual environment for the package with
Pipenv by 
1. installing pipenv `pip install pipenv`
2. calling `pipenv install` to install from Pipfile.lock

The file `setup.py` defines the cython build process.

The cpp files can be build using `pipenv run python setup.py build_ext --inplace`.


 # 2. Usage:
 ## 2.1 Interactive in Python
The `file_diffs` function requires two arguments, `filename_1` and `filename_2`, with the path to the files you wish to compare.

In addition, three optional output arguments can be passed to the functions, defining the output
files.

If the output arguments are not passed to the function, the output will be saved into 
the working directory.

```python
from filediffs.filediffs_python.filediffs import file_diffs
file_diffs(
    filename_1='path/to/file1.txt',
    filename_2='path/to/file2.txt',
    outpath_lines_present_in_both_files='output_path/to/lines_in_both.txt',
    outpath_lines_present_only_in_file1='output_path/to/lines_only_in_file1.txt',
    outpath_lines_present_only_in_file2='output_path/to/lines_only_in_file2.txt',
)
```

## 2.2 From the terminal
The `filediffs` package comes with a build in command line interface. This way it can be used to separate files from the terminal:
```shell script
# To separate two files, simply install the package with pip
pip install filediffs
# and call
filediffs path/to/file1.txt path/to/file2.txt

# If you want to define the filenames of the separated ouput files, optional arguments are provided for the script. 
filediffs path/to/file1.txt path/to/file2.txt --out_filename_both both_files.txt --out_filename_only_in_file1 file1_only.txt --out_filename_only_in_file2 file2_only.txt
```
