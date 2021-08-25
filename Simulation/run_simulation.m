clear
%% change result.mat
load result_sh;

% We sample 1000 parameter realizations from |chain| and |s2chain|
nsample = 1000;
results2.sstype = 1;

%s1
modelfun = @(d,th) s1(d(:,1),th,d);
out_s1 = mcmcpred(results2,chain2,s2chain2,data.xdata,modelfun,nsample);

%s2
modelfun = @(d,th) s2(d(:,1),th,d);
out_s2 = mcmcpred(results2,chain2,s2chain2,data.xdata,modelfun,nsample);

%s3
modelfun = @(d,th) s3(d(:,1),th,d);
out_s3 = mcmcpred(results2,chain2,s2chain2,data.xdata,modelfun,nsample);

%s4
modelfun = @(d,th) s4(d(:,1),th,d);
out_s4 = mcmcpred(results2,chain2,s2chain2,data.xdata,modelfun,nsample);

%s5
modelfun = @(d,th) s5(d(:,1),th,d);
out_s5 = mcmcpred(results2,chain2,s2chain2,data.xdata,modelfun,nsample);

%s6
modelfun = @(d,th) s6(d(:,1),th,d);
out_s6 = mcmcpred(results2,chain2,s2chain2,data.xdata,modelfun,nsample);

%s7
modelfun = @(d,th) s7(d(:,1),th,d);
out_s7 = mcmcpred(results2,chain2,s2chain2,data.xdata,modelfun,nsample);

%s8
modelfun = @(d,th) s8(d(:,1),th,d);
out_s8 = mcmcpred(results2,chain2,s2chain2,data.xdata,modelfun,nsample);

%s9
modelfun = @(d,th) s9(d(:,1),th,d);
out_s9 = mcmcpred(results2,chain2,s2chain2,data.xdata,modelfun,nsample);

%s10
modelfun = @(d,th) s10(d(:,1),th,d);
out_s10 = mcmcpred(results2,chain2,s2chain2,data.xdata,modelfun,nsample);

%universal
modelfun = @(d,th) s_universal(d(:,1),th,d);
out_universal = mcmcpred(results2,chain2,s2chain2,data.xdata,modelfun,nsample);