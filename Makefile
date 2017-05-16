ve: requirements.txt
	test -d ve || virtualenv --python=python2.7 ve
	ve/bin/pip install -r requirements.txt
	touch ve
