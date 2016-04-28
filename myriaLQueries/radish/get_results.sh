
master=ec2-52-23-231-19.compute-1.amazonaws.com

rsync -aP --include="*.log" --exclude="*" $master:~sgeadmin/results/ .
