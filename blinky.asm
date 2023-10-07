// load a 32-bit immediate using MOV
// see https://modexp.wordpress.com/2018/10/30/arm64-assembly/
.macro movl Wn, imm
    movz    \Wn,  \imm & 0xFFFF
    movk    \Wn, (\imm >> 16) & 0xFFFF, lsl 16
.endm

_start:
  movl x10, 0xffd0f0d0
  ldr w12, [x10]
  movl w11, !((1 << 18) | (1 << 25))
  and w12, w12, w11
  str w12, [x10]

  b _blink // comment out to get a print loop instead
  b _print // FIXME: this doesn't work yet... :/

_blink:
  movl x10, 0xff634458 // GPIO2 EN
  movl x11, 0xff63445C // GPIO2 OUT
  movl w12, 0xffffff37
  str w12, [x10]
  movl w10, 0xffffffff

_bloop:
  movl w12, 0xffffff37
  movl w9, 0x00a00000

l1:
  str w12, [x11]
  str w10, [x11]
  sub w9, w9, 1
  cmp w9, 0
  bne l1

  movl w12, 0xffffffb7
  movl w9, 0x00c00000
l2:
  str w12, [x11]
  str w10, [x11]
  sub w9, w9, 1
  cmp w9, 0
  bne l2

  movl w12, 0xffffffbf
  movl w9, 0x00e00000
l3:
  str w12, [x11]
  str w10, [x11]
  sub w9, w9, 1
  cmp w9, 0
  bne l3

  str w10, [x11]
  movl w9, 0x04800000
l4:
  sub w9, w9, 1
  cmp w9, 0
  bne l4
  b _bloop

_print:
  movl x8,  0xFFD24000 // UART0, UART1 @FFD23000, UART2 @FFD22000
  mov  w13, 0x42
_ploop:
  str w13, [x8]
  b _ploop

