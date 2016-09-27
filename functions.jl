#=-------------------------
BEGIN FUNCTION DECLARATION
(!!EXTRNL CODE FOR EXECUTING ALL INSTRUCTIONS GOES HERE!!)
--------------------------=#

module functions

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
function add(sX, sY)
println("adding s1,s2") #Debug print
end
function addcy(sX, sY)
end
function sub(sX, sY)
println("subbing") #Debug print
end
function subcy(sX, sY)
end
function test(sX, sY)
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
function regbank(A::String)
end
function store(k)
end
function fetch(k)
end
#= EXPORT ------- =#
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
