#--generate the result for global analysis-----
#--20210720----------------

setwd('C:/Users/wangz/Documents/ProjectAtBNU/Asymptomatic-project/test-0716/test-wzm/Global')

library(readxl)
library(writexl)

Country = read_excel('Countries-with-Age-Structure-Contact.xlsx');
Country = as.data.frame(Country)
Country = Country[,1]

Result = matrix(0,length(Country),9)
rownames(Result) = Country
colnames(Result) = c('ContributedByAsym_real','ContributedByAsym_up','ContributedByAsym_down',
	'totalP_Asym_real','totalP_Asym_up','totalP_Asym_down','PeakD_Asym_real','PeakD_Asym_up','PeakD_Asym_down');



Label = 'ConfidenceInterval_withLargestValue';

DIR = paste0('./result_',Label,'/');

for(i in Country){
	tmp = read_excel(paste0(DIR,i,'_fixR0_simulation.xlsx'),sheet='asym_real');
	tmp = as.data.frame(tmp)
	Result[i,'ContributedByAsym_real'] = sum(tmp[,'ContributedByAsym'])/sum(tmp[,'ContributedByAsym']+tmp[,'ContributedBySym'])
	Result[i,'totalP_Asym_real'] = sum(tmp[,'Asym'])/sum(tmp[,'Asym']+tmp[,'Sym'])
	Result[i,'PeakD_Asym_real'] = which.max(tmp[,'Asym']+tmp[,'Sym'])


	tmp = read_excel(paste0(DIR,i,'_fixR0_simulation.xlsx'),sheet='asym_up');
	tmp = as.data.frame(tmp)
	Result[i,'ContributedByAsym_up'] = sum(tmp[,'ContributedByAsym'])/sum(tmp[,'ContributedByAsym']+tmp[,'ContributedBySym'])
	Result[i,'totalP_Asym_up'] = sum(tmp[,'Asym'])/sum(tmp[,'Asym']+tmp[,'Sym'])
	Result[i,'PeakD_Asym_up'] = which.max(tmp[,'Asym']+tmp[,'Sym'])

	tmp = read_excel(paste0(DIR,i,'_fixR0_simulation.xlsx'),sheet='asym_down');
	tmp = as.data.frame(tmp)
	Result[i,'ContributedByAsym_down'] = sum(tmp[,'ContributedByAsym'])/sum(tmp[,'ContributedByAsym']+tmp[,'ContributedBySym'])
	Result[i,'totalP_Asym_down'] = sum(tmp[,'Asym'])/sum(tmp[,'Asym']+tmp[,'Sym'])
	Result[i,'PeakD_Asym_down'] = which.max(tmp[,'Asym']+tmp[,'Sym'])
}


Result = cbind(Country=Country,Result)
Result = as.data.frame(Result)
Result[,2:10] = as.numeric(as.matrix(Result[,2:10]))
write_xlsx(Result,path=paste0("SummaryResult_global-",Label,".xlsx"),col_names = TRUE)
