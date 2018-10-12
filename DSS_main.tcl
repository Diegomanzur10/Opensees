#############################################################################
# Model with 9-4-quad-UP element and PressureDependentMultiYield material   #
# By: Arash Khosravifar   January 2009										#
# Last edit:			  June 2013											#
#############################################################################

wipe
wipe all
set startT [clock seconds]

######################### MAIN USER INPUTS #################################
set matTag				5;				 # matTag 1, 2, 3 and 4 for sand with (N1)60 of 35, 25, 15 and 5 respectively. matTag 5 for clay with Su=20
set matType				"PIMY";		 # use PDMY02 for sand (matTag 1 to 4) and PIMY for clay (matTag 5)
set vertPress 			[expr 1.0*100];  # kPa vertical confining pressure
set loadbias			0.0; 			 # Alpha = tau_xy/s'vo
set Analysis_case "undrained_cyclic"
# Options:
# undrained_cyclic
# undrained_monotonic: define target max shear strain
# drained_cyclic: applies 2 cycles for each strain (9 shear strain ranging from 0.0003% to 3%) for the purpose of G/Gmax and Damping curves
# drained_monotonic: define target max shear strain
######################### END OF MAIN USER INPUTS ###########################

# Load material properties
source DSS_material_properties.tcl

# Some variables for the ELEMENT
set fluidDen 			1.0;		# Fluid mass density
set waterbulk 			2.2e6;		# kPa
set kdrain 				1.e1;		# permeability for drained loading
set kundrain 			1.e-8;		# permeability for undrained loading
set gravY 				0.0;
set gravX 				0.0;

# Some loading related variables
if {$Analysis_case == "undrained_cyclic"} {
	set target_shear_strain [expr 5.0/100.]
	set csr 				0.09;
	set period      		1.;
	set deltaT 				0.005;
	set kPerm				$kundrain
}
if {$Analysis_case == "undrained_monotonic"} {
	set target_shear_strain [expr 5.0/100.]
	set period      		1.;
	set deltaT 				0.001;
	set numSteps 			1000;
	set kPerm				$kundrain
}
if {$Analysis_case == "drained_monotonic"} {
	# also change the damping to 0.005 (??)
	set target_shear_strain [expr 1.0/100.];	#unit in strain - it will be multiplied by ySize later. Note: DON'T forget the ".0" in 1.0
	set period      		1.;
	set deltaT 				0.005;
	set numSteps 			3000;

	set kPerm				$kdrain
	set phaseTransAng $frinctionAng
	set contractionParam1 	0.0;
	set contractionParam2 	0.0;
	set contractionParam3 	0.0;
	set dilationParam1 		0.0;
	set dilationParam2 		0.0;
	set dilationParam3 		0.0;
	set liqParam1 			0.0;
	set liqParam2 			0.0;
}
if {$Analysis_case == "drained_cyclic"} {
	set period      		10.;
	set deltaT 				0.005;
	set numSteps 			4000;
	
	set kPerm				$kdrain
	set phaseTransAng $frinctionAng
	set contractionParam1 	0.0;
	set contractionParam2 	0.0;
	set contractionParam3 	0.0;
	set dilationParam1 		0.0;
	set dilationParam2 		0.0;
	set dilationParam3 		0.0;
	set liqParam1 			0.0;
	set liqParam2 			0.0;
}

# Define Rayleigh Damping
set rayleigh_damping2	0.001;
set rayleigh_damping1	0.001;
set rayleigh_w1			[expr 2*3.14/$period];
set rayleigh_w2			[expr 2*3.14/($period/2.0)];
set Kinitproprayleigh	[expr 2*$rayleigh_w1*$rayleigh_w2/($rayleigh_w1*$rayleigh_w1-$rayleigh_w2*$rayleigh_w2)*(-1*$rayleigh_damping1/$rayleigh_w1+1*$rayleigh_damping2/$rayleigh_w2)]; #This is a1 [expr 2*$dampratio/(2*3.1416/0.02)];
set Mproprayleigh		[expr 2*$rayleigh_w1*$rayleigh_w2/($rayleigh_w1*$rayleigh_w1-$rayleigh_w2*$rayleigh_w2)*($rayleigh_damping1*$rayleigh_w1-$rayleigh_damping2*$rayleigh_w2)]; #This is a0 [expr 2*$dampratio*(2*3.1416/2.0)];

####################################################################
set xsize 0.1;
set ysize 0.1;
set thickness 0.1;

# define the 3DOF nodes
model basic -ndm 2 -ndf 3
node 1   0.0 0.0 
node 2   $xsize 0.0 
node 3   $xsize $ysize 
node 4   0.0 $ysize

fix 1  1 1 0
fix 2  1 1 0
fix 3  0 0 1
fix 4  0 0 1
equalDOF 1 2  3
equalDOF 3 4  1 2

# define the 2DOF nodes
model basic -ndm 2 -ndf 2
node 5   [expr $xsize/2] 0.0
node 6   $xsize [expr $ysize/2]
node 7   [expr $xsize/2] $ysize
node 8   0.0 [expr $ysize/2]
node 9   [expr $xsize/2] [expr $ysize/2]

fix 5 1 1
equalDOF 3 7  1 2
equalDOF 6 8  1 2
# equalDOF 6 9  1 2


################# define material ##################################

if {$matType == "PDMY02"} {	
# SAND (PDMY02)
nDMaterial PressureDependMultiYield02 $matTag 2 $massDen $refG $refB $frinctionAng \
	$peakShearStrain $refPress $pressDependCoe $phaseTransAng \
	$contractionParam1 $contractionParam3 $dilationParam1 $dilationParam3 \
	$noYieldSurf $contractionParam2 $dilationParam2 $liqParam1 $liqParam2 \
	$void $cs1 $cs2 $cs3 $pa $c;
}

if {$matType == "PIMY"} {	
# CLAY(PIMY)
nDMaterial PressureIndependMultiYield $matTag 2 $massDen $refG $refB $cohesion \
	$peakShearStrain $frinctionAng $refPress $pressDependCoe $noYieldSurf;
}
####################################################################
# define the element                     thick       maTag  		bulk         fmass      hPerm   vPerm
element 9_4_QuadUP  1  1 2 3 4 5 6 7 8 9  $thickness $matTag    [expr $waterbulk/0.4]  $fluidDen  $kPerm $kPerm $gravX $gravY;

####################################################################
# Recorders
file mkdir output
eval "recorder Node -file output/disp1_$Analysis_case.out -time -node 1 2 3 4 5 6 7 8 9 -dof 1 disp";
eval "recorder Node -file output/disp2_$Analysis_case.out -time -node 1 2 3 4 5 6 7 8 9 -dof 2 disp";
eval "recorder Node -file output/pwp_$Analysis_case.out -time -node 1 2 3 4 -dof 3 vel";
eval "recorder Element -file output/stress_$Analysis_case.out -time -ele 1 material 9 stress";  # s11 s22 s33 s12 eta	(EFFECTIVE stresses)
eval "recorder Element -file output/strain_$Analysis_case.out -time -ele 1 material 9 strain";  # e11 e22 g12 (it is not e33 nor e12)
eval "recorder Element -file output/backbone_$Analysis_case.out -ele 1 material 9 backbone 100 1600";
####################################################################
# GRAVITY APPLICATION (elastic behavior)
model basic -ndm 2 -ndf 3
pattern Plain 1 Constant {
	load 3 [expr $loadbias*$vertPress*$xsize*$thickness*0.25] [expr -$vertPress*$xsize*$thickness*0.25] 0
	load 4 [expr $loadbias*$vertPress*$xsize*$thickness*0.25] [expr -$vertPress*$xsize*$thickness*0.25] 0
}
model basic -ndm 2 -ndf 2
pattern Plain 2 Constant {
	load 7 [expr $loadbias*$vertPress*$xsize*$thickness*0.5] [expr -$vertPress*$xsize*$thickness*0.5]
}

numberer RCM
system ProfileSPD
test NormDispIncr 1.e-5 50 2
constraints Plain; #Penalty 1.e18 1.e18
rayleigh $Mproprayleigh 0.0 $Kinitproprayleigh 0.0
set gama 1.5;
set betta [expr pow($gama+0.5, 2)/4]; #[expr 1./4.]; # 0.25 for const accel, 1/6 for linear accel (in this case deltaT<period/pi)
integrator Newmark $gama $betta;
algorithm KrylovNewton
analysis VariableTransient

updateMaterialStage -material 1 -stage 0
updateMaterialStage -material 2 -stage 0
updateMaterialStage -material 3 -stage 0
updateMaterialStage -material 4 -stage 0
updateMaterialStage -material 5 -stage 0
for {set i 1} {$i <= 100} {incr i 1} {
analyze 1 1000
set tCurrent [getTime]
puts "time = $tCurrent sec"
}
for {set i 1} {$i <= 100} {incr i 1} {
analyze 1 1000
set tCurrent [getTime]
puts "time = $tCurrent sec"
}
puts "Done Elastic"
updateMaterialStage -material 1 -stage 1
updateMaterialStage -material 2 -stage 1
updateMaterialStage -material 3 -stage 1
updateMaterialStage -material 4 -stage 1
updateMaterialStage -material 5 -stage 1
for {set i 1} {$i <= 100} {incr i 1} {
analyze 1 100
set tCurrent [getTime]
puts "time = $tCurrent sec"
}
for {set i 1} {$i <= 200} {incr i 1} {
analyze 1 1000
set tCurrent [getTime]
puts "time = $tCurrent sec"
}
puts "Done Plastic"
puts "Gravity Done!"
####################################################################
# Adjust some fixities for shear loading

# remove surface pwp fixity
model basic -ndm 2 -ndf 3
remove sp 3 3
remove sp 4 3
equalDOF 3 4  3

# equalDOF middle node
# equalDOF 6 9 1 2

####################################################################
loadConst -time 0.0
wipeAnalysis
####################################################################
# NOW APPLY LOADING SEQUENCE AND ANALYZE (plastic)

# Load control cyclic
if {$Analysis_case == "undrained_cyclic"} {

	# Define analysis parameters
	numberer RCM
	system ProfileSPD
	test NormDispIncr 1.e-5 50 0
	constraints Plain
	rayleigh $Mproprayleigh  0.0 $Kinitproprayleigh 0.0
	set gama 1.5; #0.5;	#gama=alfa in other texts
	set betta [expr pow($gama+0.5, 2)/4]; # 0.25 for const accel, 1/6 for linear accel (in this case deltaT<period/pi)
	integrator Newmark $gama $betta;
	algorithm KrylovNewton
	analysis VariableTransient
	
	model basic -ndm 2 -ndf 3
	pattern Plain 4 "Sine 0 [expr $period*1000] $period" {
		load 3 [expr $csr*$vertPress*$xsize*$thickness*0.25] 0 0
		load 4 [expr $csr*$vertPress*$xsize*$thickness*0.25] 0 0
	}
	model basic -ndm 2 -ndf 2
	pattern Plain 5 "Sine 0 [expr $period*1000] $period" {
		load 7 [expr $csr*$vertPress*$xsize*$thickness*0.5] 0
	}
	puts "$Analysis_case"
	while {[expr abs([nodeDisp 7 1]/$ysize)]<$target_shear_strain && [getTime]<300} {
	analyze 1 $deltaT [expr $deltaT/100] $deltaT 20
	puts "time = [getTime] sec"
	}
}

# Disp control monotonic
if {$Analysis_case == "undrained_monotonic"} {
	
	# Define analysis parameters
	numberer RCM
	system BandGeneral; #ProfileSPD
	test NormDispIncr 1.e-5 50 0;
	constraints Penalty 1.e15 1.e15; 
	rayleigh $Mproprayleigh  0.0 $Kinitproprayleigh 0.0
	set gama 1.5; #0.5;	#gama=alfa in other texts
	set betta [expr pow($gama+0.5, 2)/4]; # 0.25 for const accel, 1/6 for linear accel (in this case deltaT<period/pi)
	integrator Newmark $gama $betta;
	algorithm KrylovNewton
	analysis VariableTransient
	
	model basic -ndm 2 -ndf 2
	pattern Plain 14 Linear {
		sp 3 1 [expr $ysize*$target_shear_strain]
		sp 4 1 [expr $ysize*$target_shear_strain]
		sp 7 1 [expr $ysize*$target_shear_strain]
	}
	puts "$Analysis_case"
	for {set i 1} {$i <= [expr $numSteps]} {incr i 1} {
	analyze 1 $deltaT [expr $deltaT/100] $deltaT 20
	set tCurrent [getTime]
	puts "time = $tCurrent sec"
	}
}

# Disp cotrol monotonic
if {$Analysis_case == "drained_monotonic"} {
	
	# Define analysis parameters
	numberer RCM
	system BandGeneral; #ProfileSPD
	test NormDispIncr 1.e-5 50 0
	constraints Penalty 1.e18 1.e18
	rayleigh [expr 5.0*$Mproprayleigh]  0.0 [expr 5.0*$Kinitproprayleigh] 0.0
	set gama 1.5; #0.5;	#gama=alfa in other texts
	set betta [expr pow($gama+0.5, 2)/4]; # 0.25 for const accel, 1/6 for linear accel (in this case deltaT<period/pi)
	integrator Newmark $gama $betta;
	algorithm KrylovNewton
	analysis VariableTransient
	
	model basic -ndm 2 -ndf 3
	pattern Plain 15 Linear {
		sp 3 1 [expr $ysize*$target_shear_strain]
		sp 4 1 [expr $ysize*$target_shear_strain]
		sp 7 1 [expr $ysize*$target_shear_strain]
	}
	puts "$Analysis_case"
	for {set i 1} {$i <= [expr $numSteps]} {incr i 1} {
	analyze 1 $deltaT [expr $deltaT/100] $deltaT 20
	set tCurrent [getTime]
	puts "time = $tCurrent sec"
	}
}

# Disp control cyclic for G/Gmax and Xi curves
if {$Analysis_case == "drained_cyclic"} {
	
	# Define analysis parameters
	numberer RCM
	system BandGeneral; #ProfileSPD
	test NormDispIncr 1.e-5 50 0
	constraints Penalty 1.e18 1.e18
	rayleigh $Mproprayleigh  0.0 $Kinitproprayleigh 0.0
	set gama 1.5; #0.5;	#gama=alfa in other texts
	set betta [expr pow($gama+0.5, 2)/4]; # 0.25 for const accel, 1/6 for linear accel (in this case deltaT<period/pi)
	integrator Newmark $gama $betta;
	algorithm KrylovNewton
	analysis VariableTransient
		
	model basic -ndm 2 -ndf 2
	pattern Plain 4 "Sine 0 1000 $period" {
		sp 3 1 [expr $ysize*0.0003/100.]
	}
	puts "$Analysis_case"
	for {set i 1} {$i <= $numSteps} {incr i 1} {
	analyze 1 $deltaT [expr $deltaT/100] $deltaT 20
	set tCurrent [getTime]
	puts "time = $tCurrent sec"
	}
	remove loadPattern 4
	loadConst;	# I can actually comment this out. It doesn't make any change.

	pattern Plain 5 "Sine 0 1000 $period" {
		sp 3 1 [expr $ysize*0.001/100.]
	}
	for {set i 1} {$i <= $numSteps} {incr i 1} {
	analyze 1 $deltaT [expr $deltaT/100] $deltaT 20
	set tCurrent [getTime]
	puts "time = $tCurrent sec"
	}
	remove loadPattern 5
	loadConst

	pattern Plain 6 "Sine 0 1000 $period" {
		sp 3 1 [expr $ysize*0.003*0.01]
	}
	for {set i 1} {$i <= $numSteps} {incr i 1} {
	analyze 1 $deltaT [expr $deltaT/100] $deltaT 20
	set tCurrent [getTime]
	puts "time = $tCurrent sec"
	}
	remove loadPattern 6
	loadConst

	pattern Plain 7 "Sine 0 1000 $period" {
		sp 3 1 [expr $ysize*0.01*0.01]
	}
	for {set i 1} {$i <= $numSteps} {incr i 1} {
	analyze 1 $deltaT [expr $deltaT/100] $deltaT 20
	set tCurrent [getTime]
	puts "time = $tCurrent sec"
	}
	remove loadPattern 7
	loadConst

	pattern Plain 8 "Sine 0 1000 $period" {
		sp 3 1 [expr $ysize*0.03*0.01]
	}
	for {set i 1} {$i <= $numSteps} {incr i 1} {
	analyze 1 $deltaT [expr $deltaT/100] $deltaT 20
	set tCurrent [getTime]
	puts "time = $tCurrent sec"
	}
	remove loadPattern 8
	loadConst

	pattern Plain 9 "Sine 0 1000 $period" {
		sp 3 1 [expr $ysize*0.1*0.01]
	}
	for {set i 1} {$i <= $numSteps} {incr i 1} {
	analyze 1 $deltaT [expr $deltaT/100] $deltaT 20
	set tCurrent [getTime]
	puts "time = $tCurrent sec"
	}
	remove loadPattern 9
	loadConst

	pattern Plain 10 "Sine 0 1000 $period" {
		sp 3 1 [expr $ysize*0.3*0.01]
	}
	for {set i 1} {$i <= $numSteps} {incr i 1} {
	analyze 1 $deltaT [expr $deltaT/100] $deltaT 20
	set tCurrent [getTime]
	puts "time = $tCurrent sec"
	}
	remove loadPattern 10
	loadConst

	pattern Plain 11 "Sine 0 1000 $period" {
		sp 3 1 [expr $ysize*1.0*0.01]
	}
	for {set i 1} {$i <= $numSteps} {incr i 1} {
	analyze 1 $deltaT [expr $deltaT/100] $deltaT 20
	set tCurrent [getTime]
	puts "time = $tCurrent sec"
	}
	remove loadPattern 11
	loadConst

	pattern Plain 12 "Sine 0 1000 $period" {
		sp 3 1 [expr $ysize*3.0*0.01]
	}
	for {set i 1} {$i <= [expr $numSteps*1.25]} {incr i 1} {
	analyze 1 $deltaT [expr $deltaT/100] $deltaT 20
	set tCurrent [getTime]
	puts "time = $tCurrent sec"
	}
}
####################################################################
set endT [clock seconds]
puts "Execution time: [expr $endT-$startT] seconds."
puts "Finished with cyclic loading"
wipe all
wipe;  # flush output stream
