#include <Python.h>


static PyObject *_numpy = NULL;

static PyObject *method_cfib(PyObject *self, PyObject *args) {

    int x;

    // parse args
    if (!PyArg_ParseTuple(args, "i", &x)) {
        // normally you would have to set the error string (PyErr_SetString())
        // when returning NULL
        // In this case PyArg_ParseTuple() sets the error string
        return NULL;
    }

    if (x <= 2) {
        return PyLong_FromLong(1);
    }

    long a = 1, b = 1, tmp;
    for (int i = 2; i < x; i++) {
        tmp = b;
        b = a+b;
        a = tmp;
    }

    return PyLong_FromLong(b);

}

static PyObject *method_npfib(PyObject *self, PyObject *args) {

    if (_numpy == NULL) {
        _numpy = PyImport_ImportModuleNoBlock("numpy");
        if (_numpy == NULL) {
            PyErr_SetString(PyExc_ImportError, "Could not import numpy");
            return NULL;
        }
    }

    int x;

    if (!PyArg_ParseTuple(args, "i", &x)) {
        return NULL;
    }

    PyObject *builder = PyObject_CallMethod(_numpy, "zeros", "is", x, "int64");

    if (x >= 1) {
        PyObject_SetItem(builder, Py_BuildValue("i", 0), PyLong_FromLong(1));
    }

    if (x >= 2) {
        PyObject_SetItem(builder, Py_BuildValue("i", 1), PyLong_FromLong(1));
    }

    long a = 1, b = 1, tmp;
    for (int i = 2; i < x; i++) {

        tmp = b;
        b = a+b;
        a = tmp;

        PyObject_SetItem(builder, Py_BuildValue("i", i), PyLong_FromLong(b));

    }

    Py_DECREF(_numpy);

    return builder;

}

static PyMethodDef FputsMethods[] = {
    {"cfib", method_cfib, METH_VARARGS, "Fibonacci function that returns the xth element of the sequence, implemented in C.",},
    {"npfib", method_npfib, METH_VARARGS, "Fibonacci function that returns an np.array containing the sequence up to x, implemented in C."},
    {NULL, NULL, 0, NULL,},
};

static struct PyModuleDef fibmodule = {
    PyModuleDef_HEAD_INIT,
    "c",
    "Python interface for the fib C function.",
    -1,
    FputsMethods,
};

PyMODINIT_FUNC PyInit_c(void) {
    return PyModule_Create(&fibmodule);
}
