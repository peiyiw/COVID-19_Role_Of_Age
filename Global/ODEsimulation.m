function [Asym,Sym,NextAsym,NextSym] = ODEsimulation(pop_stru_size,suscep,asym_prob,contact_matrix,scale_factor,k,r,sigma,sigma_pre,gamma)

n = length(suscep);  %age_group number


contactmatrix = contact_matrix;
agegroup = pop_stru_size/sum(pop_stru_size);

duration = 200;

P=sum(pop_stru_size); 
sus = suscep; %susceptibility of each age group


beta_b =scale_factor .* sus;
sigma_a = sigma; %asymptomatic latent period^-1 [ref.Alberto,2020,nature human behavior]
sigma_s = sigma; %symptomatic latent period^-1 [ref.Alberto,2020,nature human behavior]
p = asym_prob; %asymptomatic portion





S_initial = 1;
Lstruct = agegroup;
Iastruct = agegroup;
Isstruct = agegroup;
HL(1,1:n) = S_initial .* Lstruct; %latent
HIa(1,1:n) = S_initial .* Iastruct; %infectious asymptomatic
HLp(1,1:n) = S_initial .* Isstruct; %infectious presymptomatic
HIs(1,1:n)=S_initial .* Isstruct; %infectious symptomatic
Is(1,1:n)=0; 
Ia(1,1:n)=0;
HS(1,1:n) = P.* agegroup-HL-HIa-HLp-HIs-Is-Ia; %susceptible
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
    
    Prob_infected = sum(((beta.*repmat(HIs(i-1,:)./HN(i-1,:),n,1)+beta_a.*repmat(HIa(i-1,:)./HN(i-1,:),n,1)...
        +beta_p.*repmat(HLp(i-1,:)./HN(i-1,:),n,1)).*repmat(HS(i-1,:)',1,n)), 2)';
    tmp_Exporue = Prob_infected;

    Age_cases(i,:) = tmp_Exporue;

    tmp = sum(((beta_a.*repmat(HIa(i-1,:)./HN(i-1,:),n,1)).*repmat(HS(i-1,:)',1,n)), 2)';
    Asym(i,1) = sum(tmp);
    tmp = sum(((beta.*repmat(HIs(i-1,:)./HN(i-1,:),n,1)+...
        +beta_p.*repmat(HLp(i-1,:)./HN(i-1,:),n,1)).*repmat(HS(i-1,:)',1,n)), 2)';
    Sym(i,1) = sum(tmp);

    NextAsym(i,1) = sum(p.*tmp_Exporue);
    NextSym(i,1) = sum((1-p).*tmp_Exporue);

    
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
    HS(i,:)=HS(i-1,:)-tmp_Exporue;
    %latent population
    HL(i,:)=HL(i-1,:)+tmp_Exporue-p.*(sigma_a.*HL(i-1,:))...
        -(1-p).*(sigma_s.*HL(i-1,:));
    %asymptomatic population
    HIa(i,:)=HIa(i-1,:)+p.*(sigma_a.*HL(i-1,:))-gamma.*HIa(i-1,:);%infectious
    %presymptomatic population
    HLp(i,:)=HLp(i-1,:)+(1-p).*(sigma_s.*HL(i-1,:))-sigma_pre.*HLp(i-1,:);%infectious
    %symptomatic population
    HIs(i,:)=HIs(i-1,:)+sigma_pre.*HLp(i-1,:)-gamma.*HIs(i-1,:); %infectious
    %recovered population
    HR(i,:)=HR(i-1,:)+gamma.*HIa(i-1,:)+gamma.*HIs(i-1,:); %infectious
    %all population
    HN(i,:)=HS(i,:)+HL(i,:)+HIa(i,:)+HLp(i,:)+HIs(i,:)+HR(i,:); 
    %daily confirmed cases
    Ia(i,:)=p.*(sigma_a.*HL(i-1,:));
    Is(i,:)=sigma_pre.*HLp(i-1,:);
end

end