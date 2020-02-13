"""
lambdata - a collection of data science helper functions for lambda school
"""
import setuptools

REQUIRED = [
    "numpy",
    "pandas",
    "spacy",
]

with open("README.md", "r") as fh:
    LONG_DESCRIPTION = fh.read()

setuptools.setup(
    name="five-one-one",
    version = "0.2.0",
    author = "ekoly",
    description = "a collection of data science helper functions",
    long_description = LONG_DESCRIPTION,
    long_description_content_type="text/markdown",
    url="https://datascience.stromsy.com/",
    packages=setuptools.find_packages(),
    python_requires=">=3.5",
    install_requires = REQUIRED,
    classifiers=["Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ]
)
