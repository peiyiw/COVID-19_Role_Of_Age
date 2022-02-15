function [Asym,Sym,NextAsym,NextSym] = ODEsimulation_post(pop_stru_size,suscep,asym_prob,contact_matrix,scale_factor,k,r,sigma,sigma_pre,gamma_a, gamma_s, pv)

n = length(suscep);  %age_group number


contactmatrix = contact_matrix;
agegroup = pop_stru_size/sum(pop_stru_size);

duration = 400;

P=sum(pop_stru_size); 
sus = suscep; %susceptibility of each age group


beta_b =scale_factor .* sus;
sigma_a = sigma; %asymptomatic latent period^-1 [ref.Alberto,2020,nature human behavior]
sigma_s = sigma; %symptomatic latent period^-1 [ref.Alberto,2020,nature human behavior]
ap = asym_prob; %asymptomatic portion
apv = asym_prob.*2; %vaccinated indivual are prone to be asymptomatic

S_initial = 1;
Lstruct = agegroup;
Iastruct = agegroup;
Isstruct = agegroup;
HLS(1,1:n) = S_initial .* Lstruct; %latent
HLV(1,1:n) = S_initial .* Lstruct; %latent
HIa(1,1:n) = S_initial .* Iastruct; %infectious asymptomatic
HLp(1,1:n) = S_initial .* Isstruct; %infectious presymptomatic
HIs(1,1:n)= S_initial .* Isstruct; %infectious symptomatic
Is(1,1:n)=0; 
Ia(1,1:n)=0;
HS(1,1:n) = P.* agegroup-HLS-HLV-HIa-HLp-HIs-Is-Ia; %susceptible
HV(1,1:n)=[0,0, HS(1,3:n)*pv]; %vaccinated people, only >20 years old

HS(1,1:n)=HS(1,1:n)-HV(1,1:n); %full suspected people
ve = 0.6; % 60%vaccine effectiveness 40%infeciton

HN(1,1:n)= P .* agegroup; %all population
HR(1,1:n)=0; %recovered population

Sym(1,1) =0;
Asym(1,1) = 0;
NextSym(1,1) =0;
NextAsym(1,1) = 0;

Age_cases(1,1:n) =0;

for i = 2:duration %time period
    beta = contactmatrix .* beta_b';
    beta_a = r .* beta;
    beta_p = k .* beta;
    
    HS(i-1,HS(i-1,:)<0) =0;
    HV(i-1,HV(i-1,:)<0) =0;
    
    Prob_infected_s = sum(((beta.*repmat(HIs(i-1,:)./HN(i-1,:),n,1)+beta_a.*repmat(HIa(i-1,:)./HN(i-1,:),n,1)...
        +beta_p.*repmat(HLp(i-1,:)./HN(i-1,:),n,1)).*repmat(HS(i-1,:)',1,n)), 2)';
    Prob_infected_v = sum(((beta.*repmat(HIs(i-1,:)./HN(i-1,:),n,1)+beta_a.*repmat(HIa(i-1,:)./HN(i-1,:),n,1)...
        +beta_p.*repmat(HLp(i-1,:)./HN(i-1,:),n,1)).*repmat(HV(i-1,:)'.*(1-ve),1,n)), 2)';
    tmp_Exporue = Prob_infected_s+Prob_infected_v;

    Age_cases(i,:) = tmp_Exporue;

    tmp = sum(((beta_a.*repmat(HIa(i-1,:)./HN(i-1,:),n,1)).*repmat(HS(i-1,:)',1,n)), 2)'+...
    sum(((beta_a.*repmat(HIa(i-1,:)./HN(i-1,:),n,1)).*repmat(HV(i-1,:)'.*(1-ve),1,n)), 2)';
    Asym(i,1) = sum(tmp);

    tmp = sum(((beta.*repmat(HIs(i-1,:)./HN(i-1,:),n,1)+...
        +beta_p.*repmat(HLp(i-1,:)./HN(i-1,:),n,1)).*repmat(HS(i-1,:)',1,n)), 2)'+...
    sum(((beta.*repmat(HIs(i-1,:)./HN(i-1,:),n,1)+...
        +beta_p.*repmat(HLp(i-1,:)./HN(i-1,:),n,1)).*repmat(HV(i-1,:)'.*(1-ve),1,n)), 2)';
    Sym(i,1) = sum(tmp);

    NextAsym(i,1) = sum(ap.*Prob_infected_s)+sum(apv.*Prob_infected_v);
    NextSym(i,1) = sum((1-ap).*Prob_infected_s)+sum((1-apv).*Prob_infected_v);

    
    if i > 20
        if HIa(i-1,:)<1
            HIa(i-1,:)=0;
        end
        if HIs(i-1,:)<1
            HIs(i-1,:)=0;
        end
        if HLp(i-1,:)<1
            HLp(i-1,:)=0;
        end
    end
    %% model
    %suspecitble population
    HS(i,:)=HS(i-1,:)-Prob_infected_s;
    HV(i,:)=HV(i-1,:)-Prob_infected_v;
    %latent population
    HLS(i,:)=HLS(i-1,:)+Prob_infected_s-sigma_a.*HLS(i-1,:);
    HLV(i,:)=HLV(i-1,:)+Prob_infected_v-sigma_a.*HLV(i-1,:);
    %asymptomatic population
    HIa(i,:)=HIa(i-1,:)+ap.*(sigma_a.*HLS(i-1,:))+apv.*(sigma_a.*HLV(i-1,:))-gamma_a.*HIa(i-1,:);%infectious
    %presymptomatic population
    HLp(i,:)=HLp(i-1,:)+(1-ap).*(sigma_s.*HLS(i-1,:))+(1-apv).*(sigma_s.*HLV(i-1,:))-sigma_pre.*HLp(i-1,:);%infectious
    %symptomatic population
    HIs(i,:)=HIs(i-1,:)+sigma_pre.*HLp(i-1,:)-gamma_s.*HIs(i-1,:); %infectious
    %recovered population
    HR(i,:)=HR(i-1,:)+gamma_a.*HIa(i-1,:)+gamma_s.*HIs(i-1,:); %infectious
    %all population
    HN(i,:)=HS(i,:)+HLS(i,:)+HLV(i,:)+HIa(i,:)+HLp(i,:)+HIs(i,:)+HR(i,:)+HV(i,:); 
    %daily confirmed cases
    Ia(i,:)=ap.*(sigma_a.*HLS(i-1,:))+apv.*(sigma_a.*HLV(i-1,:));
    Is(i,:)=sigma_pre.*HLp(i-1,:);
end

end