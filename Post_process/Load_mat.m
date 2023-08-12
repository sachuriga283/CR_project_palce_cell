function load_mat(Path)

arguments
Path 
end

File = dir(fullfile(Path,'*.mat'));
FileNames = {File.name}';
Length_Names = size(FileNames,1);

for i=1:Length_Names
    filename=strcat(Path, FileNames(i))
    load(filename{1,1})
end

end
