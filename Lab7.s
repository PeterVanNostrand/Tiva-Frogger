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

end_message:	.string " ██████╗  █████╗ ███╗   ███╗███████╗     ██████╗ ██╗   ██╗███████╗██████╗ " , 0x0D,0x0A
end_1:			.string "██╔════╝ ██╔══██╗████╗ ████║██╔════╝    ██╔═══██╗██║   ██║██╔════╝██╔══██╗" , 0x0D,0x0A
end_2:			.string "██║  ███╗███████║██╔████╔██║█████╗      ██║   ██║██║   ██║█████╗  ██████╔╝" , 0x0D,0x0A
end_3:			.string "██║   ██║██╔══██║██║╚██╔╝██║██╔══╝      ██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗" , 0x0D,0x0A
end_4:			.string "╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗    ╚██████╔╝ ╚████╔╝ ███████╗██║  ██║" , 0x0D,0x0A
end_5:			.string "╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝     ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝" , 0x0D,0x0A, 0
score_string:	.string "000", 0

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
	.global draw_entities
	.global test
	.global set_frog_dir

UART0: 			.field 	0x4000C000, 32
TIMER0:			.field	0x40030000,	32	; base address of Timer0
welcome:		.string	"Welcome to Peter and Komas's CSE 379 Lab 6!", 0
clear_screen:	.string 27, "[2J", 0		; escape sequence to clear screen
home_cursor:	.string 27, "[1;1H", 0		; escape sequence to move cursor to top left of terminal
board_row:		.string	27, "[1;1H", 0
show_cursor:	.string 27, "[?25h", 0
hide_cursor:	.string 27, "[?25l", 0
score_cursor:	.string 27, "[17;1H", 0
score_end_cur:	.string 27, "[7;33H", 0
play_cur:		.string 27, "[8;24H", 0
text_red:		.string 27, "[31;1m", 0
text_white:		.string 27, "[37;1m", 0
score_label:	.string "SCORE: ", 0
play_again:		.string "PRESS SPACE TO PLAY AGAIN", 0
instructions:	.string " TO START PRESS A DIRECTION KEY. THE SNAKE", 0
instructions1:	.string	"     CAN BE MOVED USING IJKM OR WASD", 0
instructions2:	.string "   UP=I/W, DOWN=M/S, LEFT=K/D, RIGHT=J/A", 0

score_value:	.field 0, 32
level:			.field 0, 32
sys_time:		.field 0, 32
level_time:		.field 240, 32
timer_interval:	.field 8000000, 32

lab7:
	STMFD SP!, {LR}
main:
	BL uart_init				; initialize uart and corresponding interrupts
	ADR r4, clear_screen		; clear the screen to remove the old board
	BL output_string
	ADR r4, home_cursor
	BL output_string
	ADR r4, hide_cursor
	BL output_string
	ADR r4, text_white
	BL output_string
	;ADR r4, welcome				; print welcome message
	;BL output_line
	;ADR r4, instructions
	;BL output_line
	;ADR r4, instructions1
	;BL output_line
	;ADR r4, instructions2
	;BL output_line
	;BL update_snake
	BL draw_board				; draw the game board to load the game
	BL draw_score
	BL timer0_init				; setup timer to handle further board updates
run_loop:
	B run_loop

clear_board: ; AAPCS Compliant, updates r0-r2
;==============================Start Clear Board=========================================
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
	MOV PC, LR
;===============================End Clear Board==========================================

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

test:
	STMFD SP!, {r0-r11, LR}
	BL move_entities
	BL draw_board
	LDMFD SP!, {r0-r11, LR}
	MOV PC, LR

draw_score:
;==============================Start Draw Score==========================================
	STMFD SP!, {r0-r11, LR}
	ADR r4, score_cursor	; move cursor to location of score counter
	BL output_string
	ADR r4, score_label		; draw the score label
	BL output_string
	MOV r6, r7				; load score into r0
	MOVW r7, score_string	; load score value string address into r1
	MOVT r7, score_string
	BL dec_to_ascii			; convert score the string, result stored in score_string
	MOVW r4, score_string	; load score value string address into r1
	MOVT r4, score_string
	BL output_string
	LDMFD SP!, {r0-r11, r4, LR}
	MOV PC, LR
;===============================End Draw Score===========================================

Timer0Handler: ; Register Invariant
;============================Start Timer0 Handler========================================
	STMFD SP!, {r0-r11, LR}		; spill the current register onto stack
	LDR r4, TIMER0				; load base address of TIMER0
	LDRB r5, [r4, #0x024]		; load GPTM interrupt clear byte
	ORR r5, r5, #1				; set last bit to clear interrupt
	STRB r5, [r4, #0x024]		; store the byte
	BL move_entities
	BL draw_board
	BL draw_entities
Timer0Exit:
	LDMFD SP!, {r0-r11, LR}		; restore the registers state
	BX LR						; return to execution
;=============================End Timer0 Handler=========================================

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

	BL set_frog_dir
uart0_exit:
	LDMFD SP!, {r0-r1,LR}		; restore the register values
	BX LR
;==============================End UART0 Handler=========================================

check_collisions: ; AAPCS Compliant - modifies r0, r1
;===========================Start Check Collisions=======================================
	MOVW r1, board				; load address of board
	MOVT r1, board
	MOV r2, #44
	MUL r2, r2, r9				; multiply ypos by 44 to get the row offset
	ADD r2, r2, r8				; add xpos to get the total ofset=(row*width)+col
	LDRB r0, [r1, r2]
	CMP r0, #32					; if the next location of the snake is not an empty space
	BNE end_game
	MOV PC, LR
;============================End Check Collisions========================================

end_game:
;=============================Start End Game=============================================
	STMFD SP!, {LR}
	BL clear_board				; reset
	; reset all values to intitial
	MOV r10, #0					; xdir - holds horizontal direction of snake (+)=right (-)=left
	MOV r11, #0					; ydir - holds vertical direction of snake (+)=down (-)=up
	ADR r4, clear_screen		; clear the screen to remove the old board
	BL output_string
	ADR r4, home_cursor
	BL output_string
	ADR r4, hide_cursor
	BL output_string
	ADR r4, text_red
	BL output_string
	MOVW r4, end_message
	MOVT r4, end_message
	BL output_string
	ADR r4, text_white
	BL output_string
	MOVW r4, score_end_cur
	MOVT r4, score_end_cur
	BL output_string
	ADR r4, score_label		; draw the score label
	BL output_string
	MOV r6, r7				; load score into r0
	MOVW r7, score_string	; load score value string address into r1
	MOVT r7, score_string
	BL dec_to_ascii			; convert score the string, result stored in score_string
	MOVW r4, score_string	; load score value string address into r1
	MOVT r4, score_string
	BL output_string
	MOVW r4, play_cur
	MOVT r4, play_cur
	BL output_string
	MOVW r4, play_again
	MOVT r4, play_again
	BL output_string
	MOV r7, #0					; score - hold current number of snake (*)'s on board
	MOV r8, #20					; xpos - hold current horizontal location of snake head
	MOV r9, #8					; ypos- holds current vertical location of snake head
	LDMFD SP!, {LR}
	MOV PC, LR
;==============================End End Game==============================================

exit:
	LDMFD SP!, {lr}				; Pop link register from stack
	MOV PC, LR					; exit subroutine
	.end
