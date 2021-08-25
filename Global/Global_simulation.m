clc
clear

%---parameters-------

r = 1/3.84;
k = 0.15;
sigma = 1/3;
sigma_pre = 1/2;
gamma = 1/5;
R0 = 2.4;

load result_sh;
suscep = xdata.sus ./ max(xdata.sus, [], 'all');

beta = 1;
%------------------


%asym_real = [0.56,0.52,0.33,0.31,0.31,0.25,0.12];
%sd_real = [0.3451498,0.2610158,0.2258966,0.2266949,0.2216288,0.1618324,0.1321003];
%asym_up = min(1,asym_real+sd_real);
%asym_down = max(0,asym_real-sd_real);

Label = 'ConfidenceInterval';

asym_real = [0.46299378,0.40720209,0.35141039,0.29561869,0.23982699,0.18403530,0.09755817];
asym_up = [0.5858031,0.5047769,0.4296170,0.3653930,0.3158359,0.2780726,0.2311883];

asym_down = [0.34018443,0.30962731,0.27320378,0.22584443,0.16381806,0.08999804,0];

DIR = strcat('./result_',Label,'/');

if exist(DIR,'dir')==0
   mkdir(DIR);
end

Country = readtable('Countries-with-Age-Structure-Contact.xlsx');
Country = table2cell(Country);
Country = convertCharsToStrings(Country);

Pop = readtable('Age-Structure_Global.xlsx');


[Index, Variant,Region_Subregion_CountryOrArea_] = readvars('Age-Structure_Global.xlsx');

Pop_age = Pop(:,9:15);
Pop_age = table2array(Pop_age);

Region_Subregion_CountryOrArea_ = convertCharsToStrings(Region_Subregion_CountryOrArea_);

for i=1:length(Country)
	Index = find(Region_Subregion_CountryOrArea_==Country(i));
	pop_stru_size = Pop_age(Index,:);
	contact_matrix = readtable(strcat("./ContactMatrix/",Country(i),".xlsx"));
	contact_matrix = table2array(contact_matrix);
	
	filename=strcat(DIR, Country(i), '_fixR0_simulation.xlsx');

	asym_prob = asym_real;
	[scale_factor,R0_actual] = target_R0(pop_stru_size,suscep,asym_prob,contact_matrix,beta,k,r,sigma,sigma_pre,gamma,R0);
	[Asym,Sym,NextAsym,NextSym] = ODEsimulation(pop_stru_size,suscep,asym_prob,contact_matrix,scale_factor,k,r,sigma,sigma_pre,gamma);
	tmp =  table(Asym, Sym, NextAsym, NextSym,'VariableNames',{'ContributedByAsym','ContributedBySym','Asym','Sym'});
	writetable(tmp,filename, 'Sheet', 'asym_real');
	
	asym_prob = asym_up;
	[scale_factor,R0_actual] = target_R0(pop_stru_size,suscep,asym_prob,contact_matrix,beta,k,r,sigma,sigma_pre,gamma,R0);
	[Asym,Sym,NextAsym,NextSym] = ODEsimulation(pop_stru_size,suscep,asym_prob,contact_matrix,scale_factor,k,r,sigma,sigma_pre,gamma);
	tmp =  table(Asym, Sym, NextAsym, NextSym,'VariableNames',{'ContributedByAsym','ContributedBySym','Asym','Sym'});
	writetable(tmp,filename, 'Sheet', 'asym_up');

	asym_prob = asym_down;
	[scale_factor,R0_actual] = target_R0(pop_stru_size,suscep,asym_prob,contact_matrix,beta,k,r,sigma,sigma_pre,gamma,R0);
	[Asym,Sym,NextAsym,NextSym] = ODEsimulation(pop_stru_size,suscep,asym_prob,contact_matrix,scale_factor,k,r,sigma,sigma_pre,gamma);
	tmp =  table(Asym, Sym, NextAsym, NextSym,'VariableNames',{'ContributedByAsym','ContributedBySym','Asym','Sym'});
	writetable(tmp,filename, 'Sheet', 'asym_down');

end




