all:
	python setup.py sdist bdist_wheel

clean:
	rm -rf dist/ build/ *.egg-info .fuse_hidden*

reinstall:
	$(MAKE) clean
	$(MAKE)
	pip uninstall -y five-one-one
	pip install dist/five_one_one*.whl
