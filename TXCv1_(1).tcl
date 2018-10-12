#############################################################################
# Model with SSPBrick Element and PressureDependentMultiYield02 material    #
# By: Jaime A. Mercado  April 17th 2018 				    #		
# Version 1 								    #
#############################################################################

wipe
wipe all
set startT [clock seconds]

# --------------------------------------------------------------------------------------------------------------
# U N I T S
# --------------------------------------------------------------------------------------------------------------

# Length : m
# Force  : kN
# Stress : kPa
# Mass   : ton

######################### MAIN USER INPUTS #################################

set Analysis_case "undrained_cyclic"
	# Options:
	# undrained_cyclic
	# undrained_monotonic: define target max shear strain ($devDisp)
set consolidation_type "isotropic"
	# Options:
	# isotropic
	# ko
set matTag		1;			 # material Tag 
set matType		"PDMY02";		 # use PDMY02 for sand, or MD for Manzaris Dafalias
set LoadingMode		"StrainC";		 # use StrainC for strain-controlled or StressC for stress-controlled
set vertPress 		[expr 1.0*50.]; 	 # kPa vertical confining pressure
set ko			[expr 0.5*$vertPress];	 # kPa lateral confining pressure (this just works used when ko consolidation is chosen)
set loadbias		0.0; 			 # Alpha = tau_xy/s'vo
set sigmad		100.; 			 # kPa vertical deviator stress (only works for the monotonic case) THIS IS FOR STRESS CONTROL
set cycDev		100.; 			 # Applied sinusoidal loading amplitude (only works for the cyclic case) THIS IS FOR STRESS CONTROL
set target_shear_strain [expr 1/100.];	 # Target shear strain (only works for the cyclic case) THIS IS FOR STRAIN CONTROL
set frequency     	1; 			 # Hz (only works for the cyclic case)
set devDisp 		-0.18;			 # Deviatoric strain (This only works for monotonic case) THIS IS FOR STRAIN CONTROL

# Consitutive soil model parameters input
# define variables for Sand
set massDen 			1.9;    # (ton/m3)
set refG 			14.e4;  # (kPa)
set refB 			24.3e4;  # (kPa)
set frinctionAng 		35.1;	 # (degree)
set peakShearStrain 		0.1;
set refPress 			101.;    # (kPa)
set pressDependCoe 		0.5;
set phaseTransAng 		31.8;	 # (degree)
set contractionParam1 		0.045;	 # Contraction rate. 
set contractionParam2 		5.0;  	 # fabric damage
set contractionParam3 		0.15;    # k_sigma effect
set dilationParam1 		0.06;   	 
set dilationParam2 		3.0;	 # As suggested by the manual
set dilationParam3 		0.15;	 # 
set liqParam1 			1.0;
set liqParam2 			0.0;
set noYieldSurf 		20;
set void 			0.7;
set cs1 			0.9;
set cs2 			0.02;
set cs3 			0.7;
set pa				101.;	 # (kPa)
set c				0.1; 	 # (kPa)

# Some variables for the ELEMENT
set fluidDen 		1.0;		# Fluid mass density
set waterbulk 		2.2e6;		# kPa
set kdrain 		1.e1;		# permeability for drained loading
set kundrain 		1.e-20;		# permeability for undrained loading
set alpha 		1.5e-5; 	# alpha = h^2/(4*(Ks + (4/3)*Gs))

######################### END OF MAIN USER INPUTS ###########################

#Directory
set dir Results.$consolidation_type.$Analysis_case
file mkdir $dir
logFile "TRIAXIAL.txt"

# Some loading related variables
if {$Analysis_case == "undrained_cyclic"} {
	set period      		[expr 1.0/$frequency];
	set kPerm			$kundrain
}
if {$Analysis_case == "undrained_monotonic"} {
	set period      		1.;
	set deltaT 			100;
	set numSteps 			10000;
	set kPerm			$kundrain
}
puts "Finished creating loading case..."


################# model domain ##################################

# node $NodeTag $XCoord $Ycoord $Zcoord

model basic -ndm 3 -ndf 4

node 1   1.0 0.0 0.0
node 2   1.0 1.0 0.0
node 3   0.0 1.0 0.0
node 4   0.0 0.0 0.0
node 5   1.0 0.0 1.0
node 6   1.0 1.0 1.0
node 7   0.0 1.0 1.0
node 8   0.0 0.0 1.0

# fix $NodeTag x-transl y-transl z-transl

fix 1  0 1 1 1 
fix 2  0 0 1 1 
fix 3  1 0 1 1 
fix 4  1 1 1 1 
fix 5  0 1 0 1 
fix 6  0 0 0 1 
fix 7  1 0 0 1 
fix 8  1 1 0 1

################# define material ################################## (so far only have the PDMY02 and Manzari Dafalias)

if {$matType == "PDMY02"} {	
# SAND (PDMY02)
nDMaterial PressureDependMultiYield02 $matTag 3 $massDen $refG $refB $frinctionAng \
	$peakShearStrain $refPress $pressDependCoe $phaseTransAng \
	$contractionParam1 $contractionParam3 $dilationParam1 $dilationParam3 \
	$noYieldSurf $contractionParam2 $dilationParam2 $liqParam1 $liqParam2 \
	$void $cs1 $cs2 $cs3 $pa $c;
}

if {$matType == "MD"} {	
#          ManzariDafalias  tag    G0   nu   e_init   Mc    c    lambda_c    e0    ksi   P_atm   m    h0   ch    nb  A0      nd   z_max   cz    Den  
nDMaterial ManzariDafalias   1    125  0.05  $void    1.25  0.712   0.019    0.934  0.7    100   0.01 7.05 0.968 1.1 0.704    3.5    4     600  1.42  
}

####################################################################

#    SSPbrickUP  tag i j k l m n p q  matTag  fBulk    fDen    k1    k2   k3   void   alpha    <b1 b2 b3>
element SSPbrickUP 1 1 2 3 4 5 6 7 8 $matTag $waterbulk $fluidDen  $kPerm $kPerm $kPerm $void $alpha
puts "Finished creating model..."

################# RECORDERS ##################################

recorder Node -file pressure.out -time -node 6 -dof 4 vel;
recorder Element -file stress.out -time  stress; 
recorder Element -file strain.out -time  strain; 

# Rayleigh damping parameter
set damp   0.1
set omega1 0.0157
set omega2 64.123
set a1 [expr 2.0*$damp/($omega1+$omega2)]
set a0 [expr $a1*$omega1*$omega2]

################# ANALYSIS PARAMETERS ##################################
# Newmark parameters for elastic
set gamma1  	0.5
set beta1   	0.25
numberer	RCM
#system 	ProfileSPD
system 		BandGeneral
test 		NormDispIncr 1.e-4 50 2
constraints 	Penalty 1.e18 1.e18
integrator 	Newmark $gamma1 $beta1;
#algorithm 	KrylovNewton
algorithm 	Newton
rayleigh 	$a0 0. $a1 0.0
analysis 	Transient

# --------------------------------------------------------------------------------------------------------------
# Stage 1 - Consolidation
# --------------------------------------------------------------------------------------------------------------
set vN [expr -$vertPress/4.0];
set hN [expr -$ko/4.0];

if {$consolidation_type == "isotropic"} {
	pattern Plain 1 {Series -time {0 10000 1e10} -values {0 1 1} -factor 1} {
  	  load 1  $vN  0.0 0.0 0.0
   	  load 2  $vN  $vN 0.0 0.0
  	  load 3  0.0  $vN 0.0 0.0
	  load 4  0.0  0.0 0.0 0.0
  	  load 5  $vN  0.0 $vN 0.0
  	  load 6  $vN  $vN $vN 0.0
  	  load 7  0.0  $vN $vN 0.0
  	  load 8  0.0  0.0 $vN 0.0
	}
}
if {$consolidation_type == "ko"} {
	pattern Plain 1 {Series -time {0 10000 1e10} -values {0 1 1} -factor 1} {
  	  load 1  $hN  0.0 0.0 0.0
   	  load 2  $hN  $hN 0.0 0.0
  	  load 3  0.0  $hN 0.0 0.0
	  load 4  0.0  0.0 0.0 0.0
  	  load 5  $hN  0.0 $vN 0.0
  	  load 6  $hN  $hN $vN 0.0
  	  load 7  0.0  $hN $vN 0.0
  	  load 8  0.0  0.0 $vN 0.0
	}
}
if {$Analysis_case == "undrained_monotonic"} {
analyze     100 100
analyze     10 1000
}

if {$Analysis_case == "undrained_cyclic"} {
#analyze     500 1
#analyze     50 1
analyze     100 100
analyze     10 1000
}
puts "Finished with consolidation stage..."

# --------------------------------------------------------------------------------------------------------------
# Stage 2 - Deviatoric Loading
# --------------------------------------------------------------------------------------------------------------

#close drainage

for {set i 1} {$i <9} {incr i} {
	remove sp $i 4
}

if {$Analysis_case == "undrained_monotonic"} {
analyze 5 0.1
#loadConst -time 20001; 				# keep consolidation stresses
updateMaterialStage -material $matTag -stage 1; # update materials to ensure plastic behavior
analyze 5 0.1
}

if {$Analysis_case == "undrained_cyclic"} {
#analyze 50 1
analyze 5 0.1
#loadConst -time 600; 				# keep consolidation stresses
analyze 5 0.1
}
puts "Drainage closed..."
updateMaterialStage -material $matTag -stage 1; # update materials to ensure plastic behavior

################# STRESS CONTROL ##################################

set cyclicL 	[expr $cycDev/4.0]
if {$LoadingMode == "StressC"} {
if {$Analysis_case == "undrained_cyclic"} {
	#set tStart 	600
	#set tEnd 	670
	set tStart 	20001
	set tEnd 	20301
	# sinusoidal loading
	timeSeries Trig 1 $tStart $tEnd $period
	pattern Plain 2 1 {
	  load 1  0.0  0.0 0.0 0.0
   	  load 2  0.0  0.0 0.0 0.0
  	  load 3  0.0  0.0 0.0 0.0
	  load 4  0.0  0.0 0.0 0.0
 	  load 5  0.0  0.0 $cyclicL 0.0
  	  load 6  0.0  0.0 $cyclicL 0.0
  	  load 7  0.0  0.0 $cyclicL 0.0
  	  load 8  0.0  0.0 $cyclicL 0.0
	}
	  analyze 10000 0.007
puts "Finished with cyclic loading..."
}
}
################# STRAINS CONTROL ##################################

if {$LoadingMode == "StrainC"} {
if {$Analysis_case == "undrained_cyclic"} {
	set tStart 	20001
	set tEnd 	20071
	model basic -ndm 3 -ndf 4
	timeSeries Trig 1 $tStart $tEnd $period
	pattern Plain 2 1 {
		sp 5 3 [expr $target_shear_strain]
		sp 6 3 [expr $target_shear_strain]
		sp 7 3 [expr $target_shear_strain]
		sp 8 3 [expr $target_shear_strain]
	}
	  analyze 10000 0.007
	   #analyze 3000 0.1
puts "Finished with cyclic loading..."
}


if {$Analysis_case == "undrained_monotonic"} {
# Read vertical displacement of top plane
set vertDisp [nodeDisp 5 3]
# Apply deviatoric strain
set eDisp [expr 1+$devDisp/$vertDisp]
eval "timeSeries Path 5 -time {0 20001 20301 1e10} -values {0 1 $eDisp $eDisp}"
pattern Plain 2 5 { 
	sp 5  3	$vertDisp
	sp 6  3	$vertDisp
	sp 7  3 $vertDisp
	sp 8  3 $vertDisp
}
	  analyze 3000 0.1
puts "Finished with monotonic loading..."
}
}
set endT [clock seconds]
puts "Execution time: [expr $endT-$startT] seconds."
puts "Done"
wipe;  # flush output stream