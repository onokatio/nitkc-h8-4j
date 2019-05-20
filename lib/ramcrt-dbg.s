/*   H8/3052版 RAM実行用のスタートアップルーチン (2008/4/3 和崎) */
/*   スタックは外部RAM上にとる                                   */
/*   .bss領域の 0 クリアはしない                                 */
    .h8300h
    .section .text
    .global _start
_start:
/* 必要最低限のレジスタ初期化は既にstubで実行済み */
/*   (内蔵RAM・ROMと外部RAMを使用可にするためのもの) */
/* 外部RAM上にスタックポインタをセット */
	mov.l   #__ext_stack, sp
/* main()を呼び出す */
/*   実行が終了したらスリープ状態になる */
__go_main:
    jsr     @_main
    sleep
    jmp     @__go_main
