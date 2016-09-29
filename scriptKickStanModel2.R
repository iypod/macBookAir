#ハイパーパラメータの事前分布を半コーシー分布に変えてみるモデル

library(rstan); rstan_options(auto_write = TRUE); options(mc.cores = parallel::detectCores())

#モデル作成
model2 <- stan_model(file='model2.stan')

#Stanをキック
fit2 <- sampling(model2, data, iter = 11000, warmup = 1000, thin = 10, seed=1)

#収束診断
print(fit2, digits = 1)
plot(fit2) + ggtitle("fit2")
traceplot(fit2, pars = c("s_Y", "s_brand", "lp__"), ncol = 1, inc_warmup = F)
stan_hist(fit2, pars = c("s_Y", "s_brand", "lp__"), ncol = 1)
stan_dens(fit2, pars = c("s_Y", "s_brand", "lp__"), separate_chains = T, ncol = 1) + ggtitle("fit2")
stan_ac(fit2, pars = c("s_Y", "s_brand", "lp__"), ncol = 1) + ggtitle("fit2")  #自己相関: 自己相関が高そうなら、thinを大きくする
stan_mcse(fit2, pars = c("s_Y", "s_brand", "lp__")) #MonteCarloSE:10%より大きい場合はパラメーターの信頼度が低いので、chainとiterを増やす
stan_ess(fit2, pars = c("s_Y", "s_brand", "lp__")) #effective sample size: 10%をきっている場合は、thinを大きくする
stan_rhat(fit2, pars = c("s_Y", "s_brand", "lp__")) #Rhat: 1.05〜1.1を上回る場合はIterを増やす

#これはやらなくてもいいか
stan_diag(fit2) #LogPosteriorと受容率のグラフ
stan_scat(fit2, pars = c("s_brand", "lp__")) #2パラメーターの散布図
