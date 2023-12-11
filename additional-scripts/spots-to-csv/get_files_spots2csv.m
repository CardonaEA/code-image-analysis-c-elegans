function [selected_files] = get_files_spots2csv(identifiers)
%=== folder containing information to be analysed
disp(newline)
disp('select folder containing FQ txt files...')
data_spots.folder = uigetdir('select folder containing FQ txt files');
% root folder
data_spots.root = cd;
data_spots.sep = filesep;
cd(data_spots.folder)

%=== getting archives
% identifiers
spots_id  = identifiers.spots_files;
images_id = identifiers.image_files;
spots_in_image = identifiers.spots_in_img;

% getting taget files
spot_files  = dir(spots_id);   spot_files   = {spot_files.name};
% image_files = dir(images_id);  image_files  = {image_files.name};

% remove '.' and '..' files
data_spots.spot_files  = spot_files(~startsWith(spot_files,{'.','..','._'}));
% data_spots.image_files = image_files(~startsWith(image_files,{'.','..','._'}));

% number of spot files
data_spots.nspots = length(data_spots.spot_files);
data_spots.nimages = 0;

if spots_in_image
    % getting taget files
    image_files = dir(images_id);  image_files  = {image_files.name};
    % remove '.' and '..' files
    data_spots.image_files = image_files(~startsWith(image_files,{'.','..','._'}));
    % number of spot files
    data_spots.nimages = length(data_spots.image_files);
end

% back to working dir
cd(data_spots.root)

% out variable
selected_files = data_spots;

disp(newline)
disp('spot files: ')
disp(data_spots.spot_files')
if spots_in_image
    disp('image files: ')
    disp(data_spots.image_files')
end
disp(newline)
end