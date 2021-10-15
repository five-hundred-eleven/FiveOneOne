import unittest

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
