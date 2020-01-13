"""
lamdata - a collection of data science helper functions
"""

import pandas as pd
import numpy as np

ONES = pd.DataFrame(np.ones(50))
ZEROS = pd.DataFrame(np.zeros(50))
NANS = pd.DataFrame([np.NaN for _ in range(50)])
