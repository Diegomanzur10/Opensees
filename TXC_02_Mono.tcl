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
# fix 3  0 0 1
# fix 4  0 0 1

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
test        NormDispIncr 1e-3 2000 1
algorithm   KrylovNewton
numberer    RCM
system      ProfileSPD
integrator  Newmark $gamma $beta
analysis    Transient

set startT  [clock seconds]
analyze     1000 1.0e-2
puts "Finished with elastic gravity analysis..."

# update materials to consider plastic behavior
updateMaterialStage -material 1 -stage 1
puts "updateMaterialStage01 "
# # plastic gravity loading
analyze     1000 1.0e-2
puts "Finished with plastic gravity analysis..."

# 9. Update Permeability Parameter

parameter 10000 element 1 vPerm
parameter 10001 element 1 hPerm
puts "Finished with parameter..."
updateParameter 10000 $vPerm
updateParameter 10001 $hPerm
puts "Finished with updateParameter..."

#  10. Create Isotropic Consolidation
wipeAnalysis
remove recorders
set sigma3c 100
# model BasicBuilder -ndm 2 -ndf 3

set load8x [expr $sigma3c*$YSize/2]
set load4x [expr $sigma3c*$YSize/4]
set load4y [expr -1*$sigma3c*$XSize/4]
set load7y [expr -1*$sigma3c*$XSize/2]
set load3x [expr -1*$sigma3c*$YSize/4]
set load3y [expr -1*$sigma3c*$XSize/4]
set load6x [expr -1*$sigma3c*$YSize/2]
set load2x [expr -1*$sigma3c*$YSize/4]
puts "Finished with load definitions..."

pattern Plain 1 Constant {
load 8  $load8x    0.0       ;#load applied in x direction
load 4  $load4x    $load4y  0.0 ;#load applied in x and y direction
load 7  0.0	       $load7y   ;#load applied in y direction
load 3  $load3x    $load3y  0.0 ;#load applied in x and y direction
load 6  $load6x    0.0       ;#load applied in x direction
load 2  $load2x    0.0      0.0 ;#load applied in x direction

}
puts "Finished with pattern Plain..."

#  11. Create Consolidation Records


eval "recorder Node -file displacementCI.out -time -node $SnodeList -dof 1 2  disp"
eval "recorder Node -file accelerationCI.out -time -node $SnodeList -dof 1 2  accel"
eval "recorder Node -file porePressureCI.out -time -node 1 2 3 4 -dof 3 vel"

recorder Element -file stress1CI.out   -time  -eleRange 1 1 material 1 stress
recorder Element -file stress2Ci.out   -time  -eleRange 1 1 material 2 stress
recorder Element -file stress3CI.out   -time  -eleRange 1 1 material 3 stress
recorder Element -file stress4CI.out   -time  -eleRange 1 1 material 4 stress
recorder Element -file stress9CI.out   -time  -eleRange 1 1 material 9 stress
recorder Element -file strain1CI.out   -time  -eleRange 1 1 material 1 strain
recorder Element -file strain2CI.out   -time  -eleRange 1 1 material 2 strain
recorder Element -file strain3CI.out   -time  -eleRange 1 1 material 3 strain
recorder Element -file strain4CI.out   -time  -eleRange 1 1 material 4 strain
recorder Element -file strain9CI.out   -time  -eleRange 1 1 material 9 strain

#  12. Consolidation Analisys

constraints Penalty 1.e14 1.e14
puts "Finished with constraints..."
test        NormDispIncr 1e-3 2000 1
puts "Finished with test..."
algorithm   KrylovNewton
puts "Finished with algorithm..."
numberer    RCM
puts "Finished with numberer..."
system      ProfileSPD
puts "Finished with systems..."
integrator  Newmark $gamma $beta
puts "Finished with integrator..."
rayleigh    $a0 $a1 0.0 0.0
puts "Finished with rayleigh..."
analysis    Transient
puts "Finished with analysis..."

# # Isotropic Consolidation loading
analyze     500 5.0e-4
puts "Isotropic Consolidation loading analysis..."

# 1 for Monotonic Triaxial, 2 for Cyclic Triaxial
set TypeofTriaxial 1



switch $TypeofTriaxial {
  1 {
     #  13.1 Create Monotonic Analysis

wipeAnalysis
remove recorders

set vertDisp [nodeDisp 3 2]
# Deviatoric strain
set devDisp -0.2

# Apply deviatoric strain
set eDisp [expr 1+$devDisp/$vertDisp]
eval "timeSeries Path 5 -time {20.250 20.251 30.251 1e10} -values {0 1 $eDisp $eDisp}"
# loading object deviator stress
pattern Plain 2 5 { 
    sp 4  2 $vertDisp
    sp 7  2 $vertDisp
    sp 3  2 $vertDisp
    
}
# pattern Plain 2 Linear {
# sp 4 2 [expr -1*$YSize*0.0001]
# sp 7 2 [expr -1*$YSize*0.0001]
# sp 3 2 [expr -1*$YSize*0.0001]

# }

#  13.1.1 Create TXC Monotonic (5%e) Records
eval "recorder Node -file displacementTXC.out -time -node $SnodeList -dof 1 2  disp"
eval "recorder Node -file accelerationTXC.out -time -node $SnodeList -dof 1 2  accel"
eval "recorder Node -file porePressureTXC.out -time -node 1 2 3 4 -dof 3 vel"

recorder Element -file stress1TXC.out   -time  -eleRange 1 1 material 1 stress
recorder Element -file stress2TXC.out   -time  -eleRange 1 1 material 2 stress
recorder Element -file stress3TXC.out   -time  -eleRange 1 1 material 3 stress
recorder Element -file stress4TXC.out   -time  -eleRange 1 1 material 4 stress
recorder Element -file stress9TXC.out   -time  -eleRange 1 1 material 9 stress
recorder Element -file strain1TXC.out   -time  -eleRange 1 1 material 1 strain
recorder Element -file strain2TXC.out   -time  -eleRange 1 1 material 2 strain
recorder Element -file strain3TXC.out   -time  -eleRange 1 1 material 3 strain
recorder Element -file strain4TXC.out   -time  -eleRange 1 1 material 4 strain
recorder Element -file strain9TXC.out   -time  -eleRange 1 1 material 9 strain

puts "Finished Monotonic Triaxial..."

#  13.1.2 Monotonic Analysis


constraints Penalty 1.e14 1.e14
test        NormDispIncr 1e-1 20000 1
algorithm   KrylovNewton
numberer    RCM
system      ProfileSPD
integrator  Newmark $gamma $beta
analysis    Transient

set startT  [clock seconds]
analyze     1000 1.0e-2 
  }
  2 {
    #  13.2 Create Cyclic Analysis


set dispMul  1.0         ;# acc. multiplier
set period   1.0         ;# Period for applied Sine wave
#   timeSeries Trig $tag $tStart $tEnd $period <-factor $cFactor> <-shift $shift>
eval "timeSeries Trig 10      -time {25      35}      -period 1   -factor 1" 
# set SinePath "Trig 10 10 10  10 "
# Sine 0.0 10.0 $period $dispMul

pattern Plain 3 10 {
sp 4 2 [expr -1*$YSize*0.0010]
sp 7 2 [expr -1*$YSize*0.0010]
sp 3 2 [expr -1*$YSize*0.0010]

}

#  13.1.1 Create TXC Cyclic (5%e) Records
eval "recorder Node -file displacementTXCC.out -time -node $SnodeList -dof 1 2  disp"
eval "recorder Node -file accelerationTXCC.out -time -node $SnodeList -dof 1 2  accel"
eval "recorder Node -file porePressureTXCC.out -time -node 1 2 3 4 -dof 3 vel"

recorder Element -file stress1TXCC.out   -time  -eleRange 1 1 material 1 stress
recorder Element -file stress2TXCC.out   -time  -eleRange 1 1 material 2 stress
recorder Element -file stress3TXCC.out   -time  -eleRange 1 1 material 3 stress
recorder Element -file stress4TXCC.out   -time  -eleRange 1 1 material 4 stress
recorder Element -file stress9TXCC.out   -time  -eleRange 1 1 material 9 stress
recorder Element -file strain1TXCC.out   -time  -eleRange 1 1 material 1 strain
recorder Element -file strain2TXCC.out   -time  -eleRange 1 1 material 2 strain
recorder Element -file strain3TXCC.out   -time  -eleRange 1 1 material 3 strain
recorder Element -file strain4TXCC.out   -time  -eleRange 1 1 material 4 strain
recorder Element -file strain9TXCC.out   -time  -eleRange 1 1 material 9 strain

#  13.1.2 Cyclic Analysis


constraints Penalty 1.e14 1.e14
test        NormDispIncr 1e-2 20000 1
algorithm   KrylovNewton
numberer    RCM
system      ProfileSPD
integrator  Newmark $gamma $beta
analysis    Transient

set startT  [clock seconds]
analyze     1000 1.0e-3
puts "Finished Cyclic Triaxial..."
  }
}




