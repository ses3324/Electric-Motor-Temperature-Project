library(ggplot2)

for (x in train_set) {
  profile_x <- read_csv(paste0("profile_", x, ".csv"))
  profile_x <- mutate(profile_x, test_seconds = as.numeric(rownames(profile_x))/2)
  
  print(ggplot(profile_x) +
    geom_line( aes(x=test_seconds, y=pm)) +
    ggtitle(paste0("Profile ", x)))
  
  rm(profile_x)
  gc()
}