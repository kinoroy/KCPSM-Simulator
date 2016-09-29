#=-------------------------
BEGIN FUNCTION DECLARATION
(!!EXTRNL CODE FOR EXECUTING ALL INSTRUCTIONS GOES HERE!!)
--------------------------=#

module functions

include("Regbank.jl")
include("Flags.jl")
import .regbankA
import .regbankB
import .Flags

regbanks = Dict("A" => regbankA.registers, "B" => regbankB.registers)
set = Dict("A" => regbankA.set,"B" => regbankB.set)
global currentRegbank = "A"

function load(sX, sY)

  secondOpRegister = false

  if (haskey(regbanks[currentRegbank],sY))
  	secondOpRegister = true
  end

  if secondOpRegister

  else

  end


#flags




end

function star(sX, sY)

  secondOpRegister = false
  if (haskey(regbanks[currentRegbank],sY)) #Checks if the 2nd arg is a known register
  	secondOpRegister = true
  end

#Value from REGISTER in the active bank (sY) moves into register in the non active bank (sX)
  if currentRegbank == "A" & !secondOpRegister
    set["B"](sX, regbanks[currentRegbank][sY])
  elseif !secondOpRegister
    set["A"](sX, regbanks[currentRegbank][sY])
  end
#Value from CONSTANT moves into register in the non active bank (sX)
  if currentRegbank == "A" & secondOpRegister
    set["B"](sX, parse(UInt8,readline(sY)))
  elseif secondOpRegister
    set["A"](sX, parse(UInt8,readline(sY)))
  end

  #flags

    #=FLAGS ARE NOT AFFECTED BY THIS FUNCTION=#


end

function and(sX, sY)
 println("anding") #Debug/test print

 secondOpRegister = false

 if (haskey(regbanks[currentRegbank],sY))
 	secondOpRegister = true
 end

 if secondOpRegister
   set[currentRegbank](sX, regbanks[currentRegbank][sX] & regbanks[currentRegbank][sY] )
 else
   set[currentRegbank](sX, regbanks[currentRegbank][sX] & parse(UInt8, sY) )
 end


 if regbanks[currentRegbank][sX] == 0
   Flags.set("Z",true)
end

#Flags

Flags.set("C",false)
println("Z is now $(Flags.get("Z")) and C is now $(Flags.get("C"))")
end

function or(sX, sY)

secondOpRegister = false

if (haskey(regbanks[currentRegbank],sY))
	secondOpRegister = true
end

if secondOpRegister
  set[currentRegbank](sX, regbanks[currentRegbank][sX] | regbanks[currentRegbank][sY] )
else
    set[currentRegbank](sX, regbanks[currentRegbank][sX] | parse(UInt8,sY) )
end


  #Flags
  if regbanks[currentRegbank][sX] == 0
	Flags.set("Z", true)
  end
Flags.set("C", false)
end


function xor(sX, sY)

  secondOpRegister = false

  if (haskey(regbanks[currentRegbank],sY))
  	secondOpRegister = true
  end

  if secondOpRegister
    set[currentRegbank](sX, regbanks[currentRegbank][sX] $ regbanks[currentRegbank][sY] )
  else
      set[currentRegbank](sX, regbanks[currentRegbank][sX] $ parse(UInt8,sY) )
  end

  #Flags
  if regbanks[currentRegbank][sX] == 0
	Flags.set("Z", true)
end
Flags.set("C", false)
end


function add(sX, sY) # EXAMPLE ON HOW TO USE THE REGISTERS IN REGBANK MODULE

secondOpRegister = false

if (haskey(regbanks[currentRegbank],sY))
	secondOpRegister = true
end

if secondOpRegister
  set[currentRegbank](sX, regbanks[currentRegbank][sX] + regbanks[currentRegbank][sY] )
else
    set[currentRegbank](sX, regbanks[currentRegbank][sX] + parse(UInt8,sY) )
end

#flags
  if regbanks[currentRegbank][sX] > 255
	Flags.set("Z", true)
	end


end

function get(sK) #NOT AN ALU FUNCTION! DONT EDIT
  return regbanks[currentRegbank][sK]
end

function setReg(sX, value) #NOT AN ALU FUNCTION! DONT EDIT
  set[currentRegbank](sX, value)
end

function addcy(sX, sY)
  C = 0  #Local variable C, not to be confused with global flag C
  if Flags.get("C")
    C = 1
  end
  secondOpRegister = false

  if (haskey(regbanks[currentRegbank],sY))
  	secondOpRegister = true
  end

  if secondOpRegister
    set[currentRegbank](sX, regbanks[currentRegbank][sX] + regbanks[currentRegbank][sY] + C)
  else
      set[currentRegbank](sX, regbanks[currentRegbank][sX] + parse(UInt8,sY) + C)
  end

  #flags




end
function sub(sX, sY)

  secondOpRegister = false

  if (haskey(regbanks[currentRegbank],sY))
  	secondOpRegister = true
  end

  if secondOpRegister
    set[currentRegbank](sX, regbanks[currentRegbank][sX] - regbanks[currentRegbank][sY] )
  else
      set[currentRegbank](sX, regbanks[currentRegbank][sX] - parse(UInt8,sY) )
  end

  #flags




end
function subcy(sX, sY)
  C = 0 #Local variable C, not to be confused with C the global flag
  if Flags.get("C")
    C = 1
  end

  secondOpRegister = false

  if (haskey(regbanks[currentRegbank],sY))
  	secondOpRegister = true
  end

  if secondOpRegister
    set[currentRegbank](sX, regbanks[currentRegbank][sX] - regbanks[currentRegbank][sY] -C )
  else
      set[currentRegbank](sX, regbanks[currentRegbank][sX] - parse(UInt8,sY) - C)
  end

  #flags




end
function test(sX, sY)
  print("test")



  #flags




end
function testcy(sX, sY)



  #flags




end
function compare(sX, sY)



  #flags




end
function comparecy(sX, sY)



  #flags




end
function sl0(sX)



  #flags




end
function sl1(sX)



  #flags




end
function slx(sX)



  #flags




end
function sla(sX)



  #flags




end
function rl(sX)



  #flags





end
function sr0(sX)



  #flags




end
function sr1(sX)



  #flags




end
function srx(sX)



  #flags




end
function sra(sX)



  #flags




end
function rr(sX)



  #flags




end
function regbank(new_RegBank::AbstractString)
  global currentRegbank
  currentRegbank = new_RegBank
  println("Regbank is now: $(currentRegbank)")
end
function store(k) #This function interacts with the scratch pad - hold off on writing until SP complete
end
function fetch(k) #This function interacts with the scratch pad - hold off on writing until SP complete
end

function getFlag(flag)
  return Flags.get(flag)
end

#=---------------------
END FUNCTION DECLARATIONS
--------------------- =#

#=-------------------------
DONT EDIT BELOW THIS LINE
-------------------------=#
export setReg

export load


export star


export and



export or

export xor

export add


export addcy

export sub


export subcy

export test

export testcy

export compare

export comparecy

export sl0

export sl1

export slx

export sla

export rl


export sr0

export sr1

export srx

export sra

export rr

export regbank

export store

export fetch

end
