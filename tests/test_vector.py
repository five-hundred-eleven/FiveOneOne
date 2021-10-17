import unittest
import random

from five_one_one.wrapper import Vector


class test_vector(unittest.TestCase):
    def assertVectorEqual(self, v1, v2):
        for m, n in zip(v1, v2):
            self.assertEqual(m, n)

    def test_init_no_args(self):
        v = Vector()

    def test_init_1_arg(self):
        v = Vector([1, 2, 3])

    def test_init_2_arg_raises_TypeError(self):
        with self.assertRaises(TypeError):
            v = Vector("foo", "bar")

    def test_len_0(self):
        v = Vector()
        self.assertEqual(len(v), 0)

    def test_len_5(self):
        l = list(range(5))
        v = Vector(l)
        self.assertEqual(len(v), 5)

    def test_getitem_0(self):
        l = list(range(5))
        v = Vector(l)
        self.assertEqual(v[0], 0)

    def test_getitem_1(self):
        l = list(range(5))
        v = Vector(l)
        self.assertEqual(v[1], 1)

    def test_getitem_neg_1(self):
        l = list(range(5))
        v = Vector(l)
        self.assertEqual(v[-1], 4)

    def test_getitem_neg_5(self):
        l = list(range(5))
        v = Vector(l)
        self.assertEqual(v[-5], 0)

    def test_getitem_out_of_range_neg_6(self):
        l = list(range(5))
        v = Vector(l)
        with self.assertRaises(IndexError):
            _ = v[-6]

    def test_setitem_0(self):
        l = list(range(5))
        v = Vector(l)
        v[0] = 99
        self.assertEqual(v[0], 99)

    def test_setitem_neg_1(self):
        l = list(range(5))
        v = Vector(l)
        v[-1] = 99
        self.assertEqual(v[-1], 99)

    def test_setitem_out_of_range_neg_6(self):
        l = list(range(5))
        v = Vector(l)

        with self.assertRaises(IndexError):
            v[-6] = 99

    def test_setitem_out_of_range_5(self):
        l = list(range(5))
        v = Vector(l)

        with self.assertRaises(IndexError):
            v[5] = 99

    def test_append_to_empty_vector(self):
        v = Vector()
        v.append(5)
        self.assertEqual(v[-1], 5)

    def test_append_multiple(self):
        v = Vector()
        for _ in range(100):
            v.append(5)
        self.assertTrue(all(x == 5 for x in v))

    def test_pop_1_el(self):
        v = Vector([1])
        res = v.pop()
        self.assertEqual(res, 1)
        self.assertEqual(len(v), 0)

    def test_pop_2_el(self):
        v = Vector([1, 2])
        res = v.pop()
        self.assertEqual(res, 2)
        self.assertEqual(len(v), 1)

    def test_pop_from_empty_list(self):
        v = Vector()
        with self.assertRaises(IndexError):
            v.pop()

    def test_pop_multiple_args(self):
        v = Vector
        with self.assertRaises(TypeError):
            v.pop("foo", "bar")

    def test_pop_1_pos_arg(self):
        v = Vector([1, 2, 3])
        res = v.pop(1)
        self.assertEqual(res, 2)
        self.assertEqual(len(v), 2)

    def test_pop_1_neg_arg(self):
        v = Vector([1, 2, 3])
        res = v.pop(-1)
        self.assertEqual(res, 3)
        self.assertEqual(len(v), 2)

    def test_pop_out_of_range(self):
        v = Vector([1, 2, 3])
        with self.assertRaises(IndexError):
            v.pop(5)

    def test_extend_empty_vector_empty_arg(self):
        v = Vector()
        v.extend([])
        self.assertEqual(len(v), 0)

    def test_extend_size_5(self):
        l = list(range(5))
        v = Vector(l)
        ext = list(range(5, 10))
        l.extend(ext)
        v.extend(ext)
        self.assertVectorEqual(v, l)

    def test_extend_size_5_empty_arg(self):
        l = list(range(5))
        v = Vector(l)
        ext = []
        l.extend(ext)
        v.extend(ext)
        self.assertVectorEqual(v, l)

    def test_extend_empty_size_5_arg(self):
        l = list()
        v = Vector(l)
        ext = list(range(5))
        l.extend(ext)
        v.extend(ext)
        self.assertVectorEqual(v, l)

    def test_extend_arg_vector(self):
        l = list(range(5))
        v = Vector(l)
        ext = Vector(range(5, 10))
        v.extend(ext)
        self.assertEqual(len(v), 10)

    def test_sort_empty_vector(self):
        l = []
        v = Vector(l)
        l.sort()
        v.sort()
        self.assertVectorEqual(v, l)

    def test_sort_size_5_vector(self):
        l = [random.randint(0, 100) for _ in range(5)]
        v = Vector(l)
        l.sort()
        v.sort()
        self.assertVectorEqual(v, l)

    def test_sort_size_1000_vector(self):
        l = [random.randint(0, 100) for _ in range(1000)]
        v = Vector(l)
        l.sort()
        v.sort()
        self.assertVectorEqual(v, l)

    def test_sort_reverse(self):
        l = [random.randint(0, 100) for _ in range(1000)]
        v = Vector(l)
        l.sort(reverse=True)
        v.sort(reverse=True)
        self.assertVectorEqual(v, l)

    def test_reverse_empty_vector(self):
        l = []
        v = Vector(l)
        l.reverse()
        v.reverse()
        self.assertVectorEqual(v, l)

    def test_reverse_size_1000(self):
        l = [random.randint(0, 100) for _ in range(1000)]
        v = Vector(l)
        l.reverse()
        v.reverse()
        self.assertVectorEqual(v, l)

    def test_remove_empty_vector_raises_ValueError(self):
        l = []
        v = Vector(l)
        with self.assertRaises(ValueError):
            v.remove(511)

    def test_remove_missing_value_raises_ValueError(self):
        l = [1, 2, 3, 4, 5]
        v = Vector(l)
        with self.assertRaises(ValueError):
            v.remove(511)

    def test_remove_first_value(self):
        l = [1, 2, 3, 4, 5]
        v = Vector(l)
        l.remove(1)
        v.remove(1)
        self.assertVectorEqual(v, l)

    def test_remove_last_value(self):
        l = [1, 2, 3, 4, 5]
        v = Vector(l)
        l.remove(5)
        v.remove(5)
        self.assertVectorEqual(v, l)

    def test_remove_middle_value(self):
        l = [1, 2, 3, 4, 5]
        v = Vector(l)
        l.remove(3)
        v.remove(3)
        self.assertVectorEqual(v, l)

    def test_remove_multiple(self):
        l = [3, 1, 2, 3, 4, 5]
        v = Vector(l)
        l.remove(3)
        v.remove(3)
        self.assertVectorEqual(v, l)
        l.remove(3)
        v.remove(3)
        self.assertVectorEqual(v, l)

    def test_insert_into_empty_vector_raises_IndexError(self):
        l = []
        v = Vector(l)

        with self.assertRaises(IndexError):
            v.insert(99, 0)

    def test_insert_out_of_range_raises_IndexError(self):
        l = [1, 2, 3, 4, 5]
        v = Vector(l)

        with self.assertRaises(IndexError):
            v.insert(6, 5)

    def test_insert_neg_one(self):
        l = [1, 2, 3, 4, 5]
        v = Vector(l)
        l.insert(-1, 99)
        v.insert(-1, 99)
        self.assertVectorEqual(l, v)

    def test_insert_neg_five(self):
        l = [1, 2, 3, 4, 5]
        v = Vector(l)
        l.insert(-5, 99)
        v.insert(-5, 99)
        self.assertVectorEqual(l, v)

    def test_insert_0(self):
        l = [1, 2, 3, 4, 5]
        v = Vector(l)
        l.insert(0, 99)
        v.insert(0, 99)
        self.assertVectorEqual(l, v)

    def test_insert_5(self):
        l = [1, 2, 3, 4, 5]
        v = Vector(l)
        l.insert(5, 99)
        v.insert(5, 99)
        self.assertVectorEqual(l, v)

    def test_clear(self):
        l = [1, 2, 3, 4, 5]
        v = Vector(l)
        l.clear()
        v.clear()
        self.assertVectorEqual(l, v)

    def test_count_0(self):
        l = [1, 2, 3, 4, 5]
        v = Vector(l)
        self.assertEqual(l.count(99), v.count(99))

    def test_count_1(self):
        l = [1, 2, 3, 4, 5]
        v = Vector(l)
        self.assertEqual(l.count(3), v.count(3))

    def test_count_5(self):
        l = [1, 1, 1, 1, 1]
        v = Vector(l)
        self.assertEqual(l.count(1), v.count(1))

    def test_index_no_value_raises_ValueError(self):
        l = list(range(5))
        v = Vector(l)
        with self.assertRaises(ValueError):
            v.index(99)

    def test_index_1st_value(self):
        l = list(range(5))
        v = Vector(l)
        self.assertEqual(l.index(0), v.index(0))

    def test_index_last_value(self):
        l = list(range(5))
        v = Vector(l)
        self.assertEqual(l.index(4), v.index(4))

    def test_index_multi_values(self):
        l = [1, 3, 1, 3, 1, 3]
        v = Vector(l)
        self.assertEqual(l.index(3), v.index(3))

    def test_slice_out_of_range_raises_IndexError(self):
        l = []
        v = Vector(l)
        with self.assertRaises(IndexError):
            v.slice(33)

    def test_slice_1_arg(self):
        l = list(range(10))
        v = Vector(l)
        self.assertEqual(l[5], v.slice(5))

    def test_slice_1_arg_9(self):
        l = list(range(10))
        v = Vector(l)
        self.assertEqual(l[9], v.slice(9))

    def test_slice_1_neg_arg_1(self):
        l = list(range(10))
        v = Vector(l)
        self.assertEqual(l[-1], v.slice(-1))

    def test_slice_1_neg_arg_5(self):
        l = list(range(10))
        v = Vector(l)
        self.assertEqual(l[-5], v.slice(-5))

    def test_slice_1_neg_arg_10(self):
        l = list(range(10))
        v = Vector(l)
        self.assertEqual(l[-10], v.slice(-10))

    def test_slice_3_6_1(self):
        l = list(range(100))
        v = Vector(l)
        i, j = 3, 6
        self.assertVectorEqual(l[i:j], v.slice(i, j))

    def test_slice_neg_6_6_1(self):
        l = list(range(10))
        v = Vector(l)
        i, j = -6, 6
        self.assertVectorEqual(l[i:j], v.slice(i, j))

    def test_slice_neg_6_neg_3_1(self):
        l = list(range(10))
        v = Vector(l)
        i, j = -6, -3
        self.assertVectorEqual(l[i:j], v.slice(i, j))

    def test_slice_3_30_2(self):
        l = list(range(100))
        v = Vector(l)
        i, j, k = 3, 30, 2
        l_slice = l[i:j:k]
        v_slice = v.slice(i, j, k)
        print(l_slice, v_slice)
        self.assertVectorEqual(l_slice, v_slice)

    def test_slice_neg_60_60_2(self):
        l = list(range(100))
        v = Vector(l)
        i, j, k = -60, 60, 2
        self.assertVectorEqual(l[i:j:k], v.slice(i, j, k))

    def test_slice_60_30_neg_2(self):
        l = list(range(100))
        v = Vector(l)
        i, j, k = 60, 30, -2
        self.assertVectorEqual(l[i:j:k], v.slice(i, j, k))

    def test_slice_neg_105_neg_95_2(self):
        l = list(range(100))
        v = Vector(l)
        i = -105
        j = -95
        k = 2
        self.assertVectorEqual(l[i:j:k], v.slice(i, j, k))

    def test_slice_105_95_neg_1(self):
        l = list(range(100))
        v = Vector(l)
        i = 105
        j = 95
        k = -1
        self.assertVectorEqual(l[i:j:k], v.slice(i, j, k))

    def test_slice_105_95_1(self):
        l = list(range(100))
        v = Vector(l)
        i = 105
        j = 95
        k = 1
        self.assertVectorEqual(l[i:j:k], v.slice(i, j, k))

    def test_slice_None_None_3(self):
        l = list(range(100))
        v = Vector(l)
        k = 3
        self.assertVectorEqual(l[::k], v.slice(None, None, k))

    def test_slice_None_50(self):
        l = list(range(100))
        v = Vector(l)
        i = None
        j = 50
        self.assertVectorEqual(l[i:j], v.slice(i, j))

    def test_slice_neg_50_None(self):
        l = list(range(100))
        v = Vector(l)
        i = -50
        j = None
        self.assertVectorEqual(l[i:j], v.slice(i, j))

    def test_slice_None_neg_50(self):
        l = list(range(100))
        v = Vector(l)
        i = None
        j = -50
        self.assertVectorEqual(l[i:j], v.slice(i, j))

    def test_slice_50_None(self):
        l = list(range(100))
        v = Vector(l)
        i = 50
        j = None
        self.assertVectorEqual(l[i:j], v.slice(i, j))

    def test_slice_None_50_neg_5(self):
        l = list(range(100))
        v = Vector(l)
        i = None
        j = 50
        k = -5
        self.assertVectorEqual(l[i:j:k], v.slice(i, j, k))

    def test_slice_neg_50_None_neg_5(self):
        l = list(range(100))
        v = Vector(l)
        i = -50
        j = None
        k = -5
        self.assertVectorEqual(l[i:j:k], v.slice(i, j, k))

    def test_slice_None_neg_50_neg_5(self):
        l = list(range(100))
        v = Vector(l)
        i = None
        j = -50
        k = -5
        self.assertVectorEqual(l[i:j:k], v.slice(i, j, k))

    def test_slice_50_None_neg_5(self):
        l = list(range(100))
        v = Vector(l)
        i = 50
        j = None
        k = -5
        self.assertVectorEqual(l[i:j:k], v.slice(i, j, k))

    def test_slice_None_50_5(self):
        l = list(range(100))
        v = Vector(l)
        i = None
        j = 50
        k = 5
        self.assertVectorEqual(l[i:j:k], v.slice(i, j, k))

    def test_slice_neg_50_None_5(self):
        l = list(range(100))
        v = Vector(l)
        i = -50
        j = None
        k = 5
        self.assertVectorEqual(l[i:j:k], v.slice(i, j, k))

    def test_slice_None_neg_50_5(self):
        l = list(range(100))
        v = Vector(l)
        i = None
        j = -50
        k = 5
        self.assertVectorEqual(l[i:j:k], v.slice(i, j, k))

    def test_slice_50_None_5(self):
        l = list(range(100))
        v = Vector(l)
        i = 50
        j = None
        k = 5
        self.assertVectorEqual(l[i:j:k], v.slice(i, j, k))

    def test_slice_105_90_neg_3(self):
        l = list(range(100))
        v = Vector(l)
        i = 105
        j = 90
        k = -3
        self.assertVectorEqual(l[i:j:k], v.slice(i, j, k))

    def test_str_empty_vector(self):
        l = []
        v = Vector(l)
        self.assertEqual(str(l), str(v))

    def test_str_size_5_vector(self):
        l = [1, 2, 3, 4, 5]
        v = Vector(l)
        self.assertEqual(str(l), str(v))
