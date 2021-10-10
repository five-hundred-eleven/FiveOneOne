"""
A collection of utility functions
"""
import setuptools
from Cython.Build import cythonize

REQUIRED = [
    "beautifulsoup4",
    "numpy",
    "pandas",
    "scikit-learn",
    "spacy",
]

with open("README.md", "r") as f:
    LONG_DESCRIPTION = f.read()

setuptools.setup(
    name="five-one-one",
    version="1.6.11",
    author="ecowley",
    author_email="erik@stromsy.com",
    description="a collection of data science helper functions",
    long_description=LONG_DESCRIPTION,
    long_description_content_type="text/markdown",
    url="https://datascience.stromsy.com",
    packages=[
        "five_one_one",
    ],
    package_dir={
        "five_one_one": "source",
    },
    ext_modules=[
        setuptools.Extension(
            "five_one_one.c",
            ["c/pyfib.c",],
        ),
    ] + cythonize([
        setuptools.Extension(
            "five_one_one.wrapper",
            ["c/vector.pyx",],
            language="c++",
        )
    ]),
    python_requires=">=3.7",
    install_requires=REQUIRED,
    classifiers=["Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ]
)
