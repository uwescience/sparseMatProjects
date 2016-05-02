#Scripts to setup and run experiments on the newly created spark cluster

Usage:
For the setup script, cd to the folder where this script resides and run the following command:

$ . ./setup.sh 

To run the matrix multiply examples, cd to the folder where this script resides and run the following command:

$ . ./run-MM-example.sh

(Notice the '.' before the ./setup.sh, running a script like this runs it in the current shell, instead of a subshell, this helps retain the changes made by 'cd' commmand)
