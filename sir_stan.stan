
functions{
  
 vector sir(real t, vector y, vector theta){
    
    real S = y[1];
    real I = y[2];
    real R = y[3];
    
    real beta = theta[1];
    real gamma = theta[2];
    real N = theta[3];
    
    vector[3] output;
    
    output[1] = -beta * S * I / N;
    output[2] = beta * S * I /N - gamma * I;
    output[3] = gamma * I ;
    
    return output;
    
  }
}
data{
  int<lower=1> T;
  array[T] real ts;
  int<lower=1> N;
  array[T] int I_obs;
  real<lower=0> gamma;
}

parameters{
  real<lower=0> beta;
  real<lower=0, upper=N> S0;
  real<lower=0, upper=N> I0;
  
  
}

transformed parameters{
  array[T] vector[3] y_hat;
  vector[3] y0;
  real t0=0;
  vector[3] theta;
  theta[1] = beta;
  theta[2] = gamma;
  theta[3] = N;
  
  y0[1] = S0;
  y0[2] = I0;
  y0[3] = N - S0 - I0;
  y_hat = ode_rk45(sir, y0, t0,ts,theta);
}

model{
  beta ~ normal(10,5);
  S0 ~ uniform(0,N);
  I0 ~ uniform(0,N);
  for(t in 1:T)
    I_obs[t] ~ poisson(y_hat[t,2]);
  
}

generated quantities{
  
  array[T] real y_rep;
  for(t in 1:T)
    y_rep[t] = poisson_rng(y_hat[t,2]);
  
}
