library(tidyverse)

motor_data <- read_csv("measures_v2.csv")

motor_data$profile_id <- as.factor(motor_data$profile_id)

num_levels <- nlevels(motor_data$profile_id)
x_lvl <- 1:num_levels

for (x in x_lvl) {
  levels(motor_data$profile_id)[x] <- x
}

dfs <- split(motor_data, motor_data$profile_id)
lapply(names(dfs), function(y){write_csv(dfs[[y]], file = paste0("profile_", y, ".csv"))})

set.seed(314159)
x_lvl_rand <- sample(x_lvl)

test_num <- floor(num_levels*0.8)
train_set <- x_lvl_rand[1:test_num]
test_set <- x_lvl_rand[(test_num+1):num_levels]

save(train_set, test_set, file = "profile_sets.RData")

rm(dfs)
rm(motor_data)
gc()