/*
  H8-3052F RAM版リンカスクリプト (スタック領域とデータ領域が外部RAM)
  2008/4/4 和崎
*/
OUTPUT_FORMAT("coff-h8300")
OUTPUT_ARCH(h8300h)
ENTRY("_start")
/*   内蔵RAMのスタックポインタの初期化アドレス */
PROVIDE(_stack = 0xffff10);
/*   外部RAMのスタックポインタの初期化アドレス */
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
    /* 割り込みを使うときにはベクタアドレスの書き換えが必須のため    */
    /* ベクタ領域 0x000000-0x000fff を内蔵RAMにマッピングする        */
    /* ( 0x000000 - 0x000fff <> 0xffe000 - 0xffefff となる)          */
    /*   但し、ROMエミュレーション機能はユーザ側の責任で行うこと     */
    /*   また、このとき内蔵RAMは残り4kB弱しか使えないので注意        */
    vectors	: o = 0xffe000, l = 0x400
    /* RAM領域を特に分断しないで詰めてロードする */
    ram		: o = 0x200000, l = 0x20000
}
SECTIONS                
{                   
.vectors : {
	/* 例外処理ベクタの処理 */
	/* ROMエミュレーションのため、RAM上に全て置かれる */
	/* 割り込みハンドラの関数名はDEFINED内の文字列            */
	/*   但し、先頭の _ をとったものになる                    */
	/*   (例) IRQ0のとき： _int_irq0 => void int_irq0(void)   */
	/*   割り込みハンドラでは、引数も戻り値もとれないので注意 */
	/* 割り込みハンドラが無いときは、全てスタートになる */
	/*   つまり、リセットと同じプログラムが実行される   */
	/* ベクタ名 ベクタ番号 でコメントを先頭に付加 */
	/* リセットベクタ 0 */
	LONG(ABSOLUTE(_start))
	/* リザーブ 1-6 */
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	/* NMIベクタ 7 */
	LONG(DEFINED(_int_nmi)?ABSOLUTE(_int_nmi):ABSOLUTE(_start))
	/* トラップベクタ 8-11 */
	LONG(DEFINED(_int_trap0)?ABSOLUTE(_int_trap0):ABSOLUTE(_start))
	LONG(DEFINED(_int_trap1)?ABSOLUTE(_int_trap1):ABSOLUTE(_start))
	LONG(DEFINED(_int_trap2)?ABSOLUTE(_int_trap2):ABSOLUTE(_start))
	LONG(DEFINED(_int_trap3)?ABSOLUTE(_int_trap3):ABSOLUTE(_start))
	/* IRQベクタ 12-17 */
	LONG(DEFINED(_int_irq0)?ABSOLUTE(_int_irq0):ABSOLUTE(_start))
	LONG(DEFINED(_int_irq1)?ABSOLUTE(_int_irq1):ABSOLUTE(_start))
	LONG(DEFINED(_int_irq2)?ABSOLUTE(_int_irq2):ABSOLUTE(_start))
	LONG(DEFINED(_int_irq3)?ABSOLUTE(_int_irq3):ABSOLUTE(_start))
	LONG(DEFINED(_int_irq4)?ABSOLUTE(_int_irq4):ABSOLUTE(_start))
	LONG(DEFINED(_int_irq5)?ABSOLUTE(_int_irq5):ABSOLUTE(_start))
	/* リザーブ 18-19 */
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	/* インターバルタイマ(ウォッチドッグタイマ) 20 */
	LONG(DEFINED(_int_wovi)?ABSOLUTE(_int_wovi):ABSOLUTE(_start))
	/* コンペアマッチ(リフレッシュコントローラ) 21 */
	LONG(DEFINED(_int_cmi)?ABSOLUTE(_int_cmi):ABSOLUTE(_start))
	/* リザーブ 22-23 */
	LONG(ABSOLUTE(_start))
	LONG(ABSOLUTE(_start))
	/* 16ビットタイマch0 24-26 */
	LONG(DEFINED(_int_imia0)?ABSOLUTE(_int_imia0):ABSOLUTE(_start))
	LONG(DEFINED(_int_imib0)?ABSOLUTE(_int_imib0):ABSOLUTE(_start))
	LONG(DEFINED(_int_ovi0)?ABSOLUTE(_int_ovi0):ABSOLUTE(_start))
	/* リザーブ 27 */
	LONG(ABSOLUTE(_start))
	/* 16ビットタイマch1 28-30 */
	LONG(DEFINED(_int_imia1)?ABSOLUTE(_int_imia1):ABSOLUTE(_start))
	LONG(DEFINED(_int_imib1)?ABSOLUTE(_int_imib1):ABSOLUTE(_start))
	LONG(DEFINED(_int_ovi1)?ABSOLUTE(_int_ovi1):ABSOLUTE(_start))
	/* リザーブ 31 */
	LONG(ABSOLUTE(_start))
	/* 16ビットタイマch2 32-34 */
	LONG(DEFINED(_int_imia2)?ABSOLUTE(_int_imia2):ABSOLUTE(_start))
	LONG(DEFINED(_int_imib2)?ABSOLUTE(_int_imib2):ABSOLUTE(_start))
	LONG(DEFINED(_int_ovi2)?ABSOLUTE(_int_ovi2):ABSOLUTE(_start))
	/* リザーブ 35 */
	LONG(ABSOLUTE(_start))
	/* 16ビットタイマch3 36-38 */
	LONG(DEFINED(_int_imia3)?ABSOLUTE(_int_imia3):ABSOLUTE(_start))
	LONG(DEFINED(_int_imib3)?ABSOLUTE(_int_imib3):ABSOLUTE(_start))
	LONG(DEFINED(_int_ovi3)?ABSOLUTE(_int_ovi3):ABSOLUTE(_start))
	/* リザーブ 39 */
	LONG(ABSOLUTE(_start))
	/* 16ビットタイマch4 40-42 */
	LONG(DEFINED(_int_imia4)?ABSOLUTE(_int_imia4):ABSOLUTE(_start))
	LONG(DEFINED(_int_imib4)?ABSOLUTE(_int_imib4):ABSOLUTE(_start))
	LONG(DEFINED(_int_ovi4)?ABSOLUTE(_int_ovi4):ABSOLUTE(_start))
	/* リザーブ 43 */
	LONG(ABSOLUTE(_start))
	/* DMAC 44-47 */
	LONG(DEFINED(_int_dend0a)?ABSOLUTE(_int_dend0a):ABSOLUTE(_start))
	LONG(DEFINED(_int_dend0b)?ABSOLUTE(_int_dend0b):ABSOLUTE(_start))
	LONG(DEFINED(_int_dend1a)?ABSOLUTE(_int_dend1a):ABSOLUTE(_start))
	LONG(DEFINED(_int_dend1b)?ABSOLUTE(_int_dend1b):ABSOLUTE(_start))
	/* リザーブ 48-51 */
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
	/* A/Dエンド 60 */
	LONG(DEFINED(_int_adi)?ABSOLUTE(_int_adi):ABSOLUTE(_start))
	/* リザーブ 61-63 */
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
