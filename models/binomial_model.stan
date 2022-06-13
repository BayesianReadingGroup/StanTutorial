// Example passives solution
data{
  int N;                                   // Number of data points
  int T;                                   // Number of treatments : lang * genre pairs
  int<lower=1, upper=T> treatment_idx[N];  // What observation belongs to what treatment
  int<lower=0> y[N];                       // Data: number of passive constructions
  int<lower=0> n[N];                       // Data: number of sentences
}
parameters{
  real<lower=0, upper=1> theta[T];
}
model{
  theta ~ beta(2,5);

  for(i in 1:N){
    y[i] ~ binomial(n[i], theta[treatment_idx[i]]); // Looping instead of vectorising for clarity
  }
}
generated quantities{
  real y_prior[N];
  real y_post[N];
  real theta_pr[T];

  for(i in 1:T){
    theta_pr[i] =  beta_rng(2,5);
  }

  for(i in 1:N){
    y_prior[i] = binomial_rng(n[i], theta_pr[treatment_idx[i]]); // prior prediction
    y_post[i]  = binomial_rng(n[i], theta[treatment_idx[i]]);    // posterior prediction
  }
}
