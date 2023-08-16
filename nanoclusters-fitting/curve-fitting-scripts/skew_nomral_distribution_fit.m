function [fit_lin, x, par_start] = skew_nomral_distribution_fit(pdf_yData, xData, yData)
%===== skewed gaussian
%% parameter start
par_start =  struct;
% starting point for amplitude and background
% amplitude and centroid and sd
[pdf_max, idx] = max(pdf_yData);
pdf_min        = min(pdf_yData);
pdf_centroid   = xData(idx); % centroid in xData
pdf_sd         = std(yData);
pdf_skew       = skewness(yData);

if not(isfield(par_start,'amp'));  par_start.amp = pdf_max-pdf_min; end
if not(isfield(par_start,'centroid'));  par_start.centroid = pdf_centroid; end
if not(isfield(par_start,'sd'));  par_start.sd = pdf_sd; end
if not(isfield(par_start,'skew'));  par_start.skew = pdf_skew; end

%== Options for fitting routine
options = optimset('Jacobian','off','Display','off','MaxIter',10000);
%options = optimset('Robust', 'LAR','Jacobian','off','Display','off','MaxIter',10000);

%% Boundary conditions
bound.lb = [0   0   0   0  ]; 
bound.ub = [inf inf inf inf];   
lb = bound.lb;
ub = bound.ub;

%% fitting
%- Initial conditions
x_init = double([ par_start.amp,  ...
                  par_start.centroid,...
                  par_start.sd,...
                  par_start.skew]);

%-  Least Squares Curve Fitting
[x,resnorm,residual,exitflag,output] = lsqcurvefit(@fun_SkewGaussian_cf,...
    double(x_init), xData,...
    pdf_yData,lb,ub,options);

%- Calculate best fit all values
fit_lin = fun_SkewGaussian_cf(x,xData);
end
