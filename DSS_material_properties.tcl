#############################################################################
# PressureDependentMultiYield material 									    #
# By: Arash Khosravifar   January 2009										#
# Last edit:			  June 2013											#
#############################################################################

if {$matTag == 1} {
# defined variables for Sand (N1)60=35 "nonliq" (Mat 1)
set massDen 			2.06;   # (ton/m3)
set refG 				111.9e3; # (kPa)
set refB 				298.3e3; # (kPa)
set frinctionAng 		42.2;	# (degree)
set peakShearStrain 	0.1;
set refPress 			100.;    # (kPa)
set pressDependCoe 		0.5;
set phaseTransAng 		32.2;	# (degree)

# Ref.: source code Line 1861: plasticPotential= (1-etaPT)^2 * [contr1 + maxCumuDilateStrainOcta*contr2]*[(p'+p'o)/Patm]^contr3
# plasticPotential = -(factorPT)*(factorPT)*(contractParam1+maxCumuDilateStrainOcta*contractParam2)*contractRule;
# factorPT = contactRatio/stressRatioPT;
# maxCumuDilateStrainOcta += zzz*liquefyParam1*subStrainRate.octahedralShear(1);
# contractRule = pow((fabs(contactStress.volume())+fabs(residualPress))/pAtm, contractParam3);
set contractionParam1 	0.001;	# Contraction rate. Adjusted to result 13 cycles before dilation
set contractionParam2 	0.5;  	# fabric damage
set contractionParam3 	0.0;   	# k_sigma effect

# Ref.: source code Line 1845: plasticPotential= (1-etaPT)^2*[dil1+cumuDilateStrainOcta^dil2]*[(p'+p'o)/Patm]^(-dil3)
# plasticPotential = ppp*factorPT*(factorPT)*(dilateParam1+pow(cumuDilateStrainOcta,dilateParam2));
# ppp=pow((fabs(contactStress.volume())+fabs(residualPress))/pAtm, -dilateParam3);
# cumuDilateStrainOcta += subStrainRate.octahedralShear(1);
set dilationParam1 		0.4;	# Adjusted to results 1.5% after dilation
set dilationParam2 		3.0;	# As suggested by the manual
set dilationParam3 		0.0;	# Set to 0. to see K-sigma effect only in the contraction zone (before dilation)

set liqParam1 			1.0;
set liqParam2 			0.0;

set noYieldSurf 		20;
set void 				0.55;
set cs1 				0.9;
set cs2 				0.02;
set cs3 				0.0;
set pa					100; # (kPa)
set c					0.1; # (kPa)
}

if {$matTag == 2} {
# defined variables for Sand (N1)60=25 (Mat 2)
set massDen 			2.03; #(ton/m3)
set refG 				94.6e3; # (kPa)
set refB 				252.6e3; # (kPa)
set frinctionAng 		35.8;
set peakShearStrain 	0.1;
set refPress 			100; # (kPa)
set pressDependCoe 		0.5;
set phaseTransAng 		30.8;

set contractionParam1 	0.005;
set contractionParam2 	1.0;
set contractionParam3 	0.2;

set dilationParam1 		0.15;
set dilationParam2 		3.0;
set dilationParam3 		0.0;

set liqParam1 			1.0;
set liqParam2 			0.0;

set noYieldSurf 		20;
set void 				0.60;
set cs1 				0.9;
set cs2 				0.02;
set cs3 				0.0;
set pa					100; # (kPa)
set c					0.1; # (kPa)
}

if {$matTag == 3} {
# defined variables for Sand (N1)60=15 (Mat 3)
set massDen 				1.99; 	#(ton/m3)
set refG 					73.7e3; # (kPa)
set refB 					196.8e3;# (kPa)
set frinctionAng 			30.3;
set peakShearStrain 		0.1;
set refPress 				100; # (kPa)
set pressDependCoe 		0.5;
set phaseTransAng 		25.3;

set contractionParam1 	0.019;
set contractionParam2 	3.0;
set contractionParam3 	0.2;

set dilationParam1 		0.15;
set dilationParam2 		3.0;
set dilationParam3 		0.0;

set liqParam1 			1.0;
set liqParam2 			0.0;

set noYieldSurf 			20;
set void 					0.67;
set cs1 					0.9;
set cs2 					0.02;
set cs3 					0.0;
set pa					100; # (kPa)
set c						0.1; # (kPa)
}

if {$matTag == 4} {
# defined variables for Sand (N1)60=5 (Mat 4)
set massDen 			1.94; #(ton/m3)
set refG 				46.9e3; # (kPa)
set refB 				125.1e3; # (kPa)
set frinctionAng 		25.4;
set peakShearStrain 	0.05; #0.1;
set refPress 			100; # (kPa)
set pressDependCoe 		0.5;
set phaseTransAng 		20.0;

set contractionParam1 	0.06;
set contractionParam2 	5.0;
set contractionParam3 	0.2;

set dilationParam1 		0.3; #0.15;
set dilationParam2 		3.0;
set dilationParam3 		0.0;

set liqParam1 			1.0;
set liqParam2 			0.0;

set noYieldSurf 		20;
set void 				0.76;
set cs1 				0.9;
set cs2 				0.02;
set cs3 				0.0;
set pa					100; # (kPa)
set c					0.1; # (kPa)
}

if {$matTag == 5} {
# defined variables for the Clay Crust (Mat 5)
set massDen 			1.6;   #Mg/m3
set Su					20.; #kPa
set cohesion			[expr $Su/(2.*sqrt(3.)/3.)];    #kPa
set refG 				[expr $Su*700.];#*(3.0/sqrt(6.0))]; #kPa
set refB 				[expr $refG*5.0]; #kPa
set peakShearStrain 	0.05; #0.1
set frinctionAng 		0.0;
set refPress 			100;   #kPa
set pressDependCoe 		0.0;
set noYieldSurf			20;
# set reduction {4.75965E-05	1.00 \
# 0.000119988	0.79 \
# 0.000203039	0.70 \
# 0.000302593	0.63 \
# 0.000423399	0.56 \
# 0.00056824	0.50 \
# 0.000749748	0.44 \
# 0.000976293	0.39 \
# 0.001218721	0.35 \
# 0.001518221	0.31 \
# 0.001877266	0.28 \
# 0.002290047	0.25 \
# 0.002854856	0.22 \
# 0.003495195	0.19 \
# 0.004340107	0.16 \
# 0.005390395	0.14 \
# 0.007236909	0.11 \
# 0.012024692	0.07 \
# 0.04854208	0.02 \
# 0.135	0.01}
}
