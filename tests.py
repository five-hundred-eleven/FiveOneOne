import unittest
from lambdata_ekoly.df_utils import *
import numpy as np
import pandas as pd


class TestSplit(unittest.TestCase):

    def setUp(self):
        self.test_df = pd.DataFrame({"zeros": np.zeros(100)})

    def testSplit(self):
        train, val, test = train_validate_test_split(self.test_df)
        assert len(train) == 60
        assert len(val) == 20
        assert len(test) == 20

    def testSplit_50_25_25(self):
        train, val, test = train_validate_test_split(self.test_df, train_size=0.5)
        assert len(train) == 50
        assert len(val) == 25
        assert len(test) == 25

