/*   H8/3052$BHG(B RAM$B<B9TMQ$N%9%?!<%H%"%C%W%k!<%A%s(B (2008/4/3 $BOB:j(B) */
/*   $B%9%?%C%/$O30It(BRAM$B>e$K$H$k(B                                   */
/*   .bss$BNN0h$N(B 0 $B%/%j%"$O$7$J$$(B                                 */
    .h8300h
    .section .text
    .global _start
_start:
/* $BI,MW:GDc8B$N%l%8%9%?=i4|2=$O4{$K(Bstub$B$G<B9T:Q$_(B */
/*   ($BFbB"(BRAM$B!&(BROM$B$H30It(BRAM$B$r;HMQ2D$K$9$k$?$a$N$b$N(B) */
/* $B30It(BRAM$B>e$K%9%?%C%/%]%$%s%?$r%;%C%H(B */
	mov.l   #__ext_stack, sp
/* main()$B$r8F$S=P$9(B */
/*   $B<B9T$,=*N;$7$?$i%9%j!<%W>uBV$K$J$k(B */
__go_main:
    jsr     @_main
    sleep
    jmp     @__go_main
