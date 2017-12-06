.intel_syntax noprefix
.text
.globl _aip_pton4
.globl _aip_ntop4

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
  je ndone                     /* end of string */
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
ndone:
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

_aip_ntop4:
  mov r8, 0x0                   /* output string position */
  mov r9, 0x0                   /* loop counter */
loop:
  rol edi, 0x8                  /* roll the next 8 bytes around */
  mov eax, edi                  /* we will preserve edi */
  and eax, 0xFF                 /* only interested in the first byte */
  mov edx, 0x0                  /* dividend = edx:eax */
  mov ecx, 0x64                 /* divisor = 100 */
  div ecx                       /* divide */
  cmp al, 0x0                   /* quotient = 0? */
  je char2                      /* if yes, move on */
  add al, 0x30                  /* itoa */
  mov byte ptr [rsi + r8], al   /* set into output string */
  add r8, 0x1                   /* output char position ++ */
char2:
  mov eax, edx                  /* move div remainder into eax */
  mov edx, 0x0                  /* dividend = edx:eax */
  mov ecx, 0xA                  /* divisor = 10 */
  div ecx                       /* divide */
  cmp al, 0x0                   /* quotient = 0? */
  je char3                      /* if yes, move on */
  add al, 0x30                  /* itoa */
  mov byte ptr [rsi + r8], al   /* set into output string */
  add r8, 0x1                   /* output char position ++ */
char3:
  add dl, 0x30                  /* itoa */
  mov byte ptr [rsi + r8], dl   /* set into output string */
  add r8, 0x1                   /* output char position ++ */
  cmp r9, 0x3                   /* fourth and final loop? */
  je pdone                      /* if yes, we're done */
  mov byte ptr [rsi + r8], 0x2E /* set ASCII "." into output string */
  add r8, 0x1                   /* output char position ++ */
  add r9, 0x1                   /* loop counter ++ */
  jmp loop
pdone:
  mov byte ptr [rsi + r8], 0x0  /* terminate string */
  mov eax, 0x0                  /* return value = 0, success */
  ret
