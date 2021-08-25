#--generate the result for global analysis-----
#--20210720----------------

setwd('C:/Users/wangz/Documents/ProjectAtBNU/Asymptomatic-project/test-0716/test-wzm/Global')

library(readxl)
library(writexl)
library(openxlsx)
library(reshape2)
library(ggplot2)
library (RColorBrewer)
library(ggpubr)

Country = read_excel('Countries-with-Age-Structure-Contact.xlsx');
Country = as.data.frame(Country)
Country = Country[,1]

N = 20;

Result1 = matrix(0,length(Country),N)
rownames(Result1) = Country
colnames(Result1) = paste0('Contribution',seq(1,N));

Result2 = matrix(0,length(Country),N)
rownames(Result2) = Country
colnames(Result2) = paste0('TotalP',seq(1,N));

Result3 = matrix(0,length(Country),N)
rownames(Result3) = Country
colnames(Result3) = paste0('PeakD',seq(1,N));

Label = 'ConfidenceInterval_withLargestValue_Random';

DIR = paste0('./result_',Label,'/');

for(i in Country){
	for(j in 1:N){
		tmp = read_excel(paste0(DIR,i,'_fixR0_simulation.xlsx'),sheet=j);
		tmp = as.data.frame(tmp)
		Result1[i,paste0('Contribution',j)] = sum(tmp[,'ContributedByAsym'])/sum(tmp[,'ContributedByAsym']+tmp[,'ContributedBySym'])
		Result2[i,paste0('TotalP',j)] = sum(tmp[,'Asym'])/sum(tmp[,'Asym']+tmp[,'Sym'])
		Result3[i, paste0('PeakD',j)] = which.max(tmp[,'Asym']+tmp[,'Sym'])
	}
}




Result = matrix(0,length(Country),9)
rownames(Result) = Country
colnames(Result) = c('ContributedByAsym_mean','ContributedByAsym_upper','ContributedByAsym_lower',
	'totalP_Asym_mean','totalP_Asym_upper','totalP_Asym_lower','PeakD_Asym_mean','PeakD_Asym_upper','PeakD_Asym_lower');
Result[,'ContributedByAsym_mean'] = apply(Result1,1,mean)
STD = apply(Result1,1,sd)
error = qnorm(0.975)*STD/sqrt(N);
Result[,'ContributedByAsym_upper'] = Result[,'ContributedByAsym_mean']+error;
Result[,'ContributedByAsym_lower'] = Result[,'ContributedByAsym_mean']-error;


Result[,'totalP_Asym_mean'] = apply(Result2,1,mean)
STD = apply(Result2,1,sd)
error = qnorm(0.975)*STD/sqrt(N);
Result[,'totalP_Asym_upper'] = Result[,'totalP_Asym_mean']+error;
Result[,'totalP_Asym_lower'] = Result[,'totalP_Asym_mean']-error;



Result[,'PeakD_Asym_mean'] = apply(Result3,1,mean)

STD = apply(Result3,1,sd)
error = qnorm(0.975)*STD/sqrt(N);
Result[,'PeakD_Asym_upper'] = Result[,'PeakD_Asym_mean']+error;
Result[,'PeakD_Asym_lower'] = Result[,'PeakD_Asym_mean']-error;


Result = cbind(Country=Country,Result)
Result = as.data.frame(Result)
Result[,2:10] = as.numeric(as.matrix(Result[,2:10]))


tmp = read.xlsx('C:/Users/wangz/Documents/ProjectAtBNU/Asymptomatic-project/Figure3/result_global.xlsx')


sum(tmp[,'Country']==Result[,'Country'])


Result=cbind(Result,median_age2020=tmp[,'median_age2020'])




write_xlsx(Result,path=paste0("SummaryResult_global-",Label,".xlsx"),col_names = TRUE)
