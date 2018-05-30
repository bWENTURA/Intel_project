global f
section .text
f:
	push rbp
	mov rbp, rsp

	mov r10, rdx
	mov rax, r10
	mov r11, 3
	mul r11
	mov rdx, r10

	mov r10, rdx
	mov r11, rax
	mov r12, rdi
bitmap_clear_outside_loop:
	mov r13, rax
bitmap_clear_inside_loop:
	mov BYTE[r12], 0xff
	inc r12
	dec r13
	cmp r13, 0
	jne bitmap_clear_inside_loop
	mov r12, rdi
	sub r12, r11
	add r11, rax
	dec r10
	cmp r10, 0
	jne bitmap_clear_outside_loop

	mov r10, rdx
	mov rax, r10
	mul rcx
	mov rdx, r10

	mov r10, rsi
z_buffer_clear_loop:
	mov BYTE[r10], 0
	inc r10
	dec rax
	jne z_buffer_clear_loop


end:
	mov rsp, rbp
	pop rbp
	ret
