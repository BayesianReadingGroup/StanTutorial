data{
  int N;
  int y[N];
  int n[N];
}
parameters{
  real<lower=0, upper=1> theta[N];
}
model{
  theta ~ beta(2,2);         // Assigns a beta(2,2) to each theta
  y     ~ binomial(n,theta); // Observation model
}
generated quantities{
  int yrep[N];

  for(i in 1:N){
    yrep[i] = binomial_rng(n[i], theta[i]); // Posterior predictive distribution
  }
}
