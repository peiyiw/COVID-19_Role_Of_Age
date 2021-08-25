clear
load ap; %row1-6: asymptomatic proportion of 6 cities under 7 age groups
%row7: average asymptomatic proportion of 6 cities
load par; %intial value and range of parameters
load xdata;

load ydata_shijiazhuang_onset;
xdata.index = 1;

% load ydata_xingtai_onset;
% xdata.index=2;

% load ydata_changchun_onset;
% xdata.index=3;

% load ydata_tonghua_onset;
% xdata.index=4;

% load ydata_harbin_onset;
% xdata.index=5;

%  load ydata_suihua_onset;
%  xdata.index=6;

%% data
% sjz-1 xt-2 cc-3 th-4 heb-5 sh-6
citynames = ["sjz", "xt", "cc", "th", "heb", "sh"];
data.xdata = xdata;
data.ydata = [ydata(:,1), movmean(ydata(:,2:3),3)]; %confirm, positive
cityname = citynames(xdata.index);
n = 7; %10 year age bands - 7 age groups
time=max(ydata(:,1)); %duration

%%
% The model sum of squares given in the model structure.
model.ssfun = @f2;

%%
% All parameters are constrained to be positive. The initial
% concentrations are also unknown and are treated as extra parameters.
params1 = {
	%parameter
	%name,mean,min.max,mean,std
    {'beta',par.initial(xdata.index,1),0,1,0,Inf}  %transmission rate
    {'theta',par.initial(xdata.index,2),0,1,0,Inf} %tracing and testing rate
	{'HL0',par.initial(xdata.index,3),par.HL0(xdata.index,1),par.HL0(xdata.index,2),0,Inf}
	{'HIa0',par.initial(xdata.index,4),par.HIa0(xdata.index,1),par.HIa0(xdata.index,2),0,Inf}
    {'HLp0',par.initial(xdata.index,5),par.HLp0(xdata.index,1),par.HLp0(xdata.index,2),0,Inf}
    {'HIs0',par.initial(xdata.index,6),par.HIs0(xdata.index,1),par.HIs0(xdata.index,2),0,Inf}
    {'p1', ap_real(7,1), ext(6+xdata.index,1), ext(xdata.index,1),0,Inf}
    {'p2', ap_real(7,2), ext(6+xdata.index,2), ext(xdata.index,2),0,Inf}
    {'p3', ap_real(7,3), ext(6+xdata.index,3), ext(xdata.index,3),0,Inf}
    {'p4', ap_real(7,4), ext(6+xdata.index,4), ext(xdata.index,4),0,Inf}
    {'p5', ap_real(7,5), ext(6+xdata.index,5), ext(xdata.index,5),0,Inf}
    {'p6', ap_real(7,6), ext(6+xdata.index,6), ext(xdata.index,6),0,Inf}
    {'p7', ap_real(7,7), ext(6+xdata.index,7), ext(xdata.index,7),0,Inf}
    };

%%
% We assume having at least some prior information on the
% repeatability of the observation and assign rather non informational
% prior for the residual variances of the observed states. The default
% prior distribution is sigma2 ~ invchisq(S20,N0), the inverse chi
% squared distribution (see for example Gelman et al.). The 3
% components (_A_, _Z_, _P_) all have separate variances.
model.S20 = [4];
model.N0  = [1];

%%
% First generate an initial chain.
options.nsimu = 100000;
options.stats = 1;
[results, chain, s2chain]= mcmcrun(model,data,params1,options);

%regenerate chain to convergence
options.nsimu = 100000;
options.stats = 1;
[results2, chain2, s2chain2] = mcmcrun(model,data,params1,options,results);
% figure
%  mcmcpredplot(out,data);
%%
% Chain plots should reveal that the chain has converged and we can
% use the results for estimation and predictive inference.
  
figure
mcmcplot(chain2,[],results2,'denspanel',2);
figure
mcmcplot(chain2,[],results2); %,'pairs'

%%
% Function |chainstats| calculates mean ans std from the chain and
% estimates the Monte Carlfigure
% the integrated autocorrelation time and |geweke| is a simple test
% for a null hypothesis that the chain has converged.

results2.sstype = 1; % needed for mcmcpred and sqrt transformation
stats = chainstats(chain2,results2); %statistic results of parameter estimation

%%
% In order to use the |mcmcpred| function we need
% function |modelfun| with input arguments given as
% |modelfun(xdata,theta)|. We construct this as an anonymous function.
modelfun = @(d,th) f3(d(:,1),th,d);

%%
% We sample 1000 parameter realizations from |chain| and |s2chain|
% and calculate the predictive plots.
nsample = 1000;
results2.sstype = 1;
out = mcmcpred(results2,chain2,s2chain2,data.xdata,modelfun,nsample);%data.ydata-->data