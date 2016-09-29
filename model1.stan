data {
  int N;
  int D;
  int K;
  matrix[N,D] X;
  vector[N] Y;
  int N2K[N];
}
parameters {
  vector[D] beta;
  vector[K] brand;
  real<lower=0> s_Y;
  real<lower=0> s_brand;
}
transformed parameters {
  vector[N] mu;
  vector[N] mu_plus_brand;
  mu = X*beta;
  mu_plus_brand = mu + brand[N2K];
}
model {
  beta[1] ~ student_t(4, 0, 3);
  beta[2:(D-1)] ~ student_t(4, 0, 1);
  s_brand ~ student_t(4, 0, 1);
  brand ~ normal(0, s_brand); 
  Y ~ normal(mu_plus_brand, s_Y);
}
