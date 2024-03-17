function [condensate_val, result, integrated_int] = integrated_intensity_batch(flags, parameters, crop, obj, dataI)
% Function adapted from FISH-quant toolbox:
% https://bitbucket.org/muellerflorian/fish_quant/src/master/
% Mueller F et al. FISH-quant: automatic counting of transcripts in 3D FISH images. Nature Methods 2013; 10(4): 277-278
% input
% flags
% parameters: microscope parameters
% center: structure with field x, y, and z if that the case
% crop: cropping mRNA analysis - like FQ analysis

%=== flags
mRNA_flag = flags.mRNA_flag;
bound_flag = flags.bound;
show_fits = flags.show_fits;
condensate_flag = flags.condensates;
%=== centroid
pos = obj;
pos_exact = obj;
%=== results structure
condensate_val = struct;
%=== PSF
par_microscope = parameters;
[sigma_xy, sigma_z] = sigma_PSF_BoZhang_v1(par_microscope);
PSF_theo.xy_nm = sigma_xy;
PSF_theo.z_nm = sigma_z;
%=== pixel size
pixel_size = par_microscope.Pixel;

%=== fit mRNA image
if mRNA_flag
    % load mRNA image
    file_path = [dataI.folder dataI.sep dataI.mRNA];
    imgInfo = imfinfo(file_path);
    zsteps = length(imgInfo);
    f = cell(1,zsteps);
    for i = 1 : zsteps
    f{i} = imread(file_path, i);
    end
    fc = cat(3,f{:});
    img = fc;
    % cropping
    [dim.Y, dim.X, dim.Z] = size(img);
    [img_large_max.val, img_large_max.ind_lin] = max(img(:));
    [img_large_max.Y, img_large_max.X, img_large_max.Z] = ind2sub(size(img),img_large_max.ind_lin(1));

    % cropping distance
    crop_xy_pix = crop.xy_pix;
    crop_z_pix  = crop.z_pix;
    xmin_crop = round(img_large_max.X - crop_xy_pix);
    xmax_crop = round(img_large_max.X + crop_xy_pix);
    ymin_crop = round(img_large_max.Y - crop_xy_pix);
    ymax_crop = round(img_large_max.Y + crop_xy_pix);
    zmin_crop = round(img_large_max.Z - crop_z_pix);
    zmax_crop = round(img_large_max.Z + crop_z_pix);

    if ymin_crop<1;     ymin_crop = 1;     end
    if ymax_crop>dim.Y; ymax_crop = dim.Y; end
    if xmin_crop<1;     xmin_crop = 1;     end
    if xmax_crop>dim.X; xmax_crop = dim.X; end
    if zmin_crop<1;     zmin_crop = 1;     end
    if zmax_crop>dim.Z; zmax_crop = dim.Z; end

    img_crop_xyz = img(ymin_crop:ymax_crop,xmin_crop:xmax_crop,zmin_crop:zmax_crop);
    img = img_crop_xyz;
    
    % results
    condensate_val.mRNA_i = double(img);
    
    % dimension of image
    [dim.Y, dim.X, dim.Z] = size(img);
    N_pix = dim.X*dim.Y*dim.Z;
    % generate vectors describing the image 
    [Xs,Ys,Zs] = meshgrid(1:dim.X,1:dim.Y,1:dim.Z);
    X1         = reshape(Xs,1,N_pix);
    Y1         = reshape(Ys,1,N_pix);
    Z1         = reshape(Zs,1,N_pix);
    xdata(1,:) = double(X1)*pixel_size.xy;
    xdata(2,:) = double(Y1)*pixel_size.xy;
    xdata(3,:) = double(Z1)*pixel_size.z;

    % reformatting image to fit data-format of axis vectors
    ydata = double(reshape(img,1,N_pix));
    
    % analyze image to get initial conditions
    % determine center of mass - starting point for center 
    center_mass  = ait_centroid3d_v3(double(img),xdata);
    % adapted
    par_start =  struct;
    if not(isfield(par_start,'centerx')); par_start.centerx = center_mass(1); end
    if not(isfield(par_start,'centery')); par_start.centery = center_mass(2); end
    if not(isfield(par_start,'centerz')); par_start.centerz = center_mass(3); end
    
    % min and max of the image: quality check 
    % starting point for amplitude and background
    img_max   = max(img(:));
    img_min   = (min(img(:))) * double((min(img(:))>0)) + (1*(min(img(:))<=0));
    
    if not(isfield(par_start,'amp'));  par_start.amp = img_max-img_min; end
    if not(isfield(par_start,'bgd'));  par_start.bgd = img_min;         end
    
    % starting points for sigma
    if not(isfield(par_start,'sigmax'));  par_start.sigmax = PSF_theo.xy_nm; end
    if not(isfield(par_start,'sigmay'));  par_start.sigmay = PSF_theo.xy_nm; end
    if not(isfield(par_start,'sigmaz'));  par_start.sigmaz = PSF_theo.z_nm; end
    
    % options for fitting routine
    options = optimset('Jacobian','off','Display','off','MaxIter',10000);
    
    % boundary conditions
    [dim_TS_crop.Y,dim_TS_crop.X,dim_TS_crop.Z] = size(img);
    if bound_flag
        simga_xy_max = dim_TS_crop.Y*pixel_size.xy;
        simga_z_max  = dim_TS_crop.Z*pixel_size.z;
        bound.lb = [0 0 0 0 0 0 0]; 
        bound.ub = [simga_xy_max simga_z_max inf inf inf inf inf];   
    else
        bound = [];   
    end
    
    if isempty(bound)
        lb = [];
        ub = [];
    else
        lb = bound.lb;
        ub = bound.ub;
    end
    
    %==== 3D fitting
    % initial conditions
    % double is necessary - otherwise problems with fitting routine
    x_init = double([par_start.sigmax, par_start.sigmaz,...
        par_start.centerx, par_start.centery, par_start.centerz,...
        par_start.amp, par_start.bgd]);
    
    % model parameters
    par_mod{1} = 2; % flag to indicate that sigma_x = sigma_y
    par_mod{2} = xdata;         
    par_mod{3} = pixel_size;
       
    % Least Squares Curve Fitting
    [x,resnorm,residual,exitflag,output] = lsqcurvefit(@fun_Gaussian_3D_v2,double(x_init),...
        par_mod,ydata,lb,ub,options);
    
    % calculate best fit
    img_fit_lin = fun_Gaussian_3D_v2(x,par_mod);
    img_fit     = reshape(img_fit_lin, size(img));
        
    % resize residuals
    if(numel(img) == numel(residual))
        im_residual = reshape(residual, size(img));
    else
        im_residual = ones(size(img));
    end
    
    % save results
    result.sigmaX      = x(1); % Sigma X
    result.sigmaY      = x(1); % Sigma Y
    result.sigmaZ      = x(2); % Sigma Z
    result.muX         = x(3) - dim.X*pixel_size.xy; % Center X
    result.muY         = x(4) - dim.Y*pixel_size.xy; % Center Y
    result.muZ         = x(5) - dim.Z*pixel_size.z;  % Center Z
    result.amp         = x(6); % Amplitude
    result.bgd         = x(7); % Background
    if isempty(resnorm)
        resnorm = 0;
    end
    result.resnorm     = resnorm;
    result.exitflag    = exitflag;
    result.centroidX   = center_mass(1); % Center of mass X: starting point for fit of center
    result.centroidY   = center_mass(2); % Center of mass Y: starting point for fit of center
    result.centroidZ   = center_mass(3); % Center of mass Z: starting point for fit of center
    result.output      = output;
    result.maxI        = img_max;
    result.im_residual = im_residual;
    result.img_fit     = img_fit;
    result.bound       = bound;
    
    % visualization
    if show_fits
        [dim_sub.Y, dim_sub.X, dim_sub.Z] = size(img); 
        % create projections
        img_MIP_xy = max(img,[],3);
        img_MIP_xz = squeeze(max(img,[],1));
        img_MIP_yz = squeeze(max(img,[],2));
        img_fit_MIP_xy = max(img_fit,[],3);
        img_fit_MIP_xz = squeeze(max(img_fit,[],1));
        img_fit_MIP_yz = squeeze(max(img_fit,[],2));
        resid_MIP_xy = max(im_residual,[],3);
        resid_MIP_xz = squeeze(max(im_residual,[],1));
        resid_MIP_yz = squeeze(max(im_residual,[],2));
        %- min and max of image
        img_min = min(img(:));
        img_max = max(img(:));
        res_min = min(im_residual(:));
        res_max = max(im_residual(:));
    
        % plot
        figure
        subplot(3,3,1), set(gcf,'color','w')
        imshow(img_MIP_xy,[img_min img_max],'XData',[0 (dim_sub.X-1)]*pixel_size.xy,'YData',[0 (dim_sub.Y-1)]*pixel_size.xy)
        title('Image - XY')    
        colorbar
        hold on
        plot(result.muX, result.muY,'og')
        hold off
        
        subplot(3,3,4)
        imshow(img_MIP_xz',[img_min img_max],'XData',[0 (dim_sub.X-1)]*pixel_size.xy,'YData',[0 (dim_sub.Z-1)]*pixel_size.z)
        title('Image - XZ')
        colorbar
        hold on
        plot(result.muX, result.muZ,'og')
        hold off
        
        subplot(3,3,7)
        imshow(img_MIP_yz',[img_min img_max],'XData',[0 (dim_sub.Y-1)]*pixel_size.xy,'YData',[0 (dim_sub.Z-1)]*pixel_size.z)
        title('Image - YZ')
        colorbar
        hold on
        plot(result.muY, result.muZ,'og')
        hold off
        
        % plot fit
        subplot(3,3,2)
        imshow(img_fit_MIP_xy,[img_min img_max],'XData',[0 (dim_sub.X-1)]*pixel_size.xy,'YData',[0 (dim_sub.Y-1)]*pixel_size.xy)
        title('FIT - XY')
        hold on
        plot(result.muX, result.muY,'og')
        hold off
        
        subplot(3,3,5)
        imshow(img_fit_MIP_xz',[img_min img_max],'XData',[0 (dim_sub.X-1)]*pixel_size.xy,'YData',[0 (dim_sub.Z-1)]*pixel_size.z)
        title('FIT - XZ')
        hold on
        plot(result.muX, result.muZ,'og')
        hold off
        
        subplot(3,3,8)
        imshow(img_fit_MIP_yz',[img_min img_max],'XData',[0 (dim_sub.Y-1)]*pixel_size.xy,'YData',[0 (dim_sub.Z-1)]*pixel_size.z)
        title('FIT - YZ')
        hold on
        plot(result.muY, result.muZ,'og')
        hold off
        
        % residuals
        subplot(3,3,3)
        imshow(resid_MIP_xy,[res_min res_max],'XData',[0 (dim_sub.X-1)]*pixel_size.xy,'YData',[0 (dim_sub.Y-1)]*pixel_size.xy)
        title('RESID - XY')
        colorbar
        subplot(3,3,6)
        imshow(resid_MIP_xz',[res_min res_max],'XData',[0 (dim_sub.X-1)]*pixel_size.xy,'YData',[0 (dim_sub.Z-1)]*pixel_size.z)
        title('RESID - XZ')
        
        subplot(3,3,9)
        imshow(resid_MIP_yz',[res_min res_max],'XData',[0 (dim_sub.Y-1)]*pixel_size.xy,'YData',[0 (dim_sub.Z-1)]*pixel_size.z)
        title('RESID - YZ')
        colormap hot
        
        % additional plots
        figure
        subplot(3,2,1)
        surf(img_MIP_xy)
        title('Image - XY')
        
        subplot(3,2,3)
        surf(img_MIP_xz')
        title('Image - XZ')
        
        subplot(3,2,5)
        surf(img_MIP_yz')
        title('Image - YZ')
        
        % additional fit
        subplot(3,2,2)
        surf(img_fit_MIP_xy)
        title('FIT - XY')
        
        subplot(3,2,4)
        surf(img_fit_MIP_xz')
        title('FIT - XZ')
        
        subplot(3,2,6)
        surf(img_fit_MIP_yz')
        title('FIT - YZ')
    end
    
    %==== integrated intensity
    x_int.min =  - crop_xy_pix * pixel_size.xy;
    x_int.max =  + crop_xy_pix * pixel_size.xy;
    y_int.min =  - crop_xy_pix * pixel_size.xy;
    y_int.max =  + crop_xy_pix * pixel_size.xy;
    z_int.min =  - crop_z_pix * pixel_size.z;
    z_int.max =  + crop_z_pix * pixel_size.z;
    % integration range
    par_mod_int(1)  = result.sigmaX;
    par_mod_int(2)  = result.sigmaY;
    par_mod_int(3)  = result.sigmaZ;
    par_mod_int(4)  = 0;
    par_mod_int(5)  = 0;
    par_mod_int(6)  = 0;
    par_mod_int(7)  = result.amp;
    par_mod_int(8)  = 0;
    % integration
    integrated_int = fun_Gaussian_3D_triple_integral_v1(x_int,y_int,z_int,par_mod_int);
end

if condensate_flag
    % load from caller workspace
    img = evalin('caller','imgbase');
    img_large = evalin('caller','imgbgd');
    % condensate values
    condensate_val.exact  = double(img(pos_exact.list));
    condensate_val.dilate = double(img(pos.list));
    % place condensate in bgd image
    img_large(pos.list) = img(pos.list);
    
    % cropping condensate - adding some extra pixels for background
    if flags.padding
    min_x = round(min(pos.x) - ceil(PSF_theo.xy_nm/pixel_size.xy));
    max_x = round(max(pos.x) + ceil(PSF_theo.xy_nm/pixel_size.xy));
    min_y = round(min(pos.y) - ceil(PSF_theo.xy_nm/pixel_size.xy));
    max_y = round(max(pos.y) + ceil(PSF_theo.xy_nm/pixel_size.xy));
    min_z = round(min(pos.z) - ceil(PSF_theo.z_nm/pixel_size.z));
    max_z = round(max(pos.z) + ceil(PSF_theo.z_nm/pixel_size.z));
    else % otherwise not adding some extra pixels for background
    min_x = round(min(pos.x));
    max_x = round(max(pos.x));
    min_y = round(min(pos.y));
    max_y = round(max(pos.y));
    min_z = round(min(pos.z));
    max_z = round(max(pos.z));
    end
    
    % make sure cropping is within image
    [dim.Y, dim.X, dim.Z] = size(img);
    if min_x < 1; min_x = 1; end
    if max_x > dim.X; max_x = dim.X; end
    if min_y < 1; min_y = 1; end
    if max_y > dim.Y; max_y = dim.Y; end
    if min_z < 1; min_z = 1; end
    if max_z > dim.Z; max_z = dim.Z; end
   
    % getting centroids
    img_centroid.X = pos.centroid_x - min_x;
    img_centroid.Y = pos.centroid_y - min_y;
    img_centroid.Z = pos.centroid_z - min_z;
    % retrieving condensate
    img_crop_xyz = img_large(min_y:max_y,min_x:max_x,min_z:max_z);
    img = img_crop_xyz;

    % dimension of image
    [dim.Y, dim.X, dim.Z] = size(img);
    N_pix                 = dim.X*dim.Y*dim.Z;
    % generate vectors describing the image 
    [Xs,Ys,Zs] = meshgrid(1:dim.X,1:dim.Y,1:dim.Z);
    
    X1         = reshape(Xs,1,N_pix);
    Y1         = reshape(Ys,1,N_pix);
    Z1         = reshape(Zs,1,N_pix);
    
    xdata(1,:) = double(X1)*pixel_size.xy;
    xdata(2,:) = double(Y1)*pixel_size.xy;
    xdata(3,:) = double(Z1)*pixel_size.z;
    
    % reformatting image to fit data-format of axis vectors
    ydata          = double(reshape(img,1,N_pix));
    
    % analyze image to get initial conditions DONE BY CENTROIDS
    if flags.centerMass
    % determine center of mass - starting point for center 
    center_mass  = ait_centroid3d_v3(double(img),xdata);
    centroidC.x = center_mass(1);
    centroidC.y = center_mass(2);
    centroidC.z = center_mass(3);
    else
    centroidC.x = img_centroid.X*pixel_size.xy;
    centroidC.y = img_centroid.Y*pixel_size.xy;
    centroidC.z = img_centroid.Z*pixel_size.z;
    end
    % The other option is using the centroid of the detected object
    par_start =  struct;
    
    if not(isfield(par_start,'centerx')); par_start.centerx = centroidC.x; end
    if not(isfield(par_start,'centery')); par_start.centery = centroidC.y; end
    if not(isfield(par_start,'centerz')); par_start.centerz = centroidC.z; end
    
    % min and max of the image: quality check 
    % starting point for amplitude and background
    img_max = max(img(:));
    img_min = (min(img(:))) * double((min(img(:))>0)) + (1*(min(img(:))<=0));
    
    if not(isfield(par_start,'amp'));  par_start.amp = img_max-img_min; end
    if not(isfield(par_start,'bgd'));  par_start.bgd = img_min;         end
    
    % starting points for sigma
    if not(isfield(par_start,'sigmax'));  par_start.sigmax = PSF_theo.xy_nm; end
    if not(isfield(par_start,'sigmay'));  par_start.sigmay = PSF_theo.xy_nm; end
    if not(isfield(par_start,'sigmaz'));  par_start.sigmaz = PSF_theo.z_nm; end
    
    % options for fitting routine
    options = optimset('Jacobian','off','Display','off','MaxIter',10000);
    
    % boundary conditions
    [dim_TS_crop.Y,dim_TS_crop.X,dim_TS_crop.Z] = size(img);
    
    if bound_flag
        simga_xy_max = dim_TS_crop.Y*pixel_size.xy;
        simga_z_max  = dim_TS_crop.Z*pixel_size.z;
        bound.lb = [0               0 0   0   0   0   0]; 
        bound.ub = [simga_xy_max simga_z_max inf inf inf inf inf];   
    else
        bound = [];   
    end
    
    if isempty(bound)
        lb = [];
        ub = [];
    else
        lb = bound.lb;
        ub = bound.ub;
    end
    
    %==== 3D fitting
    % initial conditions
    % double is necessary - otherwise problems with fitting routine
    x_init = double([par_start.sigmax,  par_start.sigmaz,...
        par_start.centerx, par_start.centery, par_start.centerz,...
        par_start.amp, par_start.bgd]);
    
    % model parameters
    par_mod{1} = 2; % flag to indicate that sigma_x = sigma_y
    par_mod{2} = xdata;         
    par_mod{3} = pixel_size;
       
    % Least Squares Curve Fitting
    [x,resnorm,residual,exitflag,output] = lsqcurvefit(@fun_Gaussian_3D_v2,double(x_init),...
        par_mod,ydata,lb,ub,options);
    
    % calculate best fit
    img_fit_lin = fun_Gaussian_3D_v2(x,par_mod);
    img_fit     = reshape(img_fit_lin, size(img));
        
    % resize residuals
    if( numel(img) == numel(residual))
        im_residual = reshape(residual, size(img));
    else
        im_residual = ones(size(img));
    end
    
    % save results  
    result.sigmaX      = x(1); % Sigma X
    result.sigmaY      = x(1); % Sigma Y
    result.sigmaZ      = x(2); % Sigma Z
    result.muX         = x(3) - dim.X*pixel_size.xy; % Center X
    result.muY         = x(4) - dim.Y*pixel_size.xy; % Center Y
    result.muZ         = x(5) - dim.Z*pixel_size.z; % Center Z
    result.amp         = x(6); % Amplitude
    result.bgd         = x(7); % Background
    if isempty(resnorm)
        resnorm = 0;
    end
    result.resnorm     = resnorm;
    result.exitflag    = exitflag;
    result.centroidX   = centroidC.x; % Center of mass X: starting point for fit of center
    result.centroidY   = centroidC.y; % Center of mass Y: starting point for fit of center
    result.centroidZ   = centroidC.z; % Center of mass Z: starting point for fit of center
    result.output      = output;
    result.maxI        = img_max;
    result.im_residual = im_residual;
    result.img_fit     = img_fit;
    result.bound       = bound;
    
    % visualization
    if show_fits
        [dim_sub.Y, dim_sub.X, dim_sub.Z] = size(img);
        % create projections
        img_MIP_xy = max(img,[],3);
        img_MIP_xz = squeeze(max(img,[],1));
        img_MIP_yz = squeeze(max(img,[],2));
        img_fit_MIP_xy = max(img_fit,[],3);
        img_fit_MIP_xz = squeeze(max(img_fit,[],1));
        img_fit_MIP_yz = squeeze(max(img_fit,[],2));
        resid_MIP_xy = max(im_residual,[],3);
        resid_MIP_xz = squeeze(max(im_residual,[],1));
        resid_MIP_yz = squeeze(max(im_residual,[],2));
        % min and max of image
        img_min = min(img(:));
        img_max = max(img(:));
        res_min = min(im_residual(:));
        res_max = max(im_residual(:));
        
        % plot
        figure
        subplot(3,3,1), set(gcf,'color','w')
        imshow(img_MIP_xy,[img_min img_max],'XData',[0 (dim_sub.X-1)]*pixel_size.xy,'YData',[0 (dim_sub.Y-1)]*pixel_size.xy)
        title('Image - XY')
        colorbar
        hold on
        plot(result.muX, result.muY,'og')
        hold off
        
        subplot(3,3,4)
        imshow(img_MIP_xz',[img_min img_max],'XData',[0 (dim_sub.X-1)]*pixel_size.xy,'YData',[0 (dim_sub.Z-1)]*pixel_size.z)
        title('Image - XZ')
        colorbar
        hold on
        plot(result.muX, result.muZ,'og')
        hold off
        
        subplot(3,3,7)
        imshow(img_MIP_yz',[img_min img_max],'XData',[0 (dim_sub.Y-1)]*pixel_size.xy,'YData',[0 (dim_sub.Z-1)]*pixel_size.z)
        title('Image - YZ')
        colorbar
        hold on
        plot(result.muY, result.muZ,'og')
        hold off
        
        % plot fit
        subplot(3,3,2)
        imshow(img_fit_MIP_xy,[img_min img_max],'XData',[0 (dim_sub.X-1)]*pixel_size.xy,'YData',[0 (dim_sub.Y-1)]*pixel_size.xy)
        title('FIT - XY')
        hold on
        plot(result.muX, result.muY,'og')
        hold off
        
        subplot(3,3,5)
        imshow(img_fit_MIP_xz',[img_min img_max],'XData',[0 (dim_sub.X-1)]*pixel_size.xy,'YData',[0 (dim_sub.Z-1)]*pixel_size.z)
        title('FIT - XZ')
        hold on
        plot(result.muX, result.muZ,'og')
        hold off
        
        subplot(3,3,8)
        imshow(img_fit_MIP_yz',[img_min img_max],'XData',[0 (dim_sub.Y-1)]*pixel_size.xy,'YData',[0 (dim_sub.Z-1)]*pixel_size.z)
        title('FIT - YZ')
        hold on
        plot(result.muY, result.muZ,'og')
        hold off
        
        % residuals
        subplot(3,3,3)
        imshow(resid_MIP_xy,[res_min res_max],'XData',[0 (dim_sub.X-1)]*pixel_size.xy,'YData',[0 (dim_sub.Y-1)]*pixel_size.xy)
        title('RESID - XY')
        colorbar
        subplot(3,3,6)
        imshow(resid_MIP_xz',[res_min res_max],'XData',[0 (dim_sub.X-1)]*pixel_size.xy,'YData',[0 (dim_sub.Z-1)]*pixel_size.z)
        title('RESID - XZ')
        
        subplot(3,3,9)
        imshow(resid_MIP_yz',[res_min res_max],'XData',[0 (dim_sub.Y-1)]*pixel_size.xy,'YData',[0 (dim_sub.Z-1)]*pixel_size.z)
        title('RESID - YZ')
        colormap hot
        
        % additional plots
        figure
        subplot(3,2,1)
        surf(img_MIP_xy)
        title('Image - XY')
        
        subplot(3,2,3)
        surf(img_MIP_xz')
        title('Image - XZ')
        
        subplot(3,2,5)
        surf(img_MIP_yz')
        title('Image - YZ')
        
        % additional fit
        subplot(3,2,2)
        surf(img_fit_MIP_xy)
        title('FIT - XY')
        
        subplot(3,2,4)
        surf(img_fit_MIP_xz')
        title('FIT - XZ')
        
        subplot(3,2,6)
        surf(img_fit_MIP_yz')
        title('FIT - YZ')
    end
    
    %==== integrated intensity
    x_int.min =  - ceil((max_x-min_x)/2) * pixel_size.xy;
    x_int.max =  + ceil((max_x-min_x)/2) * pixel_size.xy;
    y_int.min =  - ceil((max_y-min_y)/2) * pixel_size.xy;
    y_int.max =  + ceil((max_y-min_y)/2) * pixel_size.xy;  
    z_int.min =  - ceil((max_z-min_z)/2) * pixel_size.z;
    z_int.max =  + ceil((max_z-min_z)/2) * pixel_size.z;
    % integration range
    par_mod_int(1)  = result.sigmaX;
    par_mod_int(2)  = result.sigmaY;
    par_mod_int(3)  = result.sigmaZ;
    par_mod_int(4)  = 0;
    par_mod_int(5)  = 0;
    par_mod_int(6)  = 0;
    par_mod_int(7)  = result.amp;
    par_mod_int(8)  = 0 ;
    % integration
    integrated_int = fun_Gaussian_3D_triple_integral_v1(x_int,y_int,z_int,par_mod_int);
end
end