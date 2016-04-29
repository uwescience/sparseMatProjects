library(sqldf)

raw <- read.csv("google_sheet.csv", header=TRUE, sep=',')
colnames(raw) <- c("system", "task_string", "task_logical", "task_physical", "instance_type", "nworkers", "dataset", "runtime", "notes1", "notes2")

datasets <- read.csv("datasets.csv", header=TRUE, sep=',')

cleaned <- na.omit(raw)

# Resolve dataset names
#resolved <- sqldf(c("update cleaned set dataset='undirNet_1000_sm.matrix.dat' where dataset='undirNet_1000.matrix.dat'",
#                    "select * from main.cleaned"))
#resolved <- sqldf(c("update resolved set dataset='undirNet_5000_sm.matrix.dat' where dataset='undirNet_5000.matrix.dat'",
#                    "select * from main.resolved"))
cleaned[cleaned$dataset=='undirNet_1000_sm.matrix.dat',]$dataset <- 'undirNet_1000.matrix.dat'
cleaned[cleaned$dataset=='undirNet_5000_sm.matrix.dat',]$dataset <- 'undirNet_5000.matrix.dat'

# join datasets and results tables (to get num_tuples, e.g.)
cleaned <- sqldf("select * from cleaned, datasets 
                 where datasets.name=cleaned.dataset")

# Resolve application names
resolved <- sqldf("select *, 'btwnCent' as task from cleaned
                 where task_string='btwnCent' or task_string='btwnCent_batch_MyriaL'
                  or task_string='btwnCent_batch_MyriaL.sql'
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

sparsity_data <- sqldf("select *, CAST(substr(dataset, 10, 11) as integer) as vertices, 
                       CAST(substr(dataset, 16, 18) as float) as density
                       from resolved where dataset LIKE 'random_N_%'")

data <- resolved