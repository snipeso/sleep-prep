function C = lz_complexity_bin(s)

    if ~ischar(s)
        s = num2str(s(:)');  % Convert to string
    end
    dict = containers.Map();
    w = '';
    c = 0;
    for i = 1:length(s)
        wc = [w s(i)];
        if ~isKey(dict, wc)
            c = c + 1;
            dict(wc) = true;
            w = '';
        else
            w = wc;
        end
    end
end
