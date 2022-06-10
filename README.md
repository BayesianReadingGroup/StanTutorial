# StanTutorial

*13/06/22* : Stan Tutorial for **Bristol Bayes for the Brain**.

Run the Binomial model for the biased coin data: <code>Rscript run_example.r</code>

<code>sample_model.r</code> is a skeleton script that loads the passives.csv data into R. When provided with a stan model the script will initiate the sampling process and save the result in the "model_fits" directory.

### Libraries

The libraries we will be using are:

* *[Rstan](https://mc-stan.org/users/interfaces/rstan)* - sampling posteriors with HMC
* *[Tidyverse](https://www.tidyverse.org/)* -  data manipulation and plotting
* *[Bayesplot](http://mc-stan.org/bayesplot/)* -  plotting
