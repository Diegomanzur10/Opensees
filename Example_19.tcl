# Inclined (4 degrees) saturated, undrained single BbarBrick element with pressure dependent material.
# subjected to 1D sinusoidal base shaking 

wipe
set friction 31.40         ;#friction angle
set phaseTransform 26.50   ;#phase transformation angle
set E1      93178.4        ;#Young's modulus
set poisson1 0.40 ;
set G1 [expr $E1/(2*(1+$poisson1))] ;
set B1 [expr $E1/(3*(1-2*$poisson1))] ;
set gamma    0.600      ;# Newmark integration parameter

set dt   0.01           ;# time step for analysis, does not have to be the same as accDt.
set numSteps 1600       ;# number of time steps
set rhoS  2.00          ;# saturated mass density
set rhoF  1.00          ;# fluid mass density
set densityMult 1.      ;# density multiplier

set Bfluid 2.2e6        ;# fluid shear modulus
set fluid1 1            ;# fluid material tag
set solid1 10           ;# solid material tag

set shakeTime velacs1horizontal.time    ;# acceleration time file (s)
set shakeAcce velacs1horizontal.acc     ;# acceleration value file
set accMul 2                    ;# acceleration multiplier 
set pi 3.1415926535                     ;
set inclination 4;

set massProportionalDamping   0.0 ;
set InitStiffnessProportionalDamping 0.002;

set bUnitWeightX [expr ($rhoS-$rhoF)*9.81*sin($inclination/180.0*$pi)*$densityMult] ;# buoyant unit weight in X direction
set bUnitWeightY 0.0                                                              ;# buoyant unit weight in Y direction
set bUnitWeightZ [expr -($rhoS-$rhoF)*9.81*cos($inclination/180.0*$pi)]           ;# buoyant unit weight in Z direction
set ndm    3            ;# space dimension

model BasicBuilder -ndm $ndm -ndf $ndm

nDMaterial PressureDependMultiYield $solid1 $ndm [expr $rhoS*$densityMult] $G1 $B1  $friction 0.1 80 0.5 \
                                    $phaseTransform 0.17 0.4 10 10 0.015 1.0 ;#  27 0.6 0 0 0 101 0.630510273
nDMaterial FluidSolidPorous $fluid1 $ndm $solid1 $Bfluid

node        1      0.00000     0.0000    0.00000
node        2      0.00000     0.0000    1.00000
node        3      0.00000     1.0000    0.00000
node        4      0.00000     1.0000    1.00000
node        5      1.00000     0.0000    0.00000
node        6      1.00000     0.0000    1.00000
node        7      1.00000     1.0000    0.00000
node        8      1.00000     1.0000    1.00000

element bbarBrick      1      1    5    7    3     2    6    8    4  $fluid1 $bUnitWeightX $bUnitWeightY $bUnitWeightZ 

updateMaterialStage -material $solid1 -stage 0
updateMaterialStage -material $fluid1 -stage 0

fix      1      1      1      1   0   0   0
fix      2      0      1      0   0   0   0
fix      3      1      1      1   0   0   0
fix      4      0      1      0   0   0   0
fix      5      1      1      1   0   0   0
fix      6      0      1      0   0   0   0
fix      7      1      1      1   0   0   0
fix      8      0      1      0   0   0   0


# equalDOF
# tied nodes around
equalDOF      2     4  1      3
equalDOF      2     6  1      3
equalDOF      2     8  1      3


set nodeList {}
for {set i 1} {$i <=   8 } {incr i 1} {
   lappend nodeList $i
}

set elementList {}
for {set i 1} {$i <=   1 } {incr i 1} {
   lappend elementList $i
}

# GRAVITY APPLICATION (elastic behavior)
# create the SOE, ConstraintHandler, Integrator, Algorithm and Numberer
system ProfileSPD
test NormDispIncr 1.e-10 25 2
constraints Transformation
integrator LoadControl 1 1 1 1
algorithm Newton 
numberer RCM
analysis Static
analyze 2

# switch the material to plastic
updateMaterialStage -material $fluid1 -stage 1
updateMaterialStage -material $solid1 -stage 1
updateMaterials -material $solid1 bulkModulus [expr $G1*2/3.];

analyze 2

setTime 0.0 ;# reset time, otherwise reference time is not zero for time history analysis 
wipeAnalysis

############# create recorders       ##############################
eval "recorder Node -file allNodesDisp.out   -time -node $nodeList -dof 1 2 3 -dT 0.01 disp"
eval "recorder Node -file allNodesAcce.out  -time -node $nodeList -dof 1 2 3 -dT 0.01 accel"
eval "recorder Element -ele $elementList -time -file stress1.out -dT 0.01 material 1 stress"
eval "recorder Element -ele $elementList -time -file strain1.out -dT 0.01 material 1 strain"
eval "recorder Element -ele $elementList -time -file press1.out -dT 0.01 material 1 pressure"
eval "recorder Element -ele $elementList -time -file stress5.out -dT 0.01 material 5 stress"
eval "recorder Element -ele $elementList -time -file strain5.out -dT 0.01 material 5 strain"
eval "recorder Element -ele $elementList -time -file press5.out -dT 0.01 material 5 pressure"
eval "recorder Element -ele $elementList -file backbone.out -dT 1000 material 1 backbone 80 100 200 300"

############# create dynamic time history analysis ##################
pattern UniformExcitation 1 1 -accel "Sine 0 10 1 -factor $accMul"
rayleigh $massProportionalDamping 0.0 $InitStiffnessProportionalDamping 0.
integrator Newmark $gamma  [expr pow($gamma+0.5, 2)/4]  
constraints Penalty 1.e18 1.e18 ;# can't combine with test NormUnbalance   
test NormDispIncr 1.0e-5 25 0   ;# can't combine with constraints Lagrange
#algorithm Newton               ;# tengent is updated at each iteration
algorithm ModifiedNewton        ;# tengent is updated at the begining of each time step not each iteration
system ProfileSPD                ;# Use sparse solver. Next numberer is better to be Plain.
numberer Plain                  ;# method to map between between equation numbers of DOFs
analysis VariableTransient      ;# splitting time step requires VariableTransient

############# perform the Analysis and record time used ############# 
set startT [clock seconds]
analyze $numSteps $dt [expr $dt/64] $dt  15
set endT [clock seconds]
puts "Execution time: [expr $endT-$startT] seconds."