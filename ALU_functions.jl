#=-------------------------
BEGIN FUNCTION DECLARATION
(!!EXTRNL CODE FOR EXECUTING ALL INSTRUCTIONS GOES HERE!!)
--------------------------=#

module functions

include("Regbank.jl")
include("Flags.jl")
include("Scratchpad.jl")

import .regbankA
import .regbankB
import .Flags
import .Scratchpad

regbanks = Dict("A" => regbankA.registers, "B" => regbankB.registers)
set = Dict("A" => regbankA.set,"B" => regbankB.set)
global currentRegbank = "A"

function load(sX, sY)
  secondOpRegister = false

  if (haskey(regbanks[currentRegbank],sY))
    secondOpRegister = true
  end

  if secondOpRegister #Value from sX moves into sY
    set[currentRegbank](sX, regbanks[currentRegbank][sY])
  else #CONSTANT into sX
    set[currentRegbank](sX, parse(UInt8, sY))
  end
end

#=FLAGS ARE NOT AFFECTED BY THIS FUNCTION=#
function star(sX, sY)
  secondOpRegister = false
  if (haskey(regbanks[currentRegbank],sY)) #Checks if the 2nd arg is a known register
    secondOpRegister = true
  end

  #Value from REGISTER in the active bank (sY) moves into register in the non active bank (sX)
  if (currentRegbank == "A") & secondOpRegister
    set["B"](sX, regbanks[currentRegbank][sY])
  elseif secondOpRegister
    set["A"](sX, regbanks[currentRegbank][sY])
  end
  #Value from CONSTANT moves into register in the non active bank (sX)
  if (currentRegbank == "A") & !secondOpRegister
    set["B"](sX, parse(UInt8, sY)) #sY is a constant here
  elseif !secondOpRegister
    set["A"](sX, parse(UInt8, sY)) #sY is a constant here
  end

end

function and(sX, sY)
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

  Flags.set("C",false)

  #println("Z is now $(Flags.get("Z")) and C is now $(Flags.get("C"))")
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
    overflow = (regbanks[currentRegbank][sX] + regbanks[currentRegbank][sY]) > 0xFF
    set[currentRegbank](sX, UInt8(regbanks[currentRegbank][sX]) + UInt8(regbanks[currentRegbank][sY]) )
  else
    overflow = (regbanks[currentRegbank][sX] + parse(UInt8,sY)) > 0xFF
    set[currentRegbank](sX, UInt8(regbanks[currentRegbank][sX]) + UInt8(parse(UInt8,sY)) )
  end

  if regbanks[currentRegbank][sX] == 0
    Flags.set("Z", true)
  end

  if overflow
    Flags.set("C", true)
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

  if Flags.get("Z")
    zPrior = true
  end

  secondOpRegister = false

  if (haskey(regbanks[currentRegbank],sY))
    secondOpRegister = true
  end

  if secondOpRegister
    overflow = (regbanks[currentRegbank][sX] + regbanks[currentRegbank][sY] + C) > 0xff
    set[currentRegbank](sX, UInt8(regbanks[currentRegbank][sX]) + UInt8(regbanks[currentRegbank][sY]) + UInt8(C))
  else
    overflow = (regbanks[currentRegbank][sX] + parse(UInt8,sY) + C) > 0xff
    set[currentRegbank](sX, UInt8(regbanks[currentRegbank][sX]) + UInt8(parse(UInt8,sY)) + UInt8(C))
  end

  #The zero flag (Z) will be set if the 8-bit result returned 
  #to ‘sX’ is zero and the zero flag was set prior to the ADDCY instruction
  if (regbanks[currentRegbank][sX] == 0) && (zPrior == true)
    Flags.set("Z",true)
  end
  if overflow
    Flags.set("C", true)
  end
end

function sub(sX, sY)
  secondOpRegister = false

  if (haskey(regbanks[currentRegbank],sY))
    secondOpRegister = true
  end

  if secondOpRegister
    underflow = (regbanks[currentRegbank][sY] > regbanks[currentRegbank][sX]) #underflow
    set[currentRegbank](sX, UInt8(regbanks[currentRegbank][sX]) - UInt8(regbanks[currentRegbank][sY]) )
  else
    underflow = (parse(UInt8,sY) > regbanks[currentRegbank][sX]) #underflow
    set[currentRegbank](sX, UInt8(regbanks[currentRegbank][sX]) - UInt8(parse(UInt8,sY)) )
  end

  #flags
  if regbanks[currentRegbank][sX] == 0
    Flags.set("Z", true)
  end

  if underflow
    Flags.set("C", true)
  end
end

function subcy(sX, sY)
  C = 0 # Local variable C, not to be confused with C the global flag

  if Flags.get("C")
    C = 1
  end

  if Flags.get("Z")
    zPrior = true
  end

  secondOpRegister = false

  if (haskey(regbanks[currentRegbank],sY))
    secondOpRegister = true
  end

  if secondOpRegister
    underflow = ((regbanks[currentRegbank][sY] + C) > regbanks[currentRegbank][sX] ) #underflow
    set[currentRegbank](sX, UInt8(regbanks[currentRegbank][sX]) - UInt8(regbanks[currentRegbank][sY]) - UInt8(C) )
  else
    underflow = ((parse(UInt8,sY) + C) > regbanks[currentRegbank][sX]) #underflow
    set[currentRegbank](sX, UInt8(regbanks[currentRegbank][sX]) - UInt8(parse(UInt8,sY)) - UInt8(C) )
  end

  #flags
  #The zero flag (Z) will be set if the 8-bit result returned to ‘sX’ is zero and the zero flag was set prior to the SUBCY instruction.
  if (regbanks[currentRegbank][sX] == 0) && (zPrior == true)
    Flags.set("Z", true)
  end
  if underflow
    Flags.set("C", true)
  end
end

function test(sX, sY)
  # Test does not modify registers

  secondOpRegister = false

  if (haskey(regbanks[currentRegbank],sY))
    secondOpRegister = true
  end

  if secondOpRegister
    tempRes = regbanks[currentRegbank][sX] && regbanks[currentRegbank][sY]
  else
    tempRes = regbanks[currentRegbank][sX] && parse(UInt8,sY)
  end

  testString = bin(tempRes,8)
  numberOf1s = length(split(tempString,"1")) - 1
  oddNum1s = isodd(numberOf1s)

  # Flags
  if tempRes == 0 #The zero flag (Z) will be set if all 8-bits of the temporary result are zero.
    Flags.set("Z", true)
  end
  if oddNum1s == true #The carry flag (C) will be set if the temporary result contains an odd number of bits set to ‘1’
    Flags.set("C", true)
  end
end

function testcy(sX, sY)
  #Test does not modify registers

  secondOpRegister = false

  if (haskey(regbanks[currentRegbank],sY))
    secondOpRegister = true
  end

  if secondOpRegister
    tempRes = regbanks[currentRegbank][sX] && regbanks[currentRegbank][sY]
  else
    tempRes = regbanks[currentRegbank][sX] && parse(UInt8,sY)
  end

  testString = bin(tempRes,8)
  numberOf1s = length(split(tempString,"1")) - 1
  oddNum1s = isodd(numberOf1s)

  #flags
  if tempRes == 0 #The zero flag (Z) will be set if all 8-bits of the temporary result are zero and the zero flag was set prior to the TESTCY instruction.
    Flags.set("Z", true)
  end
  if oddNum1s == true #The carry flag (C) will be set if the temporary result contains an odd number of bits set to ‘1’
    Flags.set("C", true)
  end
end

# Compare does not modify registers
function compare(sX, sY)
  secondOpRegister = false

  if (haskey(regbanks[currentRegbank],sY))
    secondOpRegister = true
  end

  if secondOpRegister
   if regbanks[currentRegbank][sX] > regbanks[currentRegbank][sY]
     Flags.set("C", false)
     Flags.set("Z", false)
   elseif regbanks[currentRegbank][sX] < regbanks[currentRegbank][sY]
     Flags.set("Z", false)
     Flags.set("C", true)
   else
     Flags.set("Z", true)
     Flags.set("C", false)
   end
  else
    if regbanks[currentRegbank][sX] > parse(UInt8,sY)
      Flags.set("C", false)
      Flags.set("Z", false)
    elseif regbanks[currentRegbank][sX] < parse(UInt8,sY)
      Flags.set("Z", false)
      Flags.set("C", true)
    else #Equal
      Flags.set("Z", true)
      Flags.set("C", false)
    end
  end
end

function comparecy(sX, sY)
  C = 0
  #Compare does not modify registers
  if Flags.get("C")
    C = 1 #local variable C, not to be confused with global Flag C
  end

  secondOpRegister = false

  if (haskey(regbanks[currentRegbank],sY))
    secondOpRegister = true
  end

  if secondOpRegister
   if regbanks[currentRegbank][sX]-C > regbanks[currentRegbank][sY]
     Flags.set("C", false)
     Flags.set("Z", false)
   elseif regbanks[currentRegbank][sX]-C < regbanks[currentRegbank][sY]
     Flags.set("Z", false)
     Flags.set("C", true)
   elseif Flags.get("Z")
     Flags.set("Z", true)
     Flags.set("C", false)
   end
  else
    if regbanks[currentRegbank][sX]-C > parse(UInt8,sY)
      Flags.set("C", false)
      Flags.set("Z", false)
    elseif regbanks[currentRegbank][sX]-C < parse(UInt8,sY)
      Flags.set("Z", false)
      Flags.set("C", true)
    elseif Flags.get("Z") #Equal
      Flags.set("Z", true)
      Flags.set("C", false)
    end
  end
end

function sl0(sX)
  B = bin(regbanks[currentRegbank][sX],8)
  C = parse(Int,B[1]) #Local variable C gets MSB
  B = B[2:length(B)] #Drops MSB
  B = "$(B)0" #Adds 0 to LSB
  B = "0b$B" #Parse B as bin string
  D = parse(UInt8,B)
  set[currentRegbank](sX, D) #Sets sX after sl0

  #flags
  if C == 1
    Flags.set("C",true)
  else
    Flags.set("C",false)
  end

  if regbanks[currentRegbank][sX] == 0
    Flags.set("Z",true)
  else
    Flags.set("Z",false)
  end
end

function sl1(sX)
  B = bin(regbanks[currentRegbank][sX],8)
  C = parse(Int,B[1]) #Local variable C gets MSB
  B = B[2:length(B)] #Drops MSB
  B = "$(B)1" #Adds 1 to LSB
  B = "0b$B" #Parse B as bin string
  D = parse(UInt8,B)
  set[currentRegbank](sX, D) #Sets sX after sl1

  if C == 1
    Flags.set("C",true)
  else
    Flags.set("C",false)
  end
  Flags.set("Z",false) #Z flag is always reset by this instruction
end

function slx(sX)
  B = bin(regbanks[currentRegbank][sX],8)
  C = parse(Int,B[1]) #Local variable C gets MSB
  LSB = B[length(B)] #Keep the LSB
  B = B[2:length(B)] #Drops MSB
  B = "$(B)$(LSB)" #replicates LSB
  B = "0b$B" #Parse B as bin string
  D = parse(UInt8,B)
  set[currentRegbank](sX, D) #Sets sX after slx

  if C == 1
    Flags.set("C",true)
  else
    Flags.set("C",false)
  end

  if regbanks[currentRegbank][sX] == 0
    Flags.set("Z",true)
  else
    Flags.set("Z",false)
  end
end

function sla(sX)
  C_old = 0

  if Flags.get("C")
    C_old = 1
  end

  B = bin(regbanks[currentRegbank][sX],8)
  C = parse(Int,B[1]) #Local variable C gets MSB
  B = B[2:length(B)] #Drops MSB
  B = "$(B)$(C_old)" #Adds C_old to LSB
  B = "0b$B" #Parse B as bin string
  D = parse(UInt8,B)
  set[currentRegbank](sX, D) #Sets sX after sl0

  if C == 1
    Flags.set("C",true)
  else
    Flags.set("C",false)
  end

  if regbanks[currentRegbank][sX] == 0
    Flags.set("Z",true)
  else
    Flags.set("Z",false)
  end
end

function rl(sX)
  B = bin(regbanks[currentRegbank][sX],8)
  C = parse(Int,B[1]) #Local variable C gets MSB
  B = B[2:length(B)] #Drops MSB
  B = "$(B)$(C)" #replicates MSB into LSB
  B = "0b$B" #Parse B as bin string
  D = parse(UInt8,B)
  set[currentRegbank](sX, D) #Sets sX after slx

  if C == 1
    Flags.set("C",true)
  else
    Flags.set("C",false)
  end

  if regbanks[currentRegbank][sX] == 0
    Flags.set("Z",true)
  else
    Flags.set("Z",false)
  end
end

function sr0(sX)
  B = bin(regbanks[currentRegbank][sX],8)
  C = parse(Int,B[length(B)]) #Local variable C gets MSB
  B = B[1:length(B)-1] #Drops LSB
  B = "0$(B)" #Adds 0 to MSB
  B = "0b$B" #Parse B as bin string
  D = parse(UInt8,B)
  set[currentRegbank](sX, D) #Sets sX after sl0

  if C == 1
    Flags.set("C",true)
  else
    Flags.set("C",false)
  end

  if regbanks[currentRegbank][sX] == 0
    Flags.set("Z",true)
  else
    Flags.set("Z",false)
  end
end

function sr1(sX)
  local C

  B = bin(regbanks[currentRegbank][sX],8)
  C = parse(Int,B[length(B)]) #Local variable C gets LSB
  B = B[1:length(B)-1] #Drops LSB
  B = "1$(B)" #Adds 1 to MSB
  B = "0b$B" #Parse B as bin string
  D = parse(UInt8,B)
  set[currentRegbank](sX, D) #Sets sX after sl0

  if C == 1
    Flags.set("C",true)
  else
    Flags.set("C",false)
  end

  if regbanks[currentRegbank][sX] == 0
    Flags.set("Z",true)
  else
    Flags.set("Z",false)
  end
end

function srx(sX)
  local C

  B = bin(regbanks[currentRegbank][sX],8)
  C = parse(Int,B[length(B)]) #Local variable C gets LSB
  MSB = B[1] #Keep the MSB
  B = B[1:length(B)-1] #Drops LSB
  B = "$(MSB)$(B)" #replicates LSB
  B = "0b$B" #Parse B as bin string
  D = parse(UInt8,B)
  set[currentRegbank](sX, D) #Sets sX after slx

  if  C == 1
    Flags.set("C",true)
  else
    Flags.set("C",false)
  end

  if regbanks[currentRegbank][sX] == 0
    Flags.set("Z",true)
  else
    Flags.set("Z",false)
  end
end

function sra(sX)
  local C_old = 0

  if Flags.get("C")
    C_old = 1
  end

  B = bin(regbanks[currentRegbank][sX],8)
  C = parse(Int,B[length(B)]) #Local variable C gets LSB
  B = B[1:length(B)-1] #Drops LSB
  B = "$(C_old)$(B)" #Adds Old carry to MSB
  B = "0b$B" #Parse B as bin string
  D = parse(UInt8,B)
  set[currentRegbank](sX, D) #Sets sX after sl0

  if C == 1
    Flags.set("C",true)
  else
    Flags.set("C",false)
  end

  if regbanks[currentRegbank][sX] == 0
    Flags.set("Z",true)
  else
    Flags.set("Z",false)
  end
end

function rr(sX)
  B = bin(regbanks[currentRegbank][sX],8)
  C = parse(Int,B[length(B)]) #Local variable C gets LSB
  B = B[1:length(B)-1] #Drops LSB
  B = "$(C)$(B)" #replicates LSB into MSB
  B = "0b$B" #Parse B as bin string
  D = parse(UInt8,B)
  set[currentRegbank](sX, D) #Sets sX after slx

  if C == 1
    Flags.set("C", true)
  else
    Flags.set("C", false)
  end

  if regbanks[currentRegbank][sX] == 0
    Flags.set("Z", true)
  else
    Flags.set("Z", false)
  end
end

function regbank(newRegBank::AbstractString)
  global currentRegbank = newRegBank
end

function hwbuild(sX)
  Flags.set("C", true)
  Flags.set("Z", true)
  set[currentRegbank](sX, 0) #HWBUILD generic value = 0
end

function store(sX, ss)
  # Store does not affect registers or flag values
  if (haskey(regbanks[currentRegbank],ss))
    secondOpRegister = true
  end

  if secondOpRegister
    Scratchpad.store(regbanks[currentRegbank][sX], regbanks[currentRegbank][sY])
  else
    Scratchpad.store(regbanks[currentRegbank][sX], parse(Int,ss))
  end
end

function fetch(sX,ss)
  #fetch does not set flag values
  set[currentRegbank](sX, sratchpad.fetch(ss))
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

export hwbuild

end
