	.data

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
score_string:	.string "XXXX", 0
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
	.global set_frog_dir
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

UART0: 			.field 	0x4000C000, 32
TIMER0:			.field	0x40030000,	32	; base address of Timer0
welcome:		.string	"Welcome to Peter and Komas's CSE 379 Lab 6!", 0
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
play_again:		.string "PRESS SPACE TO PLAY AGAIN", 0
instructions:	.string " TO START PRESS A DIRECTION KEY. THE SNAKE", 0
instructions1:	.string	"     CAN BE MOVED USING IJKM OR WASD", 0
instructions2:	.string "   UP=I/W, DOWN=M/S, LEFT=K/D, RIGHT=J/A", 0
spaces:		.string "                                      ", 0

score_value:	.field 0, 32
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
	MOV r2, #3
	BL itoa_pad
	MOVW r4, score_string
	MOVT r4, score_string
	BL output_string
	LDMFD SP!, {r0-r11, LR}
	MOV PC, LR

draw_lives:
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

draw_time:
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

draw_level:
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

track_time:
	STMFD SP!, {r0-r11, LR}
	MOVW r4, isHalfTick
	MOVT r4, isHalfTick
	LDRB r4, [r4]
	CMP r4, #0
	BEQ track_time_exit
	MOVW r4, levelTime
	MOVT r4, levelTime
	LDRB r5, [r4]
	SUB r5, #1
	CMP r5, #0
	BLE track_time_end_game
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
	MOVW r4, playing
	MOVT r4, playing
	LDRB r5, [r4]
	CMP r5, #0
	BEQ Timer0Exit

	BL move_entities
	BL clear_board
	BL board_add_entities
	BL check_collisions
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
	ADR r4, text_red
	BL output_string
	MOVW r4, end_message
	MOVT r4, end_message
	BL output_string
	ADR r4, text_white
	BL output_string				; ypos- holds current vertical location of snake head
	LDMFD SP!, {LR}
	MOV PC, LR
;==============================End End Game==============================================

exit:
	LDMFD SP!, {lr}				; Pop link register from stack
	MOV PC, LR					; exit subroutine
	.end
