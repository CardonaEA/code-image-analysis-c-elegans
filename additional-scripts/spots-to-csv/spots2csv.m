%=== parameters
parameters = struct;
parameters.size_xy = pixel_size_in_x_and_y;
parameters.size_z = pixel_size_in_z;
parameters.spots_in_img = mark_detected_spots_in_images;
parameters.detected_fitted = detected_or_fitted_positions;
parameters.pixels = pixels_to_mark_from_center;
identifiers = struct;
identifiers.image_files = image_files;
identifiers.spots_files = spots_files;
identifiers.spots_in_img = parameters.spots_in_img;

%=== select dir with results of FQ spot detection
[selected_files] = get_files_spots2csv(identifiers);

%=== spot files to csv
nspots = selected_files.nspots;
spots_table = cell(nspots,1);
disp(newline)
disp('generating csv tables...')
for j = 1 : nspots
    [spots_table{j}] = make_csv_table(selected_files,j);
end
disp('done...')

if parameters.spots_in_img
disp(newline)
disp('marking spots in images...')
nimages = selected_files.nimages;
if nspots == nimages
    for k = 1 : nimages
        mark_images(selected_files,k,spots_table,parameters);
    end
else
    disp(newline)
    disp('warning: number of spot files (.txt) is not equal to number of images (.tif)')
    disp('only csv tables were generated')
end
disp('done...')
end

if nspots > 1
disp(newline)
disp('generating merged table...')
table_to_save = [];
for i = 1 : nspots
    image_ids = table(repelem(string(selected_files.spot_files{i}(1:end-4)), size(spots_table{i},1))', 'VariableNames', {'Image'});
    table_id = [image_ids, spots_table{i}];
    table_to_save = [table_to_save; table_id];
end
writetable(table_to_save, [selected_files.folder selected_files.sep 'merged_spots_data' '.csv'])
disp('...done')
end