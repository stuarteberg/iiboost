# The tests can only be run with Python 2
# (they depend on pickled test data that is incompatible with Python 3)
if python -c "import sys; sys.exit(0) if sys.version_info.major == 2 else sys.exit(1)"; then
    python python/tests/python_test_eigenvectorimage.py
    python python/tests/python_channels_test_class.py
    
    #python python/tests/python_test_raw.py
fi
