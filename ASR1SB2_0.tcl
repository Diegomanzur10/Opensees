# ASR1SB2_0.tcl --
#
#        The main .tcl file for OpenSees.
#
# Created on: 5/26/2018 3:24:55 AM
#
# Created by: 
#       OpenSeesPL (Edu Version 2.7.3.10311)
# OpenSees Analysis of 3D Lateral Pile-Ground Interaction
#      Copyright (c) 2017 All Rights Reserved.
#

wipe

set parallel 0; # 0 -- sequential run (e.g., on a PC)
                # 1 -- parallel run

logFile ASR1SB2_0.log

if { $parallel == 0 } {
    puts "Analysis started at: [clock format [clock seconds]]\n"
    # clock format [clock seconds] -format "%T"
    set startT [clock seconds]

    set solver "UmfPack"
    set solver2 "UmfPack"
} else {
    set solver "UmfPack"
    set solver2 "Mumps -ICNTL14 50"
}

set constraints "Penalty 1e18 1e18"
set test "NormDispIncr  1.000000e-004 100 2"
set algorithm "KrylovNewton"
set integrator "Newmark"
#set numberer "Plain"
set numberer "RCM"
set outfmt "-file"
# Unit system in this file: SI

# define UNITS ---------------------------------------------
set g 9.81; 	# gravitational acceleration (also good for US/EN units since SI is actually used)
set nonlinear 1
set gamma 0.5
# Rayleigh Damping
set am 2.508260e-002
set ak 1.270700e-004
set numSteps 3000
set compdT 0.05
# remove any existing old files so post-processing would not read wrong files
file delete ASR1SB2_0.tim
file delete ASR1SB2_0.dsp
file delete ASR1SB2_0.frq
file delete traceStop.txt
model basic -ndm 3 -ndf 4
node      1   0.000000e+000   0.000000e+000  -3.000000e+001
node      2   1.000000e+000   0.000000e+000  -3.000000e+001
node      3   1.000000e+000   1.000000e+000  -3.000000e+001
node      4   0.000000e+000   1.000000e+000  -3.000000e+001
node      5   0.000000e+000   0.000000e+000  -2.850000e+001
node      6   1.000000e+000   0.000000e+000  -2.850000e+001
node      7   1.000000e+000   1.000000e+000  -2.850000e+001
node      8   0.000000e+000   1.000000e+000  -2.850000e+001
node      9   0.000000e+000   0.000000e+000  -2.700000e+001
node     10   1.000000e+000   0.000000e+000  -2.700000e+001
node     11   1.000000e+000   1.000000e+000  -2.700000e+001
node     12   0.000000e+000   1.000000e+000  -2.700000e+001
node     13   0.000000e+000   0.000000e+000  -2.550000e+001
node     14   1.000000e+000   0.000000e+000  -2.550000e+001
node     15   1.000000e+000   1.000000e+000  -2.550000e+001
node     16   0.000000e+000   1.000000e+000  -2.550000e+001
node     17   0.000000e+000   0.000000e+000  -2.400000e+001
node     18   1.000000e+000   0.000000e+000  -2.400000e+001
node     19   1.000000e+000   1.000000e+000  -2.400000e+001
node     20   0.000000e+000   1.000000e+000  -2.400000e+001
node     21   0.000000e+000   0.000000e+000  -2.250000e+001
node     22   1.000000e+000   0.000000e+000  -2.250000e+001
node     23   1.000000e+000   1.000000e+000  -2.250000e+001
node     24   0.000000e+000   1.000000e+000  -2.250000e+001
node     25   0.000000e+000   0.000000e+000  -2.100000e+001
node     26   1.000000e+000   0.000000e+000  -2.100000e+001
node     27   1.000000e+000   1.000000e+000  -2.100000e+001
node     28   0.000000e+000   1.000000e+000  -2.100000e+001
node     29   0.000000e+000   0.000000e+000  -1.950000e+001
node     30   1.000000e+000   0.000000e+000  -1.950000e+001
node     31   1.000000e+000   1.000000e+000  -1.950000e+001
node     32   0.000000e+000   1.000000e+000  -1.950000e+001
node     33   0.000000e+000   0.000000e+000  -1.800000e+001
node     34   1.000000e+000   0.000000e+000  -1.800000e+001
node     35   1.000000e+000   1.000000e+000  -1.800000e+001
node     36   0.000000e+000   1.000000e+000  -1.800000e+001
node     37   0.000000e+000   0.000000e+000  -1.650000e+001
node     38   1.000000e+000   0.000000e+000  -1.650000e+001
node     39   1.000000e+000   1.000000e+000  -1.650000e+001
node     40   0.000000e+000   1.000000e+000  -1.650000e+001
node     41   0.000000e+000   0.000000e+000  -1.500000e+001
node     42   1.000000e+000   0.000000e+000  -1.500000e+001
node     43   1.000000e+000   1.000000e+000  -1.500000e+001
node     44   0.000000e+000   1.000000e+000  -1.500000e+001
node     45   0.000000e+000   0.000000e+000  -1.447059e+001
node     46   1.000000e+000   0.000000e+000  -1.447059e+001
node     47   1.000000e+000   1.000000e+000  -1.447059e+001
node     48   0.000000e+000   1.000000e+000  -1.447059e+001
node     49   0.000000e+000   0.000000e+000  -1.394118e+001
node     50   1.000000e+000   0.000000e+000  -1.394118e+001
node     51   1.000000e+000   1.000000e+000  -1.394118e+001
node     52   0.000000e+000   1.000000e+000  -1.394118e+001
node     53   0.000000e+000   0.000000e+000  -1.341176e+001
node     54   1.000000e+000   0.000000e+000  -1.341176e+001
node     55   1.000000e+000   1.000000e+000  -1.341176e+001
node     56   0.000000e+000   1.000000e+000  -1.341176e+001
node     57   0.000000e+000   0.000000e+000  -1.288235e+001
node     58   1.000000e+000   0.000000e+000  -1.288235e+001
node     59   1.000000e+000   1.000000e+000  -1.288235e+001
node     60   0.000000e+000   1.000000e+000  -1.288235e+001
node     61   0.000000e+000   0.000000e+000  -1.235294e+001
node     62   1.000000e+000   0.000000e+000  -1.235294e+001
node     63   1.000000e+000   1.000000e+000  -1.235294e+001
node     64   0.000000e+000   1.000000e+000  -1.235294e+001
node     65   0.000000e+000   0.000000e+000  -1.182353e+001
node     66   1.000000e+000   0.000000e+000  -1.182353e+001
node     67   1.000000e+000   1.000000e+000  -1.182353e+001
node     68   0.000000e+000   1.000000e+000  -1.182353e+001
node     69   0.000000e+000   0.000000e+000  -1.129412e+001
node     70   1.000000e+000   0.000000e+000  -1.129412e+001
node     71   1.000000e+000   1.000000e+000  -1.129412e+001
node     72   0.000000e+000   1.000000e+000  -1.129412e+001
node     73   0.000000e+000   0.000000e+000  -1.076471e+001
node     74   1.000000e+000   0.000000e+000  -1.076471e+001
node     75   1.000000e+000   1.000000e+000  -1.076471e+001
node     76   0.000000e+000   1.000000e+000  -1.076471e+001
node     77   0.000000e+000   0.000000e+000  -1.023529e+001
node     78   1.000000e+000   0.000000e+000  -1.023529e+001
node     79   1.000000e+000   1.000000e+000  -1.023529e+001
node     80   0.000000e+000   1.000000e+000  -1.023529e+001
node     81   0.000000e+000   0.000000e+000  -9.705882e+000
node     82   1.000000e+000   0.000000e+000  -9.705882e+000
node     83   1.000000e+000   1.000000e+000  -9.705882e+000
node     84   0.000000e+000   1.000000e+000  -9.705882e+000
node     85   0.000000e+000   0.000000e+000  -9.176471e+000
node     86   1.000000e+000   0.000000e+000  -9.176471e+000
node     87   1.000000e+000   1.000000e+000  -9.176471e+000
node     88   0.000000e+000   1.000000e+000  -9.176471e+000
node     89   0.000000e+000   0.000000e+000  -8.647059e+000
node     90   1.000000e+000   0.000000e+000  -8.647059e+000
node     91   1.000000e+000   1.000000e+000  -8.647059e+000
node     92   0.000000e+000   1.000000e+000  -8.647059e+000
node     93   0.000000e+000   0.000000e+000  -8.117647e+000
node     94   1.000000e+000   0.000000e+000  -8.117647e+000
node     95   1.000000e+000   1.000000e+000  -8.117647e+000
node     96   0.000000e+000   1.000000e+000  -8.117647e+000
node     97   0.000000e+000   0.000000e+000  -7.588235e+000
node     98   1.000000e+000   0.000000e+000  -7.588235e+000
node     99   1.000000e+000   1.000000e+000  -7.588235e+000
node    100   0.000000e+000   1.000000e+000  -7.588235e+000
node    101   0.000000e+000   0.000000e+000  -7.058824e+000
node    102   1.000000e+000   0.000000e+000  -7.058824e+000
node    103   1.000000e+000   1.000000e+000  -7.058824e+000
node    104   0.000000e+000   1.000000e+000  -7.058824e+000
node    105   0.000000e+000   0.000000e+000  -6.529412e+000
node    106   1.000000e+000   0.000000e+000  -6.529412e+000
node    107   1.000000e+000   1.000000e+000  -6.529412e+000
node    108   0.000000e+000   1.000000e+000  -6.529412e+000
node    109   0.000000e+000   0.000000e+000  -6.000000e+000
node    110   1.000000e+000   0.000000e+000  -6.000000e+000
node    111   1.000000e+000   1.000000e+000  -6.000000e+000
node    112   0.000000e+000   1.000000e+000  -6.000000e+000
node    113   0.000000e+000   0.000000e+000  -5.500000e+000
node    114   1.000000e+000   0.000000e+000  -5.500000e+000
node    115   1.000000e+000   1.000000e+000  -5.500000e+000
node    116   0.000000e+000   1.000000e+000  -5.500000e+000
node    117   0.000000e+000   0.000000e+000  -5.000000e+000
node    118   1.000000e+000   0.000000e+000  -5.000000e+000
node    119   1.000000e+000   1.000000e+000  -5.000000e+000
node    120   0.000000e+000   1.000000e+000  -5.000000e+000
node    121   0.000000e+000   0.000000e+000  -4.800000e+000
node    122   1.000000e+000   0.000000e+000  -4.800000e+000
node    123   1.000000e+000   1.000000e+000  -4.800000e+000
node    124   0.000000e+000   1.000000e+000  -4.800000e+000
node    125   0.000000e+000   0.000000e+000  -4.600000e+000
node    126   1.000000e+000   0.000000e+000  -4.600000e+000
node    127   1.000000e+000   1.000000e+000  -4.600000e+000
node    128   0.000000e+000   1.000000e+000  -4.600000e+000
node    129   0.000000e+000   0.000000e+000  -4.400000e+000
node    130   1.000000e+000   0.000000e+000  -4.400000e+000
node    131   1.000000e+000   1.000000e+000  -4.400000e+000
node    132   0.000000e+000   1.000000e+000  -4.400000e+000
node    133   0.000000e+000   0.000000e+000  -4.200000e+000
node    134   1.000000e+000   0.000000e+000  -4.200000e+000
node    135   1.000000e+000   1.000000e+000  -4.200000e+000
node    136   0.000000e+000   1.000000e+000  -4.200000e+000
node    137   0.000000e+000   0.000000e+000  -4.000000e+000
node    138   1.000000e+000   0.000000e+000  -4.000000e+000
node    139   1.000000e+000   1.000000e+000  -4.000000e+000
node    140   0.000000e+000   1.000000e+000  -4.000000e+000
node    141   0.000000e+000   0.000000e+000  -3.800000e+000
node    142   1.000000e+000   0.000000e+000  -3.800000e+000
node    143   1.000000e+000   1.000000e+000  -3.800000e+000
node    144   0.000000e+000   1.000000e+000  -3.800000e+000
node    145   0.000000e+000   0.000000e+000  -3.600000e+000
node    146   1.000000e+000   0.000000e+000  -3.600000e+000
node    147   1.000000e+000   1.000000e+000  -3.600000e+000
node    148   0.000000e+000   1.000000e+000  -3.600000e+000
node    149   0.000000e+000   0.000000e+000  -3.400000e+000
node    150   1.000000e+000   0.000000e+000  -3.400000e+000
node    151   1.000000e+000   1.000000e+000  -3.400000e+000
node    152   0.000000e+000   1.000000e+000  -3.400000e+000
node    153   0.000000e+000   0.000000e+000  -3.200000e+000
node    154   1.000000e+000   0.000000e+000  -3.200000e+000
node    155   1.000000e+000   1.000000e+000  -3.200000e+000
node    156   0.000000e+000   1.000000e+000  -3.200000e+000
node    157   0.000000e+000   0.000000e+000  -3.000000e+000
node    158   1.000000e+000   0.000000e+000  -3.000000e+000
node    159   1.000000e+000   1.000000e+000  -3.000000e+000
node    160   0.000000e+000   1.000000e+000  -3.000000e+000
node    161   0.000000e+000   0.000000e+000  -2.750000e+000
node    162   1.000000e+000   0.000000e+000  -2.750000e+000
node    163   1.000000e+000   1.000000e+000  -2.750000e+000
node    164   0.000000e+000   1.000000e+000  -2.750000e+000
node    165   0.000000e+000   0.000000e+000  -2.500000e+000
node    166   1.000000e+000   0.000000e+000  -2.500000e+000
node    167   1.000000e+000   1.000000e+000  -2.500000e+000
node    168   0.000000e+000   1.000000e+000  -2.500000e+000
node    169   0.000000e+000   0.000000e+000  -2.250000e+000
node    170   1.000000e+000   0.000000e+000  -2.250000e+000
node    171   1.000000e+000   1.000000e+000  -2.250000e+000
node    172   0.000000e+000   1.000000e+000  -2.250000e+000
node    173   0.000000e+000   0.000000e+000  -2.000000e+000
node    174   1.000000e+000   0.000000e+000  -2.000000e+000
node    175   1.000000e+000   1.000000e+000  -2.000000e+000
node    176   0.000000e+000   1.000000e+000  -2.000000e+000
node    177   0.000000e+000   0.000000e+000  -1.818182e+000
node    178   1.000000e+000   0.000000e+000  -1.818182e+000
node    179   1.000000e+000   1.000000e+000  -1.818182e+000
node    180   0.000000e+000   1.000000e+000  -1.818182e+000
node    181   0.000000e+000   0.000000e+000  -1.636364e+000
node    182   1.000000e+000   0.000000e+000  -1.636364e+000
node    183   1.000000e+000   1.000000e+000  -1.636364e+000
node    184   0.000000e+000   1.000000e+000  -1.636364e+000
node    185   0.000000e+000   0.000000e+000  -1.454545e+000
node    186   1.000000e+000   0.000000e+000  -1.454545e+000
node    187   1.000000e+000   1.000000e+000  -1.454545e+000
node    188   0.000000e+000   1.000000e+000  -1.454545e+000
node    189   0.000000e+000   0.000000e+000  -1.272727e+000
node    190   1.000000e+000   0.000000e+000  -1.272727e+000
node    191   1.000000e+000   1.000000e+000  -1.272727e+000
node    192   0.000000e+000   1.000000e+000  -1.272727e+000
node    193   0.000000e+000   0.000000e+000  -1.090909e+000
node    194   1.000000e+000   0.000000e+000  -1.090909e+000
node    195   1.000000e+000   1.000000e+000  -1.090909e+000
node    196   0.000000e+000   1.000000e+000  -1.090909e+000
node    197   0.000000e+000   0.000000e+000  -9.090909e-001
node    198   1.000000e+000   0.000000e+000  -9.090909e-001
node    199   1.000000e+000   1.000000e+000  -9.090909e-001
node    200   0.000000e+000   1.000000e+000  -9.090909e-001
node    201   0.000000e+000   0.000000e+000  -7.272727e-001
node    202   1.000000e+000   0.000000e+000  -7.272727e-001
node    203   1.000000e+000   1.000000e+000  -7.272727e-001
node    204   0.000000e+000   1.000000e+000  -7.272727e-001
node    205   0.000000e+000   0.000000e+000  -5.454545e-001
node    206   1.000000e+000   0.000000e+000  -5.454545e-001
node    207   1.000000e+000   1.000000e+000  -5.454545e-001
node    208   0.000000e+000   1.000000e+000  -5.454545e-001
node    209   0.000000e+000   0.000000e+000  -3.636364e-001
node    210   1.000000e+000   0.000000e+000  -3.636364e-001
node    211   1.000000e+000   1.000000e+000  -3.636364e-001
node    212   0.000000e+000   1.000000e+000  -3.636364e-001
node    213   0.000000e+000   0.000000e+000  -1.818182e-001
node    214   1.000000e+000   0.000000e+000  -1.818182e-001
node    215   1.000000e+000   1.000000e+000  -1.818182e-001
node    216   0.000000e+000   1.000000e+000  -1.818182e-001
node    217   0.000000e+000   0.000000e+000   0.000000e+000
node    218   1.000000e+000   0.000000e+000   0.000000e+000
node    219   1.000000e+000   1.000000e+000   0.000000e+000
node    220   0.000000e+000   1.000000e+000   0.000000e+000

fixZ [expr -3.000000e+001] 1 1 1 0 -tol 1e-4
fix    169 0 0 0 1
fix    170 0 0 0 1
fix    171 0 0 0 1
fix    172 0 0 0 1
fix    173 0 0 0 1
fix    174 0 0 0 1
fix    175 0 0 0 1
fix    176 0 0 0 1
fix    177 0 0 0 1
fix    178 0 0 0 1
fix    179 0 0 0 1
fix    180 0 0 0 1
fix    181 0 0 0 1
fix    182 0 0 0 1
fix    183 0 0 0 1
fix    184 0 0 0 1
fix    185 0 0 0 1
fix    186 0 0 0 1
fix    187 0 0 0 1
fix    188 0 0 0 1
fix    189 0 0 0 1
fix    190 0 0 0 1
fix    191 0 0 0 1
fix    192 0 0 0 1
fix    193 0 0 0 1
fix    194 0 0 0 1
fix    195 0 0 0 1
fix    196 0 0 0 1
fix    197 0 0 0 1
fix    198 0 0 0 1
fix    199 0 0 0 1
fix    200 0 0 0 1
fix    201 0 0 0 1
fix    202 0 0 0 1
fix    203 0 0 0 1
fix    204 0 0 0 1
fix    205 0 0 0 1
fix    206 0 0 0 1
fix    207 0 0 0 1
fix    208 0 0 0 1
fix    209 0 0 0 1
fix    210 0 0 0 1
fix    211 0 0 0 1
fix    212 0 0 0 1
fix    213 0 0 0 1
fix    214 0 0 0 1
fix    215 0 0 0 1
fix    216 0 0 0 1
fix    217 0 0 0 1
fix    218 0 0 0 1
fix    219 0 0 0 1
fix    220 0 0 0 1




equalDOF      5      6     1    2    3
equalDOF      5      7     1    2    3
equalDOF      5      8     1    2    3
equalDOF      9     10     1    2    3
equalDOF      9     11     1    2    3
equalDOF      9     12     1    2    3
equalDOF     13     14     1    2    3
equalDOF     13     15     1    2    3
equalDOF     13     16     1    2    3
equalDOF     17     18     1    2    3
equalDOF     17     19     1    2    3
equalDOF     17     20     1    2    3
equalDOF     21     22     1    2    3
equalDOF     21     23     1    2    3
equalDOF     21     24     1    2    3
equalDOF     25     26     1    2    3
equalDOF     25     27     1    2    3
equalDOF     25     28     1    2    3
equalDOF     29     30     1    2    3
equalDOF     29     31     1    2    3
equalDOF     29     32     1    2    3
equalDOF     33     34     1    2    3
equalDOF     33     35     1    2    3
equalDOF     33     36     1    2    3
equalDOF     37     38     1    2    3
equalDOF     37     39     1    2    3
equalDOF     37     40     1    2    3
equalDOF     41     42     1    2    3
equalDOF     41     43     1    2    3
equalDOF     41     44     1    2    3
equalDOF     45     46     1    2    3
equalDOF     45     47     1    2    3
equalDOF     45     48     1    2    3
equalDOF     49     50     1    2    3
equalDOF     49     51     1    2    3
equalDOF     49     52     1    2    3
equalDOF     53     54     1    2    3
equalDOF     53     55     1    2    3
equalDOF     53     56     1    2    3
equalDOF     57     58     1    2    3
equalDOF     57     59     1    2    3
equalDOF     57     60     1    2    3
equalDOF     61     62     1    2    3
equalDOF     61     63     1    2    3
equalDOF     61     64     1    2    3
equalDOF     65     66     1    2    3
equalDOF     65     67     1    2    3
equalDOF     65     68     1    2    3
equalDOF     69     70     1    2    3
equalDOF     69     71     1    2    3
equalDOF     69     72     1    2    3
equalDOF     73     74     1    2    3
equalDOF     73     75     1    2    3
equalDOF     73     76     1    2    3
equalDOF     77     78     1    2    3
equalDOF     77     79     1    2    3
equalDOF     77     80     1    2    3
equalDOF     81     82     1    2    3
equalDOF     81     83     1    2    3
equalDOF     81     84     1    2    3
equalDOF     85     86     1    2    3
equalDOF     85     87     1    2    3
equalDOF     85     88     1    2    3
equalDOF     89     90     1    2    3
equalDOF     89     91     1    2    3
equalDOF     89     92     1    2    3
equalDOF     93     94     1    2    3
equalDOF     93     95     1    2    3
equalDOF     93     96     1    2    3
equalDOF     97     98     1    2    3
equalDOF     97     99     1    2    3
equalDOF     97    100     1    2    3
equalDOF    101    102     1    2    3
equalDOF    101    103     1    2    3
equalDOF    101    104     1    2    3
equalDOF    105    106     1    2    3
equalDOF    105    107     1    2    3
equalDOF    105    108     1    2    3
equalDOF    109    110     1    2    3
equalDOF    109    111     1    2    3
equalDOF    109    112     1    2    3
equalDOF    113    114     1    2    3
equalDOF    113    115     1    2    3
equalDOF    113    116     1    2    3
equalDOF    117    118     1    2    3
equalDOF    117    119     1    2    3
equalDOF    117    120     1    2    3
equalDOF    121    122     1    2    3
equalDOF    121    123     1    2    3
equalDOF    121    124     1    2    3
equalDOF    125    126     1    2    3
equalDOF    125    127     1    2    3
equalDOF    125    128     1    2    3
equalDOF    129    130     1    2    3
equalDOF    129    131     1    2    3
equalDOF    129    132     1    2    3
equalDOF    133    134     1    2    3
equalDOF    133    135     1    2    3
equalDOF    133    136     1    2    3
equalDOF    137    138     1    2    3
equalDOF    137    139     1    2    3
equalDOF    137    140     1    2    3
equalDOF    141    142     1    2    3
equalDOF    141    143     1    2    3
equalDOF    141    144     1    2    3
equalDOF    145    146     1    2    3
equalDOF    145    147     1    2    3
equalDOF    145    148     1    2    3
equalDOF    149    150     1    2    3
equalDOF    149    151     1    2    3
equalDOF    149    152     1    2    3
equalDOF    153    154     1    2    3
equalDOF    153    155     1    2    3
equalDOF    153    156     1    2    3
equalDOF    157    158     1    2    3
equalDOF    157    159     1    2    3
equalDOF    157    160     1    2    3
equalDOF    161    162     1    2    3
equalDOF    161    163     1    2    3
equalDOF    161    164     1    2    3
equalDOF    165    166     1    2    3
equalDOF    165    167     1    2    3
equalDOF    165    168     1    2    3
equalDOF    169    170     1    2    3
equalDOF    169    171     1    2    3
equalDOF    169    172     1    2    3
equalDOF    173    174     1    2    3
equalDOF    173    175     1    2    3
equalDOF    173    176     1    2    3
equalDOF    177    178     1    2    3
equalDOF    177    179     1    2    3
equalDOF    177    180     1    2    3
equalDOF    181    182     1    2    3
equalDOF    181    183     1    2    3
equalDOF    181    184     1    2    3
equalDOF    185    186     1    2    3
equalDOF    185    187     1    2    3
equalDOF    185    188     1    2    3
equalDOF    189    190     1    2    3
equalDOF    189    191     1    2    3
equalDOF    189    192     1    2    3
equalDOF    193    194     1    2    3
equalDOF    193    195     1    2    3
equalDOF    193    196     1    2    3
equalDOF    197    198     1    2    3
equalDOF    197    199     1    2    3
equalDOF    197    200     1    2    3
equalDOF    201    202     1    2    3
equalDOF    201    203     1    2    3
equalDOF    201    204     1    2    3
equalDOF    205    206     1    2    3
equalDOF    205    207     1    2    3
equalDOF    205    208     1    2    3
equalDOF    209    210     1    2    3
equalDOF    209    211     1    2    3
equalDOF    209    212     1    2    3
equalDOF    213    214     1    2    3
equalDOF    213    215     1    2    3
equalDOF    213    216     1    2    3
equalDOF    217    218     1    2    3
equalDOF    217    219     1    2    3
equalDOF    217    220     1    2    3
set numys 20
# Loose soil or very loose soil
# nDMaterial PressureDependMultiYield 1 3  1.7 5.5000e+04 1.5000e+05 29.0 0.1 80 0.5\
# 					                 29.0 0.21 0.0 0.0   10.0 0.02 1.0 $numys
# Medium soil
# nDMaterial PressureDependMultiYield 1 3  1.9 7.500e+04 2.0e+05 33.0 0.1 80 0.5\
# 					                 27.0 0.07 0.4 2.0    10.0 0.01 1.0 $numys
# Medium-dense soil
# nDMaterial PressureDependMultiYield 1 3  2.0 1.0e+05 3.e+05 37.0 0.1 80 0.5\
#					                 27.0 0.05 0.6 3.0    5.0 0.003 1 $numys
# Dense soil
# nDMaterial PressureDependMultiYield 1 3  2.1 1.300e+05 3.9000e+05 40.0 0.1 80 0.5\
# 					                 27.0 0.03 0.8 5.0    0.0 0.0 0.0 $numys
# Soft clay
# nDMaterial PressureIndependMultiYield 1 3 1.3 1.3e+4 6.5e+04 18.0 0.1
# Medium clay
# nDMaterial PressureIndependMultiYield 1 3 1.5 6e+4 3e+5 37.0 0.1
# Stiff clay
# nDMaterial PressureIndependMultiYield 1 3 1.8 1.5e+5 7.5e+5 75.0 0.1
# U Sand2A: PressureDependMultiYield02
nDMaterial PressureDependMultiYield02  1 3 1.900000e+000 2.495400e+004 5.614600e+004 2.900000e+001 1.000000e-001 1.010000e+002 5.000000e-001\
					                 2.900000e+001 4.500000e-002 1.500000e-001 6.000000e-002  1.500000e-001\
                                20  5.000000e+000 3.000000e+000 1.0 0.0 0.6 0.9 0.02 0.7 101 1.000000e-001

# U Sand2A: PressureDependMultiYield02
nDMaterial PressureDependMultiYield02  2 3 1.900000e+000 3.158300e+004 7.106100e+004 3.400000e+001 1.000000e-001 1.010000e+002 5.000000e-001\
					                 2.900000e+001 4.500000e-002 1.500000e-001 6.000000e-002  1.500000e-001\
                                20  5.000000e+000 3.000000e+000 1.0 0.0 0.6 0.9 0.02 0.7 101 1.000000e-001

# U Sand2A: PressureDependMultiYield02
nDMaterial PressureDependMultiYield02  3 3 1.900000e+000 3.643500e+004 8.197800e+004 3.400000e+001 1.000000e-001 1.010000e+002 5.000000e-001\
					                 2.900000e+001 4.500000e-002 1.500000e-001 6.000000e-002  1.500000e-001\
                                20  5.000000e+000 3.000000e+000 1.0 0.0 0.6 0.9 0.02 0.7 101 1.000000e-001

# U Sand2A: PressureDependMultiYield02
nDMaterial PressureDependMultiYield02  4 3 1.900000e+000 3.214800e+004 7.233300e+004 3.600000e+001 1.000000e-001 1.010000e+002 5.000000e-001\
					                 2.900000e+001 4.500000e-002 1.500000e-001 6.000000e-002  1.500000e-001\
                                20  5.000000e+000 3.000000e+000 1.0 0.0 0.6 0.9 0.02 0.7 101 1.000000e-001

# U Sand2A: PressureDependMultiYield02
nDMaterial PressureDependMultiYield02  5 3 1.900000e+000 4.163400e+004 9.367400e+004 3.500000e+001 1.000000e-001 1.010000e+002 5.000000e-001\
					                 2.900000e+001 4.500000e-002 1.500000e-001 6.000000e-002  1.500000e-001\
                                20  5.000000e+000 3.000000e+000 1.0 0.0 0.6 0.9 0.02 0.7 101 1.000000e-001

# U Sand2A: PressureDependMultiYield02
nDMaterial PressureDependMultiYield02  6 3 1.900000e+000 1.171460e+005 2.635780e+005 2.900000e+001 1.000000e-001 1.010000e+002 5.000000e-001\
					                 2.900000e+001 4.500000e-002 1.500000e-001 6.000000e-002  1.500000e-001\
                                20  5.000000e+000 3.000000e+000 1.0 0.0 0.6 0.9 0.02 0.7 101 1.000000e-001

# U Sand2A: PressureDependMultiYield02
nDMaterial PressureDependMultiYield02  7 3 1.900000e+000 1.500000e+005 3.500000e+005 3.500000e+001 7.000000e-002 1.010000e+002 5.000000e-001\
					                 3.500000e+001 4.500000e-002 1.500000e-001 6.000000e-002  1.500000e-001\
                                20  5.000000e+000 3.000000e+000 1.0 0.0 0.6 0.9 0.02 0.7 101 1.000000e-001

set gravX 0.0
set gravZ [expr -1*9.81]
set gravY 0.0
set press 0.0

set bulk 2200000
set fmass 1

element SSPbrickUP       1      1      2      3      4      5      6      7      8     7 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP       2      5      6      7      8      9     10     11     12     7 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP       3      9     10     11     12     13     14     15     16     7 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP       4     13     14     15     16     17     18     19     20     7 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP       5     17     18     19     20     21     22     23     24     7 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP       6     21     22     23     24     25     26     27     28     7 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP       7     25     26     27     28     29     30     31     32     7 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP       8     29     30     31     32     33     34     35     36     7 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP       9     33     34     35     36     37     38     39     40     7 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      10     37     38     39     40     41     42     43     44     7 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      11     41     42     43     44     45     46     47     48     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      12     45     46     47     48     49     50     51     52     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      13     49     50     51     52     53     54     55     56     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      14     53     54     55     56     57     58     59     60     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      15     57     58     59     60     61     62     63     64     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      16     61     62     63     64     65     66     67     68     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      17     65     66     67     68     69     70     71     72     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      18     69     70     71     72     73     74     75     76     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      19     73     74     75     76     77     78     79     80     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      20     77     78     79     80     81     82     83     84     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      21     81     82     83     84     85     86     87     88     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      22     85     86     87     88     89     90     91     92     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      23     89     90     91     92     93     94     95     96     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      24     93     94     95     96     97     98     99    100     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      25     97     98     99    100    101    102    103    104     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      26    101    102    103    104    105    106    107    108     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      27    105    106    107    108    109    110    111    112     6 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      28    109    110    111    112    113    114    115    116     5 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      29    113    114    115    116    117    118    119    120     5 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      30    117    118    119    120    121    122    123    124     4 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      31    121    122    123    124    125    126    127    128     4 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      32    125    126    127    128    129    130    131    132     4 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      33    129    130    131    132    133    134    135    136     4 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      34    133    134    135    136    137    138    139    140     4 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      35    137    138    139    140    141    142    143    144     3 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      36    141    142    143    144    145    146    147    148     3 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      37    145    146    147    148    149    150    151    152     3 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      38    149    150    151    152    153    154    155    156     3 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      39    153    154    155    156    157    158    159    160     3 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      40    157    158    159    160    161    162    163    164     2 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      41    161    162    163    164    165    166    167    168     2 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      42    165    166    167    168    169    170    171    172     2 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      43    169    170    171    172    173    174    175    176     2 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      44    173    174    175    176    177    178    179    180     1 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      45    177    178    179    180    181    182    183    184     1 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      46    181    182    183    184    185    186    187    188     1 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      47    185    186    187    188    189    190    191    192     1 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      48    189    190    191    192    193    194    195    196     1 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      49    193    194    195    196    197    198    199    200     1 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      50    197    198    199    200    201    202    203    204     1 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      51    201    202    203    204    205    206    207    208     1 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      52    205    206    207    208    209    210    211    212     1 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      53    209    210    211    212    213    214    215    216     1 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ
element SSPbrickUP      54    213    214    215    216    217    218    219    220     1 $bulk $fmass [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] [expr 6.600000e-005/$g/$fmass] 0.7 6.0e-5 $gravX $gravY $gravZ

updateMaterials -material 1 shearModulus [expr 2.495400e+004]
updateMaterials -material 1 bulkModulus [expr 5.614600e+004]
updateMaterials -material 2 shearModulus [expr 3.158300e+004]
updateMaterials -material 2 bulkModulus [expr 7.106100e+004]
updateMaterials -material 3 shearModulus [expr 3.643500e+004]
updateMaterials -material 3 bulkModulus [expr 8.197800e+004]
updateMaterials -material 4 shearModulus [expr 3.214800e+004]
updateMaterials -material 4 bulkModulus [expr 7.233300e+004]
updateMaterials -material 5 shearModulus [expr 4.163400e+004]
updateMaterials -material 5 bulkModulus [expr 9.367400e+004]
updateMaterials -material 6 shearModulus [expr 1.171460e+005]
updateMaterials -material 6 bulkModulus [expr 2.635780e+005]
updateMaterials -material 7 shearModulus [expr 1.500000e+005]
updateMaterials -material 7 bulkModulus [expr 3.500000e+005]

set numnp 220
set SnodeList {}
for {set i 1} {$i <= $numnp} {incr i 1} {
lappend SnodeList [expr $i]
}

set FnodeList {}
for {set i 1} {$i <= $numnp} {incr i 1} {
lappend FnodeList [expr $i]
}

set numel 54
set EnodeList {}
for {set i 1} {$i <= $numel} {incr i 1} {
lappend EnodeList [expr $i]
}


#create trace file for progress bar display
set tracefnameTot "traceTot.txt"
set tracefnameCurr "traceCurr.txt"


########################
# Gravity application  #
########################

# elastic behavior ---------------------------------------------- 1st run
numberer $numberer
eval "constraints $constraints"
eval "system $solver"
eval "test $test"
eval "algorithm $algorithm"
#integrator LoadControl 1 1 1 1
#analysis Static 
integrator Newmark 1.5  1.
analysis Transient 
eval "recorder Node $outfmt ASR1SB2_0.dg0 -time -node $SnodeList -dof 1 2 3 disp"
eval "recorder Node $outfmt ASR1SB2_0.pg0 -time -node $FnodeList -dof 4 vel"
eval "recorder Element $outfmt ASR1SB2_0.s1g0 -element $EnodeList  -time  stress"
eval "recorder Element $outfmt ASR1SB2_0.str1g0 -element $EnodeList  -time  strain"

set fileId [open $tracefnameTot "w"]
puts $fileId "1 5"
close $fileId

set fileId [open $tracefnameCurr "w"]
puts $fileId 0
close $fileId

set ok [analyze 5  5.00e+004]
if {$ok != 0} { return $ok }
puts "First run done.
"

# switch material stage from elastic (gravity) to plastic ------- 2nd run
updateMaterialStage -material 1 -stage $nonlinear
updateMaterialStage -material 2 -stage $nonlinear
updateMaterialStage -material 3 -stage $nonlinear
updateMaterialStage -material 4 -stage $nonlinear
updateMaterialStage -material 5 -stage $nonlinear
updateMaterialStage -material 6 -stage $nonlinear
updateMaterialStage -material 7 -stage $nonlinear

set fileId [open $tracefnameTot "w"]
puts $fileId "2 3"
close $fileId

set fileId [open $tracefnameCurr "w"]
puts $fileId 0
close $fileId

set ok [analyze 3  5.00e+004]
if {$ok != 0} { return $ok }
puts "Second run done.
"



# Flexiable base -- Dashpot

# Remove vertical fixity
# corner nodes
remove sp 1 1
remove sp 1 2
remove sp 1 3
remove sp 2 1
remove sp 2 2
remove sp 2 3
remove sp 3 1
remove sp 3 2
remove sp 3 3
remove sp 4 1
remove sp 4 2
remove sp 4 3
# Tie all the base nodes
equalDOF      1      2     1 2 3
equalDOF      1      3     1 2 3
equalDOF      1      4     1 2 3

model basic -ndm 3 -ndf 3
node    231   0.000000e+000   0.000000e+000  -3.000000e+001
node    232   1.000000e+000   0.000000e+000  -3.000000e+001
node    233   1.000000e+000   1.000000e+000  -3.000000e+001
node    234   0.000000e+000   1.000000e+000  -3.000000e+001
node    235   0.000000e+000   0.000000e+000  -3.000000e+001
node    236   1.000000e+000   0.000000e+000  -3.000000e+001
node    237   1.000000e+000   1.000000e+000  -3.000000e+001
node    238   0.000000e+000   1.000000e+000  -3.000000e+001
# fix base nodes (top level)
fix    235 0 1 1
fix    236 0 1 1
fix    237 0 1 1
fix    238 0 1 1
# fix base nodes
fix    231 1 1 1
fix    232 1 1 1
fix    233 1 1 1
fix    234 1 1 1
equalDOF    235      1 1 2 3
equalDOF    236      2 1 2 3
equalDOF    237      3 1 2 3
equalDOF    238      4 1 2 3
set rockDen 1.800000e+000
set rockVs 4.000000e+002
set rockPoisson 0.4

# Compressive wave (p-wave)
set rockG [expr $rockVs*$rockVs*$rockDen]
set rockM [expr 2*$rockG*(1-$rockPoisson)/(1-2*$rockPoisson)]
set rockVp [expr pow($rockM/$rockDen,0.5)]


# Horizontal
uniaxialMaterial Viscous  2001 [expr 2.500000e-001*$rockDen*$rockVs]  1.
uniaxialMaterial Viscous  2002 [expr 2.500000e-001*$rockDen*$rockVs]  1.
uniaxialMaterial Viscous  2003 [expr 2.500000e-001*$rockDen*$rockVs]  1.
uniaxialMaterial Viscous  2004 [expr 2.500000e-001*$rockDen*$rockVs]  1.
element zeroLength     55    231    235  -mat 2001   -dir 1  
element zeroLength     56    232    236  -mat 2002   -dir 1  
element zeroLength     57    233    237  -mat 2003   -dir 1  
element zeroLength     58    234    238  -mat 2004   -dir 1  
wipeAnalysis

#############################
# Loading (Pushover, or base shaking)(4rd run) # 
#############################

# rezero time
wipeAnalysis
loadConst -time 0.0

model basic -ndm 3 -ndf 3
# load pattern for u-rock 
pattern Plain 300 "Series -fileTime acc_time.txt -filePath vel_value.txt" {
    load    235    [expr 2.500000e-001*$rockDen*$rockVs*1.000000e+000] 0.0 0.0
    load    236    [expr 2.500000e-001*$rockDen*$rockVs*1.000000e+000] 0.0 0.0
    load    237    [expr 2.500000e-001*$rockDen*$rockVs*1.000000e+000] 0.0 0.0
    load    238    [expr 2.500000e-001*$rockDen*$rockVs*1.000000e+000] 0.0 0.0
}

# output responses
remove recorders
eval "recorder Node $outfmt ASR1SB2_0.tim -time  -node 1 -dof 1 disp"
eval "recorder Node $outfmt ASR1SB2_0.dsp -time  -node $SnodeList -dof 1 2 3 disp"
eval "recorder Node $outfmt ASR1SB2_0.pwp -time  -node $FnodeList -dof 4 vel"
eval "recorder Node $outfmt ASR1SB2_0.acc -time  -node $SnodeList -dof 1 2 3 accel"
eval "recorder Element $outfmt ASR1SB2_0.sts1 -ele $EnodeList  -time   stress"
eval "recorder Element $outfmt ASR1SB2_0.str1 -ele $EnodeList  -time   strain"

# analysis options
numberer $numberer
eval "constraints $constraints"
eval "system $solver2"
eval "test $test"
eval "algorithm $algorithm"
#integrator LoadControl 1 1 1 1
#analysis Static
rayleigh $am 0.0 $ak 0.0
integrator Newmark $gamma  [expr pow($gamma+0.5, 2)/4]
analysis VariableTransient 

set fileId [open $tracefnameTot "w"]
puts $fileId "3 150"
close $fileId

set fileId [open $tracefnameCurr "w"]
puts $fileId "0"
close $fileId

# domain decomposition if not done yet (parallel run and NP > 1)
partition 0

set ok [analyze $numSteps $compdT [expr $compdT/100] $compdT  15]
if {$ok != 0} { return $ok }

if { $parallel == 0 } {
    set endT [clock seconds]
    set ElapsedTime [expr $endT-$startT]
    set ElapsedHours [expr int($ElapsedTime/3600.)]
    set ElapsedMins [expr int($ElapsedTime/60.-$ElapsedHours*60.)]
    set ElapsedSecs [expr int($ElapsedTime-$ElapsedHours*3600-$ElapsedMins*60.)]
    puts "
Analysis finished at: [clock format [clock seconds]]"
    puts "Execution time: $ElapsedHours hours and $ElapsedMins minutes and $ElapsedSecs seconds."
}
wipe; #need wipe to finish writing buffer to files
