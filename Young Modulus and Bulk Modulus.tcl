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
for {set k 1} {k=<numLayers} {incr k 1} {

	set vperm($k) [expr $vperm($k)/$accGravity/$fmass];#actual value used in computation
	set hperm($k) [expr $hperm($k)/$accGravity/$fmass];#actual value used in computation
	
	puts "The actual Vperm is $vperm($k) and Hperm is $hperm($k) for layer $k"
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

#Cohesion (kPa)
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
	puts "The actual G $G($k) (Ton/(ms^2))"
}

#If nu = 0.0 the vertical acceleration is not achieved 
set nu                  0.0 
# soil elastic modulus for each layer (kPa)
for {set k 1} {$k <= $numLayers} {incr k 1} {
    set E($k)       [expr 2*$G($k)*(1+$nu)]
	puts "The actual E $E($k) (Ton/(ms^2))"
}
# soil bulk modulus for each layer (kPa)
for {set k 1} {$k <= $numLayers} {incr k 1} {
    set bulk($k)    [expr $E($k)/(3*(1-2*$nu))]
	puts "The actual B $bulk($k) (Ton/(ms^2))"
}

