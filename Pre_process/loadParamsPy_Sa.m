function S = loadParamsPy_Sa(fn)
% ...

fid = fopen(fn, 'r');
mcFileMeta = textscan(fid, '%s%s', 'Delimiter', '=');%,  'ReturnOnError', false);
fclose(fid);
csName = mcFileMeta{1};
csValue = mcFileMeta{2};
S = struct();
for i=1:numel(csName)
    vcName1 = csName{i};
    if vcName1(1) == '~', vcName1(1) = []; end
    try
        vcValue = csValue{i};
        if startsWith(vcValue, 'r''') || startsWith(vcValue, 'r"')
            % Handle raw strings
            vcValue = extractBetween(vcValue, 2, length(vcValue));
        elseif vcValue(1) == ''''
            % Handle normal strings
            eval(sprintf('%s = %s;', vcName1, vcValue));
        else
            eval(sprintf('%s = ''%s'';', vcName1, vcValue));
        end
        eval(sprintf('num = str2double(%s);', vcName1));
        if ~isnan(num)
            eval(sprintf('%s = num;', vcName1));
        end
        eval(sprintf('S = setfield(S, ''%s'', %s);', vcName1, vcName1));
    catch
        fprintf('%s = %s error\n', csName{i}, vcValue);
    end
end

% ...
end