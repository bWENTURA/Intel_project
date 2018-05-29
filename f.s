global f
section .text
f:
	push rbp
	mov rbp, rsp
	push rdx
	push rcx


	mov rax, rdx
	mul rcx
	mov rcx, 3
	mul rcx

	push rax

	mov rax, [rbp - 8]
	mov rcx, [rbp -16]
	mul rcx

	mov rax, [rbp -8]
	mov DWORD[r8], eax


	pop rax
end:
	pop rcx
	pop rdx
	mov rsp, rbp
	pop rbp
	ret
