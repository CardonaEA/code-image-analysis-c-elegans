function [F] = fun_Sum_SkewGaussians(par_cf,fit_eval)
% FUNCTION Gaussian curve fitting
% skewed gaussian model

cf_amp_1 = par_cf(1);
cf_centroid_1 = par_cf(2);
cf_sd_1 = par_cf(3);
cf_skew_1 = par_cf(4);

cf_amp_2 = par_cf(5);
cf_centroid_2 = par_cf(6);
cf_sd_2 = par_cf(7);
cf_skew_2 = par_cf(8);

x = fit_eval;

% F = (sqrt(2*pi) * cf_amp^2 * cf_sd) *...
%     (exp(-((x - cf_centroid)/(sqrt(2)*cf_sd)).^2).*...
%     (erf(cf_skew * ((x - cf_centroid)/(sqrt(2)*cf_sd))) + 1));

% F = (sqrt(2*pi) * cf_amp^2 * cf_sd) *...
%     (exp(-(((x - cf_centroid)/cf_sd).^2)/2).*...
%     (erf((cf_skew * ((x - cf_centroid)/cf_sd))/sqrt(2)) + 1));

F = cf_amp_1 *...
    (exp(-(((x - cf_centroid_1)/cf_sd_1).^2)/2).*...
    (erf((cf_skew_1 * ((x - cf_centroid_1)/cf_sd_1))/sqrt(2)) + 1)) +...
    cf_amp_2 *...
    (exp(-(((x - cf_centroid_2)/cf_sd_2).^2)/2).*...
    (erf((cf_skew_2 * ((x - cf_centroid_2)/cf_sd_2))/sqrt(2)) + 1));
