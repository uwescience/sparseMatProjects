set -o nounset

docid=$1

wget "https://docs.google.com/spreadsheets/d/$docid/export?format=csv&id=$docid&gid=0" -O sheet_experiments.csv 
wget "https://docs.google.com/spreadsheets/d/$docid/export?format=csv&id=$docid&gid=503313865" -O sheet_datasets.csv 
