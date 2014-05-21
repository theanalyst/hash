# -*- coding: utf-8 -*-

import os
import sys


try:
    from setuptools import setup, find_packages
except ImportError:
    from distutils.core import setup

if sys.argv[-1] == 'publish':
    os.system('python setup.py sdist upload')
    sys.exit()

readme = open('README.rst').read()

setup(
    name='hash',
    version='0.1.0',
    description='Hy from AST',
    long_description=readme,
    author='Abhishek L',
    author_email='abhishek.lekshmanan@gmail.com',
    url='https://github.com/theanalyst/hash',
    packages= find_packages(exclude=['tests']),
    package_data = {
        'hash' : ['*.hy'],
    },
    install_requires=['hy >= 0.10.0', 'singledispatch >= 3.4'],
    license= "BSD",
    keywords='hash',
    classifiers=[
        'Development Status :: 3-Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        "Programming Language :: Lisp",
        "Programming Language :: Python :: 2",
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.3',
        'Programming Language :: Python :: 3.4',
    ],
)
