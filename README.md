# COVID-19_Role_Of_Age

Code for: Asymptomatic SARS-CoV-2 infection and the demography of COVID-19

## Citation

Asymptomatic SARS-CoV-2 infection and the demography of COVID-19

Zengmiao Wang, Peiyi Wu, Jingyuan Wang, José Lourenço, Bingying Li, Benjamin Rader, Marko Laine, Hui Miao, Ligui Wang, Hongbin Song, Nita Bharti, John S. Brownstein, Ottar N. Bjornstad, Christopher Dye, Huaiyu Tian

## Abstract

Asymptomatic individuals carrying SARS-CoV-2 can transmit the virus and contribute to outbreaks of COVID-19, but it is not yet clear how the proportion of asymptomatic infections varies by age and geographic location. Here we use detailed surveillance data gathered during COVID-19 resurgences in six cities of China at the beginning of 2021 to investigate this question. Data were collected by multiple rounds of city-wide PCR test with detailed contact tracing, where each patient was monitored for symptoms through the whole course of infection. We find that the proportion of infections that is asymptomatic declines with age (coefficient=-0.006, 95% CI: -0.008–-0.003, P<0.01), falling from 42% (95% CI: 6%–78%) in age group 0–9 years to 11% (95% CI: 0%–25%) in age group >60 years. Using an age-stratified compartment model, we show that this age-dependent asymptomatic pattern, together with the distribution of cases by age, can explain most of the reported variation in asymptomatic proportions among cities. Through simulations integrating asymptomatic infection data from our study and others, we demonstrate that asymptomatic individuals play an important role in COVID-19 transmission, before and after mass vaccination. With growing numbers of people being vaccinated, we expect a higher proportion of infections to be transmitted by asymptomatic individuals. Active surveillance among children and vaccinated people would be still needed in the future to monitor epidemic trajectory.

## Notes on the code

To run, you need a Matlab toolbox called "DRAM": DRAM is a combination of two ideas for improving the efficiency of Metropolis-Hastings type Markov chain Monte Carlo (MCMC) algorithms, Delayed Rejection and Adaptive Metropolis. This page explains the basic ideas behind DRAM and provides examples and Matlab code for the computations.(see http://helios.fmi.fi/~lainema/dram/)

About code folder: We used ”Fitting” folder to estimate the parameters for six cities (Shijiazhuang and Xingtai from Hebei province, Changchun and Tonghua from Jilin province, Harbin and Suihua from Heilongjiang province) in China respectively, “Simulation” folder to perform simulations evaluating the effect of initial values, contact matrix and age-structure on the reported asymptomatic proportion and “Global” folder to simulate COVID-19 trajectories for 150 countries across all continents both in pre- and post-vaccination period. We used observed pattern from China paired with globally comprehensive covariates to investigate the relationship between asymptomatic proportion and demography (and social mixing) in pre-vaccination period. Based on asymptomatic infection data from our study and others, we made several assumptions in post-vaccination period: (1) all age groups over 20 have been vaccinated with a proportion of country’s vaccination coverage; (2) all types of vaccines are 60% effective against infection; (3) the age-dependent asymptomatic proportion of vaccinated individuals infected with SARS-CoV-2 for post-vaccination was twice as high as pre-vaccination. The setting of the fixed parameters for each city and the meaning of each scenario can be found in the main text and supplemented material.

## Data

### The COVID-19 case data

For each city, the detailed surveillance data was collected from local Centers for Disease Control and Prevention, including the gender, age, and onset date. For each patient, the clinical endpoint (asymptomatic or symptomatic) was also collected.

### The global analysis

The country-specific contact matrices were obtained from previous study(Prem, Kiesha, Alex R. Cook, and Mark Jit. "Projecting social contact matrices in 152 countries using contact surveys and demographic data." PLoS computational biology 13, no. 9 (2017): e1005697.). The population demographics for 2020 were obtained from World Population Prospects 2019 and 150 countries were included in this analysis. The uncontrolled epidemic for each country was simulated. In this analysis, the relationship between asymptomatic proportion and demography (and social mixing) was investigated. Besides, the NPI affects the total infections by assuming the homogeneous effect among different age groups, not the infection proportions across different age groups. Therefore, it was not necessary to account for the country-specific strength of non-pharmaceutical interventions and the model reflecting the normal disease progression was used.
