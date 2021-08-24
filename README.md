# COVID-19_Role_of_age
Code for: How asymptomatic SARS CoV-2 infection varies by demographics   
## Citation

Determining the optimal population-level testing strategy and contact tracing to curb COVID-19 resurgence

Zengmiao Wang, Bingying Li, Yidan Li, Yonghong Liu, Ottar N. Bjornstad, Huaiyu Tian.

## Abstract

Due to the emerging new variants and the logistic constraints on vaccine roll-out, non-pharmaceutical interventions are still key activities to contain the spread of SARS-CoV-2 virus. Given the apparent substantial contribution to transmission by asymptomatic infections, population-level testing and contact tracing are critical interventions to cut transmission chains. Here, we investigate the effectiveness of population-level testing strategies, including a combination of testing interval, testing frequency, break interval (days of respite for testing crew), and response time, to curb COVID-19 resurgence using a data set that includes both symptomatic and asymptomatic cases detected from multiple rounds of population-level testing and contact tracing in several Chinese cities. We show that resurgent outbreaks in a city could be controlled by 2–5 rounds of population-level testing, supplemented by contact tracing as long as testing is frequent. However, data and models suggest that the window for control is narrowing for resurgence triggered by new more contagious variants such as lineage B.1.1.7 and P.1. Two rounds of population-level testing would still be needed to curb the transmission even with more than 50% of vaccine coverage. Our analysis potentially provides examples to control future flare-ups of SARS-CoV-2, even when immunity coverage against pre-existing lineage has been established.

## Notes on the code

To run, you need a Matlab toolbox called "DRAM": DRAM is a combination of two ideas for improving the efficiency of Metropolis-Hastings type Markov chain Monte Carlo (MCMC) algorithms, Delayed Rejection and Adaptive Metropolis. This page explains the basic ideas behind DRAM and provides examples and Matlab code for the computations.(see http://helios.fmi.fi/~lainema/dram/)

About code folder:

About code folder: We used three code folders to estimate the parameters for Tonghua, Changchun and Xingtai, respectively. For each folder: main file 1 (fitting the model): f1.m; function dependencies:f2.m,f3.m,f4.m; The setting of the fixed parameters for each city can be found in the main text and supplemented material.

The code to simulate the scenarios can be found in the Tonghua folder: main file 2: f_simu2.m; function dependencies:fsimu_deterministic.m,fsimu_P_deterministic.m,fsimu_MiddleSize_deterministic.m,fsimu_runFromMiddle_deterministic.m,fsimu_Vaccine_deterministic.m,fsimu_Vaccine_deterministic_asym.m; Note that do not run this file directly since running time is quite long.




## Data

### Epidemiological data

We collected the daily official case reports from the health commission of 2 provincial-level administrative units and 3 city-level units, the website’s links are provided. The information was collected by Bingying Li.

### Population-level testing strategy

We prepared the population-testing strategy files (for example: population_testing_strategy_break0.xlsx. "break0" represents the break interval is 0 day.). Each column represents one popualtion-level testing strategy.
