all:
	python setup.py sdist bdist_wheel

clean:
	rm -rf dist/ build/ *.egg-info .fuse_hidden*
