#!/bin/bash
yum -y update
sudo yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel python27-devel
curl https://bootstrap.pypa.io/get-pip.py | python2.7 -
pip install virtualenv
cd ~
virtualenv -p python27 forraco

#clone and setup raco dependencies.
git clone https://github.com/uwescience/raco.git
cd raco
git checkout SPJA_federation

source forraco/bin/activate
pip install -r requirements-dev.txt
python setup.py develop
pip install numpy

###install SciDb Py
git submodule init
git submodule update
cd SciDB-py/
python setup.py develop
cd ..

export PYSPARK_PYTHON=/root/forraco/bin/python
~/spark-ec2/copy-dir /root/forraco

