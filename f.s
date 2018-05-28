global f
section .text
f:
	push rbp
	mov rbp, rsp
	push rdx
	push rax
	push rdi

	mov rdx, [rbp - 24]
	mov rax, [rbp - 24]

	mov ch, [rdx]
	cmp ch, 0
	je end
	inc rax
	mov cl, [rax]
	cmp cl, 0
	je end

	loop:
		mov [rdx], cl
		mov [rax], ch
		add rdx, 2
		mov ch, [rdx]
		cmp ch, 0
		je end
		add rax, 2
		mov cl, [rax]
		cmp cl, 0
		jne	loop


end:
	pop rdi
	pop rax
	pop rdx
	mov rsp, rbp
	pop rbp
	ret
