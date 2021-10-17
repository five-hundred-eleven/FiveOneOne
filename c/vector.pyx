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


    def slice(self, *args):
        cdef int i, j, size
        size = self.vector_ptr.size()
        if len(args) == 1:
            i = args[0]
            if 0 <= i and i < size:
                return self.vector_ptr.at(i)
            elif -size <= i and i < 0:
                return self.vector_ptr.at(size+i)
            else:
                raise IndexError()
        elif len(args) == 2:
            i = args[0] if args[0] is not None else 0
            j = args[1] if args[1] is not None else size
            if i < 0:
                i = size + i
            if j < 0:
                j = size + j
            if (
                0 <= i and
                i <= j and
                j <= size
            ):
                slice_v = Vector(init_internal=False)
                slice_v.replace_internal(self._slice_single_step(i, j))
                return slice_v
            else:
                slice_v = Vector(init_internal=False)
                slice_v.replace_internal(self._slice_irregular(i, j, 1))
                return slice_v
        elif len(args) == 3:

            step = args[2] if args[2] is not None else 1

            if args[0] is not None:
                i = args[0] if args[0] >= 0 else size+args[0]
            elif step > 0:
                i = 0
            else: # step < 0
                i = size

            if args[1] is not None:
                j = args[1] if args[1] >= 0 else size+args[1]
            elif step > 0:
                j = size
            else: # step < 0
                j = -1

            if (
                0 <= i and
                i <= j and
                j <= size and
                step > 0
            ):
                slice_v = Vector()
                slice_v.replace_internal(self._slice_pos_step(i, j, step))
                return slice_v
            elif (
                0 <= j and
                j <= i and
                i < size and
                step < 0
            ):
                slice_v = Vector()
                slice_v.replace_internal(self._slice_neg_step(i, j, step))
                return slice_v
            else:
                slice_v = Vector(init_internal=False)
                slice_v.replace_internal(self._slice_irregular(i, j, step))
                return slice_v


    cdef vector[int] *_slice_single_step(self, int start, int stop):
        cdef vector[int] *slice_ptr = new vector[int](stop - start)
        cdef int *data = slice_ptr.data()
        cdef int i = 0
        while start+i < stop:
            data[i] = self.vector_ptr.at(start+i)
            i += 1
        return slice_ptr


    cdef vector[int] *_slice_pos_step(self, int start, int stop, int step):
        cdef float size_f = start - stop
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
        size_f /= step
        cdef int size_i = ceil(size_f)
        cdef vector[int] *slice_ptr = new vector[int](size_i)
        cdef int *data = slice_ptr.data()
        cdef int i, j
        i = 0
        j = start
        while j > stop:
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
