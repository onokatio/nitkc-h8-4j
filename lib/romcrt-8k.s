/*   H8/3052版 ROM化用のスタートアップルーチン (2008/4/2 和崎) */
/*   RAM版と異なるのは、.data領域を初期化すること              */
/*   .bss領域の 0 クリアはしない                               */
	.h8300h
	.section .text
	.global _start
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
	mov.b	#9, r0l       /* 内蔵RAM使用、スリープ命令でスリープ */
	mov.b	r0l, @__syscr
	mov.b	#0, r0l       /* 内蔵RAMによるエミュレーションなし */
	mov.b	r0l, @__ramcr
	mov.b	#0xff, r0l    /* 外部エリアは全て8ビット幅 */
	mov.b	r0l, @__abwcr
	mov.b	#0xff, r0l    /* 外部エリアは全て3ステートアクセス */
	mov.b	r0l, @__astcr
	mov.b	#4, r0l       /* ウェイト禁止 */
	mov.b	r0l, @__wcr
	mov.b	#0xff, r0l    /* 端子ウェイトモード禁止 */
	mov.b	r0l, @__wcer
	mov.b	#0xfe, r0l    /* A23-A21を開放、バス権開放禁止 */
	mov.b	r0l, @__brcr
	mov.b	#0xff, r0l    /* P1XはA7-A0を出力 */
	mov.b	r0l, @__p1ddr
	mov.b	#0xff, r0l    /* P2XはA15-A8を出力 */
	mov.b	r0l, @__p2ddr
	mov.b	#0xf1, r0l    /* P50はA16を出力(P51-P53は使用可) */
	mov.b	r0l, @__p5ddr
	mov.b	#0x0f, r0l    /* CS7-CS4は出力禁止, デフォルト */
	mov.b	r0l, @__cscr
	mov.b	#0xe8, r0l    /* CS1を出力 */
	mov.b	r0l, @__p8ddr
/* .data領域の初期化 */
/*   er0：.data領域の先頭アドレス (コピー先のポインタ) */
/*   er1：.data領域の終了アドレス+1 (.bss領域の先頭アドレス) */
/*   er2：初期値のあるROM内配置アドレス (コピー元のポインタ) */
/*   r3h：初期値コピー用のテンポラリ */
	mov.l	#__data_start,er0
	mov.l	#__data_end,er1
	mov.l	#__idata_start,er2
__loop_copy:
	cmp.l	er0,er1		/* er1 - er0 を計算する */
	ble	__go_main	/* er1 <= er0 なら初期化終了 */ 
	mov.b	@er2+,r3h	/* ROM領域からデータ読み出し 元ポインタ +1 */
	mov.b	r3h,@er0	/* データをコピー先に */
	inc.l	#1,er0		/* コピー先のポインタ +1 */
	bra	__loop_copy	
/* main()を呼び出す */
/*   実行が終了したらスリープ状態になる */
__go_main:
	jsr     @_main
	sleep
	bra     __go_main
