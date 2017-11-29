.intel_syntax noprefix
.text
.globl _aip_pton4

_aip_pton4:
  mov edx, 0x0                 /* current char */
  mov rcx, 0x0                 /* char counter */
  mov eax, 0x0                 /* current octet */
  mov rbx, 0x3                 /* octet counter */
  mov r9, 0x0                  /* seen digit */
next_char:
  mov dl, [rdi + rcx]          /* next char */
  inc rcx                      /* char counter ++ */
  cmp dl, 0x0                  /* NULL? */
  je done                      /* end of string */
  cmp dl, 0x2E                 /* 0x2E = ASCII "." */
  je dot                       /* char is "." */
  cmp dl, 0x30                 /* 0x30 = ASCII "0" */
  jb err                       /* non-numeric */
  cmp dl, 0x39                 /* 0x39 = ASCII "9" */
  ja err                       /* non-numeric */
digit:
  mov r9, 0x1                  /* seen digit = true */
  sub dl, 0x30                 /* atoi */
  imul eax, 0xA                /* shift current eax contents, base 10 */
  add eax, edx                 /* add int value to eax */
  cmp eax, 0xFF                /* > 255? */
  ja err                       /* octet cannot exceed 255 */
  jmp next_char                /* move to the next char */
dot:
  cmp rbx, 0x0                 /* octet counter at 0? */
  je err                       /* too many dots */
  cmp r9, 0x1                  /* was the last character a digit? */
  jne err                      /* if not we started with a dot or double dot */
  mov r9, 0x0                  /* seen digit = false */
  mov byte ptr [rsi + rbx], al /* current octet into 2nd arg */
  dec rbx                      /* octet counter -- */
  mov eax, 0x0                 /* clear current octet */
  jmp next_char                /* move to the next char */
done:
  cmp ebx, 0x0                 /* octet counter at 0? */
  jne err                      /* if not we've consumed too little */
  cmp r9, 0x1                  /* was the last character a digit? */
  jne err                      /* if not we ended on a dot */
  mov byte ptr [rsi + rbx], al /* move the final octet into 2nd arg */
  mov eax, 0x0                 /* return value = 0, success */
  ret
err:
  mov eax, 0x1                 /* return value = 1, failure */
  ret
