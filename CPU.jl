#=--------------------------------------
This is the CPU Simululator....
IF YOU NEED TO EDIT ALU FUNCTIONS ONLY USE: "functions.jl".
Functions which are not operations on registers or constants (like jump, return)
are located here.
----------------------------------------=#

module CPU

include("AssemblyParser.jl")
include("ALU_functions.jl")
include("Stack.jl")
#include("Regbank.jl")
import .AssemblyParser
import .functions
import .Stack
#import .regbankA
#import .regbankB

#=-----------------------------------------
CPU ON - Innitialize power state
------------------------------------------=#
println("on") #Test/Debug print

PC = 1 #"zero" the program counter (counting starts at 1 in Julia)
Z = false #The zero flag is initialized to false
C = false #The carry flag is initialized to flase
functions.regbank("A") #Register bank ‘A’ is selected and therefore ‘A’ is the default bank of registers.

Stack.reset() #= pointer in the program counter stack is reset to ensure that the program is able to execute programs
in which up to 30 nested subroutine calls can be made.=#

#= ------------------------
GLOBAL VARIABLE DECLARATION
----------------------------=#
numJumps = 0 #The number of recursive jump calls to the same address
jumped = false #Is true if "jump" is the last instruction executed
labelDict = Dict() #Dictionary which, maps labels to their address in the program memory

#=-----------------------------------------------
FUNCTION DECLATATION:
(ALU functions are located in ALU_functions.jl)
------------------------------------------------=#

function jump(label)
  jumped = true #The last instruction was a jump instruction
  label = chomp(label) #
  PC_current = PC
  PC_new = labelDict["$(label)"] #Change the program counter to point to label
  if PC_new == PC_current
    global numJumps+=1 #The last instruction jumped to itself
  end
  global PC = PC_new #Change the program coutner to jump to label
end

function thisCall()
  Stack.push(PC_current)
end

function thisReturn()
  Stack.pop()
end

function input(sX)
  nIn = parse(UInt8,readline(STDIN)) #Reads in a number from 0 to 255 to write to the target register
  #functions.set(sX,nIn)
end

function output(sK,pp)
  portNumber = parse(Int,pp)
  value_of_sK = functions.get(sK)
  println("$(hex(portNumber,2)) $(hex(value_of_sK,2))") #Prints output of the format "portNumber registerValue"
end

function outputk(kk,p)
  portNumber = parse(Int,p)
  value = kk
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
, "RETURN" => thisReturn, "REGBANK" => functions.regbank) #Creates dictionary of functions w/ one arguments

instructionsTwoArgDict = Dict("LOAD" => functions.load,"STAR" => functions.star,"AND" => functions.and,"OR" => functions.or,"XOR" => functions.xor,
"ADD" => functions.add,"ADDCY" => functions.addcy,"SUB" => functions.sub,"SUBCY" => functions.subcy,"TEST" => functions.test,"TESTCY" => functions.testcy,
"COMPARE" => functions.compare,"INPUT" => input,"OUTPUT" => output,"OUTPUTK" => outputk,"STORE" => functions.store,
"FETCH" => functions.fetch,"JUMP" => jump,"CALL" => thisCall) #Creates dictionary of functions w/ two arguments

#=------------------------------------------
BEGIN READING THE INPUT FILE OF INSTRUCTIONS
--------------------------------------------=#
#Runs the parser and returns a list of instructions 
#for the program memory and a dictionary containing 
#all labels and their locations in the program memory
(instructions,labelDict) = AssemblyParser.Parse()

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
      instructionsOneArgDict["$(currentInst)"](firstArg) #Call the fucntion with one argument
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
