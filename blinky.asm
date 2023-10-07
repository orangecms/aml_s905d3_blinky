// load a 32-bit immediate using MOV
// see https://modexp.wordpress.com/2018/10/30/arm64-assembly/
.macro movl Wn, imm
    movz    \Wn,  \imm & 0xFFFF
    movk    \Wn, (\imm >> 16) & 0xFFFF, lsl 16
.endm

_start:
  b _blink // comment out to get a print loop instead
  b _print

_blink:
  movl x10, 0xff634458 // GPIO2 EN
  movl x11, 0xff63445C // GPIO2 OUT
  movl w12, 0x3fffffff
  str w12, [x10]
_bloop:
  movl w12, 0xffffff37
  str w12, [x11]
  movl w12, 0xffffffff
  str w12, [x11]
  b _bloop

_print:
  movl x8,  0xFFD24000
  mov  w13, 0x42
_ploop:
  str w13, [x8]
  b _ploop

