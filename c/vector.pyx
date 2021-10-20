from libcpp cimport bool
from libcpp.vector cimport vector
from libcpp.algorithm cimport sort

from math import ceil

cdef bool reverse_cmp_float(float i, float j):
    return i > j;


cdef class VectorIter:
    
    cdef vector[float] *_v
    cdef int _i

    def __cinit__(self):
        self._i = 0

    cdef void replace_internal(self, vector[float] *new_vector):
        self._v = new_vector

    def __next__(self):
        cdef int size = self._v.size()
        if self._i < size:
            res = self._v.at(self._i)
            self._i += 1
            return res
        else:
            raise StopIteration


cdef class Vector:

    cdef vector[float] *vector_ptr

    def __cinit__(self, *args, init_internal=True):
        cdef int size
        cdef float fx
        if init_internal:
            if len(args) == 0:
                self.vector_ptr = new vector[float]();
            elif len(args) == 1:
                try:
                    other = args[0]
                    size = len(other)
                    self.vector_ptr = new vector[float](size)
                    data = self.vector_ptr.data()
                    i = 0
                    for x in other:
                        fx = x
                        data[i] = fx
                        i += 1
                except TypeError:
                    self.vector_ptr = new vector[float]()
                    for x in other:
                        fx = x
                        self.vector_ptr.push_back(fx)
            else:
                raise TypeError()
        else:
            return


    def __setitem__(self, int i, float x):
        cdef int size = self.vector_ptr.size()
        cdef float *data = self.vector_ptr.data()
        if 0 <= i and i < size:
            data[i] = x
        elif -size <= i and i < 0:
            data[size+i] = x
        else:
            raise IndexError()


    def __dealloc__(self):
        del self.vector_ptr


    def __len__(self):
        return self.vector_ptr.size()


    def __iter__(self):
        v_i = VectorIter()
        v_i.replace_internal(self.vector_ptr)
        return v_i


    def __getitem__(self, i):

        cdef int size = self.vector_ptr.size()
        cdef vector[float] *new_ptr

        if type(i) is int:
            if 0 <= i and i < size:
                return self.vector_ptr.at(i)
            elif -size <= i and i < 0:
                return self.vector_ptr.at(size+i)
            else:
                raise IndexError()

        elif isinstance(i, slice):

            step = i.step if i.step is not None else 1

            if i.start is not None:
                start = i.start if i.start >= 0 else size+i.start
            elif step > 0:
                start = 0
            else: # step < 0
                start = size-1

            if i.stop is not None:
                stop = i.stop if i.stop >= 0 else size+i.stop
            elif step > 0:
                stop = size
            else: # step < 0
                stop = -1

            return self._slice(start, stop, step)

        elif isinstance(i, Vector):
            new_ptr = new vector[float]()
            for x, is_include in zip(self, i):
                if is_include != 0.:
                    new_ptr.push_back(x)
            v = Vector(init_internal=False)
            v.replace_internal(new_ptr)
            return v

        else:
            raise TypeError()


    def __str__(self):
        return str(list(self))


    def __repr__(self):
        return "Vector(" + str(self) + ")"


    cdef _slice(self, int start, int stop, int step):
        """
            Should be considered dangerous to call besides for in __getitem__.
        """
        cdef vector[float] *slice_ptr
        cdef int size = self.vector_ptr.size()

        if (
            0 <= start and
            start <= stop and
            stop <= size and
            step > 0
        ):
            slice_ptr = self._slice_pos_step(start, stop, step)
        elif (
            -1 <= stop and
            stop <= start and
            start < size and
            step < 0
        ):
            slice_ptr = self._slice_neg_step(start, stop, step)
        else:
            slice_ptr = self._slice_irregular(start, stop, step)

        slice_v = Vector(init_internal=False)
        slice_v.replace_internal(slice_ptr)
        return slice_v


    cdef vector[float] *_slice_pos_step(self, int start, int stop, int step):
        cdef float size_f = stop - start
        size_f /= step
        cdef int size_i = ceil(size_f)
        cdef vector[float] *slice_ptr = new vector[float](size_i)
        cdef float *data = slice_ptr.data()
        cdef int i, j
        i = 0
        j = start
        while j < stop:
            data[i] = self.vector_ptr.at(j)
            i += 1
            j += step
        return slice_ptr


    cdef vector[float] *_slice_neg_step(self, int start, int stop, int step):
        cdef float size_f = start - stop
        size_f /= -step
        cdef int size_i = ceil(size_f)
        cdef vector[float] *slice_ptr = new vector[float](size_i)
        cdef float *data = slice_ptr.data()
        cdef int i, j
        i = 0
        j = start
        while j > stop:
            data[i] = self.vector_ptr.at(j)
            i += 1
            j += step
        return slice_ptr


    cdef vector[float] *_slice_irregular(self, int start, int stop, int step):
        cdef vector[float] *slice_ptr = new vector[float]()
        cdef int i, size
        size = self.vector_ptr.size()
        if start < 0:
            i = 0
        elif start >= size:
            i = size-1
        else:
            i = start

        if step > 0 and start < stop:
            while i < stop:
                if 0 <= i and i < size:
                    slice_ptr.push_back(self.vector_ptr.at(i))
                else:
                    break
                i += step
            return slice_ptr
        elif step < 0 and start > stop:
            while i > stop:
                if 0 <= i and i < size:
                    slice_ptr.push_back(self.vector_ptr.at(i))
                else:
                    break
                i += step
            return slice_ptr
        else:
            return slice_ptr


    cdef void replace_internal(self, vector[float] *other):
        self.vector_ptr = other


    def pop(self, *args):
        cdef int pos, size
        cdef float item
        size = self.vector_ptr.size()
        if len(args) == 0:
            if size > 0:
                item = self.vector_ptr.back()
                self.vector_ptr.pop_back()
                return item
            else:
                raise IndexError("pop from empty vector")
        elif len(args) == 1:
            pos = args[0]
            if 0 <= pos and pos < size:
                item = self.vector_ptr.at(pos)
                self.vector_ptr.erase(self.vector_ptr.begin()+pos)
                return item
            elif -size <= pos and pos < 0:
                item = self.vector_ptr.at(size+pos)
                self.vector_ptr.erase(self.vector_ptr.begin()+size+pos)
                return item
            else:
                raise IndexError("pop index out of range")
        else:
            raise TypeError("pop expected at most 1 argument")


    def append(self, float x):
        self.vector_ptr.push_back(x)


    def extend(self, other):
        cdef int size, other_size, i
        cdef float *data, fx
        size = self.vector_ptr.size()
        try:
            other_size = len(other)
            self.vector_ptr.resize(size+other_size)
            data = self.vector_ptr.data()
            i = size
            for x in other:
                fx = x
                data[i] = fx
                i += 1
        except TypeError:
            for x in other:
                self.vector_ptr.push_back(x)


    def count(self, float x):
        cdef int i = 0
        cdef int size = self.vector_ptr.size()
        res = 0
        while i < size:
            if self.vector_ptr.at(i) == x:
                res += 1
            i += 1
        return res


    def index(self, float x):
        cdef unsigned i = 0
        while i < self.vector_ptr.size():
            if self.vector_ptr.at(i) == x:
                return i
            i += 1
        raise ValueError()


    def remove(self, float x):
        cdef unsigned i = 0
        while i < self.vector_ptr.size():
            if self.vector_ptr.at(i) == x:
                self.vector_ptr.erase(self.vector_ptr.begin()+i)
                return
            i += 1
        raise ValueError()


    def insert(self, int i, float x):
        cdef int size = self.vector_ptr.size()
        if 0 <= i and i <= size:
            self.vector_ptr.insert(self.vector_ptr.begin()+i, x)
        elif -size <= i and i < 0:
            self.vector_ptr.insert(self.vector_ptr.begin()+self.vector_ptr.size()+i, x)
        else:
            raise IndexError()


    def reverse(self):
        cdef int size = self.vector_ptr.size()
        cdef int i = 0
        cdef vector[float] *reversed_ptr = new vector[float](size)
        cdef float *reversed_data = reversed_ptr.data()
        while i < size:
            reversed_data[i] = self.vector_ptr.at(size-i-1)
            i += 1
        del self.vector_ptr
        self.vector_ptr = reversed_ptr


    def sort(self, reverse=False):
        if not reverse:
            sort(self.vector_ptr.begin(), self.vector_ptr.end())
        else:
            sort(self.vector_ptr.begin(), self.vector_ptr.end(), reverse_cmp_float)


    def clear(self):
        del self.vector_ptr
        self.vector_ptr = new vector[float]()

    
    def __eq__(self, other):
        cdef int i, size
        i = 0
        size = self.vector_ptr.size()
        cdef vector[float] *res = new vector[float](size)
        cdef float *data = res.data()

        v = Vector(init_internal=False)
        v.replace_internal(res)

        if hasattr(other, "__getitem__"):
            while i < size:
                data[i] = 1. if self[i] == other[i] else 0.
                i += 1
        elif type(other) in (float, int):
            while i < size:
                data[i] = 1. if self[i] == other else 0.
                i += 1

        return v
