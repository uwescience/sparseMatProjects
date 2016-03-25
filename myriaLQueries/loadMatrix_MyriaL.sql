--- matrix datasets ---
S = load("/path/to/random_N_10k_r_1.2.matrix.dat",
    csv(schema(row:int, col:int, value:float), delimiter=" ")
);
store(S, shbae:matrices:random_N_10k_r_1_2, [row, col]);
