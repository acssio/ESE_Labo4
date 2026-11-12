	THUMB
	AREA    |.text|, CODE, READONLY
;	AREA    |.data|, CODE, READWRITE, ALIGN=4

	EXPORT ledInit
	EXPORT ledRGB
	EXPORT nopDelay
	EXPORT LedsRGB
		
;-------------------------------------------------------------------
; Register Section
;-------------------------------------------------------------------


rClock1Dat0 RN 3
rClock1Dat1 RN 6
rData0	RN 4
rData1	RN 5
regODR RN 10


;-------------------------------------------------------------------
; Led Init
;-------------------------------------------------------------------
; send the data for the led to init
;-------------------------------------------------------------------
ledInit PROC
	STMFD	sp!,{r14}
	
	mov r0, #0
	bl ledsCommand
	
	LDMFD	sp!,{pc} ; return
	
	
;-------------------------------------------------------------------
; LedRGB
;-------------------------------------------------------------------
; send the data for the led to init
; r0 : RED value
; r1 : Green Value
; r2 : Blue Value
; r3 : Luminosity
;-------------------------------------------------------------------
ledRGB
	STMFD	sp!,{r4,r14}
	
	lsl r1, r1, #8 		; r1 = r1 << 8
	lsl r2, r2, #16 	; r1 = r1 << 16
	lsl r3, r3, #24 	; r1 = r1 << 24
	mov r4, #0xE0000000 ; r4 = 0b111000...
	
	orr r0, r0, r1		; Compile the message
	orr r0, r0, r2		; Compile the message
	orr r0, r0, r3		; Compile the message
	orr r0, r0, r4		; Compile the message
	
	bl ledsCommand
	
	LDMFD	sp!,{r4,pc} ; return

;-------------------------------------------------------------------
; Led Command
;-------------------------------------------------------------------
; r0 : 32 Bit data to send
;-------------------------------------------------------------------
ledsCommand	
	STMFD	sp!,{r4,r5,r6,r10,r14}
	
	ldr		regODR, =ODR
	ldr		regODR,[regODR]	; save the ODR value in a register
	
	mov		rClock1Dat0, #0x200 	; Register value 1 for the pin 9 (For clock)
	mov		rClock1Dat1, #0x300 	; Register value 1 for the pin 9 (For clock)
	mov		rData0, #0x000	; Register value 0 for the pin 9 (For clock)
	mov		rData1, #0x100 	; Register value 1 for the pin 9 (For clock)
	
	mov		r1,#32			; idx = 32
	
beginFor
	sub 	r1,r1,#1	; idx --
	str		rData0, [regODR] ; Clock Falling
	
	lsr		r2,r0, r1		; r1 = r0 >> idx
	tst		r2, #1 			; if(r0 & 0b0001 == 0)
	
	streq	rData0, [regODR] ; if true, transmit 0
	strne	rData1, [regODR] ; if false, transmit 1
	
	nop
	
	streq	rClock1Dat0, [regODR] ; Clock Rinsing, data0
	strne	rClock1Dat1, [regODR] ; Clock Rinsing, data1
	
	
	cmp 	r1,#0 ; idx == 0
	bne 	beginFor
	streq	rData0, [regODR] ; Clock Falling
	LDMFD	sp!,{r4,r5,r6,r10,pc} ; return
		
		
;-------------------------------------------------------------------
; Variadic functino LedsRGB
;-------------------------------------------------------------------
; a1 : numer of parameters
; a2-a4 : firsts parameters
; the rest of the parameters are in the stack
;-------------------------------------------------------------------
LedsRGB
	mov 	r10, sp
	push	{r4,r5,r6,r7,r8,r10,r14}
	
	mov 	r4,a1		; Move parameters so i can call ledsCommand
	mov 	r5,a2
	mov 	r6,a3
	mov 	r7,a4
	mov 	r8, #0xE0000000	
	
	; Led 1
	cmp 	r4,#0		; r4 == 0 ?
	beq		returnLedsRGB	; if true, return
	orr 	r0, r5, r8		; add 0b111.... to the message, and put it in r0
	bl 		ledsCommand 	; Set the led with the following data
	
	; Led 2
	subs	r4,r4,#1		; idx--, r4 == 0 ?
	beq		returnLedsRGB	; if true, return
	orr 	r0, r6, r8		; add 0b111.... to the message, and put it in r0
	bl 		ledsCommand 	; Set the led with the following data
	
	; Led 3
	subs	r4,r4,#1		; idx--, r4 == 0 ?
	beq		returnLedsRGB	; if true, return
	orr 	r0, r7, r8		; add 0b111.... to the message, and put it in r0
	bl 		ledsCommand 	; Set the led with the following data
	
	
	sub	r4,r4,#1		; idx--
	; Rest of leds
	;add		r10,r10,r4, LSL #2 ; spRec = spRec + 4*r4
	
debLed
	LDR		r5,[r10], #4 
	orr 	r0, r5, r8		; add 0b111.... to the message, and put it in r0
	bl 		ledsCommand 	; Set the led with the following data
	
	subs	r4,r4,#1		; idx--, r4 == 0 ?
	bne		debLed			; if false, read another led
	
returnLedsRGB
	pop	{r4,r5,r6,r7,r8,r10,pc} ; return
		
		

nopDelay
	STMFD	sp!,{r14}

Delay
	subs 	r0,r0,#1
	bne Delay
	
	LDMFD	sp!,{pc}

		ENDP

;-------------------------------------------------------------------
; Data section
;-------------------------------------------------------------------
	AREA  |.data|, CODE, READWRITE, ALIGN=4

globalPower		DCD		1
ODR				DCD		0x40020414 ; Adress of ODR Port B
	

	END