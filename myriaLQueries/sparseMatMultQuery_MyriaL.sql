MatA = scan('shbae:matrices:random_N_10k_r_1_2');
MatB = scan('shbae:matrices:random_N_10k_r_1_2');

outMat = 
    [from MatA, MatB
    where MatA.col = MatB.row
    emit MatA.row as row, MatB.col as col, SUM(MatA.value*MatB.value) as value];
    
sink(outMat);
