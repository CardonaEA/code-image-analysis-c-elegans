function [s] = define_new_microscope_parameters
%=== user inputs
pixel_xy   = [];
pixel_z    = [];
emission   = [];
excitation = [];
aperture   = [];
refraction = [];
% microscope = [];

disp(newline)
disp('type pixel size in x and y')
while isempty(pixel_xy); pixel_xy = input('value in nm: '); end
disp(newline)
disp('type pixel size in z')
while isempty(pixel_z); pixel_z = input('value in nm: '); end
disp(newline)
disp('type emission peak')
while isempty(emission); emission = input('wavelength in nm: '); end
disp(newline)
disp('type excitation peak')
while isempty(excitation); excitation = input('wavelength in nm: '); end
disp(newline)
disp('type the numerical aperture (NA)')
while isempty(aperture); aperture = input('NA units: '); end
disp(newline)
disp('type the refraction index (RI)')
while isempty(refraction); refraction = input('RI units: '); end
disp(newline)
% disp('type the microscope used')
% while isempty(microscope); microscope = input('i.e.: widefield, confocal... : ','s'); end
disp('microscope is set to confocal')

%=== structure inputs
s = struct;
s.Em = emission;
s.Ex = excitation;
s.NA = aperture;
s.RI = refraction;
s.type = 'confocal';
s.Pixel.xy = pixel_xy;
s.Pixel.z = pixel_z;
end