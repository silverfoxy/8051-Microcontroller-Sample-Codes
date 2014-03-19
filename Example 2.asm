;The 8051 microcontroller in this example is connected to a 7447 BCD to 7 segment decoder
;A button is connected to P1.0 and when it's pressed the 7 segment that is connected to
;P2.0-3 should count from 0 to 9 incrementing it's value by one every second
;The counter should stop counting when the button is released.
;It also should count back from zero after reaching 9.


org 0x0000
jmp main
org 0x0003
jmp EXT0ISR
org 0x000B
jmp T0ISR
;***Button down(p3.2 = 0) Button up(p3.2 = 1)***
;When the button is pressed a 0 signal will be present at p3.2
;the ISR runs and starts the timer, everytime the timer ISR runs it checks the button state
;if the button is no more pressed down and 1 is present at p3.2 the timer stops counting
;the next time that you press the button ex0 isr runs and starts counting from the number it left off
;after every second the number gets incremented
;main does the initialization and sets interrupts
;EXT0ISR does the main function of the program
;it moves lower 4bits of the number to p2 ports to be shown on 7seg
main:;We do the initialization here
setb ea;enable all the ints
mov tmod, #0x11;set t0 to 16bit mode
mov ie, #0x81;enable ex0
mov r0, #0x0;r0 will be shown on 7seg
setb it0;enable interrupt on falling edge
WAIT:
jmp $;wait for an interrupt to happen.

EXT0ISR:
mov a, r0;getting lower 4bits of r0 and moving them to p2
rrc a
mov p2.0, c
rrc a
mov p2.1, c
rrc a
mov p2.2, c
rrc a
mov p2.3, c
mov r7, #20;running t0 20 times to get 1sec delay
setb et0;enable t0 int
setb tf0;run t0 isr
reti
T0ISR:
clr tr0;stop t0
djnz r7, SKIP;if not 20th time, skip the rest
clr et0;if 20th time disable t0
inc r0;inc the number that will be shown on 7seg
cjne r0, #0x0A, EXT0ISR;if the number is not 10(0x0A) we just go on
jmp ADJ_R0;if the number reaches 10 we set it back to 0
SKIP:
jb p3.2, EXIT;if that button is not pressed anymore, go to exit
mov th0, #high(-50000);set the timer to count 50000 micro secs
mov tl0, #low(-50000)
setb et0;enable t0 int
setb tr0;run t0
reti
EXIT:
clr et0;disable t0 int
clr tr0;stop t0
reti
ADJ_R0:
mov r0, #0;if r0 is 10(0x0A), set it back to 0
jmp EXT0ISR