import dataset
import csv

db = dataset.connect('sqlite:///polystore.db')
table = db['matrix']

writer = csv.DictWriter(open('output.csv', 'w'), 
[
        'system',
        'Task_String',
        'Task_LogicalPlan',
        'Task_PhysicalPlan',
        'Env_InstanceType',
        'Env_NumWorkers',
        'Dataset',
        'Time (s)'
        ], delimiter='\t')

for row in table.all():
    d = {'system': row['system'],
        'Task_String': row['exe'].replace('grappa_', '').replace('.exe', ''),
        'Task_LogicalPlan': '//',
        'Task_PhysicalPlan': '//', 
        'Env_InstanceType': row['machine'],
        'Env_NumWorkers': row['nnode'],
        'Dataset': row['input_file_matrix'] or row['input_file_graph'],
        'Time (s)': row['in_memory_runtime']}
    writer.writerow(d)



