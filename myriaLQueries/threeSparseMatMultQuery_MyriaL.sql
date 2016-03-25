MatA = scan('shbae:matrices:random_N_10k_r_1_3');
MatB = scan('shbae:matrices:random_N_10k_r_1_3');
MatC = scan('shbae:matrices:random_N_10k_r_1_3');

tempMat = 
    [from MatA, MatB
    where MatA.col = MatB.row
    emit MatA.row as row, MatB.col as col, SUM(MatA.value*MatB.value) as value];

outMat = 
    [from tempMat, MatC
    where tempMat.col = MatC.row
    emit tempMat.row as row, MatC.col as col, SUM(tempMat.value*MatC.value) as value];

sink(outMat);
