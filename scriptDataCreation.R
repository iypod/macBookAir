d <- read.csv(file='PCdata.csv', stringsAsFactors=FALSE)
d_cpu <- read.csv(file='CPUdata.csv', skip=1, stringsAsFactors=FALSE)
rownames(d_cpu) <- d_cpu$CPU
company_names <- c('Lenovo', 'Dell', 'NEC', 'Panasonic', 'Fujitsu', 'VAIO', 'HP', 'Apple', 'AppleDscnt')
d$company_name <- factor(d$company_name, levels=company_names)
d$cpubenchmark <- d_cpu[d$CPU, ]$cpubenchmark/4000
d$price <- d$price/100000
d$display_res <- (d$display_res_width * d$display_res_height)/1920/1080
d$battery_time1 <- d$battery_time1/20
d$memory <- d$memory/16
d$SSD <- d$SSD/512
d$ports <- d$LAN_port

usb_cvt <- c('0'=0, '1'=0.5, '2'=0.8, '3'=1)
d$USB30_val <- usb_cvt[as.character(d$USB30)]
d$USB31_val <- usb_cvt[as.character(d$USB31)]

Y <- d$price
gr <- d$company_name
use_cols <- c('cpubenchmark', 'memory', 'SSD', 'PCIe', 'display_size', 'display_res', 'display_touch', 'display_glare', 'keyboard_light', 'battery_time1', 'weight', 'DVD', 'SIM', 'ports', 'USB30_val', 'USB31_val', 'output_HDMI', 'MSoffice')
X <- data.frame(1, d[ , use_cols])
data <- list(N=nrow(X), D=ncol(X), K=nlevels(gr), X=X, Y=Y, N2K=as.numeric(gr))
