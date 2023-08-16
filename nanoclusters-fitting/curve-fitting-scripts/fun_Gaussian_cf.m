function [F] = fun_Gaussian_cf(par_cf,fit_eval)
% FUNCTION Gaussian curve fitting
% normal gaussian

cf_amp = par_cf(1);
cf_centroid = par_cf(2);
cf_sd = par_cf(3);

x = fit_eval;

% F = cf_amp * exp(-((x - cf_centroid)/(sqrt(2)*cf_sd)).^2);
% F = cf_amp * exp((-((x - cf_centroid)/cf_sd).^2)/2);
F = cf_amp * exp(-(((x - cf_centroid)/cf_sd).^2)/2);
