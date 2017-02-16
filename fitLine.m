function w = fitLine(Y, X)


w = linsolve(X' * X, X' * Y);
