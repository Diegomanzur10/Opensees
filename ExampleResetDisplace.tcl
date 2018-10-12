wipe
 
model BasicBuilder -ndm 3 -ndf 3
 
# create the nodes
node 1	1.0	0.0	0.0
node 2	1.0	1.0	0.0
node 3 	0.0	1.0	0.0	
node 4	0.0	0.0	0.0
node 5	1.0	0.0	1.0
node 6 	1.0	1.0	1.0
node 7 	0.0	1.0	1.0
node 8 	0.0	0.0	1.0
 
# boundary conditions
fix 1 	1 1 1
fix 2 	1 1 1
fix 3	1 1 1
fix 4 	1 1 1
fix 5	1 1 0
fix 6 	1 1 0
fix 7	1 1 0
fix 8 	1 1 0
 
# define main material obeject
nDMaterial ElasticIsotropic 1 25000 0.35
 
# define material wrapper
nDMaterial InitialStateAnalysisWrapper 2 1 3
 
# create the element (NOTE: the material tag associated with this element is that of the wrapper)
element SSPbrick 1  1 2 3 4 5 6 7 8  2  0.0 0.0 -17.0   
 
# create the pre-gravity recorders
set step 0.1
 
recorder Node -time -file Gdisp.out -dT $step -nodeRange 5 8 -dof 1 2 3 disp
recorder Element -ele 1 -time -file Gstress.out  -dT $step stress
recorder Element -ele 1 -time -file Gstrain.out  -dT $step  strain
 
# create the gravity analysis
integrator LoadControl 0.5
numberer RCM
system SparseGeneral
constraints Transformation
test NormDispIncr 1e-5 40 1
algorithm Newton
analysis Static
 
# turn on the initial state analysis feature
InitialStateAnalysis on
 
# analyze four steps
analyze 4
 
# turn off the initial state analysis feature
InitialStateAnalysis off
 
# create post-gravity recorders
recorder Node -time -file disp.out -dT $step -nodeRange 5 8 -dof 1 2 3 disp
recorder Element -ele 1 -time -file stress.out  -dT $step  stress
recorder Element -ele 1 -time -file strain.out  -dT $step  strain
 
# analyze for three steps, should have non-zero stress and strain with zero displacement
analyze 3
 
wipe