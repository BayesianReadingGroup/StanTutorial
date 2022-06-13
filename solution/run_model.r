library(rstan)
library(bayesplot)
library(tidyverse)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Read the data
data <- read_csv(file="../data/passives.csv",
  col_types = list(id      = col_skip(),
                   passive = col_integer(),
                   n_w     = col_skip(),
                   n_s     = col_integer(),
                   cat     = col_factor(),
                   genre   = col_skip(),
                   lang    = col_factor(c("AmE", "BrE"))))

# Prepare data for stan
data <- data %>% group_by(cat, lang) %>% summarise(passive = sum(passive), n_s=sum(n_s)) # Combine observations
data <- data %>% mutate(lang_idx=as.numeric(lang))
data <- data %>% mutate(cat_idx=as.numeric(cat))
data <- data %>% mutate(treatment_idx = cat_idx * (lang_idx  + lang_idx%%2) - lang_idx%%2)

stan_data <- list("T"              = length(data$treatment_idx),
                  "treatment_idx"  = data$treatment_idx,
                  "N"              = length(data$passive),
                  "y"              = data$passive,
                  "n"              = data$n_s)

# Run the Model and save fit
fit <- stan(file="../models/binomial_model.stan", data=stan_data, chains=4, iter=2000)
saveRDS(fit,"../model_fits/simple_binom_soln.rds")

fit
