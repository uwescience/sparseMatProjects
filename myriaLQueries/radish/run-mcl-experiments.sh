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
   
# git lfs
cd $HOME && wget https://github.com/github/git-lfs/releases/download/v1.1.2/git-lfs-linux-amd64-1.1.2.tar.gz && \
	tar xzvf git-lfs-linux-amd64-1.1.2.tar.gz && \
	cd git-lfs-1.1.2 && \
	mkdir -p $HOME/local && \
	PREFIX=$HOME/local ./install.sh && \
	git lfs install 
	
# sparse matrix experiments
cd $HOME/sparseMatProjects && \
	cd matrices && \
	git lfs fetch && \
   	git lfs checkout undirNet_graphs.tgz && \
	git lfs checkout random_10k_matrices.tgz && \
	git lfs checkout random_20k_matrices.tgz && \
	git lfs checkout random_50k_matrices.tgz && \
  	tar xzvf undirNet_graphs.tgz && \
  	tar xzvf random_10k_matrices.tgz && \
  	tar xzvf random_20k_matrices.tgz && \
  	tar xzvf random_50k_matrices.tgz

# hosts in mpi cluster
grep -E 'master|node[0-9]{3}' /etc/hosts | awk '{print $2}' >$HOME/hostfile

df -h /
echo 'WARNING: if the above disk availability is low, then the commands may have failed'
echo 'example command: mpirun -np 64 -hostfile $HOME/hostfile -- applications/join/grappa_MCL_MyriaL.exe --input_file_graph=$HOME/sparseMatProjects/matrices/undirNet_1000.matrix.dat'
