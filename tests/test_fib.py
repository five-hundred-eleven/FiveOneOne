import unittest
from five_one_one.c import cfib, npfib

class test_fib(unittest.TestCase):

    def test_cfib_1(self):
        res = cfib(1)
        self.assertEqual(res, 1)

    def test_cfib_5(self):
        res = cfib(5)
        self.assertEqual(res, 5)

    def test_cfib_10(self):
        res = cfib(10)
        self.assertEqual(res, 55)

    def test_npfib_1(self):
        res = npfib(1)
        self.assertEqual(res[0], 1)

    def test_npfib_5(self):
        res = npfib(5)
        self.assertEqual(res[-1], 5)

    def test_npfib_10(self):
        res = npfib(10)
        self.assertEqual(res[-1], 55)
