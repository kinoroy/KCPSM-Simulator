module Scratchpad

sp = zeros(UInt8, 256)

function store(sX, ss) #Should store value sX, into ss. #Both sX, and ss are passed as integer value
    sp[(0xff & ss) + 1] = sX
end

function fetch(ss) #Should return the value at address ss #ss is passed by value
    return sp[ss + 1]
end

end
