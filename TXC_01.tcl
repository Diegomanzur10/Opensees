# 1. Geometry

set nElemX  1
set nElemY  1

set nNodeX  [expr 2 * $nElemX +1]
set nNodeY  [expr 2 * $nElemY +1]

set XSize  0.15
set YSize  0.30

set NTotal  [expr $nNodeX * $nNodeY]

# 2. Create Pore Pressure Nodes and Fixities

model BasicBuilder -ndm 2 -ndf 3

node 1	 0	 	 0
node 2	 $XSize	 0
node 3	 $XSize  $YSize
node 4   0       $YSize

fix 1  1 1 0
fix 2  0 1 0

equalDOF 3 4 2

# 3. Create interior Nodes and Fixities

model BasicBuilder -ndm 2 -ndf 2

node 5	[expr $XSize/2] 0
node 6  $XSize          [expr $YSize/2]
node 7  [expr $XSize/2] $YSize
node 8	0               [expr $YSize/2]
node 9	[expr $XSize/2] [expr $YSize/2]

fix 5  0 1 0

equalDOF 4 6 2

# 4. Create Soil Material

set g -9.81

nDMaterial PressureDependMultiYield02 1 2 1.8 9.0e4 2.2e5 32 0.1 101 0.5\
                                          26. 0.067 0.23 0.06 0.27\
										  20 5.0 3.0 1.0 \
										  0.0 0.77 0.9 0.02 0.65 101.0		
										  

set thick 1.0

set xWgt  0
set yWgt  [expr $g]
set uBulk 6.88e6
set hPerm 1.0e-4
set vPerm 1.0e-4



# 5. Create Soil Element


element 9_4_QuadUP 1 1 2 3 4 5 6 7 8 9 $thick 1 $uBulk 1.0 1.0 1.0 $xWgt $yWgt

set SnodeList {}
for {set i 0} {$i < 9} {incr i 1} {
  lappend SnodeList [expr $i+1]
}

# 6. Create Gravity Records

eval "recorder Node -file Gdisplacement.out -time -node $SnodeList -dof 1 2  disp"
eval "recorder Node -file Gacceleration.out -time -node $SnodeList -dof 1 2  accel"
eval "recorder Node -file GporePressure.out -time -node 1 2 3 4 -dof 3 vel"

recorder Element -file Gstress1.out   -time  -eleRange 1 1 material 1 stress
recorder Element -file Gstress2.out   -time  -eleRange 1 1 material 2 stress
recorder Element -file Gstress3.out   -time  -eleRange 1 1 material 3 stress
recorder Element -file Gstress4.out   -time  -eleRange 1 1 material 4 stress
recorder Element -file Gstress9.out   -time  -eleRange 1 1 material 9 stress
recorder Element -file Gstrain1.out   -time  -eleRange 1 1 material 1 strain
recorder Element -file Gstrain2.out   -time  -eleRange 1 1 material 2 strain
recorder Element -file Gstrain3.out   -time  -eleRange 1 1 material 3 strain
recorder Element -file Gstrain4.out   -time  -eleRange 1 1 material 4 strain
recorder Element -file Gstrain9.out   -time  -eleRange 1 1 material 9 strain



# 7. Define Analysis Parameters

#---RAYLEIGH DAMPING PARAMETERS
set pi      3.141592654
# damping ratio
set damp    0.02
# lower frequency
set omega1  [expr 2*$pi*0.2]
# upper frequency
set omega2  [expr 2*$pi*20]
# damping coefficients
set a0      [expr 2*$damp*$omega1*$omega2/($omega1 + $omega2)]
set a1      [expr 2*$damp/($omega1 + $omega2)]
puts "damping coefficients: a_0 = $a0;  a_1 = $a1"

#---ANALYSIS PARAMETERS
# Newmark parameters
set gamma  0.5
set beta   0.25


# 8. Gravity Analysis

# update materials to ensure elastic behavior
updateMaterialStage -material 1 -stage 0

constraints Penalty 1.e14 1.e14
test        NormDispIncr 1e-4 200 1
algorithm   KrylovNewton
numberer    RCM
system      ProfileSPD
integrator  Newmark $gamma $beta
analysis    Transient

set startT  [clock seconds]
analyze     10 5.0e2
puts "Finished with elastic gravity analysis..."

# update materials to consider plastic behavior
updateMaterialStage -material 1 -stage 1
puts "updateMaterialStage01 "
# plastic gravity loading
analyze     200 5.0e-2
puts "Finished with plastic gravity analysis..."

# 9. Update Permeability Parameter

parameter 10000 element 1 vPerm
parameter 10001 element 1 hPerm

updateParameter 10000 $vPerm
updateParameter 10001 $hPerm


#  10. Create Isotropic Consolidation
wipeAnalysis
set sigma3c 100e6
model BasicBuilder -ndm 2 -ndf 3
pattern Plain 1 Constant {
load 8  [expr $sigma3c*$YSize/2]    0.0  0.0;#load applied in x direction
load 4  [expr $sigma3c*$YSize/4]    [expr -1*$sigma3c*$XSize/4]  0.0;#load applied in x and y direction
load 7  0.0			     		 	[expr -1*$sigma3c*$XSize/2]  0.0;#load applied in y direction
load 3  [expr -1*$sigma3c*$YSize/4] [expr -1*$sigma3c*$XSize/4]  0.0;#load applied in x and y direction
load 6  [expr -1*$sigma3c*$YSize/2] 0.0   0.0;#load applied in x direction
load 2  [expr -1*$sigma3c*$YSize/4] 0.0   0.0;#load applied in x direction

}
#  11. Create Consolidation Records


eval "recorder Node -file GdisplacementCI.out -time -node $SnodeList -dof 1 2  disp"
eval "recorder Node -file GaccelerationCI.out -time -node $SnodeList -dof 1 2  accel"
eval "recorder Node -file GporePressureCI.out -time -node 1 2 3 4 -dof 3 vel"

recorder Element -file Gstress1CI.out   -time  -eleRange 1 1 material 1 stress
recorder Element -file Gstress2Ci.out   -time  -eleRange 1 1 material 2 stress
recorder Element -file Gstress3CI.out   -time  -eleRange 1 1 material 3 stress
recorder Element -file Gstress4CI.out   -time  -eleRange 1 1 material 4 stress
recorder Element -file Gstress9CI.out   -time  -eleRange 1 1 material 9 stress
recorder Element -file Gstrain1CI.out   -time  -eleRange 1 1 material 1 strain
recorder Element -file Gstrain2CI.out   -time  -eleRange 1 1 material 2 strain
recorder Element -file Gstrain3CI.out   -time  -eleRange 1 1 material 3 strain
recorder Element -file Gstrain4CI.out   -time  -eleRange 1 1 material 4 strain
recorder Element -file Gstrain9CI.out   -time  -eleRange 1 1 material 9 strain

#  12. Consolidation Analisys

constraints Penalty 1.e14 1.e14
test        NormDispIncr 1e-4 35 1
algorithm   KrylovNewton
numberer    RCM
system      ProfileSPD
integrator  Newmark $gamma $beta
analysis    Transient

# Isotropic Consolidation loading
analyze     200 5.0e-2

#  13. Create Cyclic Analisis