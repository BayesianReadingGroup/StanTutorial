library(tidyverse)
library(bayesplot)
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Read the data
data <- read_csv(file="data/passives.csv",
  col_types = list(id      = col_skip(), # Don't need this column
                   passive = col_integer(),
                   n_w     = col_skip(),
                   n_s     = col_integer(),
                   cat     = col_factor(),
                   genre   = col_skip(), # Genre are the named categories, we don't need both
                   lang    = col_factor(c("AmE", "BrE")))) # 1 : AmE, 2: BrE

# Prepare data for stan
data <- data %>% group_by(cat, lang) %>% summarise(passive = sum(passive), n_s=sum(n_s)) # Combine observations
data <- data %>% mutate(lang_idx = as.numeric(lang))
data <- data %>% mutate(cat_idx  = as.numeric(cat))
data <- data %>% mutate(treatment_idx = cat_idx * (lang_idx  + lang_idx%%2) - lang_idx%%2) # Indexes cartesian product (language x category)

stan_data <- list("T"              = "......",
                  "treatment_idx"  = "......",
                  "N"              = "......",
                  "y"              = "......",
                  "n"              = "......" )

# Run the Model and save fit
fit <- stan(file="models/YOUR MODEL HERE", data=stan_data, chains=4, iter=2000)
saveRDS(fit,"model_fits/simple_binom.rds")
