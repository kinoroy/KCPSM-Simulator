module Stack

s = zeros(Int64, 30)
depth = 0

function reset()
  global depth = 0
  global s
  zeros(s)
end

function push(addr)
  if depth + 1 > 30
    throw( OverflowError() )
  end

  global depth = depth + 1

  s[depth] = addr
end

function pop()
    global depth
    addr = s[depth]
    depth = depth - 1
    return addr
end

end
