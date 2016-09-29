library(ggplot2); library(tidyverse)
res <- summary(fit1)$summary

#項目vs影響グラフ
g1 <- res[2:19,c(1, 4, 8)] %>% as.data.frame()
colnames(g1) <- c("value", "lower", "upper")
g1$factor <- factor(use_cols, levels = rev(use_cols))
ggplot(g1, aes(factor, value, ymin = lower, ymax = upper)) + 
  theme(axis.text.y = element_text(size=13)) + geom_hline(yintercept = 0, linetype = "dashed", size = 0.5) +
  geom_point(size = 5) + geom_linerange(size = 1) + coord_flip() + xlab("")

#ブランドvs影響グラフ
g2 <- res[20:28,c(1, 4, 8)] %>% as.data.frame()
colnames(g2) <- c("value", "lower", "upper")
g2$company <- factor(levels(gr), levels = rev(levels(gr)))
ggplot(g2, aes(company, value, ymin = lower, ymax = upper, col = company)) + 
  theme(axis.text.y = element_text(size=13)) + geom_hline(yintercept = 0, linetype = "dashed", size = 0.5) +
  geom_point(size = 5) + geom_linerange(size = 1) + coord_flip() + xlab("")

#真の値段と実際の値段のグラフ
#データ整形
g3 <- res[31:(31-1+nrow(X)),c(1, 4, 8)] %>% as.data.frame()
g3 <- g3 * 100000
colnames(g3) <- c("calculatedValue", "lower", "upper")
g3$price <- d$price * 100000
g3$priceReduction <- (g3$price - g3$calculatedValue) / g3$calculatedValue
g3$model <- factor(d$model_name)
g3$company <- d$company_name
g3$serch_site <- d$search_site
g3$CPU <- d$CPU
g3$memory <- d$memory * 16 
g3$SSD <- d$SSD * 512

#グラフ加工
g3 <- g3 %>% arrange(priceReduction)
ggplot(g3, aes(price, calculatedValue, ymin = lower, ymax = upper, col = model, shape = model)) + 
  geom_abline(intercept=0, slope=1, linetype = "dashed", size = 0.5) + 
  scale_shape_manual(values = rep(16:17, 12)) +
  geom_point(size = 3) + geom_linerange(size = 1, alpha = 0.5) + 
  xlab("real price") + ylab("calculated price")
