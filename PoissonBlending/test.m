X = 1:100;
Y = sin(X.*X/500);
plot(Y)

dY = Y(2:100) - Y(1:99);
% plot(X(1:99), dY)
Y1 = Y(1);
