/*   H8/3052版 RAM実行用のスタートアップルーチン (2008/4/3 和崎) */
/*   スタックは内蔵RAM上にとる                                   */
/*   .bss領域の 0 クリアはしない                                 */
    .h8300h
    .section .text
    .global _start
_start:
/* 初期化に必要な各レジスタの定義 */
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
/* 内蔵RAM上にスタックポインタをセット */
	mov.l   #_stack, sp    /* NMI対策、内蔵RAM：0xffff10 */
/* 必要最低限のレジスタ初期化 */
/*   内蔵RAM・ROMと外部RAMを使用可にするためのもの */
	mov.l	#__syscr, er0
	mov.b	#9, @er0       /* 内蔵RAM使用、スリープ命令でスリープ */
	mov.l	#__ramcr, er0
	mov.b	#0, @er0       /* 内蔵RAMによるエミュレーションなし */
	mov.l	#__abwcr, er0
	mov.b	#0xff, @er0    /* 外部エリアは全て8ビット幅 */
	mov.l	#__astcr, er0
	mov.b	#0xff, @er0    /* 外部エリアは全て3ステートアクセス */
	mov.l	#__wcr, er0
	mov.b	#4, @er0       /* ウェイト禁止 */
	mov.l	#__wcer, er0
	mov.b	#0xff, @er0    /* 端子ウェイトモード禁止 */
	mov.l	#__brcr, er0
	mov.b	#0xfe, @er0    /* A23-A21を開放、バス権開放禁止 */
	mov.l	#__p1ddr, er0
	mov.b	#0xff, @er0    /* P1XはA7-A0を出力 */
	mov.l	#__p2ddr, er0
	mov.b	#0xff, @er0    /* P2XはA15-A8を出力 */
	mov.l	#__p5ddr, er0
	mov.b	#0xf1, @er0    /* P50はA16を出力(P51-P53は使用可) */
	mov.l	#__cscr, er0
	mov.b	#0x0f, @er0    /* CS7-CS4は出力禁止, デフォルト */
	mov.l	#__p8ddr, er0
	mov.b	#0xe8, @er0    /* CS1を出力 */
/* main()を呼び出す */
/*   実行が終了したらスリープ状態になる */
go_main:
    jsr     @_main
    sleep
    jmp     @__go_main
