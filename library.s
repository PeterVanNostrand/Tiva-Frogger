	.text
	.global uart_init
	.global timer0_init
	.global output_string
	.global output_line
	.global output_character
	.global dec_to_ascii
	.global printf
	.global itoa

LOCKCODE:		.field	0x4C4F434B		; special value written to lock registers to allow use
SYSCLKCTRL:		.field	0x400FE108, 32	; clock control register
string: 		.field 	0x20000000, 32
result: 		.field 0x20000008, 32
UART0: 			.field 	0x4000C000, 32
U0LSR: 			.equ 	0x18
UART0_IBRD_R: 	.equ 	0x24
UART0_FBRD_R: 	.equ 	0x28
UART0_LCRH: 	.equ 	0x2C
UART0_CTL: 		.equ 	0x30
GPIOIS:			.equ	0x404
UARTIM:			.equ	0x038			; interrupt mask for UART0
EN0:			.field	0XE000E100, 32	; interrupt set enable register 0
GPIOIBE:		.equ	0x408
GPIOIEV:		.equ	0x40C
GPIOIM:			.equ	0x410
PORTA:			.field 	0x40004000, 32  ; GPIO Port A Base Address
PORTB:			.field 	0X40005000, 32 	; GPIO Port B Base Address
PORTC:			.field 	0x40006000, 32 	; GPIO Port C Base Address
PORTD:			.field 	0x40007000, 32 	; GPIO Port D Base Address
PORTE:			.field 	0x40024000, 32 	; GPIO Port E Base Address
PORTF:			.field	0x40025000, 32 	; GPIO Port F Base Address
DATA:			.equ	0x3FC			; offset for GPIO DATA
DIR:			.equ	0x400			; offset for GPIO pin direction register, 1=output
DIGITAL:		.equ	0x51C			; offset for GPIO digital/analog register, 1=digital
LOCK:			.equ	0x520			; offset for GPIO lock register
UARTIM:			.equ	0x038			; interrupt mask for UART0
INTERVAL:		.field	4000000, 32		; number of clock ticks between interrupts

timer0_init: ; AAPCS Compliant - Register Invariant
;==============================Start Timer0Init==========================================
	STMFD SP!, {r4-r6, LR}
	; Connect 16MHz oscillator on Tiva board to Timer0
	MOV r4, #0xE604			; Load address of RCGCTIMER (timer control register)
	MOVT r4, #0x400F
	LDR r5, [r4]			; Load timer control byte
	ORR r5,	#1				; Set bit 0 high to enable clock to Timer0
	STR r5, [r4]			; re-store byte
	BL delay				; delay to allow clock to stabilize
	BL delay
	BL delay

	; Disable timer
	MOV r4, #0x000C			; load address of GPTM Control Register
	MOVT r4, #0x4003
	LDR r5, [r4]
	BIC r5, r5, #0			; set bit 0 TAEN to 0 to disable timer
	STR r5, [r4]

	; Set timer for 32-bit Mode
	MOV r4, #0x0000			; Load address of GPTM Configuration Register
	MOVT r4, #0x4003
	LDR r5, [r4]			; Load configuration byte
	BIC r5, r5, #0			; Set last 3 bits 0
	BIC r5, r5, #1			; Set last 3 bits 0
	BIC r5, r5, #2			; Set last 3 bits 0
	STR r5, [r4]			; re-store byte

	; Put timer into Periodic Mode
	MOV r4, #0x0004			; Load address of GPTM Timer A Mode register
	MOVT r4, #0x4003
	LDR r5, [r4]			; load TAMR
	BIC r5, r5, #0
	BIC r5, r5, #1
	ORR r5, r5, #2			; set TAMR to 2 for periodic mode
	STR r5, [r4]			; re-store byte

	; Set interrupt interval
	MOV r4, #0x0028			; load address of GPTM Timer a interval register
	MOVT r4, #0x4003
	LDR r5, INTERVAL		; Load 4x10^6 into r5 s.t. the clock interrupts every .25 second
	STR r5, [r4]			; store the value into the interval register

	; Set timer to interrupt when top limit of timer is reached
	MOV r4, #0x0018			; load address of GPTM interrupt mask register
	MOVT r4, #0x4003
	LDR r5, [r4]			; load Timer Interrupt Mask Byte
	ORR r5, r5, #1			; set bit 0 high to enable Timer A mask
	STR r5, [r4]			; re-store byte

	; Configure NVIC
	MOV r4, #0xE100			; load addres of NVIC EN0
	MOVT r4, #0xE000
	LDR r5, [r4]			; load EN0
	MOV r6, #10000000000000000000b
	ORR r5, r5, r6			; Set bit 19 to to enable Timer0 interrupt
	STR r5, [r4]

	; Enable timer
	MOV r4, #0x000C			; load address of GPTM Control Register
	MOVT r4, #0x4003
	LDR r5, [r4]
	ORR r5, r5, #1			; set bit 0 TAEN to 1 to enable timer
	STR r5, [r4]

	LDMFD SP!, {r4-r6, LR}
	MOV PC, LR
;===============================END Timer0Init===========================================

uart_init: ; AAPCS Compliant - Register Invariant
;==============================Start UART Setup==========================================
	; Intialize the Serial UART
	STMFD SP!, {r4-r5, LR}			; Store register lr on stack
	BL delay
	; r4 address of register
	; r5 value loaded from register
	; Provide clock to UART0 - register address 0x400FE618
	MOV r4, #0xE618				; Set lower 16 bits of address
	MOVT r4, #0x400F			; set upper 16 bits of address
	LDR r5, [r4]				; load register value
	ORR r5, r5, #1 				; set last bit to 0
	STR r5, [r4]				; restore register value
	BL delay
	; Turn on clock to UART0 - register address 0x400FE608
	; UARTSysClk = 16MHz, ClkDiv = 16
	MOV r4, #0xE608
	MOVT r4, #0x400F
	LDR r5, [r4]
	ORR r5, r5, #1
	STR r5, [r4]
	BL delay
	; Disable UART0 Control
	MOV r4, #0xC030
	MOVT r4, #0x4000
	LDR r5, [r4]
	ORR r5, r5, #0
	STR r5, [r4]
	; Set UART0_IBRD_R for 115200 baud
	; 115200 - BRD = 8, FBRD = 44
	; 230400 - BRD = 4, FBRD = 22
	; 460800 - BRD = 2, FBRD = 11
	MOV r4, #0xC024
	MOVT r4, #0x4000
	LDR r5, [r4]
	ORR r5, r5, #8
	STR r5, [r4]
	; Set UART0_FBRD_R for 115200 baud
	MOV r4, #0xC028
	MOVT r4, #0x4000
	LDR r5, [r4]
	ORR r5, r5, #44
	STR r5, [r4]
	; Use System Clock
	MOV r4, #0xCFC8
	MOVT r4, #0x4000
	LDR r5, [r4]
	ORR r5, r5, #0
	STR r5, [r4]
	; Use 8-bit word length, 1 stop bit, no parity
	MOV r4, #0xC02C
	MOVT r4, #0x4000
	LDR r5, [r4]
	ORR r5, r5, #0x60
	STR r5, [r4]
	; Enable UART Control
	MOV r4, #0xC030
	MOVT r4, #0x4000
	LDR r5, [r4]
	MOV r5, #0x301
	ORR r5, r5, r5
	STR r5, [r4]
	; Make PA0 and PA1 as Digital Ports - register address 0x4000451C
	MOV r4, #0x451C
	MOVT r4, #0x4000
	LDR r5, [r4]
	ORR r5, r5, #0x03
	STR r5, [r4]
	; Change PA0,PA1 to Use an Alternate Function - register 0x40004420
	MOV r4, #0x4420
	MOVT r4, #0x4000
	LDR r5, [r4]
	ORR r5, r5, #0x03
	STR r5, [r4]
	; Configure PA0 and PA1 for UART - register 0x4000452C
	MOV r4, #0x452C
	MOVT r4, #0x4000
	LDR r5, [r4]
	ORR r5, r5, #0x11
	STR r5, [r4]
	; Set UART0 to generate interrupt for every byte received
	LDR r4, UART0
	LDRB r5, [r4, #UARTIM]
	ORR r5, #0x10				; set RXIM (bit) 4 to recieve interrupts
	STRB r5, [r4, #UARTIM]
	; Enable interrupts for UART0
	LDR r4, EN0					; load address of interrupt enable register
	LDRB r5, [r4]
	ORR r5, #0x20				; set bit 5 high to enable UART0 interrupt
	STRB r5, [r4]

	BL delay
	LDMFD SP!, {r4-r5, LR}				; Pop link register from stack
	MOV PC, LR
;===============================End UART Setup===========================================

output_string:
;=============================Start Output String========================================
	; Transmits a null-terminated string over the UART interface. The base address of the string should be passed in r4
	STMFD SP!, {lr}				; Store the link register on the stack
	LDR r1, UART0				; initialize r1 to the UART0 data register address
output_string_loop:
	LDRB r0, [r4], #1			; Load the next character into r0 and increment the string pointer
	CMP r0, #0					; if the character is 0 we have hit the null termination
	BEQ output_string_exit			; so we exitlib the output_string subroutine
	BL output_character			; Otherwise print the character
	B output_string_loop		; Repeat for the next character
output_string_exit:
	LDMFD sp!, {lr}				; Pop link register from stack
	MOV pc, lr					; exitlib the output_string subroutine
;==============================End Output String=========================================

printf:
;=================================Start printf===========================================
	; Transmits a null-terminated string over the UART interface. The base address of the string should be passed in r0
	STMFD SP!, {lr}				; Store the link register on the stack
	MOV r4, r0
	BL output_string
	LDMFD sp!, {lr}				; Pop link register from stack
	MOV pc, lr					; exitlib the output_string subroutine
;=================================End printf===========================================

output_line:
;==============================Start Output Line=========================================
	; Transmits a null-terminated string over the UART interface. The base address of the string should be passed in r4
	STMFD SP!, {lr}				; Store the link register on the stack
	LDR r1, UART0				; initialize r1 to the UART0 data register address
output_line_loop:
	LDRB r0, [r4], #1			; Load the next character into r0 and increment the string pointer
	CMP r0, #0					; if the character is 0 we have hit the null termination
	BEQ output_line_exit			; so we exitlib the output_string subroutine
	BL output_character			; Otherwise print the character
	B output_line_loop				; Repeat for the next character
output_line_exit:
	MOV r0, #13					; print out carriage return
	BL output_character
	MOV r0, #10					; print out line feed
	BL output_character
	LDMFD sp!, {lr}				; Pop link register from stack
	MOV pc, lr					; exitlib the output_string subroutine
;===============================End Output Line==========================================

output_character:
;=============================Start output_character=========================================
	; Transmits the character stored in r0 over the UART
	; The address of UART0 should be passed in r1
	LDRB r2, [r1, #U0LSR] 		; loading the line status register value
	LSR r2, r2, #5 				; mask out recieve TxFF bit (transmit FIFO full)
	AND r2, r2, #1
	CMP r2, #1					; if bit is 1 loop, the data cannot be transmitted now
	BEQ output_character		; Restart the loop and try again
	STRB r0, [r1]				; Otherwise write character to screen [stores the byte]
	MOV PC, LR					; return to caller
;==============================End output_character==========================================

div_and_mod:
;===============================Start div_and_mod============================================
	; Performs r1/r0 and returns the quotient r0 and the remainder in r1.
	; Other registers are left unchanged
	; r0 is divisor
	; r1 is dividend
	; r2 is loop counter
	; r3 holds quotient
	; r4 holds remainder
	; r5 holds common sign indicator
	STMFD SP!, {r2-r11}
; CHECKING SIGNS OF OPERANDS
	EOR r5, r0, r1 		; exclusive or operands, iff they have the same sign r5>=0
	CMP r0, #0 			; check if divisor is negative
	BEQ divide_by_zero	; if r0==0, throw a divide by zero error
	BGT nonneg_divisor	; if r0>=0 skip sign flip
	RSB r0, r0, #0 		; force divisor positive r0 = 0-r0
nonneg_divisor:
	CMP r1, #0			; check if dividend is negative
	BGT div_setup		; if r1>=0 skip sign flip
	RSB r1, r1, #0 		; force dividend positive r1 = 0-r1
; END SIGN CHECK
; START DIVISON
div_setup:
	MOV r2, #15			; counter - initialize  to 15
	MOV r3, #0			; quotient - initialize  to 0
	LSL r0, r0, #15		; logical left shift divisor 15 places
	MOV r4, r1			; remainder - initialize to dividend
loop:
	SUB r4, r4, r0		; remainder = remainder - divisor
	CMP r4, #0			; if remainder<0
	BLT neg_remainder
	LSL r3, r3, #1		; left shift quotient
	ORR r3, r3, #0x1	; make LSB=1
shift_divisor:
	LSR r0, r0, #1		; right shift divisor, making MSB=0
	CMP r2, #0			; if counter is <= 0
	BLE quotient_sign	; division complete - exitlib loop and check sign of quotient
	SUB r2, r2, #1 		; otherwise decrement counter
	B loop				; loop again
neg_remainder:
	ADD r4, r4, r0		; remainder = remainder + divisor
	LSL r3, r3, #1		; left shift quotient, LSB=0
	B shift_divisor
; END DIVISON
divide_by_zero:			; handle divide by zero
	MOV r4, #-1			; set remainder to -1 to indicate error
	MOV r3, #0			; clear the quotient
	B quotient_exitlib
quotient_sign:
	CMP r5, #0			; check if the quotient needs to be negative
	BGE quotient_exitlib	; quotient should be positive, exitlib
	RSB r3, r3, #0		; quotient should be negative, r3 = 0-r3
quotient_exitlib:
	MOV r0, r3 			; return the quotient in r0
	MOV r1, r4			; return the remainder in r1
	LDMFD SP!, {r2-r11}
	MOV PC, LR			; exitlib to caller
;================================End div_and_mod=============================================

itoa:
;===================================itod Start===============================================
	; Takes the decimal value from r0 and it returns as a string starting at the base in r1
	STMFD SP!, {r1, r6-r8, LR}
	MOV r6, r0
	MOV r7, r1
	BL dec_to_ascii
	MOV r0, r7
	LDMFD SP!, {r1, r6-r8, LR}
	MOV PC, LR
;====================================itod End================================================

dec_to_ascii:
;==============================Start dec_to_ascii========================================
	; Takes the decimal value from r6 and saves it to the memory addres in r7 as an ascii string
	STMFD SP!, {lr}
	MOV r8, #0
d2a_loop:
	MOV r1, r6					; Get ready to div_and_mod the result
	MOV r0, #10					; Divide by 10 to right shift the decimal value
	ADD r8, r8, #1
	BL div_and_mod				; Performs r1/r0 returns the quotient r0 and the remainder in r1
	MOV r6, r0					; right shifted decimal value
	; r1 is the modulus result from the ones place in decimal form
	ADD r1, r1, #48				; add 48 to make the ascii equivalent
	STMFD SP!, {r1}				; store the ASCII character on the stack
	CMP r6, #0					; is r0=0?
	BNE d2a_loop				; if r6 is not 0, loop again, otherwise fall through
	; LOOP IS DONE, r8 holds number of characters stored on stack
d2a_store:
	LDMFD SP!, {r1}				; Pop the ASCII character from the stack
	STRB r1, [r7], #1			; stores the ASCII character to the string and increments r7
	SUB r8, r8, #1
	CMP r8, #0					; is r8=0?
	BGT d2a_store				; if r8>0 there are still characters on the stack, store the next
	MOV r1, #0					; Null terminate the string
	STRB r1, [r7]
	LDMFD SP!, {LR}				; Pop link register from stack
	MOV PC, LR					; exitlib subroutine
;===============================End dec_to_ascii=========================================

delay: ; AAPCS Compliant
;==================================START DELAY===============================================
	STMFD SP!, {r4}			; Store register r4 on stack
	MOV r4, #100
delay_loop:
	SUB r4, r4, #1
	CMP r4, #0
	BNE delay_loop
	LDMFD sp!, {r4}			; pop r4 from the stack
	MOV PC, LR
;===================================END DELAY================================================
	.end
