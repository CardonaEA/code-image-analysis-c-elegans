function [csv_table] = make_csv_table(selected_files,idx)
%=== spots data
folder = selected_files.folder;
filename = selected_files.spot_files{idx};
sep = selected_files.sep;
pathfile = [folder sep filename];

%=== read txt file
T = fileread(pathfile);
%=== locate target info
spots_start = strfind(T,'SPOTS_START');
spots_end = strfind(T,'SPOTS_END');

%=== start and end of each table
spots_start_pos = length(sprintf('%s\n','SPOTS_START'));
% spots_end_pos = length(sprintf('\n%s','SPOTS_END'));
spots_end_pos = length(sprintf('\n'));

if length(spots_start) == length(spots_end)
spots_All = cell(length(spots_start),1);

for i = 1:length(spots_start)
  spots_All{i} = T(spots_start(i) + spots_start_pos : spots_end(i) - spots_end_pos);
  
  row_number = strfind(spots_All{i},sprintf('\n'));
  spots_data = sscanf(spots_All{i}(row_number(1) + 1 : end),'%f');
  
  headT = spots_All{i}(1:row_number(1)-1);
  headT_Array = split(headT,sprintf('\t'));
  nheads = length(headT_Array);
  
  if length(row_number)-1 == length(spots_data)/nheads
    spots_All{i} = [];
    Spots_Matrix = reshape(spots_data,nheads,[])'; 
    spots_All{i} = horzcat(repmat(i,[length(row_number)-1,1]),Spots_Matrix);
  else
    spots_All{i} = [];  
  end
end
else
error('something is wrong with the file: SPOTS_START diff from SPOTS_END')
end

array_data = cat(1,spots_All{:});
csv_table = array2table(array_data,'VariableNames',cat(1,'CELL_Oocyte', headT_Array)');
% writetable(csv_table,[folder sep filename(1:end-4) '_SPOTS' '.txt'],'FileType','text','Delimiter','tab')
writetable(csv_table,[folder sep filename(1:end-4) '_SPOTS' '.csv'])
end