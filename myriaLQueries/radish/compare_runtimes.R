library(ggplot2)
library(sqldf)


raw <- read.csv("google_sheet.csv", header=TRUE, sep=',')
colnames(raw) <- c("system", "task_string", "task_logical", "task_physical", "instance_type", "nworkers", "dataset", "runtime", "notes1", "notes2")

cleaned <- na.omit(raw)

resolved <- sqldf("select *, 'btwnCent' as task from cleaned
                 where task_string='btwnCent' or task_string='btwnCent_batch_MyriaL'
                 union all
                 select *, 'MM' as task from cleaned
                 where task_string='Matrix Multiply' or task_string='sparseMatMultQuery_MyriaL'
                 or task_string='sparseMatMultQuery_MyriaL.sql'
                 union all
                 select *, '3MM' as task from cleaned
                 where task_string='Three Mat Mult' or task_string='threeSparseMatMultQuery_MyriaL'
                 or task_string='threeSparseMatMultQuery_MyriaL.sql'
                 union all
                 select *, 'MCL' as task from cleaned
                 where task_string='MCL' or task_string='MCL_MyriaL' or task_string='MCL_MyriaL.sql'")
stopifnot(dim(cleaned)[0]==dim(resolved)[0])

plot <- ggplot(resolved, aes(x=dataset, y=runtime, fill=system)) +
  stat_summary(fun.y="mean", geom="bar", position="dodge", aes(width=0.9)) + 
  facet_grid(task ~ .) +
  scale_y_continuous(trans='log2') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggsave(plot=plot, filename='compare_runtimes.pdf')