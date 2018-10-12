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
set vertPress 		[expr 1.0*100.]; 	 # kPa vertical confining pressure
set ko			[expr 0.5*$vertPress];	 # kPa lateral confining pressure (this just works used when ko consolidation is chosen)
set loadbias		0.0; 			 # Alpha = tau_xy/s'vo
set sigmad		100.; 			 # kPa vertical deviator stress (only works for the monotonic case) THIS IS FOR STRESS CONTROL
set cycDev		100.; 			 # Applied sinusoidal loading amplitude (only works for the cyclic case) THIS IS FOR STRESS CONTROL
set target_shear_strain [expr -1.0*0.00486];	 # Target shear strain (only works for the cyclic case) THIS IS FOR STRAIN CONTROL
set frequency     	1.; 			 # Hz (only works for the cyclic case)
set devDisp 		-0.18;			 # Deviatoric strain (This only works for monotonic case) THIS IS FOR STRAIN CONTROL

# # # # # # # # Average High Dr (3 tests)
set massDen 	1.90
set refG 	66333.33
set refB 	165000.00
set frinctionAng 	31.67
set peakShearStrain 	0.15
set refPress 	101.00
set pressDependCoe 	0.50
set phaseTransAng 	25.33
set contractionParam1 	0.11
set contractionParam2 	1.00
set contractionParam3 	0.7
set dilationParam1 	0.15
set dilationParam2 	2.3
set dilationParam3 	0.025
set liqParam1 	1.00
set liqParam2 	0.00
set noYieldSurf 	20.00
set void 	0.75
set cs1 	0.90
set cs2 	0.02
set cs3 	0.00
set pa	101.00
set c	0.10



# Average Test #5 and %#6
# set massDen 	1.9
# set refG 	67000
# set refB 	165000
# set frinctionAng 	33
# set peakShearStrain 	0.15
# set refPress 	101
# set pressDependCoe 	0.5
# set phaseTransAng 	22
# set contractionParam1 	0.13
# set contractionParam2 	1
# set contractionParam3 	0.65
# set dilationParam1 	0.2
# set dilationParam2 	2
# set dilationParam3 	0.05
# set liqParam1 	1
# set liqParam2 	0
# set noYieldSurf 	20
# set void 	0.75
# set cs1 	0.9
# set cs2 	0.02
# set cs3 	0
# set pa	101
# set c	0.1









# # # # # # # # Average Low Dr
# set massDen 	1.9
# set refG 	60000
# set refB 	160000
# set frinctionAng 	21
# set peakShearStrain 	0.15
# set refPress 	101
# set pressDependCoe 	0.5
# set phaseTransAng 	27
# set contractionParam1 	0.07
# set contractionParam2 	0.5
# set contractionParam3 	0.6
# set dilationParam1 	0.75
# set dilationParam2 	3
# set dilationParam3 	0
# set liqParam1 	1.3
# set liqParam2 	0
# set noYieldSurf 	40
# set void 	0.5
# set cs1 	0.9
# set cs2 	0.02
# set cs3 	0
# set pa	101
# set c	0.1



# Sensibility Analysis over PT C1 C3 D1 
# set massDen 			1.9;    # (ton/m3)		
# set refG 			8.e4;  # (kPa)		
# set refB 			18.e4;  # (kPa)		
# set frinctionAng 		35.;	 # (degree)		
# set peakShearStrain 		0.15;			
# set refPress 			101.;    # (kPa)		
# set pressDependCoe 		0.5;			
# set phaseTransAng 		29.;	 # (degree)		
# set contractionParam1 		0.12;	 # Contraction rate. 	
# set contractionParam2 		0.5;  	 # fabric damage		
# set contractionParam3 		1.6;    # k_sigma effect	1.6  1.2  0.8 /0.6/	0.4	0.2
# set dilationParam1 		2.0; # 2.0 1.5 1.0   /0.75/ 0.50  0.25	 		
# set dilationParam2 		3.0;	 # As suggested by the manual		
# set dilationParam3 		0.;	 # 		
# set liqParam1 			1.3;		
# set liqParam2 			0.0;		
# set noYieldSurf 		40;			
# set void 			0.5;		
# set cs1 			0.9;		
# set cs2 			0.02;		
# set cs3 			0.0;		
# set pa				101.;	 # (kPa)
# set c				0.1; 	 # (kPa)

# Consitutive soil model parameters input
# define variables for Sand
# set	massDen	1.9
# set	refG	7.00E+04
# set	refB	1.65E+05
# set	frinctionAng	35.
# set	peakShearStrain	0.15
# set	refPress	101.
# set	pressDependCoe	0.5
# set	phaseTransAng	28.
# set	contractionParam1	0.07
# set	contractionParam2	1.
# set	contractionParam3	0.2
# set	dilationParam1	0.4
# set	dilationParam2	0.01
# set	dilationParam3	0.1
# set	liqParam1	6.
# set	liqParam2	0.
# set	noYieldSurf	20.
# set	void	0.75
# set	cs1	0.9
# set	cs2	0.02
# set	cs3	0.
# set	pa	101.
# set	c	0.1

# # # # # # # # # TEST #1

# set massDen 			1.9;    # (ton/m3)		
# set refG 			6.e4;  # (kPa)		
# set refB 			16.e4;  # (kPa)		
# set frinctionAng 		20.;	 # (degree)		
# set peakShearStrain 		0.15;			
# set refPress 			101.;    # (kPa)		
# set pressDependCoe 		0.5;			
# set phaseTransAng 		20.;	 # (degree)		
# set contractionParam1 		0.07;	 # Contraction rate. 		
# set contractionParam2 		2.0;  	 # fabric damage		
# set contractionParam3 		0.6;    # k_sigma effect			
# set dilationParam1 		0.;   	 		
# set dilationParam2 		3.0;	 # As suggested by the manual		
# set dilationParam3 		0.;	 # 		
# set liqParam1 			1.0;		
# set liqParam2 			0.0;		
# set noYieldSurf 		20;			
# set void 			0.75;		
# set cs1 			0.9;		
# set cs2 			0.02;		
# set cs3 			0.0;		
# set pa				101.;	 # (kPa)
# set c				0.1; 	 # (kPa)
			

# # # # # # # # # # # TEST #2
			
# set massDen 			1.9;    # (ton/m3)		
# set refG 			8.e4;  # (kPa)		
# set refB 			18.e4;  # (kPa)		
# set frinctionAng 		23.;	 # (degree)		
# set peakShearStrain 		0.15;			
# set refPress 			101.;    # (kPa)		
# set pressDependCoe 		0.5;			
# set phaseTransAng 		29.;	 # (degree)		
# set contractionParam1 		0.12;	 # Contraction rate. 		
# set contractionParam2 		0.5;  	 # fabric damage		
# set contractionParam3 		0.6;    # k_sigma effect			
# set dilationParam1 		0.75;   	 		
# set dilationParam2 		3.0;	 # As suggested by the manual		
# set dilationParam3 		0.;	 # 		
# set liqParam1 			1.3;		
# set liqParam2 			0.0;		
# set noYieldSurf 		40;			
# set void 			0.5;		
# set cs1 			0.9;		
# set cs2 			0.02;		
# set cs3 			0.0;		
# set pa				101.;	 # (kPa)
# set c				0.1; 	 # (kPa)

# # # # # # # # TEST #3

# set	massDen	1.9
# set	refG	6.00E+04
# set	refB	1.60E+05
# set	frinctionAng	21
# set	peakShearStrain	0.15
# set	refPress	101
# set	pressDependCoe	0.5
# set	phaseTransAng	27
# set	contractionParam1	0.07
# set	contractionParam2	0.5
# set	contractionParam3	0.6
# set	dilationParam1	0.75
# set	dilationParam2	3
# set	dilationParam3	0
# set	liqParam1	1.3
# set	liqParam2	0
# set	noYieldSurf	40
# set	void	0.5
# set	cs1	0.9
# set	cs2	0.02
# set	cs3	0
# set	pa	101
# set	c	0.1

# # # # # # # # # TEST #4

# set	massDen	1.9
# set	refG	6.50E+04
# set	refB	1.65E+05
# set	frinctionAng	29
# set	peakShearStrain	0.15
# set	refPress	101
# set	pressDependCoe	0.5
# set	phaseTransAng	20
# set	contractionParam1	0.013
# set	contractionParam2	1
# set	contractionParam3	0.75
# set	dilationParam1	0.1
# set	dilationParam2	3
# set	dilationParam3	0
# set	liqParam1	1
# set	liqParam2	0
# set	noYieldSurf	20
# set	void	0.75
# set	cs1	0.9
# set	cs2	0.02
# set	cs3	0
# set	pa	101
# set	c	0.1

# # # # # # # # # TEST #5

# set	massDen	1.9
# set	refG	6.50E+04
# set	refB	1.65E+05
# set	frinctionAng	31
# set	peakShearStrain	0.15
# set	refPress	101
# set	pressDependCoe	0.5
# set	phaseTransAng	19
# set	contractionParam1	0.1
# set	contractionParam2	1
# set	contractionParam3	0.9
# set	dilationParam1	0.1
# set	dilationParam2	3.
# set	dilationParam3	0.
# set	liqParam1	1.
# set	liqParam2	0.
# set	noYieldSurf	20
# set	void	0.75
# set	cs1	0.9
# set	cs2	0.02
# set	cs3	0
# set	pa	101
# set	c	0.1

# # # # # # # # # # TEST #6

# set	massDen	1.9
# set	refG	6.90E+04
# set	refB	1.65E+05
# set	frinctionAng	35
# set	peakShearStrain	0.15
# set	refPress	101
# set	pressDependCoe	0.5
# set	phaseTransAng	25
# set	contractionParam1	0.16
# set	contractionParam2	1
# set	contractionParam3	0.4
# set	dilationParam1	0.3
# set	dilationParam2	1
# set	dilationParam3	0.1
# set	liqParam1	1
# set	liqParam2	0
# set	noYieldSurf	20
# set	void	0.75
# set	cs1	0.9
# set	cs2	0.02
# set	cs3	0
# set	pa	101
# set	c	0.1






# Some variables for the ELEMENT
set fluidDen 		1.0;		# Fluid mass density
set waterbulk 		2.2e6;		# kPa
set kdrain 		1.e1;		# permeability for drained loading
set kundrain 		1.e-20;		# permeability for undrained loading
set alpha 		1.0e-5; 	# alpha = h^2/(4*(Ks + (4/3)*Gs))

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

# node 1   0.15 0.00 0.00
# node 2   0.15 0.15 0.00
# node 3   0.00 0.15 0.00
# node 4   0.00 0.00 0.00
# node 5   0.15 0.00 0.30
# node 6   0.15 0.15 0.30
# node 7   0.00 0.15 0.30
# node 8   0.00 0.00 0.30

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


# nDMaterial InitialStateAnalysisWrapper 2 $matTag 3


####################################################################

#    SSPbrickUP  tag i j k l m n p q  matTag  fBulk    fDen    k1    k2   k3   void   alpha    <b1 b2 b3>
element SSPbrickUP 1 1 2 3 4 5 6 7 8 $matTag $waterbulk $fluidDen  $kPerm $kPerm $kPerm $void $alpha
puts "Finished creating model..."

################# RECORDERS ##################################



# recorder Node -file pressure.out -time -node 6 -dof 4 vel;
# recorder Element -file stress.out -time  stress; 
# recorder Element -file strain.out -time  strain; 

# Rayleigh damping parameter
set pi      3.141592654
set damp   0.3
# set omega1  [expr 2*$pi*0.2]
# set omega2  [expr 2*$pi*20]
# set omega1 0.0157
set omega1 25.
# set omega2 64.123
set omega2 1.123
# set a1 [expr 2.0*$damp/($omega1+$omega2)]
# set a0 [expr $a1*$omega1*$omega2]
set a1 0.0250826
set a0 0.00012707

################# ANALYSIS PARAMETERS ##################################
# Newmark parameters for elastic
# set gamma1  	0.5
# set beta1   	0.25

set gamma1  	0.5
set beta1   	0.25

numberer	RCM
# system 	ProfileSPD ufmpack
# system 		BandGeneral
system UmfPack General
test 		NormDispIncr 3.e-3 50 2
constraints 	Penalty 3.e9 3.e1
# constraints Plain
integrator 	Newmark $gamma1 $beta1;
algorithm 	KrylovNewton
# algorithm 	Newton
rayleigh 	$a0 0. $a1 0.01
# rayleigh 	0.1 0.005 0.02 0.03
# rayleigh 	$a0 $a1 0. 0.0
analysis 	Transient




# --------------------------------------------------------------------------------------------------------------
# Stage 1 - Consolidation
# --------------------------------------------------------------------------------------------------------------
set vN [expr -$vertPress/4.0];
set hN [expr -$ko/4.0];
	# # turn on the initial state analysis feature
	  # InitialStateAnalysis on
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
	  # # turn off the initial state analysis feature
      # InitialStateAnalysis off
# --------------------------------------------------------------------------------------------------------------
# Stage 2 - Deviatoric Loading
# --------------------------------------------------------------------------------------------------------------

wipeAnalysis
nDMaterial InitialStateAnalysisWrapper 2 1 3
remove recorders
# reset displacement

numberer	RCM
# system 	ProfileSPD ufmpack
# system 		BandGeneral
system UmfPack General
test 		NormDispIncr 3.e-3 50 2
constraints 	Penalty 6.e5 3.e1
# constraints Plain
integrator 	Newmark $gamma1 $beta1;
algorithm 	KrylovNewton
# algorithm 	Newton
rayleigh 	$a0 0. $a1 0.015
# rayleigh 	0.1 0.005 0.02 0.03
# rayleigh 	$a0 $a1 0. 0.0
analysis 	Transient

		recorder Node -file pressure.out -time -node 6 -dof 4 vel;
		recorder Element -file stress.out -time  stress; 
		recorder Element -file strain.out -time  strain;
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
	set tStart 	0
	set tEnd 	301
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
	  analyze 9500 0.007
puts "Finished with cyclic loading..."
}
}

################# STRAINS CONTROL ##################################

if {$LoadingMode == "StrainC"} {
if {$Analysis_case == "undrained_cyclic"} {
	set tStart 	20000.
	set tEnd 	20201.
	model basic -ndm 3 -ndf 4
	# Read vertical displacement of top plane
    set vertDisp [nodeDisp 5 3]
	
	set shift [expr asin($vertDisp/$target_shear_strain)] 
	# set shift [expr $pi/2] 
	
	timeSeries Trig 1 $tStart $tEnd $period -factor 1 -shift $shift
	
	pattern Plain 2 1 {
		sp 5 3 [expr $target_shear_strain]
		sp 6 3 [expr $target_shear_strain]
		sp 7 3 [expr $target_shear_strain]
		sp 8 3 [expr $target_shear_strain]
	}

	  

		
		analyze 17000 0.005
		
		

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



 