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
currentRegbank = "A"

function load(sX, sY)



#flags




end

function star(sX, sY)



  #flags




end

function and(sX, sY)
 println("anding") #Debug/test print
 set[currentRegbank](sX, regbanks[currentRegbank][sX] & regbanks[currentRegbank][sY] )

 if regbanks[currentRegbank][sX] == 0
   Flags.set("Z",true)
end
Flags.set("C",false)
println("Z is now $(Flags.get("Z")) and C is now $(Flags.get("C"))")
end

function or(sX, sY)

  set[currentRegbank](sX, regbanks[currentRegbank][sX] | regbanks[currentRegbank][sY] )

secondOpRegister = false

if(haskey(regbanks[currentRegbank],sY))
	secondOpRegister = true
end




  #Flags
  if regbanks[currentRegbank][sX] == 0
	Flags.set("Z", true)
  end
Flags.set("C", false)
end


function xor(sX, sY)


  #Flags
  if regbanks[currentRegbank][sX] == 0
	Flags.set("Z", true)
end
Flags.set("C", false)
end


function add(sX, sY) # EXAMPLE ON HOW TO USE THE REGISTERS IN REGBANK MODULE
#  println("adding $(regbanks[currentRegbank][sX])+$(regbanks[currentRegbank][sY])") #Debug/test print
  set[currentRegbank](sX, regbanks[currentRegbank][sX]+regbanks[currentRegbank][sY]) #Adds register sX and sY and stores into sX
#  println("now the val is: $(regbanks[currentRegbank][sX])") #Test/Debug print


#flags
  if regbanks[currentRegbank][sX] > 255
	Flags.set("Z", true)
	end

#

end

function get(sK) #NOT AN ALU FUNCTION!
  return regbanks[currentRegbank][sK]
end

#=function set(sK, value)
  set[currentRegbank](sX, value)
end=#

function addcy(sX, sY)



  #flags




end
function sub(sX, sY)
  println("subbing") #Debug/test print



  #flags




end
function subcy(sX, sY)



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
  println("changing RegBank to:$(new_RegBank)") #Test/Debug print
  currentRegbank = new_RegBank
end
function store(k)
end
function fetch(k)
end


#=---------------------
END FUNCTION DECLARATIONS
--------------------- =#

#=-------------------------
DONT EDIT BELOW THIS LINE
-------------------------=#
export set

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
