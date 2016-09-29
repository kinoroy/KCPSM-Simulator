#=---------
REGBANK A
----------=#
module regbankA
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
registers = Dict("S0" => s0,"S1" => s1,"S2" => s2,"S3" => s3,"S4" => s4,"S5" => s5,"S6" => s6,
"S7" => s7,"S8" => s8,"S9" => s9,"SA" => sA,"SB" => sB,"SC" => sC,"SD" => sD,"SE" => sE,"SF" => sF)
#=----------------------------------=#
#=----Getters and setters allow access to registers from other modules----=#
function get(sX)
return registers[sX]
end

function set(sX,value)
  registers[sX] = value
end

end

#=--------------
REGBANK B
---------------=#
module regbankB #Registers in bank A
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
registers = Dict("S0" => s0,"S1" => s1,"S2" => s2,"S3" => s3,"S4" => s4,"S5" => s5,"S6" => s6,
"S7" => s7,"S8" => s8,"S9" => s9,"SA" => sA,"SB" => sB,"SC" => sC,"SD" => sD,"SE" => sE,"SF" => sF)
#=----------------------------------=#

function get(sX)
  return registers[sX]
end

function set(sX,value)
  registers[sX] = value
end

end
