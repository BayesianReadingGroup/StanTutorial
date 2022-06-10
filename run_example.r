library(rstan)
library(readr)
library(bayesplot)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

data <- read_csv("data/coin.csv",
          col_types = list(ID = col_factor(),
                      Heads   = col_integer(),
                      Flips   = col_integer(),
                      P_Heads = col_double())) # Read in the data

# Prepare data for Stan
stan_data <- list(N = nrow(data),
                  y = data$Heads,
                  n = data$Flips)

# Sample the model
fit <- stan(file="models/binom_coin.stan", data=stan_data, chains=4, iter=2000)
saveRDS(fit, "model_fits/binom_coin.rds")

# Extract theta samples, needs to be a matrix with named columns for the recovery plot
theta <- extract(fit, "theta")$theta
colnames(theta) <- paste(rep("theta[", stan_data$N), c(1:stan_data$N), "]", sep="") # Name the columns

# plotting
color_scheme_set("mix-purple-green")
p_trace <- mcmc_combo(fit, c("dens_overlay","trace"), pars=c("theta[1]", "theta[7]"), gg_theme=legend_none())
ggsave(plot=p_trace, filename="plots/trace_plot.png", dpi=600, units="mm", height=96*0.8, width=126*0.8) # Maybe just overlay data on this

color_scheme_set("purple")
p_recover_hist <- mcmc_recover_hist(theta[, c(1,7)], true=data$P_Heads[c(1,7)]) + legend_none()
ggsave(plot=p_recover_hist, filename="plots/recover_plot.png", dpi=600, units="mm", height=96*0.8, width=126*0.8)
