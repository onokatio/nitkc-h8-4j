/*
  H8-3052F ROM版リンカスクリプト (スタック領域とデータ領域が外部RAM)
  2008/4/4 和崎
*/
OUTPUT_FORMAT("coff-h8300")
OUTPUT_ARCH(h8300h)
ENTRY("_start")
/* スタックポインタの設定 */
/* ＝＝＝＝＝ ROM化を行う時の注意点 ＝＝＝＝＝                       */
/*   外付けRAMをスタック領域に使うときに                             */
/*     PROVIDE(_stack = 0x220000);                                   */
/*   とすると、初めにCSのコントロールをしていないので、外部RAMが     */
/*   メモリ空間上に存在しないため、スタックが機能せず、暴走する。    */
/*   NMIの関係で、最初の命令はスタックポインタのセットが必須である。 */
/*   最初に内蔵RAM上にとり、外部RAMに関する初期化の後に外部RAM上に   */
/*   改めて設定し直す必要がある。(romcrt*.sで記述済み)               */
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
    0xfff000 - 0xffff0f (0x00ff0 bytes) : Stack & Data Area (4kB)
*/
MEMORY
{
    /* ROM化したときのベクタ領域 */
    /*   リセット後は必ず Flash-ROM 領域になっている */
    vectors	: o = 0x000000, l = 0x100
    /* プログラム領域として使える Flash-ROM 領域 */
    /*   先頭の256バイト分はベクタ領域として使用している */
    rom		: o = 0x000100, l = 0x7ff00
    /* データ領域の設定 */
    /*   内蔵RAM か 外付けRAM の「どちらかだけ」が選択できる */
    /* 外付けRAM(128k)をデータ領域に使う場合はこちらを有効にする */
    ram	   	: o = 0x200000, l = 0x20000
    /* 内蔵RAM(8K)をデータ領域に使う場合はこちらを有効にする */
    /* ram		: o = 0xfff000, l = 0xff0 */
}
SECTIONS                
{                   
.vectors : {
	/* 例外処理ベクタの処理                         */
	/*   ROMの先頭256バイト分のベクタ領域に置かれる */
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
/* コード領域、文字列、定数の領域 → 内蔵ROM */
.text : {
      __text_start = . ;
      *(.text)                
      *(.strings)
      *(.rodata)              
      __text_end = . ; 
}  > rom
/* C++のコンストラクタとデストラクタ → 内蔵ROM */
.tors : {
    __ctors = . ;
    *(.ctors)
    __ctors_end = . ;
    __dtors = . ;
    *(.dtors)
    __dtors_end = . ;
    __idata_start = . ;
    }  > rom
/* 初期値をもつ変数 → 内蔵ROM →(転送)→ RAM領域 */
/*   RAM領域への転送は、romcrt.s で行う */
.data : AT(__idata_start) {
    __data_start = .;
    *(.data)
    __data_end = . ;
    }  > ram
/* 初期値をもたない変数 → RAM領域 */
.bss : {
    __bss_start = .;
    *(.bss)
    *(COMMON)
    __bss_end = .;
    }  >ram
}
