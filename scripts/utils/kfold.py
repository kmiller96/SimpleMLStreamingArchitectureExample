from sklearn.model_selection import KFold

from .preprocessing import Xy_split


def kfold(dataframe, n=5):
    """Initialises a KFold iterator to run model training on."""
    X, y = Xy_split(dataframe)
    kf = KFold(n_splits=n, shuffle=True)

    for train_index, test_index in kf.split(X, y):
        X_train, y_train = X.iloc[train_index], y.iloc[train_index]
        X_test, y_test = X.iloc[test_index], y.iloc[test_index]
        yield X_train, y_train, X_test, y_test
