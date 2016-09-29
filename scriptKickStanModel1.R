#オリジナルモデル

library(rstan); rstan_options(auto_write = TRUE); options(mc.cores = parallel::detectCores())

#モデル作成
model1 <- stan_model(file='model1.stan')

#Stanをキック。自己相関が強そうだったので、オリジナルと比べ、thinを大きくし、iterを増やした
fit1 <- sampling(model1, data, iter = 6000, warmup = 1000, thin = 5, seed=1)

#収束診断
print(fit1, digits = 1)
plot(fit1) + ggtitle("fit1")
traceplot(fit1, pars = c("s_Y", "s_brand", "lp__"), ncol = 1, inc_warmup = F)
stan_hist(fit1, pars = c("s_Y", "s_brand", "lp__"), ncol = 1)
stan_dens(fit1, pars = c("s_Y", "s_brand", "lp__"), separate_chains = T, ncol = 1) + ggtitle("fit1")
stan_ac(fit1, pars = c("s_Y", "s_brand", "lp__"), ncol = 1) + ggtitle("fit1") #自己相関: 自己相関が高そうなら、thinを大きくする
stan_mcse(fit1, pars = c("s_Y", "s_brand", "lp__")) #MonteCarloSE:10%より大きい場合はパラメーターの信頼度が低いので、chainとiterを増やす
stan_ess(fit1, pars = c("s_Y", "s_brand", "lp__")) #effective sample size: 10%をきっている場合は、thinを大きくする
stan_rhat(fit1, pars = c("s_Y", "s_brand", "lp__")) #Rhat: 1.05〜1.1を上回る場合はIterを増やす

#これはやらなくてもいいか
stan_diag(fit1) #LogPosteriorと受容率のグラフ
stan_scat(fit1, pars = c("s_brand", "lp__")) #2パラメーターの散布図
