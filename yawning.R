yawn.diff <- rep(0, 1e4)
for (i in 1:1e4){
  t <- mean(rbinom(34, 1, 14/50))
  c <- mean(rbinom(16, 1, 14/50))
  yawn.diff[i] <- t - c
}

hist(yawn.diff)

10/34 - 4/16

data.frame(yawn.diff) %>% filter(yawn.diff >= (10/34 - 4/16)) %>% summarize(p = n()/10000)

yawns <- rep(0, 1e3)
for (i in 1:1e3){
  t <- mean(rbinom(34, 1, 10/34))
  c <- mean(rbinom(16, 1, 4/16))
  yawns[i] <- t - c
}
data.frame(yawns) %>% ggplot(aes(x = yawns)) + 
  geom_histogram(fill = "white", color = "black", bins = 20)

data.frame(yawns) %>% filter(yawns > quantile(yawn.diff, c(.95))) %>% summarize(power = n()/1000)
