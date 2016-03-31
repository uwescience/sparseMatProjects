#!/bin/bash

. env.sh 
export PATH=$PATH:$HOME/local

# Raco setup
git clone https://github.com/uwescience/raco.git
cd raco && \
	pip install --user -r requirements-dev.txt && \
	python setup.py develop --user && \
	cd c_test_environment && \
	make libracoc.a && \
	cd ../.. && \
	export RACO_HOME=`pwd`/raco
	
cd grappa && \
	git fetch && \
	git checkout bmyerz/sru+merged && \
	git cherry-pick c9bc0dd && \
	./configure --cc=$(which gcc) --gen=Make && \
	cd ..
   
# git lfs
wget https://github.com/github/git-lfs/releases/download/v1.1.2/git-lfs-linux-amd64-1.1.2.tar.gz && \
	tar xzvf git-lfs-linux-amd64-1.1.2.tar.gz && \
	cd git-lfs-1.1.2 && \
	mkdir -p $HOME/local && \
	PREFIX=$HOME/local ./install.sh && \
	git lfs install && \
	cd ..
	
# sparse matrix experiments
git clone https://github.com/uwescience/sparseMatProjects.git && \
	cd sparseMatProjects/matrices && \
	git lfs fetch && \
   	git lfs checkout undirNet_graphs.tgz && \
  	tar xzvf undirNet_graphs.tgz && \
	cd ../..

cd raco/c_test_environment && \
	python grappa_ingest.py -i $HOME/sparseMatProjects/matrices/undirNet_1000.matrix.dat \
                                -c $HOME/sparseMatProjects/matrices/catalogs/catalog.py \
				-n graph \
                        	-s grappa \
			  	--softlink-data \
                        	--local-softlink-data \
				--allow-failed-upload \
                        	--storage binary \
				--delim ' ' && \
	cd ../..

# hosts in mpi cluster
grep -E 'master|node[0-9]{3}' /etc/hosts | awk '{print $2}' >$HOME/hostfile

echo 'example command: mpirun -np 64 -hostfile=$HOME/hostfile -- applications/join/grappa_MCL_MyriaL.exe --input_file_graph=$HOME/sparseMatProjects/matrices/undirNet_1000.matrix.dat'
