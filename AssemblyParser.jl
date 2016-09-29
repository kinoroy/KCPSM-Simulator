#= This is the assembly language parser
Created by: Kino Roy for CMPT 276, Assignment 1. =#
module AssemblyParser

include("ALU_functions.jl")

import .functions

function Parse()

#=-----------------------------------------
Initializing data structures for holding data
------------------------------------------=#
instructions = Array{AbstractString}(2048,4)
labelDict = Dict() #Creates the dictionary for labels

fill!(instructions, "")
#=-----------------------------
BEGIN FILE READING
------------------------------=#

inStream = open("instructions.txt") #Open the input file and set the input stream
lines = readlines(inStream) # Create an array with each element, an instruction

counter = 1 #Start the counter

for l in lines #Stepping through the lines
  if(l[1] == ";") #Allows starting the file with comment only lines
    continue
  end
  l = split(l,r";")[1] #eliminate the comments (garbage)
  #Determines type of arguments in the line

  splitLine = split(l,r":| |,",keep=false) #Filters text

#---- Begin Parsing ----#

  #CASE: "INST"
  if size(splitLine)[1] == 1

    instructions[counter,2] = chomp(splitLine[1])

  #CASE: "LABEL + INST"
  elseif size(splitLine)[1] == 2 && contains(l,":")
    instructions[counter,1] = splitLine[1]
    instructions[counter,2] = chomp(splitLine[2])
      #ADDS LABEL TO DICTIONARY
      labelDict["$(splitLine[1])"] = counter


  #CASE: "INST + OP1"
  elseif size(splitLine)[1] == 2
    instructions[counter,2] = splitLine[1]
    instructions[counter,3] = chomp(splitLine[2])
      #ADDS LABEL TO DICTIONARY
      labelDict["$(splitLine[1])"] = counter

  #CASE: "LABEL + INST + OP1"
  elseif size(splitLine)[1] == 3 && contains(l,":")
    instructions[counter,1] = splitLine[1]
    instructions[counter,2] = splitLine[2]
    instructions[counter,3] = chomp(splitLine[3])
      #ADDS LABEL TO DICTIONARY
      labelDict["$(splitLine[1])"] = counter

  #CASE: "INST + OP1 + OP2"
  elseif size(splitLine)[1] == 3 && contains(l,",")
    instructions[counter,2] = splitLine[1]
    instructions[counter,3] = splitLine[2]
    instructions[counter,4] = chomp(splitLine[3])

  #CASE: "LABEL + INST + OP1 + OP2"
  elseif size(splitLine)[1] == 4
  instructions[counter,1] = splitLine[1]
  instructions[counter,2] = splitLine[2]
  instructions[counter,3] = splitLine[3]
  instructions[counter,4] = chomp(splitLine[4])
    #ADDS LABEL TO DICTIONARY
    labelDict["$(splitLine[1])"] = counter
  end

   counter += 1
end
close(inStream)
#=-----------
 END READING
 -----------=#

return instructions,labelDict
end
end
export Parse
#=------------
END ASSEMBLY PARSER
-------------=#
