#= This is the assembly language parser
Created by: Kino Roy for CMPT 276, Assignment 1. =#
module AssemblyParser #Module declaration temp patches warning bug: later to delete
#= Begin Function Decs=#
#=---------------------------------------
ALU FUNCTIONS ARE LOCATED IN FUNCTIONS.JL
----------------------------------------=#

include("functions.jl")

import .functions

function input(sX)
  nIn = parse(UInt8,readline(STDIN)) #Reads in a number from 0 to 255

end


function output()
println("Variable goes here") #debug print
end
function outputk()
end


jumped = false


function jump(label)
global jumped = true #sets the jump boolean variable
label = chomp(label)
  PC_current = PC
  PC_new = labelDict["$(label)"] #Change the program counter to point to label
  if PC_new == PC_current
    #=println("jumping $(numJumps)") TEST PRINT /DEBUG PRINT =#
    global numJumps = numJumps+1

  end
  global PC = PC_new
end

function thisCall()
end

function thisReturn()
end

#=-------------------------------------
 END FUNCTION DECLARATION
 ------------------------------------=#
 #=-------------------------------------
  BEGIN ASSEMBLY PARSER
  ------------------------------------=#
#=-----------------------------------------
Initializing data structures for holding data
------------------------------------------=#
instructions = Array{AbstractString}(2047,4)
labelDict = Dict() #Creates the dictionary for labels

instructionsOneArgDict = Dict("SL0" => functions.sl0, "SL1" => functions.sl1, "SLX" => functions.slx, "SLA" => functions.sla
, "RL" => functions.rl, "SR0" => functions.sr0, "SR1" => functions.sr1, "SRX" => functions.srx, "SRA" => functions.sra, "RR" => functions.rr, "JUMP" => jump
, "CALL" => thisCall, "STORE" => functions.store, "FETCH" => functions.fetch, "INPUT" => input, "OUTPUT" => output
, "RETURN" => thisReturn, "REGBANK" => functions.regbank) #Creates dictionary of functions w/ one arguments

instructionsTwoArgDict = Dict("LOAD" => functions.load,"STAR" => functions.star,"AND" => functions.and,"OR" => functions.or,"XOR" => functions.xor,
"ADD" => functions.add,"ADDCY" => functions.addcy,"SUB" => functions.sub,"SUBCY" => functions.subcy,"TEST" => functions.test,"TESTCY" => functions.testcy,
"COMPARE" => functions.compare,"INPUT" => input,"OUTPUT" => output,"OUTPUTK" => outputk,"STORE" => functions.store,
"FETCH" => functions.fetch,"JUMP" => jump,"CALL" => thisCall) #Creates dictionary of functions w/ two arguments

PC = 1
numJumps = 0


fill!(instructions,"")
#=-----------------------------
BEGIN FILE READING
------------------------------=#
println("on")
inStream = open("instructions.txt") #Open the input file and set the input stream
lines = readlines(inStream) # Create an array with each element, an instruction

counter = 1 #Start the counter

for l in lines #Stepping through the lines
    l = split(l,r";")[1] #elimnate the comments (garbage)
    #Determines type of arguments in the line


  splitLine = split(l,r":| |,",keep=false) #Filters text

#---- Begin Parsing ----#

  #CASE: "INST"
  if size(splitLine)[1] == 1

    instructions[counter,2] = splitLine[1]

  #CASE: "LABEL + INST"
  elseif size(splitLine)[1] == 2 && contains(l,":")
    instructions[counter,1] = splitLine[1]
    instructions[counter,2] = splitLine[2]
      #ADDS LABEL TO DICTIONARY
      labelDict["$(splitLine[1])"] = counter


  #CASE: "INST + OP1"
  elseif size(splitLine)[1] == 2
    instructions[counter,2] = splitLine[1]
    instructions[counter,3] = splitLine[2]
      #ADDS LABEL TO DICTIONARY
      labelDict["$(splitLine[1])"] = counter

  #CASE: "LABEL + INST + OP1"
  elseif size(splitLine)[1] == 3 && contains(l,":")
    instructions[counter,1] = splitLine[1]
    instructions[counter,2] = splitLine[2]
    instructions[counter,3] = splitLine[3]
      #ADDS LABEL TO DICTIONARY
      labelDict["$(splitLine[1])"] = counter

  #CASE: "INST + OP1 + OP2"
  elseif size(splitLine)[1] == 3 && contains(l,",")
    instructions[counter,2] = splitLine[1]
    instructions[counter,3] = splitLine[2]
    instructions[counter,4] = splitLine[3]

  #CASE: "LABEL + INST + OP1 + OP2"
  elseif size(splitLine)[1] == 4
  instructions[counter,1] = splitLine[1]
  instructions[counter,2] = splitLine[2]
  instructions[counter,3] = splitLine[3]
  instructions[counter,4] = splitLine[4]
    #ADDS LABEL TO DICTIONARY
    labelDict["$(splitLine[1])"] = counter
  end

   counter += 1
end
close(inStream)
#=-----------
 END READING
 -----------=#

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
#=------------
END ASSEMBLY PARSER
-------------=#
