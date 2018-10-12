###########################################################
#                                                         #
# Effective stress site response analysis for a layered   #
# soil profile located on a 2% slope and underlain by an  #
# elastic half-space.  9-node quadUP elements are used.   #
# The finite rigidity of the elastic half space is        #
# considered through the use of a viscous damper at the   #
# base.                                                   #
#                                                         #
#   Created by:  Chris McGann                             #
#                HyungSuk Shin                            #
#                Pedro Arduino                            #
#                Peter Mackenzie-Helnwein                 #
#              --University of Washington--               #
#                                                         #
# ---> Basic units are kN and m   (unless specified)      #
#                                                         #
###########################################################

wipe

#-----------------------------------------------------------------------------------------
#  1. DEFINE SOIL AND MESH GEOMETRY
#-----------------------------------------------------------------------------------------

#---SOIL GEOMETRY
# thicknesses of soil profile (m)
set soilThick      30.0
# number of soil layers
set numLayers      3
# layer thicknesses
set layerThick(3)  2.0
set layerThick(2)  8.0
set layerThick(1)  20.0
# depth of water table
set waterTable     2.0

# define layer boundaries
set layerBound(1) $layerThick(1)
for {set i 2} {$i <= $numLayers} {incr i 1} {
    set layerBound($i) [expr $layerBound([expr $i-1])+$layerThick($i)]
}

#---MESH GEOMETRY
# number of elements in horizontal direction
set nElemX  1
# number of nodes in horizontal direction
set nNodeX  [expr 2*$nElemX+1]
# horizontal element size (m)
set sElemX  2.0

# number of elements in vertical direction for each layer
set nElemY(3)  4
set nElemY(2)  16
set nElemY(1)  40
# total number of elements in vertical direction
set nElemT     60
# vertical element size in each layer
for {set i 1} {$i <=$numLayers} {incr i 1} {
    set sElemY($i) [expr $layerThick($i)/$nElemY($i)]
    puts "size:  $sElemY($i)"
}

# number of nodes in vertical direction
set nNodeY  [expr 2*$nElemT+1]
# total number of nodes
set nNodeT  [expr $nNodeX*$nNodeY]

puts "# nodes in Y is $nNodeY"
puts "# of total nodes is $nNodeT"