#!/bin/bash
cd ~
source forraco/bin/activate
cd raco/raco/backends/federated/tests
/root/spark/bin/spark-submit --packages com.databricks:spark-csv_2.10:1.4.0 matmul_driver.py
