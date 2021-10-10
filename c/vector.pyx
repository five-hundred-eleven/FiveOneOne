from libcpp cimport bool
from libcpp.vector cimport vector
from libcpp.algorithm cimport sort

cdef bool reverse_cmp(int i, int j):
    return i > j;


cdef class Vector:

    cdef vector[int] *vector_ptr;

    def __cinit__(self, *args):
        self.vector_ptr = new vector[int]();
        cdef unsigned i
        cdef int ix
        
        if len(args) == 0:
            pass
        elif len(args) == 1:
            other = args[0]
            for x in other:
                ix = x
                self.vector_ptr.push_back(ix)
        else:
            raise TypeError()


    def __dealloc__(self):
        del self.vector_ptr


    def __len__(self):
        return self.vector_ptr.size()


    def __getitem__(self, int i):
        if i < self.vector_ptr.size():
            return self.vector_ptr.at(i)
        else:
            raise IndexError()


    def __setitem__(self, int i, int x):
        if i < self.vector_ptr.size():
            self.vector_ptr.assign(i, x)
        else:
            raise IndexError()


    def append(self, int x):
        self.vector_ptr.push_back(x)


    def pop(self, *args):
        cdef int item, pos
        if len(args) == 0:
            if self.vector_ptr.size() > 0:
                item = self.vector_ptr.back()
                self.vector_ptr.pop_back()
                return item
            else:
                raise IndexError("pop from empty vector")
        elif len(args) == 1:
            pos = args[0]
            if self.vector_ptr.size() > pos:
                item = self.vector_ptr.at(pos)
                self.vector_ptr.erase(self.vector_ptr.begin()+pos)
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
        cdef int i = 0
        reversed.reserve(self.vector_ptr.size())
        while i < self.vector_ptr.size():
            reversed.assign(self.vector_ptr.size() - i - 1, self.vector_ptr.at(i))
            i += 1

        del self.vector_ptr
        self.vector_ptr = reversed


    def __str__(self):
        cdef int i = 0
        res = "["

        while i < self.vector_ptr.size():
            res += str(self.vector_ptr.at(i))
            res += ", "
            i += 1

        res += "]"

        return res


    def __repr__(self):
        return "Vector(" + str(self) + ")"


    def __iter__(self):
        return VectorIter(self)


class VectorIter:
    

    def __init__(self, v):
        self._vector = v
        self._i = 0


    def __next__(self):
        if self._i < len(self._vector):
            res = self._vector[self._i]
            self._i += 1
            return res
        else:
            raise StopIteration
