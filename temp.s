mov r10d, DWORD[sorted_array]
mov DWORD[rcx + 4], r10d
mov r10d, DWORD[sorted_array + 4]
mov DWORD[rcx + 16], r10d
mov r10d, DWORD[sorted_array + 8]
mov DWORD[rcx + 28], r10d
mov r10d, DWORD[sorted_array + 12]
mov DWORD[rcx + 40], r10d

movsxd r10, DWORD[rcx]
; 	movsxd r11, DWORD[rcx + 24]
; 	movsxd r12, DWORD[rcx + 4]
; 	movsxd r13, DWORD[rcx + 28]
; 	sub r10, r11
; 	sub r12, r13
;
; 	; mov QWORD[temp_floating], r10
; 	cvtsi2sd xmm1, r10
; 	cvtsi2sd xmm0, r12
; 	divsd xmm0, xmm1
; 	cvtsi2sd xmm2, DWORD[rcx]
; 	cvtsi2sd xmm1, DWORD[rcx + 4]
; 	mulsd xmm2, xmm0
; 	subsd xmm1, xmm2
; 	movsd QWORD[temp_floating], xmm0
; 	movsd QWORD[temp_floating + 8], xmm1
;
; 	mov r12d, DWORD[rdx]
; 	mov DWORD[temp_integer], r12d
; 	mov r12d, DWORD[rdx + 4]
; 	mov DWORD[temp_integer + 4], r12d
; 	mov r12d, DWORD[rdx + 8]
; 	mov DWORD[temp_integer + 8], r12d
;
; 	push rdx
; 	movsxd r10, DWORD[rcx + 4]
; 	movsxd r15, DWORD[rcx + 28]
; loop:
; 	mov r12, rdi
; 	cvtsi2sd xmm2, r10
; 	subsd xmm2, xmm1
; 	divsd xmm2, xmm0
; 	cvtsd2si r11, xmm2
; 	movsxd rax, DWORD[temp_integer + 8]
; 	mul r10
; 	mov r13, rax
; 	mov rax, r11
; 	mov r14, 3
; 	mul r14
; 	add rax, r13
;
; 	add r12, rax
; 	mov BYTE[r12], 60
; 	mov BYTE[r12 + 1], 60
; 	mov BYTE[r12 + 2], 60
;
; 	add r10, 1
; 	cmp r10, r15
; 	jne loop
;
; 	pop rdx
