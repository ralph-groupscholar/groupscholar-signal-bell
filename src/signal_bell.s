// groupscholar-signal-bell: AArch64 macOS assembly CLI
// Builds a SQL insert statement for ops signal logging.

.section __TEXT,__text,regular,pure_instructions
.globl _main

_main:
  stp x29, x30, [sp, #-16]!
  mov x29, sp

  mov x19, x0 // argc
  mov x20, x1 // argv

  cmp x19, #4
  b.ge have_args

  adrp x0, usage@PAGE
  add x0, x0, usage@PAGEOFF
  bl _puts
  mov w0, #1
  b done

have_args:
  ldr x21, [x20, #8]   // argv[1]
  ldr x22, [x20, #16]  // argv[2]
  ldr x23, [x20, #24]  // argv[3]

  // Optional argv[4] = source, default to "manual".
  cmp x19, #5
  b.ge have_source
  adrp x24, default_source@PAGE
  add x24, x24, default_source@PAGEOFF
  b source_ready
have_source:
  ldr x24, [x20, #32]  // argv[4]
source_ready:

  // Optional argv[5] = owner, default to "unassigned".
  cmp x19, #6
  b.ge have_owner
  adrp x25, default_owner@PAGE
  add x25, x25, default_owner@PAGEOFF
  b owner_ready
have_owner:
  ldr x25, [x20, #40]  // argv[5]
owner_ready:

  // Reject inputs containing single quotes to prevent SQL breakage.
  mov x0, x21
  mov w1, #39
  bl _strchr
  cbnz x0, quote_error

  mov x0, x22
  mov w1, #39
  bl _strchr
  cbnz x0, quote_error

  mov x0, x23
  mov w1, #39
  bl _strchr
  cbnz x0, quote_error

  mov x0, x24
  mov w1, #39
  bl _strchr
  cbnz x0, quote_error

  mov x0, x25
  mov w1, #39
  bl _strchr
  cbnz x0, quote_error

  // Build SQL in buffer with strcpy/strcat to avoid varargs ABI issues.
  adrp x0, buffer@PAGE
  add x0, x0, buffer@PAGEOFF
  adrp x1, sql_prefix@PAGE
  add x1, x1, sql_prefix@PAGEOFF
  bl _strcpy

  adrp x0, buffer@PAGE
  add x0, x0, buffer@PAGEOFF
  mov x1, x21
  bl _strcat

  adrp x0, buffer@PAGE
  add x0, x0, buffer@PAGEOFF
  adrp x1, sql_mid@PAGE
  add x1, x1, sql_mid@PAGEOFF
  bl _strcat

  adrp x0, buffer@PAGE
  add x0, x0, buffer@PAGEOFF
  mov x1, x22
  bl _strcat

  adrp x0, buffer@PAGE
  add x0, x0, buffer@PAGEOFF
  adrp x1, sql_mid@PAGE
  add x1, x1, sql_mid@PAGEOFF
  bl _strcat

  adrp x0, buffer@PAGE
  add x0, x0, buffer@PAGEOFF
  mov x1, x23
  bl _strcat

  adrp x0, buffer@PAGE
  add x0, x0, buffer@PAGEOFF
  adrp x1, sql_mid@PAGE
  add x1, x1, sql_mid@PAGEOFF
  bl _strcat

  adrp x0, buffer@PAGE
  add x0, x0, buffer@PAGEOFF
  mov x1, x24
  bl _strcat

  adrp x0, buffer@PAGE
  add x0, x0, buffer@PAGEOFF
  adrp x1, sql_mid@PAGE
  add x1, x1, sql_mid@PAGEOFF
  bl _strcat

  adrp x0, buffer@PAGE
  add x0, x0, buffer@PAGEOFF
  mov x1, x25
  bl _strcat

  adrp x0, buffer@PAGE
  add x0, x0, buffer@PAGEOFF
  adrp x1, sql_suffix@PAGE
  add x1, x1, sql_suffix@PAGEOFF
  bl _strcat

  // puts(buffer)
  adrp x0, buffer@PAGE
  add x0, x0, buffer@PAGEOFF
  bl _puts

  mov w0, #0
  b done

quote_error:
  adrp x0, err_quote@PAGE
  add x0, x0, err_quote@PAGEOFF
  bl _puts
  mov w0, #2

 done:
  ldp x29, x30, [sp], #16
  ret

.section __TEXT,__cstring,cstring_literals
usage:
  .asciz "Usage: signal-bell <severity> <category> <note> [source] [owner]"
err_quote:
  .asciz "Error: input contains a single quote ('). Please remove or replace it."
sql_prefix:
  .asciz "insert into groupscholar_signal_bell.signals (severity, category, note, source, owner, created_at) values ('"
sql_mid:
  .asciz "','"
sql_suffix:
  .asciz "', now());"
default_source:
  .asciz "manual"
default_owner:
  .asciz "unassigned"

.section __DATA,__bss
  .balign 16
buffer:
  .skip 2048
