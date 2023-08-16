function  [fit_lin, x, x_init] = fit_nanoclusters_model(pdf_yData, xData, yData, x, peak_fixed)
% paremter from prev fit
x_init = x;

% parameter second summed gauss
par_start =  struct;
[pdf_max, idx] = max(pdf_yData);
pdf_min        = min(pdf_yData);
pdf_centroid   = xData(idx); % centroid in xData
pdf_sd         = std(yData);
pdf_skew       = skewness(yData);
%pdf_skew       = x(4);

if not(isfield(par_start,'amp'));  par_start.amp = pdf_max-pdf_min; end
if not(isfield(par_start,'centroid'));  par_start.centroid = pdf_centroid; end
if not(isfield(par_start,'sd'));  par_start.sd = pdf_sd; end
if not(isfield(par_start,'skew'));  par_start.skew = pdf_skew; end

%== Options for fitting routine
options = optimset('Jacobian','off','Display','off','MaxIter',10000);
%options = optimset('Robust', 'LAR','Jacobian','off','Display','off','MaxIter',10000);

%% Boundary conditions
% Variable peak at  [ -5% SM value + 5%]
if isempty(peak_fixed) || ~peak_fixed
bound.lb = [0    x(2)*0.95    x(3)    x(4)   0     x(2)*1.4     0     x(4)]; 
bound.ub = [inf  x(2)*1.05    x(3)    x(4)   inf   inf          inf   inf ];   
% bound.lb = [0    x(2)*0.95    x(3)    x(4)   0     x(2)*1.05     0     0   ];
% bound.ub = [inf  x(2)*1.05    x(3)    x(4)   inf   x(2)*2        inf   inf ];
end
% Fixed peak at SM  value
if peak_fixed
bound.lb = [0    x(2)    x(3)    x(4)   0     x(2)*1.4    0     x(4)]; 
bound.ub = [inf  x(2)    x(3)    x(4)   inf   inf         inf   inf ];
% bound.lb = [0    x(2)    x(3)    x(4)   0     x(2)*1.05    0     0  ];
% bound.ub = [inf  x(2)    x(3)    x(4)   inf   x(2)*2       inf   inf];
end

lb = bound.lb;
ub = bound.ub;

%% fitting
%- Initial conditions
x_init = double([ x_init,...
                  par_start.amp,  ...
                  par_start.centroid,...
                  par_start.sd,...
                  par_start.skew]);

%-  Least Squares Curve Fitting
[x,resnorm,residual,exitflag,output] = lsqcurvefit(@fun_Sum_SkewGaussians,...
    double(x_init), xData,...
    pdf_yData,lb,ub,options);

%- Calculate best fit all values
fit_lin = fun_Sum_SkewGaussians(x,xData);
end
