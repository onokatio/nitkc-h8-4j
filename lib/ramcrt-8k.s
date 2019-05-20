/*   H8/3052$BHG(B RAM$B<B9TMQ$N%9%?!<%H%"%C%W%k!<%A%s(B (2008/4/3 $BOB:j(B) */
/*   $B%9%?%C%/$OFbB"(BRAM$B>e$K$H$k(B                                   */
/*   .bss$BNN0h$N(B 0 $B%/%j%"$O$7$J$$(B                                 */
    .h8300h
    .section .text
    .global _start
_start:
/* $B=i4|2=$KI,MW$J3F%l%8%9%?$NDj5A(B */
__syscr = 0xfffff2
__ramcr = 0xffff47
__abwcr = 0xffffec
__astcr = 0xffffed
__wcr   = 0xffffee
__wcer  = 0xffffef
__brcr  = 0xfffff3
__cscr  = 0xffff5f
__p1ddr = 0xffffc0
__p2ddr = 0xffffc1
__p5ddr = 0xffffc8
__p8ddr = 0xffffcd
_start:
/* $BFbB"(BRAM$B>e$K%9%?%C%/%]%$%s%?$r%;%C%H(B */
	mov.l   #_stack, sp    /* NMI$BBP:v!"FbB"(BRAM$B!'(B0xffff10 */
/* $BI,MW:GDc8B$N%l%8%9%?=i4|2=(B */
/*   $BFbB"(BRAM$B!&(BROM$B$H30It(BRAM$B$r;HMQ2D$K$9$k$?$a$N$b$N(B */
	mov.l	#__syscr, er0
	mov.b	#9, @er0       /* $BFbB"(BRAM$B;HMQ!"%9%j!<%WL?Na$G%9%j!<%W(B */
	mov.l	#__ramcr, er0
	mov.b	#0, @er0       /* $BFbB"(BRAM$B$K$h$k%(%_%e%l!<%7%g%s$J$7(B */
	mov.l	#__abwcr, er0
	mov.b	#0xff, @er0    /* $B30It%(%j%"$OA4$F(B8$B%S%C%HI}(B */
	mov.l	#__astcr, er0
	mov.b	#0xff, @er0    /* $B30It%(%j%"$OA4$F(B3$B%9%F!<%H%"%/%;%9(B */
	mov.l	#__wcr, er0
	mov.b	#4, @er0       /* $B%&%'%$%H6X;_(B */
	mov.l	#__wcer, er0
	mov.b	#0xff, @er0    /* $BC<;R%&%'%$%H%b!<%I6X;_(B */
	mov.l	#__brcr, er0
	mov.b	#0xfe, @er0    /* A23-A21$B$r3+J|!"%P%98"3+J|6X;_(B */
	mov.l	#__p1ddr, er0
	mov.b	#0xff, @er0    /* P1X$B$O(BA7-A0$B$r=PNO(B */
	mov.l	#__p2ddr, er0
	mov.b	#0xff, @er0    /* P2X$B$O(BA15-A8$B$r=PNO(B */
	mov.l	#__p5ddr, er0
	mov.b	#0xf1, @er0    /* P50$B$O(BA16$B$r=PNO(B(P51-P53$B$O;HMQ2D(B) */
	mov.l	#__cscr, er0
	mov.b	#0x0f, @er0    /* CS7-CS4$B$O=PNO6X;_(B, $B%G%U%)%k%H(B */
	mov.l	#__p8ddr, er0
	mov.b	#0xe8, @er0    /* CS1$B$r=PNO(B */
/* main()$B$r8F$S=P$9(B */
/*   $B<B9T$,=*N;$7$?$i%9%j!<%W>uBV$K$J$k(B */
go_main:
    jsr     @_main
    sleep
    jmp     @__go_main
