	THUMB
	AREA    |.text|, CODE, READONLY
;	AREA    |.data|, CODE, READWRITE, ALIGN=4

	EXPORT  ledsInit
	EXPORT nopDelay
		
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
ledsInit	PROC
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