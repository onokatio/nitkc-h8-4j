/*   H8/3052$BHG(B RAM$B<B9TMQ$N%9%?!<%H%"%C%W%k!<%A%s(B (2008/4/3 $BOB:j(B) */
/*   $B%9%?%C%/$O7QB3;HMQ$9$k$N$GHsGK2u(B                            */
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
/* $BI,MW:GDc8B$N%l%8%9%?=i4|2=(B */
/*   $BFbB"(BRAM$B!&(BROM$B$H30It(BRAM$B$r;HMQ2D$K$9$k$?$a$N$b$N(B */
	mov.b	#9, r0l       /* $BFbB"(BRAM$B;HMQ!"%9%j!<%WL?Na$G%9%j!<%W(B */
	mov.b	r0l, @__syscr
	mov.b	#0, r0l       /* $BFbB"(BRAM$B$K$h$k%(%_%e%l!<%7%g%s$J$7(B */
	mov.b	r0l, @__ramcr
	mov.b	#0xff, r0l    /* $B30It%(%j%"$OA4$F(B8$B%S%C%HI}(B */
	mov.b	r0l, @__abwcr
	mov.b	#0xff, r0l    /* $B30It%(%j%"$OA4$F(B3$B%9%F!<%H%"%/%;%9(B */
	mov.b	r0l, @__astcr
	mov.b	#4, r0l       /* $B%&%'%$%H6X;_(B */
	mov.b	r0l, @__wcr
	mov.b	#0xff, r0l    /* $BC<;R%&%'%$%H%b!<%I6X;_(B */
	mov.b	r0l, @__wcer
	mov.b	#0xfe, r0l    /* A23-A21$B$r3+J|!"%P%98"3+J|6X;_(B */
	mov.b	r0l, @__brcr
	mov.b	#0xff, r0l    /* P1X$B$O(BA7-A0$B$r=PNO(B */
	mov.b	r0l, @__p1ddr
	mov.b	#0xff, r0l    /* P2X$B$O(BA15-A8$B$r=PNO(B */
	mov.b	r0l, @__p2ddr
	mov.b	#0xf1, r0l    /* P50$B$O(BA16$B$r=PNO(B(P51-P53$B$O;HMQ2D(B) */
	mov.b	r0l, @__p5ddr
	mov.b	#0x0f, r0l    /* CS7-CS4$B$O=PNO6X;_(B, $B%G%U%)%k%H(B */
	mov.b	r0l, @__cscr
	mov.b	#0xe8, r0l    /* CS1$B$r=PNO(B */
	mov.b	r0l, @__p8ddr
/* main()$B$r8F$S=P$9(B */
/*   $B<B9T$,=*N;$7$?$i8F$S=P$7$?%W%m%0%i%`$KLa$k(B */
go_main:
	jsr     @_main
	rts
