	.data

board:			.string	"|---------------------------------------------|", 0x0D,0x0A
bline1:			.string "|*********************************************|", 0x0D,0x0A
bline2:			.string "|*****     *****     *****     *****     *****|", 0x0D,0x0A
bline3:			.string "|                                             |", 0x0D,0x0A
bline4:			.string "|                                             |", 0x0D,0x0A
bline5:			.string "|                                             |", 0x0D,0x0A
bline6:			.string "|                                             |", 0x0D,0x0A
bline7:			.string "|.............................................|", 0x0D,0x0A
bline8:			.string "|                                             |", 0x0D,0x0A
bline9:			.string "|                                             |", 0x0D,0x0A
bline10:		.string "|                                             |", 0x0D,0x0A
bline11:		.string "|                                             |", 0x0D,0x0A
bline12:		.string "|                                             |", 0x0D,0x0A
bline13:		.string "|                                             |", 0x0D,0x0A
bline14:		.string "|.............................................|", 0x0D,0x0A
bborderB:		.string	"|---------------------------------------------|", 0

emptyboard:		.string	"|---------------------------------------------|", 0x0D,0x0A
ebline1:		.string "|*********************************************|", 0x0D,0x0A
ebline2:		.string "|*****     *****     *****     *****     *****|", 0x0D,0x0A
ebline3:		.string "|                                             |", 0x0D,0x0A
ebline4:		.string "|                                             |", 0x0D,0x0A
ebline5:		.string "|                                             |", 0x0D,0x0A
ebline6:		.string "|                                             |", 0x0D,0x0A
ebline7:		.string "|.............................................|", 0x0D,0x0A
ebline8:		.string "|                                             |", 0x0D,0x0A
ebline9:		.string "|                                             |", 0x0D,0x0A
ebline10:		.string "|                                             |", 0x0D,0x0A
ebline11:		.string "|                                             |", 0x0D,0x0A
ebline12:		.string "|                                             |", 0x0D,0x0A
ebline13:		.string "|                                             |", 0x0D,0x0A
ebline14:		.string "|.............................................|", 0x0D,0x0A
ebborderB:		.string	"|---------------------------------------------|", 0

end_message:	.string 27, "[31;1m"
end_0:			.string " ██████╗  █████╗ ███╗   ███╗███████╗     ██████╗ ██╗   ██╗███████╗██████╗ " , 0x0D,0x0A
end_1:			.string "██╔════╝ ██╔══██╗████╗ ████║██╔════╝    ██╔═══██╗██║   ██║██╔════╝██╔══██╗" , 0x0D,0x0A
end_2:			.string "██║  ███╗███████║██╔████╔██║█████╗      ██║   ██║██║   ██║█████╗  ██████╔╝" , 0x0D,0x0A
end_3:			.string "██║   ██║██╔══██║██║╚██╔╝██║██╔══╝      ██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗" , 0x0D,0x0A
end_4:			.string "╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗    ╚██████╔╝ ╚████╔╝ ███████╗██║  ██║" , 0x0D,0x0A
end_5:			.string "╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝     ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝" , 0x0D,0x0A
end_6:			.string 27,"[37;0m"
end_7:			.string	"                         PRESS SPACE TO PLAY AGAIN!", 0
pause_screen:	.string	27,"[32;1m"
pause1:			.string	" ██████╗  █████╗ ███╗   ███╗███████╗    ██████╗  █████╗ ██╗   ██╗███████╗███████╗██████╗" , 0x0D,0x0A
pause2:			.string	"██╔════╝ ██╔══██╗████╗ ████║██╔════╝    ██╔══██╗██╔══██╗██║   ██║██╔════╝██╔════╝██╔══██╗" , 0x0D,0x0A
pause3:			.string	"██║  ███╗███████║██╔████╔██║█████╗      ██████╔╝███████║██║   ██║███████╗█████╗  ██║  ██║" , 0x0D,0x0A
pause4:			.string	"██║   ██║██╔══██║██║╚██╔╝██║██╔══╝      ██╔═══╝ ██╔══██║██║   ██║╚════██║██╔══╝  ██║  ██║" , 0x0D,0x0A
pause5:			.string	"╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗    ██║     ██║  ██║╚██████╔╝███████║███████╗██████╔╝" , 0x0D,0x0A
pause6:			.string	" ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚═════╝" , 0x0D,0x0A
pause7:			.string 27,"[37;0m"
pause8:			.string	"                 PRESS SPACE OR A KEY ON THE KEYPAD TO RESUME PLAYING",0

score_string:	.string "XXXXXX", 0
lives_string:	.string "X", 0
time_string:	.string	"XX", 0
level_string:	.string	"XX", 0

	.text
	.global lab7
	.global uart_init
	.global timer0_init
	.global Uart0Handler
	.global Timer0Handler
	.global output_string
	.global output_line
	.global output_character
	.global dec_to_ascii
	.global draw_board
	.global move_entities
	.global char_handler
	.global board_add_entities
	.global clear_board
	.global end_game
	.global check_collisions
	.global playing
	.global itoa
	.global itoa_pad
	.global board
	.global score
	.global lives
	.global levelTime
	.global level
	.global levelTicks
	.global div_and_mod
	.global levelSeconds
	.global isHalfTick
	.global getTimeSeconds
	.global sysTime
	.global text_red
	.global clear_screen
	.global hide_cursor
	.global white
	.global home_cursor
	.global welcome_screen
	.global ready_screen
	.global pause_screen
	.global Timer1Handler
	.global generate_entities
	.global illuminate_RGB_LED
	.global PortAHandler
	.global timer0_stop
	.global started

UART0: 			.field 	0x4000C000, 32
TIMER0:			.field	0x40030000,	32	; base address of Timer0
TIMER1:			.field	0x40031000,	32	; base address of Timer1
PORTA:			.field 	0x40004000, 32  ; GPIO Port A Base Address
BUTTON_DELAY:	.field	800000,	32
GPIOICR:		.equ	0x41C
clear_screen:	.string 27, "[2J", 0		; escape sequence to clear screen
home_cursor:	.string 27, "[1;1H", 0		; escape sequence to move cursor to top left of terminal
board_row:		.string	27, "[1;1H", 0
show_cursor:	.string 27, "[?25h", 0
hide_cursor:	.string 27, "[?25l", 0
score_cursor:	.string 27, "[17;1H", 0
lives_cursor:	.string 27, "[17;14H", 0
time_cursor:	.string 27, "[17;24H", 0
level_cursor:	.string 27, "[17;34H", 0
score_end_cur:	.string 27, "[7;33H", 0
play_cur:		.string 27, "[8;24H", 0
text_red:		.string 27, "[31;1m", 0
text_white:		.string 27, "[37;1m", 0
score_label:	.string "SCORE: ", 0
lives_label:	.string "LIVES: ", 0
time_label:		.string	"TIME: ", 0
level_label:	.string "LEVEL: ", 0

escape:			.string	27,"[",0
white: 			.string 27,"[37;0m",0;
green:			.string 27,"[32;1m",0
brown:			.string 27,"[38;2;139;069;019m",0

score_value:	.field 0, 32
sys_time:		.field 0, 32
level_time:		.field 240, 32
timer_interval:	.field 8000000, 32

welcome_screen:	.string	"", 0x0D,0x0A
w1:				.string	"		Welcome to Peter and Komas's Final Project!", 0x0D,0x0A
w2:				.string	"", 0x0D,0x0A
w3:				.string	"This is an implementation of the class videogame frogger in which the user", 0x0D,0x0A
w4:				.string	"controls a frog trying to cross a dangerous road and river to return home.", 0x0D,0x0A
w5:				.string	"In order to win this game you must successfully navigate two frogs across", 0x0D,0x0A
w6:				.string	"the road, across the river, and into an unoccupied home space before time", 0x0D,0x0A
w7:				.string	"runs out. But be careful! Getting hit by a car, truck, standing on an", 0x0D,0x0A
w8:				.string	"alligator's mouth or falling in the water will all result in you death!", 0x0D,0x0A
w9:				.string	"Four death's or running out of time on the clock will cause you to loose", 0x0D,0x0A
w10:			.string	"the game. Your current number of lives is displayed on the screen and on", 0x0D,0x0A
w11:			.string	"board's LEDs. You the frog can move twice as fast as the objects around you.", 0x0D,0x0A
w12:			.string	"Once two frogs make it home the game will proceed to a new level and things", 0x0D,0x0A
w13:			.string	"will get faster. If at any point you need a break, just press 'ESC' or any", 0x0D,0x0A
w14:			.string	"key on the keypad to pause the game. Remember that when you get two frogs", 0x0D,0x0A
w14a:			.string "home the game will move to a new level. This clears your homed frogs, rests", 0x0D,0x0A
w14b:			.string	"the timer to a new shorter time, and makes things move faster. Watch out!", 0x0D,0x0A
w24c:			.string "When the game is over, you can always play again by pressing 'SPACE'", 0x0D,0x0A
w15:			.string	"", 0x0D,0x0A
w16:			.string	"Instructions:", 0x0D,0x0A
w17:			.string	" - The frog is moved using the WASD keys, W=UP, S=DOWN, D=RIGHT, A=LEFT", 0x0D,0x0A
w18:			.string	" - Press 'ESC' or a key on the keypad to pause the game", 0x0D,0x0A
w19:			.string	" - When ready press 'SPACE' to start playing!", 0

;	RGB LED CODES
;	0 = OFF
;	1 = RED
;	2 = BLUE
;	3 = PURPLE
;	4 = GREEN
;	5 = YELLOW
;	6 = CYAN
;	7 = WHITE
; ASCII fonts http://patorjk.com/software/taag/ "ANSI Shadow"

clear_board: ; AAPCS Compliant - Register Invariant
;==============================Start Clear Board=========================================
	STMFD SP!, {r0-r2}
	MOVW r0, emptyboard			; load address of empty board
	MOVT r0, emptyboard
	MOVW r1, board				; load address of current game board
	MOVT r1, board
clear_loop:
	LDRB r2, [r0], #1			; load next character of game board and increment address
	CMP r2, #0					; if the character is null, we've reached the end of the string
	BEQ clear_exit				; exit loop
	STRB r2, [r1], #1			; otherwise overwrite board with emptyboard and increment address
	B clear_loop
clear_exit:
	LDMFD SP!, {r0-r2}
	MOV PC, LR
;===============================End Clear Board==========================================

draw_score:
;========================================================================================
	STMFD SP!, {r0-r11, LR}
	MOVW r4, score_cursor
	MOVT r4, score_cursor
	BL output_string
	MOVW r4, score_label
	MOVT r4, score_label
	BL output_string
	MOVW r0, score
	MOVT r0, score
	LDR r0, [r0]
	MOVW r1, score_string
	MOVT r1, score_string
	MOV r2, #5
	BL itoa_pad
	MOVW r4, score_string
	MOVT r4, score_string
	BL output_string
	LDMFD SP!, {r0-r11, LR}
	MOV PC, LR
;========================================================================================

draw_lives:
;========================================================================================
	STMFD SP!, {r0-r11, LR}
	MOVW r4, lives_cursor
	MOVT r4, lives_cursor
	BL output_string
	MOVW r4, lives_label
	MOVT r4, lives_label
	BL output_string
	MOVW r0, lives
	MOVT r0, lives
	LDRB r0, [r0]
	MOVW r1, lives_string
	MOVT r1, lives_string
	BL itoa
	MOVW r4, lives_string
	MOVT r4, lives_string
	BL output_string
	LDMFD SP!, {r0-r11, LR}
	MOV PC, LR
;========================================================================================

draw_time:
;========================================================================================
	STMFD SP!, {r0-r11, LR}
	MOVW r4, time_cursor
	MOVT r4, time_cursor
	BL output_string
	MOVW r4, time_label
	MOVT r4, time_label
	BL output_string
	BL getTimeSeconds
	MOVW r1, time_string
	MOVT r1, time_string
	MOV r2, #2
	BL itoa_pad
	MOVW r4, time_string
	MOVT r4, time_string
	BL output_string
	LDMFD SP!, {r0-r11, LR}
	MOV PC, LR
;========================================================================================

draw_level:
;========================================================================================
	STMFD SP!, {r0-r11, LR}
	MOVW r4, level_cursor
	MOVT r4, level_cursor
	BL output_string
	MOVW r4, level_label
	MOVT r4, level_label
	BL output_string
	MOVW r0, level
	MOVT r0, level
	LDRB r0, [r0]
	MOVW r1, level_string
	MOVT r1, level_string
	BL itoa
	MOVW r4, level_string
	MOVT r4, level_string
	BL output_string
	LDMFD SP!, {r0-r11, LR}
	MOV PC, LR
;========================================================================================

track_time:
;========================================================================================
	STMFD SP!, {r0-r11, LR}
	; if its not a half tick (i.e. is a full tick)
	MOVW r4, isHalfTick
	MOVT r4, isHalfTick
	LDRB r4, [r4]
	CMP r4, #0
	BEQ track_time_exit
	; increment the level time
	MOVW r4, levelTime
	MOVT r4, levelTime
	LDRB r5, [r4]
	SUB r5, #1
	; if the time is < 0 zero
	CMP r5, #0
	BLE track_time_end_game ; end the game
	STRB r5, [r4]
track_time_exit:
	LDMFD SP!, {r0-r11, LR}
	MOV r0, #0
	MOV PC, LR
track_time_end_game:
	BL end_game
	LDMFD SP!, {r0-r11, LR}
	MOV r0, #1
	MOV PC, LR
;========================================================================================

draw_board: ; AAPCS Compliant - Register Invariant
;==============================Start Draw Board==========================================
	; clears the current board and redraws the updated board
	STMFD SP!, {r4, LR}
	ADR r4, board_row
	BL output_string
	MOVW r4, board				; print the updated board
	MOVT r4, board
	BL output_string
	LDMFD SP!, {r4, LR}
	MOV PC, LR
;===============================End Draw Board===========================================

Timer0Handler: ; Register Invariant
;============================Start Timer0 Handler========================================
	STMFD SP!, {r0-r11, LR}		; spill the current register onto stack
	LDR r4, TIMER0				; load base address of TIMER0
	LDRB r5, [r4, #0x024]		; load GPTM interrupt clear byte
	ORR r5, r5, #1				; set last bit to clear interrupt
	STRB r5, [r4, #0x024]		; store the byte
	; if the user is playing
	MOVW r4, playing
	MOVT r4, playing
	LDRB r5, [r4]
	CMP r5, #0
	BEQ Timer0Exit
	; move stuff
	BL move_entities
	BL generate_entities
	BL clear_board
	BL board_add_entities
	BL check_collisions ; will updates lives / end game if lost
	; if the user is not playing, skip
	MOVW r4, playing
	MOVT r4, playing
	LDRB r5, [r4]
	CMP r5, #0
	BEQ Timer0Exit
	; endif
	BL track_time ; will return nonzero if game ended
	CMP r0, #0
	BNE Timer0Exit
	BL draw_board
	BL draw_score
	BL draw_lives
	BL draw_time
	BL draw_level
Timer0Exit:
	LDMFD SP!, {r0-r11, LR}		; restore the registers state
	BX LR						; return to execution
;=============================End Timer0 Handler=========================================

Timer1Handler:
	STMFD SP!, {r0-r11, LR}		; spill the current register onto stack
	LDR r4, TIMER1				; load base address of TIMER0
	LDRB r5, [r4, #0x024]		; load GPTM interrupt clear byte
	ORR r5, r5, #1				; set last bit to clear interrupt
	STRB r5, [r4, #0x024]		; store the byte

	; increment the system time
	MOVW r4, sysTime
	MOVT r4, sysTime
	LDR r5, [r4]
	ADD r5, #1
	STR r5, [r4]
Timer1Exit:
	LDMFD SP!, {r0-r11, LR}		; restore the registers state
	BX LR						; return to execution


Uart0Handler: ; Register Invariant
;=============================Start UART0 Handler========================================
	STMFD SP!, {r0-r1,LR}
	MOV r0, #0xC044				; load address of UARTICR (interrupt clear)
	MOVT r0, #0x4000
	LDRB r1, [r0]				; Load interupt status
	ORR r1, #0x1				; set bit 4 to clear interrupt
	STRB r1, [r0]				; store interrupt status

	; Read the character
	LDR r1, UART0
	LDRB r0, [r1]

	BL char_handler
uart0_exit:
	LDMFD SP!, {r0-r1,LR}		; restore the register values
	BX LR
;==============================End UART0 Handler=========================================

end_game:
;=============================Start End Game=============================================
	STMFD SP!, {LR}
	MOVW r4, playing
	MOVT r4, playing
	MOV r5, #0
	STRB r5, [r4]
	BL clear_board				; reset
	; reset all values to intitial
	ADR r4, clear_screen		; clear the screen to remove the old board
	BL output_string
	ADR r4, home_cursor
	BL output_string
	ADR r4, hide_cursor
	BL output_string
	MOVW r4, end_message
	MOVT r4, end_message
	BL output_string				; ypos- holds current vertical location of snake head
	MOV r0, #2
	BL illuminate_RGB_LED

	MOVW r4, started
	MOVT r4, started
	MOV r5, #0
	STRB r5, [r4]

	LDMFD SP!, {LR}
	MOV PC, LR
;==============================End End Game==============================================

PortAHandler:
;=============================Start PORTA Handler========================================
	STMFD SP!, {r0-r10, LR}		; store the current program registers
	; Clear Interrupt
	LDR r0, PORTA
	LDRB r1, [r0, #GPIOICR]
	ORR r1, r1, #0x3C
	STRB r1, [r0, #GPIOICR]		; set bits 2-5 to 1 to clear interrupt

	MOVW r4, playing
	MOVT r4, playing
	LDRB r5, [r4]
	CMP r5, #0 ; weren't playing, unpause game
	BEQ set_playing
	B set_not_playing ; otherwise were playing, pause game
keypad_exit:
	LDRB r0, BUTTON_DELAY
button_loop:
	SUB r0, r0, #1
	CMP r0, #0
	BGT button_loop
	LDMFD SP!, {r0-r10, LR}		; restore the current program registers
	BX LR						; return to normal execution
set_playing:
	MOV r0, #4 ; GREEN
	BL illuminate_RGB_LED ; set LED green
	BL ready_screen ; clear screen
	MOVW r4, playing
	MOVT r4, playing
	MOV r5, #1 ; set state to playing
	STRB r5, [r4]
	B keypad_exit
set_not_playing:
	MOV r0, #1 ; RED
	BL illuminate_RGB_LED
	BL ready_screen ; clear screen
	MOVW r4, pause_screen
	MOVT r4, pause_screen
	BL output_string
	MOVW r4, playing
	MOVT r4, playing
	MOV r5, #0 ; set state to playing
	STRB r5, [r4]
	B keypad_exit
;==============================End PORTA Handler=========================================

ready_screen:
;========================================================================================
	STMFD SP!, {r0, r11, LR}
	MOVW r4, clear_screen
	MOVT r4, clear_screen
	BL output_string
	MOVW r4, home_cursor
	MOVT r4, home_cursor
	BL output_string
	MOVW r4, hide_cursor
	MOVT r4, hide_cursor
	BL output_string
	MOVW r4, white
	MOVT r4, white
	BL output_string
	LDMFD SP!, {r0, r11, LR}
	MOV PC, LR
;========================================================================================

exit:
	LDMFD SP!, {lr}				; Pop link register from stack
	MOV PC, LR					; exit subroutine
	.end
