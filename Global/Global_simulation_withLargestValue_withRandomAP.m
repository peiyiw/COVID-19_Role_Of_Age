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



Label = 'ConfidenceInterval_withLargestValue_Random';

asym_real = [0.92,0.78,0.59,0.54,0.53,0.43,0.32];

asym_up = [0.9520400,0.8455470,0.7438708,0.6511742,0.5705207,0.4995511,0.3991131];

asym_down = [0.7503611,0.6853086,0.6154391,0.5365901,0.4456980,0.3451220,0.1796642];

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

N = 20;
asym_random = zeros(N,7);
for i=1:N
	a = asym_down(1);
	b= asym_up(1);
	asym_random(i,1) = (b-a).*rand(1) + a;
	for M=2:7
		a = asym_down(M);
		b= asym_random(i,M-1);
		asym_random(i,M) = (b-a).*rand(1) + a;
	end
end
save(strcat(DIR, 'APrandom.mat'),'asym_random');

for i=1:length(Country)
	Index = find(Region_Subregion_CountryOrArea_==Country(i));
	pop_stru_size = Pop_age(Index,:);
	contact_matrix = readtable(strcat("./ContactMatrix/",Country(i),".xlsx"));
	contact_matrix = table2array(contact_matrix);
	
	filename=strcat(DIR, Country(i), '_fixR0_simulation.xlsx');

	for j=1:N
		asym_prob = asym_random(j,:);
		[scale_factor,R0_actual] = target_R0(pop_stru_size,suscep,asym_prob,contact_matrix,beta,k,r,sigma,sigma_pre,gamma,R0);
		scale_factor
		[Asym,Sym,NextAsym,NextSym] = ODEsimulation(pop_stru_size,suscep,asym_prob,contact_matrix,scale_factor,k,r,sigma,sigma_pre,gamma);
		tmp =  table(Asym, Sym, NextAsym, NextSym,'VariableNames',{'ContributedByAsym','ContributedBySym','Asym','Sym'});
		writetable(tmp,filename, 'Sheet', int2str(j));
		clearvars asym_prob scale_factor R0_actual Asym Sym NextAsym NextSym tmp
	end

	
end




