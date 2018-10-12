# TRIAXIAL UNDRAINED
# JORGE CARRILLO

wipe

# Confinement Stress
set pConf -10.0
# Deviatoric strain
set devDisp -0.2
# Permeablity
set perm 1.0e-9

# Rayleigh damping parameter
set damp   0.1
set omega1 0.0157
set omega2 64.123
set a1 [expr 2.0*$damp/($omega1+$omega2)]
set a0 [expr $a1*$omega1*$omega2]

# Create a 3D model with 4 Degrees of Freedom
model BasicBuilder -ndm 3 -ndf 4

# Create nodes
node 1  1.0 0.0 0.0
node 2  1.0 1.0 0.0
node 3  0.0 1.0 0.0 
node 4  0.0 0.0 0.0
node 5  1.0 0.0 1.0
node 6  1.0 1.0 1.0
node 7  0.0 1.0 1.0
node 8  0.0 0.0 1.0
 
# Create Fixities
fix 1   0 1 1 1
fix 2   0 0 1 1
fix 3   1 0 1 1
fix 4   1 1 1 1
fix 5   0 1 0 1
fix 6   0 0 0 1
fix 7   1 0 0 1
fix 8   1 1 0 1
 
# Create material
set mTag  1
set mDen  1.8
set fang  31.4
set ptang 26.5
set eNot  0.7
set E     90000.0
set nu    0.40
set G     [expr $E/(2.0*(1.0+$nu))]
set B     [expr $E/(3.0*(1.0-2.0*$nu))]

#nDMaterial PressureDependMultiYield tag  nd   rho refShearModul refBulkModul frictionAng peakShearStra refPress pressDependCoe PTAng contrac dilat1 dilat2 liquefac1 liquefac2 liquefac3
nDMaterial PressureDependMultiYield  $mTag 3 $mDen $G $B $fang 0.1 80 0.5 $ptang 0.17 0.4 1.0 10 0.015 1.0

# Create element
set fBulk 2.2e6
set fDen  1.0
set alpha 1.5e-5
#    SSPbrickUP  tag i j k l m n p q  matTag  fBulk    fDen    k1    k2   k3   void   alpha    <b1 b2 b3>
element SSPbrickUP 1 1 2 3 4 5 6 7 8 $mTag $fBulk $fDen $perm $perm $perm $eNot $alpha
 
# Create recorders
recorder Node    -file disp.out   -time -nodeRange 5 8 -dof 3 disp
recorder Node    -file press.out  -time -nodeRange 1 8 -dof 4 vel
recorder Element -file stress.out -time stress
recorder Element -file strain.out -time strain

# recorder Element -file stress1TXC.out   -time  -eleRange 1 1 material 1 stress
# recorder Element -file stress2TXC.out   -time  -eleRange 1 1 material 2 stress
# recorder Element -file stress3TXC.out   -time  -eleRange 1 1 material 3 stress
# recorder Element -file stress4TXC.out   -time  -eleRange 1 1 material 4 stress
# recorder Element -file stress9TXC.out   -time  -eleRange 1 1 material 9 stress
# recorder Element -file strain1TXC.out   -time  -eleRange 1 1 material 1 strain
# recorder Element -file strain2TXC.out   -time  -eleRange 1 1 material 2 strain
# recorder Element -file strain3TXC.out   -time  -eleRange 1 1 material 3 strain
# recorder Element -file strain4TXC.out   -time  -eleRange 1 1 material 4 strain
# recorder Element -file strain9TXC.out   -time  -eleRange 1 1 material 9 strain 
 
 
 
 
 
# Create analysis
constraints Penalty 1.0e17 1.0e17
test        NormDispIncr 1.0e-4 20 1
algorithm   Newton
numberer    RCM
system      BandGeneral
integrator  Newmark 0.5 0.25
rayleigh    $a0 0.0 $a1 0.0
analysis    Transient
 
# Apply confinement pressure
set pNode [expr $pConf/4.0]
pattern Plain 1 {Series -time {0 10000 1e10} -values {0 1 1} -factor 1} {
    load 1  $pNode  0.0    0.0    0.0
    load 2  $pNode  $pNode 0.0    0.0
    load 3  0.0     $pNode 0.0    0.0
    load 5  $pNode  0.0    $pNode 0.0
    load 6  $pNode  $pNode $pNode 0.0
    load 7  0.0     $pNode $pNode 0.0
    load 8  0.0     0.0    $pNode 0.0
}
analyze 100 100
 
# Let the model rest and waves damp out
analyze 10  1000
 
# Close drainage valves
for {set x 1} {$x<9} {incr x} {
   remove sp $x 4
}
analyze 5 0.1

updateMaterialStage -material 1 -stage 1

analyze 5 0.1
 
# Read vertical displacement of top plane
set vertDisp [nodeDisp 5 3]
# Apply deviatoric strain
set eDisp [expr 1+$devDisp/$vertDisp]
eval "timeSeries Path 5 -time {0 20001 20301 1e10} -values {0 1 $eDisp $eDisp}"
# loading object deviator stress
pattern Plain 2 5 { 
    sp 5  3 $vertDisp
    sp 6  3 $vertDisp
    sp 7  3 $vertDisp
    sp 8  3 $vertDisp
}
 
# Set number and length of time steps
set dT      0.1
set numStep 3000
 
analyze $numStep $dT

wipe