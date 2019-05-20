/*
  H8-3052F RAM$BHG%j%s%+%9%/%j%W%H(B ($B%9%?%C%/NN0h$H%G!<%?NN0h$,30It(BRAM)
  2008/4/4 $BOB:j(B
*/
OUTPUT_FORMAT("coff-h8300")
OUTPUT_ARCH(h8300h)
ENTRY("_start")
/*   $BFbB"(BRAM$B$N%9%?%C%/%]%$%s%?$N=i4|2=%"%I%l%9(B */
PROVIDE(_stack = 0xffff10);
/*   $B30It(BRAM$B$N%9%?%C%/%]%$%s%?$N=i4|2=%"%I%l%9(B */
PROVIDE(__ext_stack = 0x220000);
/*
  Memory Map
  0x000000 - 0x07ffff (0x80000 bytes) : Internal Flash-ROM (512kB)
    0x000000 - 0x0000ff (0x00100 bytes) : Vector Area        (256Byte)
    0x000100 - 0x07ffff (0x7ff00 bytes) : Internal ROM Area  (512KB)
  0x200000 - 0x21ffff (0x20000 bytes) : External RAM Area  (128kB)
  0xffdf10 - 0xffff0f (0x02000 bytes) : Internal RAM Area  (8kB)
    ROM Emulation : 
    0xffe000 - 0xffefff (0x01000 bytes) <=> 0x000000 - 0x000fff (4kB)
*/
MEMORY
{
    /* $B3d$j9~$_$r;H$&$H$-$K$O%Y%/%?%"%I%l%9$N=q$-49$($,I,?\$N$?$a(B    */
    /* $B%Y%/%?NN0h(B 0x000000-0x000fff $B$rFbB"(BRAM$B$K%^%C%T%s%0$9$k(B        */
    /* ( 0x000000 - 0x000fff <> 0xffe000 - 0xffefff $B$H$J$k(B)          */
    /*   $BC"$7!"(BROM$B%(%_%e%l!<%7%g%s5!G=$O%f!<%6B&$N@UG$$G9T$&$3$H(B     */
    /*   $B$^$?!"$3$N$H$-FbB"(BRAM$B$O;D$j(B4kB$B<e$7$+;H$($J$$$N$GCm0U(B        */
    vectors	: o = 0xffe000, l = 0x400
    /* RAM$BNN0h$rFC$KJ,CG$7$J$$$G5M$a$F%m!<%I$9$k(B */
    ram		: o = 0x200000, l = 0x20000
}
SECTIONS                
{                   
.vectors : {
	/* $BNc30=hM}%Y%/%?$N=hM}(B */
	/* ROM$B%(%_%e%l!<%7%g%s$N$?$a!"(BRAM$B>e$KA4$FCV$+$l$k(B */
	/* $B3d$j9~$_%O%s%I%i$N4X?tL>$O(BDEFINED$BFb$NJ8;zNs(B            */
	/*   $BC"$7!"@hF,$N(B _ $B$r$H$C$?$b$N$K$J$k(B                    */
	/*   ($BNc(B) IRQ0$B$N$H$-!'(B _int_irq0 => void int_irq0(void)   */
	/*   $B3d$j9~$_%O%s%I%i$G$O!"0z?t$bLa$jCM$b$H$l$J$$$N$GCm0U(B */
	/* $B3d$j9~$_%O%s%I%i$,L5$$$H$-$O!"A4$F%9%?!<%H$K$J$k(B */
	/*   $B$D$^$j!"%j%;%C%H$HF1$8%W%m%0%i%`$,<B9T$5$l$k(B   */
	/* $B%Y%/%?L>(B $B%Y%/%?HV9f(B $B$G%3%a%s%H$r@hF,$KIU2C(B */
	/* $B%j%;%C%H%Y%/%?(B 0 */
	LONG(ABSOLUTE(_start))
	/* $B%j%6!<%V(B 1-6 */
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	/* NMI$B%Y%/%?(B 7 */
	LONG(DEFINED(_int_nmi)?ABSOLUTE(_int_nmi):ABSOLUTE(_start))
	/* $B%H%i%C%W%Y%/%?(B 8-11 */
	LONG(DEFINED(_int_trap0)?ABSOLUTE(_int_trap0):ABSOLUTE(_start))
	LONG(DEFINED(_int_trap1)?ABSOLUTE(_int_trap1):ABSOLUTE(_start))
	LONG(DEFINED(_int_trap2)?ABSOLUTE(_int_trap2):ABSOLUTE(_start))
	LONG(DEFINED(_int_trap3)?ABSOLUTE(_int_trap3):ABSOLUTE(_start))
	/* IRQ$B%Y%/%?(B 12-17 */
	LONG(DEFINED(_int_irq0)?ABSOLUTE(_int_irq0):ABSOLUTE(_start))
	LONG(DEFINED(_int_irq1)?ABSOLUTE(_int_irq1):ABSOLUTE(_start))
	LONG(DEFINED(_int_irq2)?ABSOLUTE(_int_irq2):ABSOLUTE(_start))
	LONG(DEFINED(_int_irq3)?ABSOLUTE(_int_irq3):ABSOLUTE(_start))
	LONG(DEFINED(_int_irq4)?ABSOLUTE(_int_irq4):ABSOLUTE(_start))
	LONG(DEFINED(_int_irq5)?ABSOLUTE(_int_irq5):ABSOLUTE(_start))
	/* $B%j%6!<%V(B 18-19 */
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	/* $B%$%s%?!<%P%k%?%$%^(B($B%&%)%C%A%I%C%0%?%$%^(B) 20 */
	LONG(DEFINED(_int_wovi)?ABSOLUTE(_int_wovi):ABSOLUTE(_start))
	/* $B%3%s%Z%"%^%C%A(B($B%j%U%l%C%7%e%3%s%H%m!<%i(B) 21 */
	LONG(DEFINED(_int_cmi)?ABSOLUTE(_int_cmi):ABSOLUTE(_start))
	/* $B%j%6!<%V(B 22-23 */
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	/* 16$B%S%C%H%?%$%^(Bch0 24-26 */
	LONG(DEFINED(_int_imia0)?ABSOLUTE(_int_imia0):ABSOLUTE(_start))
	LONG(DEFINED(_int_imib0)?ABSOLUTE(_int_imib0):ABSOLUTE(_start))
	LONG(DEFINED(_int_ovi0)?ABSOLUTE(_int_ovi0):ABSOLUTE(_start))
	/* $B%j%6!<%V(B 27 */
	LONG(ABSOLUTE(_start))
	/* 16$B%S%C%H%?%$%^(Bch1 28-30 */
	LONG(DEFINED(_int_imia1)?ABSOLUTE(_int_imia1):ABSOLUTE(_start))
	LONG(DEFINED(_int_imib1)?ABSOLUTE(_int_imib1):ABSOLUTE(_start))
	LONG(DEFINED(_int_ovi1)?ABSOLUTE(_int_ovi1):ABSOLUTE(_start))
	/* $B%j%6!<%V(B 31 */
	LONG(ABSOLUTE(_start))
	/* 16$B%S%C%H%?%$%^(Bch2 32-34 */
	LONG(DEFINED(_int_imia2)?ABSOLUTE(_int_imia2):ABSOLUTE(_start))
	LONG(DEFINED(_int_imib2)?ABSOLUTE(_int_imib2):ABSOLUTE(_start))
	LONG(DEFINED(_int_ovi2)?ABSOLUTE(_int_ovi2):ABSOLUTE(_start))
	/* $B%j%6!<%V(B 35 */
	LONG(ABSOLUTE(_start))
	/* 16$B%S%C%H%?%$%^(Bch3 36-38 */
	LONG(DEFINED(_int_imia3)?ABSOLUTE(_int_imia3):ABSOLUTE(_start))
	LONG(DEFINED(_int_imib3)?ABSOLUTE(_int_imib3):ABSOLUTE(_start))
	LONG(DEFINED(_int_ovi3)?ABSOLUTE(_int_ovi3):ABSOLUTE(_start))
	/* $B%j%6!<%V(B 39 */
	LONG(ABSOLUTE(_start))
	/* 16$B%S%C%H%?%$%^(Bch4 40-42 */
	LONG(DEFINED(_int_imia4)?ABSOLUTE(_int_imia4):ABSOLUTE(_start))
	LONG(DEFINED(_int_imib4)?ABSOLUTE(_int_imib4):ABSOLUTE(_start))
	LONG(DEFINED(_int_ovi4)?ABSOLUTE(_int_ovi4):ABSOLUTE(_start))
	/* $B%j%6!<%V(B 43 */
	LONG(ABSOLUTE(_start))
	/* DMAC 44-47 */
	LONG(DEFINED(_int_dend0a)?ABSOLUTE(_int_dend0a):ABSOLUTE(_start))
	LONG(DEFINED(_int_dend0b)?ABSOLUTE(_int_dend0b):ABSOLUTE(_start))
	LONG(DEFINED(_int_dend1a)?ABSOLUTE(_int_dend1a):ABSOLUTE(_start))
	LONG(DEFINED(_int_dend1b)?ABSOLUTE(_int_dend1b):ABSOLUTE(_start))
	/* $B%j%6!<%V(B 48-51 */
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	/* SCI ch0 52-55 */
	LONG(DEFINED(_int_eri0)?ABSOLUTE(_int_eri0):ABSOLUTE(_start))
	LONG(DEFINED(_int_rxi0)?ABSOLUTE(_int_rxi0):ABSOLUTE(_start))
	LONG(DEFINED(_int_txi0)?ABSOLUTE(_int_txi0):ABSOLUTE(_start))
	LONG(DEFINED(_int_tei0)?ABSOLUTE(_int_tei0):ABSOLUTE(_start))
	/* SCI ch1 56-59 */
	LONG(DEFINED(_int_eri1)?ABSOLUTE(_int_eri1):ABSOLUTE(_start))
	LONG(DEFINED(_int_rxi1)?ABSOLUTE(_int_rxi1):ABSOLUTE(_start))
	LONG(DEFINED(_int_txi1)?ABSOLUTE(_int_txi1):ABSOLUTE(_start))
	LONG(DEFINED(_int_tei1)?ABSOLUTE(_int_tei1):ABSOLUTE(_start))
	/* A/D$B%(%s%I(B 60 */
	LONG(DEFINED(_int_adi)?ABSOLUTE(_int_adi):ABSOLUTE(_start))
	/* $B%j%6!<%V(B 61-63 */
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
    }  > vectors
.text : {
    __text_start = . ;
    *(.text)                
    *(.rodata)              
    *(.strings)
     __text_end = . ; 
    }  > ram
.tors : {
    ___ctors = . ;
    *(.ctors)
    ___ctors_end = . ;
    ___dtors = . ;
    *(.dtors)
    ___dtors_end = . ;
    }  > ram
.data : {
    __data_start = .;
    *(.data)
    __edata = . ;
    }  > ram
.bss : {
    __bss_start = .;
    *(.bss)
    *(COMMON)
    __bss_end = .;
    }  >ram
}
