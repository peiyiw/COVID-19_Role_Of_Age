# COVID-19_Role_Of_Age

Code for: Asymptomatic SARS-CoV-2 infection and the demography of COVID-19

## Citation

Asymptomatic SARS-CoV-2 infection and the demography of COVID-19

Zengmiao Wang, Peiyi Wu, Jingyuan Wang, José Lourenço, Bingying Li, Benjamin Rader, Marko Laine, Hui Miao, Ligui Wang, Hongbin Song, Nita Bharti, John S. Brownstein, Ottar N. Bjornstad, Christopher Dye, Huaiyu Tian

## Abstract

Background: Asymptomatic individuals carrying SARS-CoV-2 can transmit the virus and contribute to outbreaks of COVID-19, but it is not yet clear how the proportion of asymptomatic infections varies by age and geographic location. Here we investigate the underlying factors related to the heterogeneity of asymptomatic proportion. 

Methods: We use detailed surveillance data gathered during COVID-19 resurgences in six cities of China at the beginning of 2021 to investigate this question. Data were collected by multiple rounds of city-wide PCR test with detailed contact tracing, where each patient was monitored for symptoms through the whole course of infection. We develop an age-stratified compartment model to estimate the asymptomatic proportion. 

Results: We find that the proportion of infections that is asymptomatic declines with age (coefficient=-0.006, 95% CI: -0.008–-0.003, P<0.01), falling from 42% (95% CI: 6%–78%) in age group 0–9 years to 11% (95% CI: 0%–25%) in age group >60 years. Using an age-stratified compartment model, we show that this age-dependent asymptomatic pattern, together with the distribution of cases by age, can explain most of the reported variation in asymptomatic proportions among cities. 

Conclusions: Age-dependent asymptomatic pattern and the distribution of SARS-CoV-2 infections by age contribute to the heterogeneity of asymptomatic proportion. Active surveillance among high-asymptomatic-proportion groups would be still needed in the future to monitor epidemic trajectory. 

Keywords: Asymptomatic infection; Age; Geographic location; Age-stratified compartment model. 


## Notes on the code

To run, you need a Matlab toolbox called "DRAM": DRAM is a combination of two ideas for improving the efficiency of Metropolis-Hastings type Markov chain Monte Carlo (MCMC) algorithms, Delayed Rejection and Adaptive Metropolis. This page explains the basic ideas behind DRAM and provides examples and Matlab code for the computations.(see http://helios.fmi.fi/~lainema/dram/)

About code folder: We used ”Fitting” folder to estimate the parameters for six cities (Shijiazhuang and Xingtai from Hebei province, Changchun and Tonghua from Jilin province, Harbin and Suihua from Heilongjiang province) in China respectively and “Simulation” folder to perform simulations evaluating the effect of initial values, contact matrix and age-structure on the reported asymptomatic proportion. The setting of the fixed parameters for each city and the meaning of each scenario can be found in the main text and supplemented material.

## Data

### The COVID-19 case data

For each city, the detailed surveillance data was collected from local Centers for Disease Control and Prevention, including the gender, age, and onset date. For each patient, the clinical endpoint (asymptomatic or symptomatic) was also collected.

