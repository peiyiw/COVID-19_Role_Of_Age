# COVID-19_Role_Of_Age

Code for: Asymptomatic SARS-CoV-2 infection and the demography of COVID-19  

## Citation

Asymptomatic SARS-CoV-2 infection and the demography of COVID-19

Zengmiao Wang, Peiyi Wu, Jingyuan Wang, José Lourenço, Bingying Li, Benjamin Rader, Marko Laine, Hui Miao, Ligui Wang, Hongbin Song, Nita Bharti, John S. Brownstein, Ottar N. Bjornstad, Christopher Dye, Huaiyu Tian

## Abstract

Asymptomatic individuals carrying SARS-CoV-2 can transmit the virus and contribute to outbreaks of COVID-19, but it is not yet clear how the proportion of asymptomatic infections varies by age and geographic location. Here we use detailed surveillance data gathered during COVID-19 resurgences in six cities of China at the beginning of 2021 to investigate this question. Data were collected by multiple rounds of city-wide PCR test with detailed contact tracing, where each patient was monitored for symptoms through the whole course of infection. We find that the proportion of asymptomatic infections declines with age (coefficient =-0.006, P<0.01), falling from 56% in age group 0–9 years to 12% in age group >60 years. Using an age-stratified compartment model, we show that this age-dependent asymptomatic pattern together with the age distribution of overall cases can explain most of the geographic differences in reported asymptomatic proportions. Combined with demography and contact matrices from other countries worldwide, we estimate that a maximum of 22%–55% of SARS-CoV-2 infections would come from asymptomatic cases in an uncontrolled epidemic based on asymptomatic proportions in China. Our analysis suggests that flare-ups of COVID-19 are likely if only adults are vaccinated and that surveillance and possibly control measures among children will be still needed in the future to contain epidemic resurgence.

## Notes on the code

To run, you need a Matlab toolbox called "DRAM": DRAM is a combination of two ideas for improving the efficiency of Metropolis-Hastings type Markov chain Monte Carlo (MCMC) algorithms, Delayed Rejection and Adaptive Metropolis. This page explains the basic ideas behind DRAM and provides examples and Matlab code for the computations.(see http://helios.fmi.fi/~lainema/dram/)

About code folder: We used ”Fitting” folder to estimate the parameters for six cities (Shijiazhuang and Xingtai from Hebei province, Changchun and Tonghua from Jilin province, Harbin and Suihua from Heilongjiang province) in China respectively, “Simulation” folder to perform simulations evaluating the effect of initial values, contact matrix and age-structure on the reported asymptomatic proportion and “Global” folder to simulate COVID-19 trajectories for 150 countries across all continents using observed pattern from China paired with globally comprehensive covariates. The setting of the fixed parameters for each city and the meaning of each scenario can be found in the main text and supplemented material.

## Data

### The COVID-19 case data

For each city, the detailed surveillance data was collected from local Centers for Disease Control and Prevention, including the gender, age, and onset date. For each patient, the clinical endpoint (asymptomatic or symptomatic) was also collected.

### The global analysis

The country-specific contact matrices were obtained from previous study(Prem, Kiesha, Alex R. Cook, and Mark Jit. "Projecting social contact matrices in 152 countries using contact surveys and demographic data." PLoS computational biology 13, no. 9 (2017): e1005697.). The population demographics for 2020 were obtained from World Population Prospects 2019 and 150 countries were included in this analysis.
