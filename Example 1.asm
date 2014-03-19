;Write a program that reads two unsigned 8 bits integers from p0 and p1
;multiplies them together and adds the 16 bit result to previous values
;outputs the 16 bit result on port 2 and 3, the whole calculation is repeated
;everytime a value on input port changes.
;If the multiplication result overflows the 16 bits the process stops.


mov p0, #0xFF ;Set p0 and p1 as input ports
mov p1, #0xFF
mov r0, p0
mov r1, p1
mov r2, #0
mov r3, #0
loop:
mov a, r0
mov b, p0
cjne a, b, rzero_changed ;check if p0 or p1 changed
mov a, r1
mov b, p1
cjne a, b, rone_changed
jmp loop
rzero_changed:
rone_changed:
mov r0, p0
mov r1, p1
mov a, r0
mov b, r1
mul ab
add a, r2
mov r2, a
mov a, b
addc a, r3
mov r3, a
jb cy, exit
mov p2, r2
mov p3, r3
jmp loop
exit:
mov p2, #0
mov p3, #0
end
