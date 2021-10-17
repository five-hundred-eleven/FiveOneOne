from libcpp cimport bool
from libcpp.vector cimport vector
from libcpp.algorithm cimport sort

from math import ceil

cdef bool reverse_cmp(int i, int j):
    return i > j;


cdef class VectorIter:
    
    cdef vector[int] *_v
    cdef int _i

    def __cinit__(self, ):
        self._i = 0

    cdef void replace_internal(self, vector[int] *new_vector):
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

    cdef vector[int] *vector_ptr;

    def __cinit__(self, *args, init_internal=True):
        cdef int ix
        if init_internal:
            self.vector_ptr = new vector[int]();
        else:
            return
        
        if len(args) == 0:
            return
        elif len(args) == 1:
            other = args[0]
            for x in other:
                ix = x
                self.vector_ptr.push_back(ix)
        else:
            raise TypeError()


    cdef void replace_internal(self, vector[int] *other):
        self.vector_ptr = other


    def __dealloc__(self):
        del self.vector_ptr


    def __len__(self):
        return self.vector_ptr.size()


    def __getitem__(self, int i):
        cdef int size = self.vector_ptr.size()
        if 0 <= i and i < size:
            return self.vector_ptr.at(i)
        elif -size <= i and i < 0:
            return self.vector_ptr.at(size+i)
        else:
            raise IndexError()


    def __setitem__(self, int i, int x):
        cdef int size = self.vector_ptr.size()
        cdef int *data = self.vector_ptr.data()
        if 0 <= i and i < size:
            data[i] = x
        elif -size <= i and i < 0:
            data[size+i] = x
        else:
            raise IndexError()


    def append(self, int x):
        self.vector_ptr.push_back(x)


    def pop(self, *args):
        cdef int item, pos, size
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


    def extend(self, other):
        for x in other:
            self.vector_ptr.push_back(x)


    def sort(self, reverse=False):
        if not reverse:
            sort(self.vector_ptr.begin(), self.vector_ptr.end())
        else:
            sort(self.vector_ptr.begin(), self.vector_ptr.end(), reverse_cmp)


    def reverse(self):
        cdef vector[int] *reversed = new vector[int]()
        cdef unsigned i = 0
        while i < self.vector_ptr.size():
            reversed.push_back(self.vector_ptr.at(self.vector_ptr.size() - i - 1))
            i += 1
        del self.vector_ptr
        self.vector_ptr = reversed


    def remove(self, int x):
        cdef unsigned i = 0
        while i < self.vector_ptr.size():
            if self.vector_ptr.at(i) == x:
                self.vector_ptr.erase(self.vector_ptr.begin()+i)
                return
            i += 1
        raise ValueError()


    def insert(self, int i, int x):
        cdef int size = self.vector_ptr.size()
        if 0 <= i and i <= size:
            self.vector_ptr.insert(self.vector_ptr.begin()+i, x)
        elif -size <= i and i < 0:
            self.vector_ptr.insert(self.vector_ptr.begin()+self.vector_ptr.size()+i, x)
        else:
            raise IndexError()


    def clear(self):
        del self.vector_ptr
        self.vector_ptr = new vector[int]()


    def count(self, int x):
        cdef unsigned i = 0
        res = 0
        while i < self.vector_ptr.size():
            if self.vector_ptr.at(i) == x:
                res += 1
            i += 1
        return res


    def index(self, int x):
        cdef unsigned i = 0
        while i < self.vector_ptr.size():
            if self.vector_ptr.at(i) == x:
                return i
            i += 1
        raise ValueError()


    def slice(self, start=None, stop=None, step=None):
        cdef int start_i, stop_i, step_i, size
        size = self.vector_ptr.size()

        step_i = step if step is not None else 1

        if start is not None:
            start_i = start if start >= 0 else size+start
        elif step_i > 0:
            start_i = 0
        else: # step_i < 0
            start_i = size-1

        if stop is not None:
            stop_i = stop if stop >= 0 else size+stop
        elif step_i > 0:
            stop_i = size
        else: # step_i < 0
            stop_i = -1

        if (
            0 <= start_i and
            start_i <= stop_i and
            stop_i <= size and
            step_i > 0
        ):
            slice_v = Vector()
            print("slice_pos_step", start_i, stop_i, step_i)
            slice_v.replace_internal(self._slice_pos_step(start_i, stop_i, step_i))
            return slice_v
        elif (
            -1 <= stop_i and
            stop_i <= start_i and
            start_i < size and
            step_i < 0
        ):
            slice_v = Vector()
            print("slice_neg_step", start_i, stop_i, step_i)
            slice_v.replace_internal(self._slice_neg_step(start_i, stop_i, step_i))
            return slice_v
        else:
            slice_v = Vector(init_internal=False)
            print("slice_irregular", start_i, stop_i, step_i)
            slice_v.replace_internal(self._slice_irregular(start_i, stop_i, step_i))
            return slice_v


    cdef vector[int] *_slice_pos_step(self, int start, int stop, int step):
        cdef float size_f = stop - start
        size_f /= step
        cdef int size_i = ceil(size_f)
        cdef vector[int] *slice_ptr = new vector[int](size_i)
        cdef int *data = slice_ptr.data()
        cdef int i, j
        i = 0
        j = start
        while j < stop:
            data[i] = self.vector_ptr.at(j)
            i += 1
            j += step
        return slice_ptr


    cdef vector[int] *_slice_neg_step(self, int start, int stop, int step):
        cdef float size_f = start - stop
        size_f /= -step
        cdef int size_i = ceil(size_f)
        print(size_i)
        cdef vector[int] *slice_ptr = new vector[int](size_i)
        cdef int *data = slice_ptr.data()
        cdef int i, j
        i = 0
        j = start
        while j > stop:
            print(i, j)
            data[i] = self.vector_ptr.at(j)
            i += 1
            j += step
        return slice_ptr

    cdef vector[int] *_slice_irregular(self, int start, int stop, int step):
        cdef vector[int] *slice_ptr = new vector[int]()
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


    def __str__(self):
        return str(list(self))


    def __repr__(self):
        return "Vector(" + str(self) + ")"


    def __iter__(self):
        v_i = VectorIter()
        v_i.replace_internal(self.vector_ptr)
        return v_i
