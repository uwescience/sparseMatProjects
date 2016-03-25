A = scan('shbae:matrices:random_N_10k_r_1_3');
B = scan('shbae:matrices:random_N_10k_r_1_3');
C = scan('shbae:matrices:random_N_10k_r_1_3');

outMat = 
	[from A, B, C
	where A.col = B.row and B.col = C.row
	emit A.row, C.col, SUM(A.value*B.value*C.value)];

--store(cnt, cntThreeMatMultMultiJoin);
sink(outMat);

