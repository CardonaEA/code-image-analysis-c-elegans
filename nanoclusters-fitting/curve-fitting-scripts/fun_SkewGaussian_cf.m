function [F] = fun_SkewGaussian_cf(par_cf,fit_eval)
% FUNCTION Gaussian curve fitting
% skewed gaussian

cf_amp = par_cf(1);
cf_centroid = par_cf(2);
cf_sd = par_cf(3);
cf_skew = par_cf(4);

x = fit_eval;

% F = (sqrt(2*pi) * cf_amp^2 * cf_sd) *...
%     (exp(-((x - cf_centroid)/(sqrt(2)*cf_sd)).^2).*...
%     (erf(cf_skew * ((x - cf_centroid)/(sqrt(2)*cf_sd))) + 1));

% F = (sqrt(2*pi) * cf_amp^2 * cf_sd) *...
%     (exp(-(((x - cf_centroid)/cf_sd).^2)/2).*...
%     (erf((cf_skew * ((x - cf_centroid)/cf_sd))/sqrt(2)) + 1));

F = cf_amp *...
    (exp(-(((x - cf_centroid)/cf_sd).^2)/2).*...
    (erf((cf_skew * ((x - cf_centroid)/cf_sd))/sqrt(2)) + 1));
