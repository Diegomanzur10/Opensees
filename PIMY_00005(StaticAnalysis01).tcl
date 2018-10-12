wipe

# Fluid mass density
set fmass 1

# Permeability per soil layer (m/s)
set vperm(1)       5.0e-4
set vperm(2)       9.0e-4
set vperm(3)       5.0e-5
set vperm(4)       9.0e-5

set hperm(1)       5.0e-4
set hperm(2)       9.0e-4
set hperm(3)       5.0e-5
set hperm(4)       9.0e-5 

set accGravity     9.81   ;#(m/s^2)
set numLayers     4
for {set k 1} {$k<=$numLayers} {incr k 1} {

	set vperm($k) [expr $vperm($k)/$accGravity/$fmass];#actual value used in computation
	set hperm($k) [expr $hperm($k)/$accGravity/$fmass];#actual value used in computation
}

#Define quantity of layers


#soil layer thicknesses (m)
set layerThick(1)   5.0
set layerThick(2)   3.0
set layerThick(3)   3.0
set layerThick(4)   2.0

#Material Properties 

#Rho as a saturated soil (ton/m3)
set ro(1)  	        1.8
set ro(2)   		1.9
set ro(3)        	2.0
set ro(4)           2.1

#Cohesion (kPa) Just PIMY case
set cohe(1)		    14.0
set cohe(2)		    18.0
set cohe(3)		    20.0
set cohe(4)		    24.0

#Phi (ton/m3)
set fi(1)  	       24.0
set fi(2)   	   27.0
set fi(3)          30.0
set fi(4)          33.0

#Vs (m/s)
set vs(1)  		  170.9
set vs(2)         311.3
set vs(3)         347.0
set vs(4)         374.3

#gammaPeak
set gamPeak(1)    0.09
set gamPeak(2)    0.10
set gamPeak(3)    0.11     
set gamPeak(4)    0.12   

# phase transformation angle
set phasAng(1)        21
set phasAng(2)        24
set phasAng(3)        27
set phasAng(4)        30
  
# soil shear modulus for each layer (kPa)
for {set k 1} {$k <= $numLayers} {incr k 1} {
    set G($k)       [expr $ro($k)*$vs($k)*$vs($k)]
}

#If nu = 0.0 the vertical acceleration is not achieved 
set nu                  0.0 
# soil elastic modulus for each layer (kPa)
for {set k 1} {$k <= $numLayers} {incr k 1} {
    set E($k)       [expr 2*$G($k)*(1+$nu)]
}
# soil bulk modulus for each layer (kPa)
for {set k 1} {$k <= $numLayers} {incr k 1} {
    set bulk($k)    [expr $E($k)/(3*(1-2*$nu))]
}

set press   0.0    ;# isotropic consolidation pressure on quad element(s)

# reference pressure
set refPress           80.0
# pressure dependency coefficient
set pressCoeff          0.0
# contraction Just PDMY01 case
set contract            0.06
# dilation coefficients
set dilate1             0.5
set dilate2             2.5
# liquefaction coefficients
set liq1                0.0 
set liq2                0.0 
set liq3                0.0
# bedrock shear wave velocity (m/s)
set rockVS            762.0
# bedrock mass density (Mg/m^3)
set rockDen             2.396

# #---GROUND MOTION PARAMETERS
# # time step in ground motion record
set motionDT        0.005
# number of steps in ground motion record
set motionSteps     7990

# #---WAVELENGTH PARAMETERS
# # highest frequency desired to be well resolved (Hz)
set fMax     100.0
# shear wave velocity desired to be well resolved
set vsMin    $vs(1)
# wavelength of highest resolved frequency
set wave     [expr $vsMin/$fMax]
# number of elements per one wavelength
set nEle     8

# #---RAYLEIGH DAMPING PARAMETERS
set pi      3.141592654
# damping ratio (Ask WHY????)
set damp    0.05
# lower frequency
set omega1  [expr 2*$pi*0.2]
# upper frequency
set omega2  [expr 2*$pi*20]
# damping coefficients
set a0      [expr 2*$damp*$omega1*$omega2/($omega1 + $omega2)]
set a1      [expr 2*$damp/($omega1 + $omega2)]
puts "damping coefficients: a_0 = $a0;  a_1 = $a1"

# #---ANALYSIS PARAMETERS
# # Newmark parameters
set gamma       1.5;#    0.5
set beta        1.0;#    0.25

# ----------------------
#  2. DEFINE MESH GEOMETRY
# #-----------------------------------------------------------------------------------------------------------
 
# trial vertical element size
set hTrial   [expr $wave/$nEle]
 
set numTotalEle 0
# loop over layers to determine appropriate element size
for {set k 1} {$k <= $numLayers} {incr k 1} {
 
  # trial number of elements 
    set nTrial   [expr $layerThick($k)/$hTrial]
	
	
	puts "nTrial for layer $k: $nTrial and is compared with [expr floor($layerThick($k)/$hTrial)]"
	
	
  # round up if not an integer number of elements
    if { $nTrial > [expr floor($layerThick($k)/$hTrial)] } {
        set numEleY($k)  [expr int(floor($layerThick($k)/$hTrial)+1)]
		
		puts "the number of elements in Y is [expr int(floor($layerThick($k)/$hTrial)+1)]"
		
    } else {
        set numEleY($k)  [expr int($nTrial)+1]
    }
    puts "number of vertical elements in layer $k: $numEleY($k)"
 
  # counter for total number of elements
    set numTotalEle [expr $numTotalEle + $numEleY($k)]
 
  # final vertical size of elements (m) 
	puts "The layer Thick of Layer # $k is $layerThick($k) and the number of vertical elements in this layer is $numEleY($k)"
  
    set sizeEleY($k)  [expr {$layerThick($k)/$numEleY($k)}]
    puts "vertical size of elements in layer $k: $sizeEleY($k)"
}
puts "total number of vertical elements: $numTotalEle"
 
# define horizontal size of elements as smallest vertical element size (m)
set sizeEleX  $sizeEleY(1)
for {set k 2} {$k <= $numLayers} {incr k 1} {
    if { $sizeEleY($k) < $sizeEleY([expr $k-1]) } {
        set sizeEleX  $sizeEleY($k)
		set sizeEleYUNIQUE $sizeEleY($k)
    }
}

# #### All the process must be done with sizeEleX and sizeEleYUNIQUE variables ######

puts "horizontal size of elements: $sizeEleX and vertical size of elements: $sizeEleYUNIQUE"
 
# number of nodes in vertical direction in each layer
set numTotalNode 0
for {set k 1} {$k < $numLayers} {incr k 1} {
    
	set numNodeY($k)  [expr 2*$numEleY($k)]
	
    puts "number of nodes in layer $k: $numNodeY($k)"
    set numTotalNode  [expr $numTotalNode + $numNodeY($k)]
}
set numNodeY($numLayers) [expr 2*($numEleY($numLayers)+1)]
puts "number of nodes in layer $numLayers: $numNodeY($numLayers)"
set numTotalNode      [expr $numTotalNode + $numNodeY($numLayers)]
puts "total number of nodes: $numTotalNode"
 
puts "Finished with dynamic analysis..."
puts "total number of vertical elements: $numTotalEle"
puts "horizontal size of elements: $sizeEleX"
puts "number of nodes in layer $numLayers: $numNodeY($numLayers)"
puts "total number of nodes: $numTotalNode"
for {set k 1} {$k <= $numLayers} {incr k 1} {
   puts "vertical size of elements in layer $k: $sizeEleY($k)"
}





# #-----------------------------------------------------------------------------------------------------------
# #  3. DEFINE NODES FOR SOIL ELEMENTS
# #-----------------------------------------------------------------------------------------------------------
 
# soil nodes are created in 2 dimensions, with 3 dof (2 translational, 1 porePressure)
model BasicBuilder -ndm 2 -ndf 3
 
set yCoord     0.0
set count      0
# loop over layers
for {set k 1} {$k <= $numLayers} {incr k 1} {
  # loop over nodes
    for {set j 1} {$j <= $numNodeY($k)} {incr j 2} {
        node    [expr $j+$count]     0.0         $yCoord
        node    [expr $j+$count+1]   $sizeEleX   $yCoord
		
		
		puts "The coordinates of node #[expr $j+$count] is  0.0 , $yCoord"
		puts "The coordinates of node #[expr $j+$count+1] is  $sizeEleX  , $yCoord"
 
 
 
        set yCoord  [expr {$yCoord + $sizeEleYUNIQUE}]
		
		
    }
    set count [expr $count+$numNodeY($k)]
}
puts "Finished creating all soil nodes..."



# #-----------------------------------------------------------------------------------------------------------
# #  4. DEFINE DASHPOT NODES
# #-----------------------------------------------------------------------------------------------------------
 
node 2000 0.0 0.0
node 2001 0.0 0.0
 
puts "Finished creating dashpot nodes..."
 

 #-----------------------------------------------------------------------------------------------------------
#  5. DEFINE BOUNDARY CONDITIONS AND EQUAL DOF
# #-----------------------------------------------------------------------------------------------------------
 
# define fixity of base nodes
fix 1 0 1
fix 2 0 1
 
# define fixity of dashpot nodes
fix  2000  1 1
fix  2001  0 1
 
# define equal DOF for simple shear deformation of soil elements

#If equalDOF restrain 1 and 2 DOF, don´t happend consolidation 
equalDOF 1 2 1 2

for {set k 3} {$k <= $numTotalNode} {incr k 2} {
    equalDOF  $k  [expr $k+1]  1 2
}
 
# define equal DOF for dashpot and base soil nodes
equalDOF 1    2 1 
equalDOF 1 2001 1
 # update materials to consider plastic behavior

puts "Finished creating all boundary conditions and equalDOF..."
 
 

 # #-----------------------------------------------------------------------------------------------------------
# #  6. DEFINE SOIL MATERIALS
# #-----------------------------------------------------------------------------------------------------------
 
 
# PDMY01 DATA
# set rho             2.202
 # # soil friction angle
# set phi             35.0
# # peak shear strain
# set gammaPeak       0.1
# # reference pressure
# set refPress        80.0
# # pressure dependency coefficient
# set pressCoeff      0.0
# # phase transformation angle
# set phaseAng        27.0 
# # contraction
# set contract        0.06
# # dilation coefficients
# set dilate1         0.5
# set dilate2         2.5
# # liquefaction coefficients
# set liq1            0.0 
# set liq2            0.0 
# set liq3            0.0
# # bedrock shear wave velocity (m/s)
# set rockVS           762.0
# # bedrock mass density (Mg/m^3)
# set rockDen          2.396




 
# loop over layers to define materials
for {set k 1} {$k <= $numLayers} {incr k 1} {

# nDMaterial PressureIndependMultiYield $k 2 $ro($k) $G($k) $bulk($k) $cohe($k) $gamPeak($k) $fi($k) 100.0 0.0 

# This material is implemented to simulate monotonic
# or cyclic response of materials whose shear behavior is insensitive to the confinement change.
# Such materials include, for example, organic soils or clay under fast (undrained) loading
# conditions.

# nDMaterial PressureDependMultiYield $k 2 $rho $G($k) $bulk($k) $phi $gammaPeak $refPress $pressCoeff \
                                    # $phaseAng $contract $dilate1 $dilate2 $liq1 $liq2 $liq3 16


nDMaterial PressureDependMultiYield02 $k 2 $ro($k) $G($k) $bulk($k) $fi($k) $gamPeak($k) $refPress  $pressCoeff $phasAng($k) 0.067 0.23 0.06 0.27 

# We have to define the contraction and dilatation for the nondata soil layers, the propouse values are the ones obtained with TXC calibration for the second layer (Dept=10m).
}
 
puts "Finished creating all soil materials..."

 
 #-----------------------------------------------------------------------------------------------------------
#  7. DEFINE SOIL ELEMENTS
# #-----------------------------------------------------------------------------------------------------------
 
set wgtX  0.0
# set wgtY  [expr -9.81*$rho]
 
set count 0
# loop over layers 
for {set k 1} {$k <= $numLayers} {incr k 1} {
  # loop over elements
    for {set j 1} {$j <= $numEleY($k)} {incr j 1} {
 
        set nI  [expr 2*($j+$count) - 1] 
        set nJ  [expr $nI + 1]
        set nK  [expr $nI + 3]
        set nL  [expr $nI + 2]
 
        # element quad [expr $j+$count] $nI $nJ $nK $nL 1.0 "PlaneStrain" $k 0.0 0.0 $wgtX [expr -9.81*$ro($k)]
		
		#      thick maTag  bulk  mDensity  perm1  perm2  gravity      press  
		element quadUP [expr $j+$count] $nI $nJ $nK $nL 1.0 $k $bulk($k) $fmass $hperm($k) $vperm($k) $wgtX [expr -9.81*$ro($k)] $press
 
    }
    set count [expr $count + $numEleY($k)]
}
 
puts "Finished creating all soil elements..."
 
 
 # Update to elastac behavior after create elements
 for {set k 1} {$k <= $numLayers} {incr k} {
    updateMaterialStage -material $k -stage 0
}
 
 
 #-----------------------------------------------------------------------------------------------------------
#  8. DEFINE MATERIAL AND ELEMENTS FOR VISCOUS DAMPERS
# #-----------------------------------------------------------------------------------------------------------
 
# dashpot coefficient 
set mC     [expr $sizeEleX*$rockDen*$rockVS]
 
# material
uniaxialMaterial Viscous 4000 $mC 1
 
# elements.
element zeroLength 5000 2000 2001 -mat 4000 -dir 1
 
puts "Finished creating dashpot material and element..."
 
 #-----------------------------------------------------------------------------------------------------------
#  8. CREATE GRAVITY RECORDERS
# #-----------------------------------------------------------------------------------------------------------
 
# record nodal displacements, velocities, and accelerations at each time step
recorder Node -file Gdisplacement00005(SA01)X.out -time  -nodeRange 1 $numTotalNode -dof 1  disp
recorder Node -file Gdisplacement00005(SA01)Y.out -time  -nodeRange 1 $numTotalNode -dof 2  disp
recorder Node -file Gvelocity00005(SA01)X.out     -time  -nodeRange 1 $numTotalNode -dof 1  vel
recorder Node -file Gvelocity00005(SA01)Y.out     -time  -nodeRange 1 $numTotalNode -dof 2  vel
recorder Node -file Gacceleration00005(SA01)X.out -time  -nodeRange 1 $numTotalNode -dof 1  accel
recorder Node -file Gacceleration00005(SA01)Y.out -time  -nodeRange 1 $numTotalNode -dof 2  accel
recorder Node -file Gpressure00005(SA01)Y.out -time  -nodeRange 1 $numTotalNode -dof 3  vel

# record stress and strain at each gauss point in the soil elements
recorder Element -file Gstress100005(SA01).out   -time  -eleRange  1   $numTotalEle   material 1 stress
recorder Element -file Gstress200005(SA01).out   -time  -eleRange  1   $numTotalEle   material 2 stress
recorder Element -file Gstress300005(SA01).out   -time  -eleRange  1   $numTotalEle   material 3 stress
recorder Element -file Gstress400005(SA01).out   -time  -eleRange  1   $numTotalEle   material 4 stress
 
recorder Element -file Gstrain100005(SA01).out   -time  -eleRange  1   $numTotalEle   material 1 strain
recorder Element -file Gstrain200005(SA01).out   -time  -eleRange  1   $numTotalEle   material 2 strain
recorder Element -file Gstrain300005(SA01).out   -time  -eleRange  1   $numTotalEle   material 3 strain
recorder Element -file Gstrain400005(SA01).out   -time  -eleRange  1   $numTotalEle   material 4 strain
 
puts "Finished creating gravity recorders..."
 
 
 #-----------------------------------------------------------------------------------------------------------
# #  9. APPLY GRAVITY LOADING
# #-----------------------------------------------------------------------------------------------------------
 
# constraints Transformation
constraints Penalty 1.e18 1.e18
# constraints Plain tolerancia 0.01 dinámica
test        NormDispIncr 1e-4 500 1
algorithm   Newton
# algorithm	  KrylovNewton
numberer      RCM
system    	  ProfileSPD
# system 		BandSPD
# system		SparseGeneral
# system 		UmfPack
# system 		SparseSPD
# system BandGeneral
integrator  Newmark $gamma $beta 
analysis    Transient
 
 
 # _____________________
 
# system ProfileSPD
# test NormDispIncr 1.e-4 500 1
# algorithm ModifiedNewton
# constraints Transformation
# integrator LoadControl 1 1 1 1
# numberer RCM
 
 # ______________________
 
 
 
 #from here comes the step values in the statical analyze 
analyze     60 2.0e2
 
puts "Finished with elastic gravity analysis..."
 
 
 #-----------------------------------------------------------------------------------------------------------
#  10. CREATE POST-GRAVITY RECORDERS
# #-----------------------------------------------------------------------------------------------------------
 # # update materials to consider plastic behavior
for {set k 1} {$k <= $numLayers} {incr k} {
    updateMaterialStage -material $k -stage 1
}
# reset time and analysis
setTime 0.0
wipeAnalysis
 
# record nodal displacments, velocities, and accelerations at each time step
recorder Node -file DynamicDisplacementX.out -time -dT $motionDT -nodeRange 1 $numTotalNode -dof 1  disp
recorder Node -file DynamicDisplacementY.out -time -dT $motionDT -nodeRange 1 $numTotalNode -dof 2  disp
recorder Node -file DynamicVelocityX.out     -time -dT $motionDT -nodeRange 1 $numTotalNode -dof 1  vel
recorder Node -file DynamicVelocityY.out     -time -dT $motionDT -nodeRange 1 $numTotalNode -dof 2  vel
recorder Node -file DynamicAccelerationX.out -time -dT $motionDT -nodeRange 1 $numTotalNode -dof 1  accel
recorder Node -file DynamicAccelerationY.out -time -dT $motionDT -nodeRange 1 $numTotalNode -dof 2  accel
recorder Node -file DynamicPressure.out -time -dT $motionDT -nodeRange 1 $numTotalNode -dof 3  vel

 
# record stress and strain at each gauss point in the soil elements
recorder Element -file DynamicStress1.out   -time -dT $motionDT -eleRange  1   $numTotalEle   material 1 stress
recorder Element -file DynamicStress2.out   -time -dT $motionDT -eleRange  1   $numTotalEle   material 2 stress
recorder Element -file DynamicStress3.out   -time -dT $motionDT -eleRange  1   $numTotalEle   material 3 stress
recorder Element -file DynamicStress4.out   -time -dT $motionDT -eleRange  1   $numTotalEle   material 4 stress
 
recorder Element -file DynamicStrain1.out   -time -dT $motionDT -eleRange  1   $numTotalEle   material 1 strain
recorder Element -file DynamicStrain2.out   -time -dT $motionDT -eleRange  1   $numTotalEle   material 2 strain
recorder Element -file DynamicStrain3.out   -time -dT $motionDT -eleRange  1   $numTotalEle   material 3 strain
recorder Element -file DynamicStrain4.out   -time -dT $motionDT -eleRange  1   $numTotalEle   material 4 strain
 
puts "Finished creating all recorders..."
 
 
 # #-----------------------------------------------------------------------------------------------------------
# #  11. DYNAMIC ANALYSIS  
# #-----------------------------------------------------------------------------------------------------------
 
# define constant factor for applied velocity
set cFactor [expr $sizeEleX*$rockDen*$rockVS]
 
# define velocity time history file
# set velocityFile velocityHistory.out
 set velocityFile velocityHistorySenosoidal.txt
# timeseries object for force history
set mSeries "Path -dt $motionDT -filePath $velocityFile -factor $cFactor"
 
# loading object
pattern Plain 10 $mSeries {
load 1 1.0 0.0 
}
puts "Dynamic loading created..."
 
# #---DETERMINE STABLE ANALYSIS TIME STEP USING CFL CONDITION
# maximum shear wave velocity (m/s)
set vsMax     $vs(1)
# duration of ground motion (s)
set duration  [expr $motionDT*$motionSteps]
# trial analysis time step
set kTrial    [expr $sizeEleX/(pow($vsMax,0.5))]
# define time step and number of steps for analysis
if { $motionDT <= $kTrial } {
    set nSteps  $motionSteps
    set dT      $motionDT
} else {
    set nSteps  [expr floor($duration/$kTrial)+1]
    set dT      [expr $duration/$nSteps] 
}
puts "number of steps in analysis: $nSteps"
puts "analysis time step: $dT"
 
# analysis objects
# constraints Transformation
constraints Penalty 1.e18 1.e18
test        NormDispIncr 1e-2 500 1
# algorithm   Newton
algorithm KrylovNewton
numberer    RCM
# system      ProfileSPD
system BandGeneral
integrator  Newmark $gamma $beta 
rayleigh    $a0 $a1 0.0 0.0
analysis    VariableTransient
 
analyze     $nSteps  $dT
 
puts "Finished with dynamic analysis..."


puts "total number of vertical elements: $numTotalEle"
puts "horizontal size of elements: $sizeEleX"
puts "number of nodes in layer $numLayers: $numNodeY($numLayers)"
puts "total number of nodes: $numTotalNode"
for {set k 1} {$k <= $numLayers} {incr k 1} {
   puts "vertical size of elements in layer $k: $sizeEleY($k)"
}
wipe
 
 


