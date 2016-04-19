set -o nounset

export $PATH=$PATH:$HOME/local/bin
name=$1
data=$HOME/data

cd $HOME/raco/c_test_environment && \
	python grappa_ingest.py -i $data/$name \
                -c $HOME/sparseMatProjects/matrices/catalogs/catalog.py \
				-n graph \
                -s grappa \
			  	--softlink-data \
				--allow-failed-upload \
                --storage binary \
				--delim ' '

cd $HOME/grappa/build/Make+Release/applications/join && ln -s $data/$name.bin

