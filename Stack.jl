module Stack

s = zeros(Int64, 30)
depth = 0

function reset()
  global depth = 0
  global s = zeros(s)
end

function push(addr)
  global depth

  if depth + 1 > 30
    throw( OverflowError() )
  end

  depth = depth + 1

  s[depth] = addr
end

function pop()
  global depth

  if depth - 1 < 0
    throw( OverflowError() )
  end

  addr = s[depth]
  depth = depth - 1

  return addr
end

end
