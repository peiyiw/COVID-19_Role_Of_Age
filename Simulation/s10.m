%homo_sus
function ydot = s1(t,theta,xdata)

n = 7;  %age_group number
% sjz-1 xt-2 cc-3 th-4 heb-5 sh-6
index = xdata.index;  %city index
%row1:contact col1:participant
cbaseline = xdata.cbaseline; %contact matrix during baseline
coutbreak = xdata.coutbreak; %contact matrix during outbreak
contactmatrix = cbaseline;
agegroup = xdata.age(index, :);
duration = 1000; 
dlockdown = xdata.dmin_onset(index); 
dconfirm = xdata.dconfirm(index); 
P=xdata.population(index); 
sus = xdata.sus ./ max(xdata.sus, [], 'all'); %susceptibility of each age group
% *******************homo_sus*******************
sus = repmat(sum(sus, 'all')/7,1,7);
% **********************************************

% param
beta_b =theta(1) .* sus;
sigma_a = 1/3; %asymptomatic latent period^-1 [ref.Aleta,2020,nature human behavior]
sigma_s = 1/3; %symptomatic latent period^-1 [ref.Aleta,2020,nature human behavior]
sigma_pre = 1/2; %presymptomatic period^-1 [ref.Aleta,2020,nature human behavior]
Theta=theta(2); %success rate of tracing and testing
r=1/3.84; %relative infectiousness of asymptomatic individuals [ref.Sayampanathan,2020,nature human behavior]
k=0.15; %proportion of presymptomatic transmission equals percent of infectioness [ref.Aleta,2020,nature human behavior]
p = [theta(7), theta(8), theta(9), theta(10), theta(11), theta(12), theta(13)]; %asymptomatic portion

Lstruct = xdata.Lstruct3(index, :);
Iastruct = xdata.Iastruct3(index, :);
Isstruct = xdata.Isstruct3(index, :);
HL(1,1:n) = theta(3) .* Lstruct; %latent
HIa(1,1:n) = theta(4) .* Iastruct; %infectious asymptomatic
HLp(1,1:n) = theta(5) .* Isstruct; %infectious presymptomatic
HIs(1,1:n)=theta(6) .* Isstruct; %infectious symptomatic
Is(1,1:n)=0; 
Ia(1,1:n)=0;
HS(1,1:n) = P.* agegroup-HL-HIa-HLp-HIs-Is-Ia; %susceptible
HN(1,1:n)= P .* agegroup; %all population


for i = 2:duration %time period
    if i > dlockdown
        contactmatrix = coutbreak;
    end
    beta = contactmatrix .* beta_b';
    beta_a = r .* beta;
    beta_p = k .* beta;
    
    Prob_infected = sum(((beta.*repmat(HIs(i-1,:)./HN(i-1,:),n,1)+beta_a.*repmat(HIa(i-1,:)./HN(i-1,:),n,1)...
        +beta_p.*repmat(HLp(i-1,:)./HN(i-1,:),n,1)).*repmat(HS(i-1,:)',1,n)), 2)';
    tmp_Exporue = Prob_infected;
    
    if i < dconfirm
        %% model
        %suspecitble population
        HS(i,:)=HS(i-1,:)-tmp_Exporue;
        %latent population
        HL(i,:)=HL(i-1,:)+tmp_Exporue-p.*(sigma_a.*HL(i-1,:))...
            -(1-p).*(sigma_s.*HL(i-1,:));
        %asymptomatic population
        HIa(i,:)=HIa(i-1,:)+p.*(sigma_a.*HL(i-1,:));%infectious
        %presymptomatic population
        HLp(i,:)=HLp(i-1,:)+(1-p).*(sigma_s.*HL(i-1,:))-sigma_pre.*HLp(i-1,:);%infectious
        %symptomatic population
        HIs(i,:)=HIs(i-1,:)+sigma_pre.*HLp(i-1,:); %infectious
        %all population
        HN(i,:)=HS(i,:)+HL(i,:)+HIa(i,:)+HLp(i,:)+HIs(i,:)+sum(Is,1)+sum(Ia,1); 
    else
        %% model
        %suspecitble population
        HS(i,:)=HS(i-1,:)-tmp_Exporue;
        %latent population
        HL(i,:)=HL(i-1,:)+tmp_Exporue-p.*(sigma_a.*(1-Theta).*HL(i-1,:))...
            -(1-p).*(sigma_s.*(1-Theta).*HL(i-1,:))-Theta.*HL(i-1,:);
        %asymptomatic population
        HIa(i,:)=HIa(i-1,:)+p.*(sigma_a.*(1-Theta).*HL(i-1,:))-Theta.*HIa(i-1,:);%infectious
        %presymptomatic population
        HLp(i,:)=HLp(i-1,:)+(1-p).*(sigma_s.*(1-Theta).*HL(i-1,:))-sigma_pre.*(1-Theta).*HLp(i-1,:)-Theta.*HLp(i-1,:);%infectious
        %symptomatic population
        HIs(i,:)=HIs(i-1,:)+sigma_pre.*(1-Theta).*HLp(i-1,:)-Theta.*HIs(i-1,:); %infectious
        %daily confirmed cases
        Is(i,:)=Theta.*HIs(i-1,:)+Theta.*HLp(i-1,:)+(1-p).*Theta.*HL(i-1,:);
        Ia(i,:)=Theta.*HIa(i-1,:)+p.*Theta.*HL(i-1,:);
        %all population
        HN(i,:)=HS(i,:)+HL(i,:)+HIa(i,:)+HLp(i,:)+HIs(i,:)+sum(Is,1)+sum(Ia,1); 
        if sum(tmp_Exporue) < 1
            break
        end
    end
end
ydot=[sum(Is,1)',sum(Ia,1)'];