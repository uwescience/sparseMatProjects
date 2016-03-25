-- Betweenness Centrality matrix formulation (unweighted graph case)
-- step1: initialization
-- step2: BFS (a.k.a. SSSP of unweighted graph starting the source vertex, Dijkstra's algorithm)
-- step3: BC update loop

-- assume data is already stored as [src:int, dst:int, val:float] 
Graph = scan(shbae:graphs:undirNet_1000_sm);	-- in fact, it is stored as an edge list. [src, dst, val]

-- This is the undirected graph case, so it is enough to check src column only.
--V = [from Graph emit distinct (Graph.$0) as vid];	
V = select distinct Graph.src as vid from Graph;
N = [from V emit count(*)];

-- betweenness centrality (bc) score initialization.
bc = [from V
	  emit V.vid as vid, 0.0 as score];

--srcID = [0];	-- srcID will start from 1, so initialize with 0.

-- Below is the batch run of single-source shortest paths and bc updates.
-- So, we don't have outside do-while loop.

srcIDs = V;		-- source vertex id for each bc calculation.
depth = [0];	-- initialize depth

-- I will make 'nsp' as a table with N number of tuples which has nsp (vid, val)
-- initialization of nsp (Number of Shortest Paths via the vertex)
nsp = [from V, srcIDs
	   emit srcIDs.vid as srcID, V.vid as vid, (case when V.vid != srcIDs.vid then 0.0 else 1.0 end) as val];

fringe = [from Graph, srcIDs
		  where Graph.src = srcIDs.vid
		  emit srcIDs.vid as srcID, Graph.dst as vid, Graph.val as val];

BFS = empty(srcID:int, depth:int, vid:int);		-- BFS refers depth of BFS and corresponding vertices.
	
-- Step2: BFS and counting number of shortest paths (nsp).
do
	depth = [*depth + 1];	-- increase depth by 1.

	nsp_vid = [from nsp emit nsp.srcID, nsp.vid];
	fringe_vid = [from fringe emit fringe.srcID, fringe.vid];

	diff_vid = diff(nsp_vid, fringe_vid);

	diff_nsp = [from nsp, diff_vid
				where nsp.srcID = diff_vid.srcID and nsp.vid = diff_vid.vid
				emit nsp.srcID, nsp.vid, nsp.val];

	join_nsp = [from nsp, fringe
				where nsp.srcID = fringe.srcID and nsp.vid = fringe.vid
				emit nsp.srcID as srcID, nsp.vid as vid, (nsp.val + fringe.val) as val];

	nsp = diff_nsp + join_nsp;


	-- on depth, bfs searches only fringe vertices.
	-- '+' works as 'UnionAll' w.r.t. MyriaWeb parsed result.
	newBFS = BFS + 
			[from depth, fringe
			 emit fringe.srcID as srcID, *depth as depth, fringe.vid as vid];		

	BFS = newBFS;

	--update fringe : f = fA x (negate[nsp])
	tmpFringe = [from fringe, Graph
				 where fringe.vid == Graph.src
				 emit fringe.srcID as srcID, Graph.dst as vid, sum(fringe.val * Graph.val) as val];
	
	-- nsp is a fixed length (length = N) relation, so we can simply generate negateNSP in O(N).
	negateNSP = [from nsp
				 emit srcID, vid, (case when val != 0.0 then 0 else 1 end) as val];

	newFringe = [from tmpFringe, negateNSP
				 where tmpFringe.srcID = negateNSP.srcID and tmpFringe.vid = negateNSP.vid and negateNSP.val = 1
				 emit tmpFringe.srcID as srcID, tmpFringe.vid as vid, tmpFringe.val as val];

	fringe = newFringe;

	continue = [from fringe emit count(*) > 0];	-- if fringe is not NULL true. Otherwise false.

while continue;		-- check there are vertices not yet searched.


--store (BFS, batchBFS, [srcID]);
--store (nsp, batchNSP, [srcID]);


-- Step 3: BC updates loop...
u = [from nsp
	 emit nsp.srcID as srcID, nsp.vid as vid, 0.0 as uVal];

do
	-- w = S(d, :) x (1+u) / p
	w1 = [from BFS, u, depth, nsp
		  where BFS.depth = *depth and BFS.vid = u.vid and BFS.vid = nsp.vid and BFS.srcID = u.srcID and BFS.srcID = nsp.srcID
		  emit BFS.srcID as srcID, BFS.vid as vid, (u.uVal+1.0) / nsp.val as val];
	
	-- w = Aw
	w2 = [from Graph, w1
		  where Graph.dst = w1.vid
		  emit w1.srcID as srcID, Graph.src as vid, sum(Graph.val*w1.val) as val];

	-- w = w x S(d-1,:) x p
	weight = [from w2, BFS, nsp
			  where BFS.depth = (*depth - 1) and w2.vid = BFS.vid and w2.vid = nsp.vid and w2.srcID = BFS.srcID and w2.srcID = nsp.srcID
			  emit BFS.srcID as srcID, BFS.vid as vid, w2.val * nsp.val as val];

	u_vid = [from u emit u.srcID, u.vid];
	w_vid = [from weight emit weight.srcID, weight.vid];
	diff_vid2 = diff(u_vid, w_vid);

	diff_u = [from u, diff_vid2
			  where u.srcID = diff_vid2.srcID and u.vid = diff_vid2.vid
			  emit u.srcID, u.vid, u.uVal];

	join_u = [from u, weight
			  where u.srcID = weight.srcID and u.vid = weight.vid
			  emit u.srcID as srcID, u.vid as vid, (u.uVal + weight.val) as uVal];

	u = diff_u + join_u;

	depth = [*depth - 1];
	continue = [from depth emit *depth >= 2];
while continue;

-- store final bc scores here.
bc = [from bc, u
	  where bc.vid = u.vid
	  emit bc.vid as vid, sum(bc.score + u.uVal) as score];

--store (u, btwnCentUpdate, [srcID]);
store (bc, btwnCentScore, [vid]);
