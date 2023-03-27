library(tidyverse)
library(data.table)

#lag_amt <- 240
#ccf_table <- data.frame(tbl_lag = -lag_amt:lag_amt)

load("profile_sets.RData")

for (x in train_set) {
  profile_x <- read_csv(paste0("profile_", x, ".csv"))
  profile_x <- mutate(profile_x, test_seconds = as.numeric(rownames(profile_x))/2)
  
  loess01 <- loess(pm ~ test_seconds, data=profile_x, span=.01)
  
  profile_x <- profile_x %>%
    mutate(pm_loess = loess01[["fitted"]]) %>%
    mutate(delta_pm = (shift(pm_loess, n=-1, fill=0) - shift(pm_loess, n=1, fill=0))/2)
  
  delta_loess01 <- loess(delta_pm ~ test_seconds, data=profile_x, span=.01)
  
  profile_x <- profile_x %>%
    mutate(delta_pm_loess = delta_loess01[["fitted"]]) %>%
    mutate(delta_squared_pm = (shift(delta_pm_loess, n=-1, fill=0) - shift(delta_pm_loess, n=1, fill=0))/2)
  
  #corr_name <- paste0("profile_", x)
  #ccf_values <- ccf(profile_x$delta_pm_smooth, profile_x$pm, lag.max = lag_amt, type = "correlation", plot = FALSE, na.action = na.omit)
  #ccf_table <- mutate(ccf_table, "{{corr_name}}" := ccf_values[["acf"]])
  
  write_csv(profile_x, paste0("profile_", x, "_expanded.csv"))
  rm(profile_x)
  rm(loess01)
  rm(delta_loess01)
  #rm(corr_name)
  gc()
}

#ccf_mean <- apply(ccf_table[,-1], 1, mean)
#ccf_sd <- apply(ccf_table[,-1], 1, sd)
#ccf_table <- mutate(ccf_table, test_mean = ccf_mean, test_sd = ccf_sd)