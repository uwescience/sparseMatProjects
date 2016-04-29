library(ggplot2)

source("cleandata.R")

plot <- ggplot(data, aes(x=dataset, y=runtime, fill=system)) +
  stat_summary(fun.y="mean", geom="bar", position="dodge", aes(width=0.9)) + 
  facet_grid(task ~ .) +
  scale_y_continuous(trans='log2') +
  xlab("Dataset") +
  ylab("Time (s)") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggsave(plot=plot, filename='compare_runtimes.pdf')


