from iiboost import  computeEigenVectorsOfHessianImage
from sklearn.externals import joblib    # to load data

import numpy as np

# to show something
import matplotlib.pyplot as plt

# load data
from os.path import split, join
data_dir = join(split(__file__)[0], '../../testData')
gt = joblib.load(data_dir + "/gt.jlb")
img = joblib.load(data_dir + "/img.jlb")

# compute eigen vector image
eigenvectors = computeEigenVectorsOfHessianImage(gt, zAnisotropyFactor=1.0, sigma=1.0)
