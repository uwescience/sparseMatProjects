#!/bin/bash

. $HOME/env.sh 
export PATH=$PATH:$HOME/local/bin

# Raco setup
cd $HOME && git clone https://github.com/uwescience/raco.git && \
cd $HOME/raco && \
	pip install --user -r requirements-dev.txt && \
	python setup.py develop --user && \
	cd c_test_environment && \
	make libracoc.a && \
	export RACO_HOME=$HOME/raco
	
cd $HOME/grappa && \
	git fetch && \
	git checkout bmyerz/sru+merged && \
	git cherry-pick c9bc0dd && \
	./configure --cc=$(which gcc) --gen=Make 

# aws configure!   
mkdir $HOME/data
cd $HOME/data && \
    aws s3 cp 's3://uwdb/shbae/graphs/*.dat' . && \
    aws s3 cp 's3://uwdb/shbae/graphs/*.dat' .

# hosts in mpi cluster
grep -E 'master|node[0-9]{3}' /etc/hosts | awk '{print $2}' >$HOME/hostfile

df -h /
echo 'WARNING: if the above disk availability is low, then the commands may have failed'
echo 'example command: mpirun -np 64 -hostfile $HOME/hostfile -- applications/join/grappa_MCL_MyriaL.exe --input_file_graph=$HOME/sparseMatProjects/matrices/undirNet_1000.matrix.dat'
