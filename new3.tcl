#!/home/jeremi
# put your path and exec name above aftetr #! to make script self-executable
# jeremic@ucdavis.edu
# 08 April 2004
# solid model, 8 node brick, linear elastic
# Examples for the course:  
# Computational Geomechanics: 
# Inelastic Finite Elements for Pressure Sensitive Materials  



# ################################
# create the modelbuilder
# #################################

model BasicBuilder -ndm 3 -ndf 3

# ################################
# build the model
# #################################
# nodes
node 1 1.0 1.0 0.0
node 2 0.0 1.0 0.0
node 3 0.0 0.0 0.0
node 4 1.0 0.0 0.0
node 5 1.0 1.0 1.0
node 6 0.0 1.0 1.0
node 7 0.0 0.0 1.0
node 8 1.0 0.0 1.0


# displacement boundary conditions
fix 1   0 0 1
fix 2   1 0 1
fix 3   1 1 1
fix 4   0 1 1
#fix 5 1 0 1
#fix 6 1 0 1
#fix 7 1 0 1
#fix 8 1 0 1

# linear elastic material     tag                 E               nu       rho
nDMaterial ElasticIsotropic3D 1      100  0.2   1.8

#            tag     8 nodes          matID  bforce1 bforce2 bforce3   massdensity
element stdBrick  1  5 6 7 8 1 2 3 4   1      0.0     0.0     0.0     1.8
#element stdBrick  1  1 2 3 4 5 6 7 8   1      0.0     0.0    -9.81    1.8
#element stdBrick  1  5 6 7 8 1 2 3 4   1      0.0     0.0    -9.81    1.8

pattern Plain 1 Linear {
   load  5      0    0  -1.0
   load  6      0    0  -1.0 
   load  7      0    0  -1.0 
   load  8      0    0  -1.0 
}


# ################################
# create the analysis
# #################################

set lf1 1.0

constraints Penalty 1e9 1e9


integrator LoadControl $lf1 

# CHOOSE algorithm
#set different_algorithms  Linear
set different_algorithms  Newton
puts "USING  $different_algorithms ALGORITHM"


# this is needed by Newton 
test NormDispIncr 1.0e-8 30 1
#test NormUnbalance 1.0e-8 30 1

algorithm $different_algorithms


numberer RCM
system UmfPack
analysis Static


# ################################
# perform the analysis
# #################################

for {set i 1} {$i <=1} {incr i} {
 puts $i
 analyze 1


print node 1
print node 2
print node 3
print node 4
print node 5
print node 6
print node 7
#print node 8


print -ele 1




}



wipe