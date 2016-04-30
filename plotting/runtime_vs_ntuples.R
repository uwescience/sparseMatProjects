library(ggplot2)

source("cleandata.R")

get_theme <- function(size) {
  return (theme(
    panel.background = element_rect(fill="white"),
    panel.border = element_rect(fill=NA, color="grey50"),
    panel.grid.major = element_line(color="grey80", size=0.3),
    panel.grid.minor = element_line(color="grey90", size=0.3),
    strip.background = element_rect(fill="grey90", color="grey50"),
    strip.background = element_rect(fill="grey80", color="grey50"),
    axis.ticks = element_line(colour="black"),
    panel.grid = element_line(colour="black"),
    axis.text.y = element_text(colour="black", size=size),
    axis.text.x = element_text(colour="black", size=size),
    axis.title.y = element_text(colour="black", size=size),
    axis.title.x = element_text(colour="black", size=size),
    legend.text = element_text(colour="black", size=size)
    #text = element_text(size=14, family="Open Sans")
  ))
}

plot <- ggplot(data, aes(x=num_tuples, y=runtime, color=system)) +
  stat_summary(fun.y="mean", geom="point") + 
  facet_grid(task ~ .) +
  scale_y_continuous(trans='log10') +
  scale_x_continuous(trans='log10') +
  scale_color_brewer(palette = "Set1", "") + 
  xlab("# nonzeros/edges") +
  ylab("Time (s)") + 
  get_theme(18)

ggsave(plot=plot, filename='runtime_vs_ntuples.pdf')