#include <Python.h>

static PyObject *method_cfib(PyObject *self, PyObject *args) {

    int x;

    // parse args
    if (!PyArg_ParseTuple(args, "i", &x)) {
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

static PyMethodDef FputsMethods[] = {
    {"cfib", method_cfib, METH_VARARGS, "Fibonacci function implemented in C.",},
    {NULL, NULL, 0, NULL,},
};

static struct PyModuleDef fibmodule = {
    PyModuleDef_HEAD_INIT,
    "cfib",
    "Python interface for the fib C function.",
    -1,
    FputsMethods,
};

PyMODINIT_FUNC PyInit_cfib(void) {
    return PyModule_Create(&fibmodule);
}
