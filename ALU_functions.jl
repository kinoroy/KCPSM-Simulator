#=-------------------------
BEGIN FUNCTION DECLARATION
(!!EXTRNL CODE FOR EXECUTING ALL INSTRUCTIONS GOES HERE!!)
--------------------------=#

module functions

include("Regbank.jl")
import .regbankA
import .regbankB

regbanks = Dict("A" => regbankA.registers, "B" => regbankB.registers)
set = Dict("A" => regbankA.set,"B" => regbankB.set)
currentRegbank = "A"

function load(sX, sY)
end

function star(sX, sY)
end

function and(sX, sY)
 println("anding") #Debug/test print
end

function or(sX, sY)
end
function xor(sX, sY)
end

function add(sX, sY) # EXAMPLE ON HOW TO USE THE REGISTERS IN REGBANK MODULE
#  println("adding $(regbanks[currentRegbank][sX])+$(regbanks[currentRegbank][sY])") #Debug/test print
  set[currentRegbank](sX, regbanks[currentRegbank][sX]+regbanks[currentRegbank][sY]) #Adds register sX and sY and stores into sX
#  println("now the val is: $(regbanks[currentRegbank][sX])") #Test/Debug print
end

function get(sK) #NOT AN ALU FUNCTION!
  return regbanks[currentRegbank][sK]
end

function addcy(sX, sY)
end
function sub(sX, sY)
  println("subbing") #Debug/test print
end
function subcy(sX, sY)
end
function test(sX, sY)
  print("test")
end
function testcy(sX, sY)
end
function compare(sX, sY)
end
function comparecy(sX, sY)
end
function sl0(sX)
end
function sl1(sX)
end
function slx(sX)
end
function sla(sX)
end
function rl(sX)

end
function sr0(sX)
end
function sr1(sX)
end
function srx(sX)
end
function sra(sX)
end
function rr(sX)
end
function regbank(new_RegBank::String)
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
