.org 0x0
.section .iv,"a"

_start:     

interrupt_vector:

    b RESET_HANDLER
.org 0x8
    b SVC_HANDLER
.org 0x18
    b IRQ_HANDLER
    
.org 0x100

.text

    @ Zera o contador
    ldr r2, =CONTADOR
    mov r0,#0
    str r0,[r2]

RESET_HANDLER:
    .set GPT_CR,                0x53FA0000
    .set GPT_PR,                0x53FA0004
    .set GPT_OCR1,              0x53FA0010
    .set GPT_IR,                0x53FA000C

    @Set interrupt table base address on coprocessor 15.
    ldr r0, =interrupt_vector
    mcr p15, 0, r0, c12, c0, 0

    ldr r2, =GPT_CR
    mov r3, #0X00000041
    str r3, [r2]
    
    ldr r2, =GPT_PR
    mov r3, #0
    str r3, [r2]
    
    ldr r2, =GPT_OCR1
    mov r3, #0x00010000
    str r3, [r2]
    
    ldr r2, =GPT_IR
    mov r3, #1
    str r3, [r2]  
    
SET_TZIC:
    @ Constantes para os enderecos do TZIC
    .set TZIC_BASE,             0x0FFFC000
    .set TZIC_INTCTRL,          0x0
    .set TZIC_INTSEC1,          0x84 
    .set TZIC_ENSET1,           0x104
    .set TZIC_PRIOMASK,         0xC
    .set TZIC_PRIORITY9,        0x424

    @ Liga o controlador de interrupcoes
    @ R1 <= TZIC_BASE

    ldr r1, =TZIC_BASE

    @ Configura interrupcao 39 do GPT como nao segura
    mov r0, #(1 << 7)
    str r0, [r1, #TZIC_INTSEC1]

    @ Habilita interrupcao 39 (GPT)
    @ reg1 bit 7 (gpt)

    mov r0, #(1 << 7)
    str r0, [r1, #TZIC_ENSET1]

    @ Configure interrupt39 priority as 1
    @ reg9, byte 3

    ldr r0, [r1, #TZIC_PRIORITY9]
    bic r0, r0, #0xFF000000
    mov r2, #1
    orr r0, r0, r2, lsl #24
    str r0, [r1, #TZIC_PRIORITY9]

    @ Configure PRIOMASK as 0
    eor r0, r0, r0
    str r0, [r1, #TZIC_PRIOMASK]

    @ Habilita o controlador de interrupcoes
    mov r0, #1
    str r0, [r1, #TZIC_INTCTRL]

    @instrucao msr - habilita interrupcoes
    msr  CPSR_c, #0x13       @ SUPERVISOR mode, IRQ/FIQ enabled

laco:
    b laco
    
SVC_HANDLER:
    spmf

IRQ_HANDLER:
    .set GPT_SR, 0x53FA0008
    
    ldr r2, =GPT_SR
    mov r3, #0x1
    str r3, [r2]
    
    ldr r1, =CONTADOR
    ldr r0, [r1]
    add r0, r0, #1
    str r0, [r1]
    
    movs pc, lr

.data
    CONTADOR:
        .word 0