
data = tibble(
  NB = rep(c(128,192,256),6) %>% factor,
  N = rep(c(50000,60000,64512),each=3,2),
  mapping = rep(c("5-4","4-5"),each=9) %>% factor,
  flops = c(
      399.99,400.13,395.26,
      402.55,406.44,405.16,
      397.60,401.64,399.03,
      399.77,400.94,397.17,
      404.82,406.92,404.54,
      396.61,402.34,399.31
    )
)

ggplot(data=data, aes(x=N,y=flops,col=NB, linetype = mapping))+
  geom_line() + 
  scale_color_manual(values=c("blue","orange","chocolate4")) + 
  ggtitle("Performance on HPLinpack for node cn07-07",
          "Calculated on different configuration parameters (probl. size → N, num. blocks → NB, block mapping → mapping") + 
  ylab("MFlops")
