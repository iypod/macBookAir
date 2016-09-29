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
  s_brand ~ cauchy(0, 5); //t分布ではなく、半cauchy分布を使ってみる
  brand ~ normal(0, s_brand/1000); //推計値の値が0に近すぎるので、1000倍する
  Y ~ normal(mu_plus_brand, s_Y);
}
