module regbankA
s0 = 0
registers = Dict("s0" => s0)

function get(registerToGet)
  valueOfRegister = registers[registerToGet]
  return valueOfRegister
end

end

module regbankB
end
