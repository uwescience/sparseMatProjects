--- graph datasets ---
S = load("/path/to/graphs/undirNet_1000.matrix.dat",
    csv(schema(src:int, dst:int, val:float), delimiter=" ")
);
store(S, shbae:graphs:undirNet_1000, [src, dst]);
