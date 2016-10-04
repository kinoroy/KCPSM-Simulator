#=--------------------------------------
This is the CPU Simululator....RUN THIS FILE
IF YOU NEED TO EDIT ALU FUNCTIONS ONLY USE: "functions.jl".
Functions which are not operations on registers or constants (like jump, return)
are located here.
----------------------------------------=#

module CPU

include("AssemblyParser.jl")
include("ALU_functions.jl")
include("Stack.jl")

import .AssemblyParser
import .functions
import .Stack

#=-----------------------------------------
CPU ON - Innitialize power state
------------------------------------------=#
println("on") #Test/Debug print
called = false
PC = 1 #"zero" the program counter (counting starts at 1 in Julia)
 #The zero flag is initialized to false by Flags.jl
 #The carry flag is initialized to false by Flags.jl
functions.regbank("A") #Register bank ‘A’ is selected and therefore ‘A’ is the default bank of registers.

#= ------------------------
RESET FUNCTION DECLARATION
----------------------------=#
function reset()
  global PC
  global numJumps
  global jumped
  PC = 1
  numJumps = 0
  jumped = false

  functions.Flags.set("C", false)
  functions.Flags.set("Z", false)
  functions.regbank("A")

  Stack.reset()
end

reset() #= pointer in the program counter stack is reset to ensure that the program is able to execute programs
in which up to 30 nested subroutine calls can be made.=#

#= ------------------------
GLOBAL VARIABLE DECLARATION
----------------------------=#
global numJumps = 0 #The number of recursive jump calls to the same address
global jumped = false #Is true if "jump" is the last instruction executed
labelDict = Dict() #Dictionary which, maps labels to their address in the program memory

#=-----------------------------------------------
FUNCTION DECLARATION:
(ALU functions are located in ALU_functions.jl)
------------------------------------------------=#

function jump(label)
  global jumped
  jumped = true #The last instruction was a jump instruction
  label = chomp(label) #Cleans up garbage
  PC_current = PC
  PC_new = labelDict["$(label)"] #Change the program counter to point to label
  if PC_new == PC_current
    global numJumps+=1 #The last instruction jumped to itself
  end
  global PC = PC_new #Change the program coutner to jump to label
end

function jump(inCondition, label)
  global jumped
  conditions = Dict("Z" => functions.getFlag("Z"), "NZ" => !functions.getFlag("Z")
  , "C" => functions.getFlag("C"), "NC" => !functions.getFlag("C"))

  if conditions[inCondition]
    jumped = true #The last instruction was a jump instruction
    label = chomp(label) #Cleans up garbage
    PC_current = PC
    PC_new = labelDict["$(label)"] #Change the program counter to point to label
    global PC = PC_new #Change the program coutner to jump to label
  else
    #Do nothing, the CPU will increment the PC
  end
end

function jumpAt(sX, sY)
  global jumped
  global PC
  newAddr = ((UInt8(functions.get(sX)) & (0x0F)) * (0x100)) + UInt8(functions.get(sY)) #New address is lower 4 bits of sX:sY
  jumped = true #The last instruction was a jump instruction
  PC_current = PC
#  println("The address is:$(newAddr)")
  PC_new = newAddr #Change the program counter to point to new address
  if PC_new == PC_current
    global numJumps+=1 #The last instruction jumped to itself
  end
  global PC = PC_new #Change the program coutner to jump to label
end

function thisCall(k)
  try
    global PC
    global jumped
    jumped = true
    Stack.push(PC)
    PC = k
  catch # If the Stack overflows then reset
    reset()
  end
end

function thisCall(flag, k)
  addr = labelDict["$k"]
  if flag == "Z" && functions.getFlag("Z")
    thisCall(addr)
  elseif flag == "NZ" && ! functions.getFlag("Z")
    thisCall(addr)
  elseif flag == "C" && functions.getFlag("C")
    thisCall(addr)
  elseif flag == "NC" && ! functions.getFlag("C")
    thisCall(addr)
  end
end

function thisCallAt(sX, sY)
  a = convert(UInt16, sX)
  b = convert(UInt16, sY)

  # take the lower 4 bits of a
  a = a & 0xF
  # take the lower 8 bits of b
  b = b & 0xFF
  # shift a left by 8 bits
  a = a << 8

  addr = a | b

  thisCall(Int64(addr))
end

function thisReturn()
  try
    global jumped = true
    global PC = Stack.pop()
  catch
    reset()
  end
end

function thisReturn(flag)
  if flag == "Z" && functions.getFlag("Z")
    thisReturn()
  elseif flag == "NZ" && ! functions.getFlag("Z")
    thisReturn()
  elseif flag == "C" && functions.getFlag("C")
    thisReturn()
  elseif flag == "NC" && ! functions.getFlag("C")
    thisReturn()
  end
end

function input(sX)
  nIn = parse(UInt8,readline(STDIN)) #Reads in a number from 0 to 255 to write to the target register
  functions.setReg(sX,nIn)
end

function output(sK,pp)
  secondOpRegister = (pp[1] == '(')

  if secondOpRegister
    portNumber = functions.get(pp[2:length(pp)-1])
  else
    portNumber = parse(Int,pp)
  end

  value_of_sK = functions.get(sK)
  println("$(hex(portNumber,2)) $(hex(value_of_sK,2))") #Prints output of the format "portNumber registerValue"
end

function outputk(kk,p)
  portNumber = parse(Int,p)
  value = parse(Int,kk)
  println("$(hex(portNumber,2)) $(hex(value,2))") #Prints output of the format "portNumber Value"
end

#=-------------------------------------------------------------------
These dictionaries map instruction codeword syntax to Julia functions
of ALU_functions.jl and CPU.jl
(This is a co-req of parsing the assembly code)
--------------------------------------------------------------------=#
instructionsOneArgDict = Dict("SL0" => functions.sl0, "SL1" => functions.sl1, "SLX" => functions.slx, "SLA" => functions.sla
, "RL" => functions.rl, "SR0" => functions.sr0, "SR1" => functions.sr1, "SRX" => functions.srx, "SRA" => functions.sra, "RR" => functions.rr, "JUMP" => jump
, "CALL" => thisCall, "STORE" => functions.store, "FETCH" => functions.fetch, "INPUT" => input
, "RETURN" => thisReturn, "REGBANK" => functions.regbank, "HWBUILD" => functions.hwbuild) #Creates dictionary of functions w/ one arguments

instructionsTwoArgDict = Dict("LOAD" => functions.load,"STAR" => functions.star,"AND" => functions.and,"OR" => functions.or,"XOR" => functions.xor,
"ADD" => functions.add,"ADDCY" => functions.addcy,"SUB" => functions.sub,"SUBCY" => functions.subcy,"TEST" => functions.test,"TESTCY" => functions.testcy,
"COMPARE" => functions.compare,"INPUT" => input,"OUTPUT" => output,"OUTPUTK" => outputk,"STORE" => functions.store,
"FETCH" => functions.fetch,"JUMP" => jump, "JUMP@" => jumpAt, "CALL" => thisCall, "CALL@" => thisCallAt) #Creates dictionary of functions w/ two arguments

#=------------------------------------------
BEGIN READING THE INPUT FILE OF INSTRUCTIONS
--------------------------------------------=#
#Runs the parser and returns a list of instructions
#for the program memory and a dictionary containing
#all labels and their locations in the program memory
(instructions,labelDict) = AssemblyParser.Parse() #Note that this is the function Parse from "AssemblyParser.jl", NOT the built in Julia function "parse()"

#=----------------------------------------
BEGIN EXECUTION OF PARSED ADDEMBLY CODE
-----------------------------------------=#

  while PC <= size(instructions)[1] && numJumps<10 #Checks whether the Program Counter has reached the end of the program memory or the program has jumped to the same label 10 times
    currentInst = instructions[PC,2] #Gets the next instruction from the program memory

    # Is this redundant?
    if isempty(currentInst) #Checks if there are no more instructions to execute
      break #End execution immediately
    end

    firstArg = instructions[PC,3] #Gets the first argument of the current instruction(might be empty string)
    secondArg = instructions[PC,4] #Gets the second argument of the current instruction(might be empty string)

    hasArg1 = !isempty(firstArg) #Fails on first argument being empty
    hasArg2 = !isempty(secondArg) #Fails on the second argument being empty

    if hasArg1 == false && hasArg2 == false #1st and 2nd arguments are empty
      thisReturn() #Return is the only function which can be called with no arguments
    elseif hasArg1 == true && hasArg2 == false #1st argument is non empty, 2nd is empty
      instructionsOneArgDict["$(currentInst)"](firstArg) #Call the function with one argument
    elseif hasArg1 == true && hasArg2 == true #1st argument is non empty, 2nd arument is non empty
      instructionsTwoArgDict["$(currentInst)"](firstArg,secondArg) #Call the function with two arguments
    end

    if !jumped
      PC+=1
    end #Increment the program counter if the last instruction executed is not a jump

    jumped = false #"Jump" was not the last instruction
  end
  #=------------------------------
  END EXECUTION OF ASSEMBLY CODE
  ------------------------------=#
  #=------------
  CPU OFF
  ------------=#

  println("off") #Test/Debug print

end
