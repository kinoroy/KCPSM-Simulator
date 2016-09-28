module regbankA #Registers in bank A
#=----------------------------
Initialize registers to zero
-----------------------------=#
s0 = 0
s1 = 0
s2 = 0
s3 = 0
s4 = 0
s5 = 0
s6 = 0
s7 = 0
s8 = 0
s9 = 0
sA = 0
sB = 0
sC = 0
sD = 0
sE = 0
sF = 0

#=-------------------------------------
Text parsing stuff (you can ignore :])
--------------------------------------=#
registers = Dict("s0" => s0,"s1" => s1,"s2" => s2,"s3" => s3,"s4" => s4,"s5" => s5,"s6" => s6,
"s7" => s7,"s8" => s8,"s9" => s9,"sA" => sA,"sB" => sB,"sC" => sC,"sD" => sD,"sE" => sE,"sF" => sF,)
#=----------------------------------=#

end

module regbankB #Registers in bank B
#=----------------------------
Initialize registers to zero
-----------------------------=#
s0 = 0
s1 = 0
s2 = 0
s3 = 0
s4 = 0
s5 = 0
s6 = 0
s7 = 0
s8 = 0
s9 = 0
sA = 0
sB = 0
sC = 0
sD = 0
sE = 0
sF = 0

#=-------------------------------------
Text parsing stuff (you can ignore :])
--------------------------------------=#
registers = Dict("s0" => s0,"s1" => s1,"s2" => s2,"s3" => s3,"s4" => s4,"s5" => s5,"s6" => s6,
"s7" => s7,"s8" => s8,"s9" => s9,"sA" => sA,"sB" => sB,"sC" => sC,"sD" => sD,"sE" => sE,"sF" => sF)
#=----------------------------------=#


end
