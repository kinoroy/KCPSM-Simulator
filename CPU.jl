#=--------------------------------------
This is the CPU Simululator....
IF YOU NEED TO EDIT ALU FUNCTIONS ONLY USE: "functions.jl".
Functions which are not operations on registers or constants (like jump, return)
are located here. 
----------------------------------------=#

module CPU
println("on")
include("AssemblyParser.jl")
include("functions.jl")
import .AssemblyParser
import .functions
#=--------
GLOBAL VARS
-------=#
PC = 1
numJumps = 0
jumped = false
labelDict = Dict()
#=--------
END GLOBAL VARS
---------=#
#=-----------
FUNCTION DECS
-----------=#

function jump(label)
jumped = true #sets the jump boolean variable
label = chomp(label)
  PC_current = PC
  PC_new = labelDict["$(label)"] #Change the program counter to point to label
  if PC_new == PC_current
    #=println("jumping $(numJumps)") TEST PRINT /DEBUG PRINT =#
    global numJumps+=1
  end
  global PC= PC_new
end

function thisCall()
end

function thisReturn()
end

function input(sX)
  nIn = parse(UInt8,readline(STDIN)) #Reads in a number from 0 to 255
end

function output()
println("Variable goes here") #debug print
end
function outputk()
end

instructionsOneArgDict = Dict("SL0" => functions.sl0, "SL1" => functions.sl1, "SLX" => functions.slx, "SLA" => functions.sla
, "RL" => functions.rl, "SR0" => functions.sr0, "SR1" => functions.sr1, "SRX" => functions.srx, "SRA" => functions.sra, "RR" => functions.rr, "JUMP" => jump
, "CALL" => thisCall, "STORE" => functions.store, "FETCH" => functions.fetch, "INPUT" => input, "OUTPUT" => output
, "RETURN" => thisReturn, "REGBANK" => functions.regbank) #Creates dictionary of functions w/ one arguments

instructionsTwoArgDict = Dict("LOAD" => functions.load,"STAR" => functions.star,"AND" => functions.and,"OR" => functions.or,"XOR" => functions.xor,
"ADD" => functions.add,"ADDCY" => functions.addcy,"SUB" => functions.sub,"SUBCY" => functions.subcy,"TEST" => functions.test,"TESTCY" => functions.testcy,
"COMPARE" => functions.compare,"INPUT" => input,"OUTPUT" => output,"OUTPUTK" => outputk,"STORE" => functions.store,
"FETCH" => functions.fetch,"JUMP" => jump,"CALL" => thisCall) #Creates dictionary of functions w/ two arguments
#=---------------
END FUNCTION DECS
-------------------=#

#=---------------
BEGIN READING
---------------=#
(instructions,labelDict) = AssemblyParser.Parse()
#=-----------
END READING
-------------=#
#=-----------
BEGIN EXECUTE
------------=#

while PC<= size(instructions)[1] && numJumps<10 #iterate through all instructions

  currentInst = instructions[PC,2]

  if isempty(currentInst) #Checks if there are no more instructions to execute
    break
  end

  firstArg = instructions[PC,3]
  secondArg = instructions[PC,4]

  hasArg1 = false;
  hasArg2 = false;

  if !isempty(firstArg) #Checks if 1st argument exists
    hasArg1 = true
  end
  if !isempty(secondArg) #Checks if 2nd argument exists
    hasArg2 = true

  end

  if hasArg1 == false && hasArg2 == false #No arguments
    println("Calling return")
  elseif hasArg1 == true && hasArg2 == false #1 argument
    instructionsOneArgDict["$(currentInst)"](firstArg)
  elseif hasArg1 == true && hasArg2 == true #2 arguments
    instructionsTwoArgDict["$(currentInst)"](firstArg,secondArg)
  end

if !jumped PC+=1 end #increment program counter
jumped = false
end
#=------------
END EXECUTE
-------------=#

println("off")
end
