function parsave(fname, xStr,x)
    %eval([xStr, '= evalin(''base'', xStr);']);
    %save(fname, xStr)
    S.(xStr) = x;
    save(fname, '-struct', 'S')
end