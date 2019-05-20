/*
  H8-3052F ROM$BHG%j%s%+%9%/%j%W%H(B ($B%9%?%C%/NN0h$H%G!<%?NN0h$,30It(BRAM)
  2008/4/4 $BOB:j(B
*/
OUTPUT_FORMAT("coff-h8300")
OUTPUT_ARCH(h8300h)
ENTRY("_start")
/* $B%9%?%C%/%]%$%s%?$N@_Dj(B */
/* $B!a!a!a!a!a(B ROM$B2=$r9T$&;~$NCm0UE@(B $B!a!a!a!a!a(B                       */
/*   $B30IU$1(BRAM$B$r%9%?%C%/NN0h$K;H$&$H$-$K(B                             */
/*     PROVIDE(_stack = 0x220000);                                   */
/*   $B$H$9$k$H!"=i$a$K(BCS$B$N%3%s%H%m!<%k$r$7$F$$$J$$$N$G!"30It(BRAM$B$,(B     */
/*   $B%a%b%j6u4V>e$KB8:_$7$J$$$?$a!"%9%?%C%/$,5!G=$;$:!"K=Av$9$k!#(B    */
/*   NMI$B$N4X78$G!":G=i$NL?Na$O%9%?%C%/%]%$%s%?$N%;%C%H$,I,?\$G$"$k!#(B */
/*   $B:G=i$KFbB"(BRAM$B>e$K$H$j!"30It(BRAM$B$K4X$9$k=i4|2=$N8e$K30It(BRAM$B>e$K(B   */
/*   $B2~$a$F@_Dj$7D>$9I,MW$,$"$k!#(B(romcrt*.s$B$G5-=R:Q$_(B)               */
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
    0xfff000 - 0xffff0f (0x00ff0 bytes) : Stack & Data Area (4kB)
*/
MEMORY
{
    /* ROM$B2=$7$?$H$-$N%Y%/%?NN0h(B */
    /*   $B%j%;%C%H8e$OI,$:(B Flash-ROM $BNN0h$K$J$C$F$$$k(B */
    vectors	: o = 0x000000, l = 0x100
    /* $B%W%m%0%i%`NN0h$H$7$F;H$($k(B Flash-ROM $BNN0h(B */
    /*   $B@hF,$N(B256$B%P%$%HJ,$O%Y%/%?NN0h$H$7$F;HMQ$7$F$$$k(B */
    rom		: o = 0x000100, l = 0x7ff00
    /* $B%G!<%?NN0h$N@_Dj(B */
    /*   $BFbB"(BRAM $B$+(B $B30IU$1(BRAM $B$N!V$I$A$i$+$@$1!W$,A*Br$G$-$k(B */
    /* $B30IU$1(BRAM(128k)$B$r%G!<%?NN0h$K;H$&>l9g$O$3$A$i$rM-8z$K$9$k(B */
    ram	   	: o = 0x200000, l = 0x20000
    /* $BFbB"(BRAM(8K)$B$r%G!<%?NN0h$K;H$&>l9g$O$3$A$i$rM-8z$K$9$k(B */
    /* ram		: o = 0xfff000, l = 0xff0 */
}
SECTIONS                
{                   
.vectors : {
	/* $BNc30=hM}%Y%/%?$N=hM}(B                         */
	/*   ROM$B$N@hF,(B256$B%P%$%HJ,$N%Y%/%?NN0h$KCV$+$l$k(B */
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
/* $B%3!<%INN0h!"J8;zNs!"Dj?t$NNN0h(B $B"*(B $BFbB"(BROM */
.text : {
      __text_start = . ;
      *(.text)                
      *(.strings)
      *(.rodata)              
      __text_end = . ; 
}  > rom
/* C++$B$N%3%s%9%H%i%/%?$H%G%9%H%i%/%?(B $B"*(B $BFbB"(BROM */
.tors : {
    __ctors = . ;
    *(.ctors)
    __ctors_end = . ;
    __dtors = . ;
    *(.dtors)
    __dtors_end = . ;
    __idata_start = . ;
    }  > rom
/* $B=i4|CM$r$b$DJQ?t(B $B"*(B $BFbB"(BROM $B"*(B($BE>Aw(B)$B"*(B RAM$BNN0h(B */
/*   RAM$BNN0h$X$NE>Aw$O!"(Bromcrt.s $B$G9T$&(B */
.data : AT(__idata_start) {
    __data_start = .;
    *(.data)
    __data_end = . ;
    }  > ram
/* $B=i4|CM$r$b$?$J$$JQ?t(B $B"*(B RAM$BNN0h(B */
.bss : {
    __bss_start = .;
    *(.bss)
    *(COMMON)
    __bss_end = .;
    }  >ram
}
