function p_hat = fitGeometric(y,x)

errors = [];
p_range = 0:0.01:1;
for p = p_range
    y_p = geopdf(x, p);
    errors = [errors, norm(y_p - y);];
end

p_hat = p_range(find(errors == min(errors)));