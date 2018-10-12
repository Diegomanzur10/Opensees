# Written by Jinchi Lu and Zhaohui Yang (May 2004)

wipe
set matOpt   1          ;# 1 = pressure depend; 
                        ;# 2 = pressure independ; 
set fmass  1            ;# fluid mass density
set smass  2.0          ;# saturated soil mass density
set G     9.0e4     
set B     2.2e5    
set bulk   2.2e6                        ;#fluid-solid combined bulk modulus
set vperm  5.e-6        ;#vertical permeability (m/s)
set hperm  [expr $vperm]        ;#horizontal permeability (m/s)

set accGravity  9.81    ;#acceleration of gravity
set vperm  [expr $vperm/$accGravity/$fmass]  ;#actual value used in computation
set hperm  [expr $hperm/$accGravity/$fmass]  ;#actual value used in computation
set loadBias 0.0                        ;# Static shear load, in percentage 
                                        ;# of gravity load (=sin(inclination angle))

set accMul  2.          ;# acc. multiplier
set period   1.0        ;# Period for applied Sine wave
set deltaT   0.01       ;# time step for analysis
set numSteps 2500       ;# number of time steps
set gamma    0.6        ;# Newmark integration parameter

set massProportionalDamping   0. ;
set InitStiffnessProportionalDamping 0.002;

#############################################################
# BUILD MODEL

#create the ModelBuilder
model basic -ndm 2 -ndf 3
node 1 0 0
node 2 2.5 0
node 3 2.5 2
node 4 0 2

fix 1 1 1 0 
fix 2 1 1 0
fix 3 0 0 1
fix 4 0 0 1
equalDOF 3 4 1 2

model basic -ndm 2 -ndf 2
node 5 1.25 0.
node 6 2.5 1
node 7 1.25 2
node 8 0 1
node 9 1.25 1

fix 5 1 1
equalDOF 3 7 1 2
equalDOF 6 8 1 2
equalDOF 6 9 1 2

set gravY [expr -$accGravity]  ;#calc. gravity
set gravX [expr -$gravY*$loadBias]

# define material and properties
switch $matOpt {
  1 {
    nDMaterial PressureDependMultiYield02 1 2 1.8 $G $B 32 .1 80 0.5\
                                          26. 0.067 0.23 0.06 0.27 
  }
  2 {
    nDMaterial PressureIndependMultiYield 2 2 1.8 4.e4 2.e5 40 .1
  }
}

              #    ele#                     thick maTag    bulk  mDensity  perm1  perm2  gravity       
element 9_4_QuadUP  1     1 2 3 4 5 6 7 8 9  1.0   1       $bulk $fmass  $hperm  $vperm $gravX $gravY    

#set material to elastic for gravity loading
updateMaterialStage -material $matOpt -stage 0  

#recorder for nodal variables along the vertical center line.
set SnodeList {}
for {set i 0} {$i < 9} {incr i 1} {
  lappend SnodeList [expr $i+1]
}

set FnodeList {}
for {set i 0} {$i < 4} {incr i 1} {
  lappend FnodeList [expr $i+1]
}

#############################################################
# GRAVITY APPLICATION (elastic behavior)

# create the SOE, ConstraintHandler, Integrator, Algorithm and Numberer
numberer RCM
system ProfileSPD
test NormDispIncr 1.0e-8 30 0
algorithm KrylovNewton
constraints Penalty 1.e18 1.e18
set nw 1.5
set nw2 [expr pow($nw+0.5, 2)/4]
integrator Newmark $nw $nw2
analysis Transient 

analyze 10 5e3

updateMaterialStage -material $matOpt -stage 1

analyze 100 1.e0

# rezero time
wipeAnalysis
setTime 0.0
#############################################################
# NOW APPLY LOADING SEQUENCE AND ANALYZE (plastic)

#   base input motion                     
pattern UniformExcitation  1  1    -accel "Sine 0. 10. $period -factor $accMul"

eval "recorder Node -file disp  -time -node $SnodeList -dof 1 2 -dT $deltaT disp"
eval "recorder Node -file  pwp -time -node $FnodeList -dof 3 -dT $deltaT vel"
eval "recorder Node -file acc  -time -node $SnodeList -dof 1 2 -dT $deltaT accel"
recorder Element -ele 1  -time -file stress1  -dT $deltaT material 1 stress
recorder Element -ele 1  -time -file strain1  -dT $deltaT material 1 strain
recorder Element -ele 1  -time -file stress5  -dT $deltaT material 5 stress
recorder Element -ele 1  -time -file strain5  -dT $deltaT material 5 strain
recorder Element -ele 1  -time -file stress9  -dT $deltaT material 9 stress
recorder Element -ele 1  -time -file strain9  -dT $deltaT material 9 strain


constraints Penalty 1.e18 1.e18
test NormDispIncr 1.e-4 25 0
numberer RCM
algorithm KrylovNewton
system ProfileSPD
integrator Newmark $gamma  [expr pow($gamma+0.5, 2)/4]  
rayleigh $massProportionalDamping 0.0 $InitStiffnessProportionalDamping 0.0
analysis VariableTransient 

set startT [clock seconds]
analyze $numSteps $deltaT [expr $deltaT/100] $deltaT 15
set endT [clock seconds]
puts "Execution time: [expr $endT-$startT] seconds."

wipe  #flush ouput stream
