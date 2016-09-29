module Flags
export Z, C, get,set


global Z = false
global C = false

global flags = Dict("Z" => Z, "C" => C)

function get(flagToSet)
  return flags[flagToSet]
end

function set(flagToSet, bool)

  flags[flagToSet] = bool
  #println("setting $(flagToSet) is now $(flags[flagToSet])")
end

end
