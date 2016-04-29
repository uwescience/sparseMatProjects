
docid=$1
if [ -z "$docid"]; then
    echo "Missing argument: google document id" 1>&2
    exit 1 
fi

wget "https://docs.google.com/spreadsheets/d/$docid/export?format=csv&id=$docid&gid=0" -O sheet_experiments.csv 
wget "https://docs.google.com/spreadsheets/d/$docid/export?format=csv&id=$docid&gid=503313865" -O sheet_datasets.csv 
