LOAD s0, 01
LOAD s1, 01
LOAD s2, 01
loop: ADD s0, 01
ADDCY s1, 00
ADDCY s2, 00
JUMP NC, loop
OUTPUT s0, 00
death: JUMP death
