matA = scan(shbae:graph); -- shbae:matrix should be replaced with actual table name.

-- define constant values as singleton tables.
epsilon = [0.001];
prunelimit = [0.00001];

-- initialize oldChaos and newChaos for stop condition.
oldchaos = [1000.0];
newchaos = [1000.0];

-- while there is an epsilon improvement
do 
	oldchaos = newchaos;

	-- square matA
	AxA = [from matA as A, matA as B
			   where A.dst == B.src
			   emit A.src as src, B.dst as dst, sum(A.val * B.val) as value];
	
	-- inflate operation
	-- value will be value^2
	squareA = [from AxA emit src as src, dst as dst, value * value as value];

	colsums = [from squareA
			   emit squareA.dst as dst, sum(squareA.value) as colsum];
	
	-- normalize newMatA
	newMatA = [from squareA, colsums
			   where squareA.dst == colsums.dst
			   emit squareA.src as src, squareA.dst as dst, squareA.value/colsums.colsum as value];

	-- pruning
	prunedA = [from newMatA
			   where value > *prunelimit
			   emit *];

	-- calculate newchaos
	colssqs = [from prunedA
			   emit prunedA.dst as col, sum (prunedA.value * prunedA.value) as sumSquare];
	colmaxs = [from prunedA
			   emit prunedA.dst as col, max (prunedA.value) as maxVal];

	newchaos = [from colmaxs, colssqs
				where colmaxs.col == colssqs.col
				emit max (colmaxs.maxVal - colssqs.sumSquare)];

	-- prepare for the iteration.
	matA = prunedA;

	-- check the convergency.
	continue = [from newchaos, oldchaos emit (*oldchaos - *newchaos) > *epsilon];
while continue;

store (newchaos, OUTPUT);
