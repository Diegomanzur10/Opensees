wipe
 
#-----------------------------------------------------------------------------------------------------------
#  1. DEFINE ANALYSIS PARAMETERS
#-----------------------------------------------------------------------------------------------------------
 
#---SOIL GEOMETRY
# number of soil layers
set numLayers       30
# layer thicknesses (m)
set layerThick(30)  1.0
set layerThick(29)  1.0
set layerThick(28)  1.0
set layerThick(27)  1.0
set layerThick(26)  1.0
set layerThick(25)  1.0
set layerThick(24)  1.0
set layerThick(23)  1.0
set layerThick(22)  1.0
set layerThick(21)  1.0
set layerThick(20)  1.0
set layerThick(19)  1.0
set layerThick(18)  1.0
set layerThick(17)  1.0
set layerThick(16)  1.0
set layerThick(15)  1.0
set layerThick(14)  1.0
set layerThick(13)  1.0
set layerThick(12)  1.0
set layerThick(11)  1.0
set layerThick(10)  1.0
set layerThick(9)   1.0
set layerThick(8)   1.0
set layerThick(7)   1.0
set layerThick(6)   1.0
set layerThick(5)   1.0
set layerThick(4)   1.0
set layerThick(3)   1.0
set layerThick(2)   1.0
set layerThick(1)   1.0
 
#---MATERIAL PROPERTIES
# soil mass density (Mg/m^3)
set rho             2.202
# soil shear wave velocity for each layer(m/s)
set Vs(30)          170.9
set Vs(29)          224.9
set Vs(28)          255.6
set Vs(27)          278.0
set Vs(26)          296.0
set Vs(25)          311.3
set Vs(24)          324.5
set Vs(23)          336.4
set Vs(22)          347.0
set Vs(21)          356.8
set Vs(20)          365.9
set Vs(19)          374.3
set Vs(18)          382.2
set Vs(17)          389.6
set Vs(16)          396.6
set Vs(15)          403.3
set Vs(14)          409.6
set Vs(13)          415.7
set Vs(12)          421.5
set Vs(11)          427.1
set Vs(10)          432.5
set Vs(9)           437.7
set Vs(8)           442.7
set Vs(7)           447.5
set Vs(6)           452.2
set Vs(5)           456.7
set Vs(4)           461.2
set Vs(3)           465.4
set Vs(2)           469.6
set Vs(1)           473.7
# soil shear modulus for each layer (kPa)
for {set k 1} {$k <= $numLayers} {incr k 1} {
    set G($k)       [expr $rho*$Vs($k)*$Vs($k)]
}
# poisson's ratio of soil
set nu              0.0
# soil elastic modulus for each layer (kPa)
for {set k 1} {$k <= $numLayers} {incr k 1} {
    set E($k)       [expr 2*$G($k)*(1+$nu)]
}
# soil bulk modulus for each layer (kPa)
for {set k 1} {$k <= $numLayers} {incr k 1} {
    set bulk($k)    [expr $E($k)/(3*(1-2*$nu))]
}
# soil friction angle
set phi             35.0
# peak shear strain
set gammaPeak       0.1
# reference pressure
set refPress        80.0
# pressure dependency coefficient
set pressCoeff      0.0
# phase transformation angle
set phaseAng        27.0
# contraction
set contract        0.06
# dilation coefficients
set dilate1         0.5
set dilate2         2.5
# liquefaction coefficients
set liq1            0.0 
set liq2            0.0 
set liq3            0.0
# bedrock shear wave velocity (m/s)
set rockVS           762.0
# bedrock mass density (Mg/m^3)
set rockDen          2.396
 
#---GROUND MOTION PARAMETERS
# time step in ground motion record
set motionDT        0.005
# number of steps in ground motion record
set motionSteps     7990
 
#---WAVELENGTH PARAMETERS
# highest frequency desired to be well resolved (Hz)
set fMax     100.0
# shear wave velocity desired to be well resolved
set vsMin    $Vs(30)
# wavelength of highest resolved frequency
set wave     [expr $vsMin/$fMax]
# number of elements per one wavelength
set nEle     10

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
set gamma           0.5
set beta            0.25
 
#-----------------------------------------------------------------------------------------------------------
#  2. DEFINE MESH GEOMETRY
#-----------------------------------------------------------------------------------------------------------
 
# trial vertical element size
set hTrial   [expr $wave/$nEle]
 
set numTotalEle 0
# loop over layers to determine appropriate element size
for {set k 1} {$k <= $numLayers} {incr k 1} {
 
  # trial number of elements 
    set nTrial   [expr $layerThick($k)/$hTrial]
 
  # round up if not an integer number of elements
    if { $nTrial > [expr floor($layerThick($k)/$hTrial)] } {
        set numEleY($k)  [expr int(floor($layerThick($k)/$hTrial)+1)]
    } else {
        set numEleY($k)  [expr int($nTrial)]
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
    }
}
puts "horizontal size of elements: $sizeEleX"
 
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






