/*   H8/3052$BHG(B ROM$B2=MQ$N%9%?!<%H%"%C%W%k!<%A%s(B (2008/4/2 $BOB:j(B) */
/*   RAM$BHG$H0[$J$k$N$O!"(B.data$BNN0h$r=i4|2=$9$k$3$H(B              */
/*   .bss$BNN0h$N(B 0 $B%/%j%"$O$7$J$$(B                               */
	.h8300h
	.section .text
	.global _start
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
/* .data$BNN0h$N=i4|2=(B */
/*   er0$B!'(B.data$BNN0h$N@hF,%"%I%l%9(B ($B%3%T!<@h$N%]%$%s%?(B) */
/*   er1$B!'(B.data$BNN0h$N=*N;%"%I%l%9(B+1 (.bss$BNN0h$N@hF,%"%I%l%9(B) */
/*   er2$B!'=i4|CM$N$"$k(BROM$BFbG[CV%"%I%l%9(B ($B%3%T!<85$N%]%$%s%?(B) */
/*   r3h$B!'=i4|CM%3%T!<MQ$N%F%s%]%i%j(B */
	mov.l	#__data_start,er0
	mov.l	#__data_end,er1
	mov.l	#__idata_start,er2
__loop_copy:
	cmp.l	er0,er1		/* er1 - er0 $B$r7W;;$9$k(B */
	ble	__go_main	/* er1 <= er0 $B$J$i=i4|2==*N;(B */ 
	mov.b	@er2+,r3h	/* ROM$BNN0h$+$i%G!<%?FI$_=P$7(B $B85%]%$%s%?(B +1 */
	mov.b	r3h,@er0	/* $B%G!<%?$r%3%T!<@h$K(B */
	inc.l	#1,er0		/* $B%3%T!<@h$N%]%$%s%?(B +1 */
	bra	__loop_copy	
/* main()$B$r8F$S=P$9(B */
/*   $B<B9T$,=*N;$7$?$i%9%j!<%W>uBV$K$J$k(B */
__go_main:
	jsr     @_main
	sleep
	bra     __go_main
