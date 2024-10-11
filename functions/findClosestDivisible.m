function result = findClosestDivisible(a, b)
    r = mod(a, b);
    if r == 0
        result = a;
    else
        
        %if r <= b / 2
            result = a - r;
        %else
            result = a + (b - r);
        %end
    end
end