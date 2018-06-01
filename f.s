section .text
global f

section .data
	temp_integer:	times 16 db	0
	temp_floating: times 16 db 0

f:
	push rbp
	mov rbp, rsp

			;first section - clearing bitmap and z-buffer array

	mov r10, rdx
	movsxd rax, DWORD[rdx]
	mov r11, 3
	mul r11
	mov rdx, r10

	mov r11d, DWORD[rdx + 8]
	movsxd r14, r11d
	mov r11, r14

	movsxd r10, DWORD[rdx + 4]
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
	add r12, r14
	add r14, r11
	dec r10
	cmp r10, 0
	jne bitmap_clear_outside_loop



	push rdx
	movsxd rax, DWORD[rdx]
	movsxd r10, DWORD[rdx + 4]
	mul r10
	pop rdx

	mov r10, rsi
z_buffer_clear_loop:
	mov BYTE[r10], 0
	inc r10
	dec rax
	jne z_buffer_clear_loop

			;end of bitmap and -buffer section

			;section sorting array of coordinates in correct order, with lowest y coordinate first

	mov r10d, DWORD[rcx + 4]
	mov r12d, DWORD[rcx + 16]
	cmp r10d, r12d
	jb skip_first

	mov r10d, DWORD[rcx + 16]
	mov r12d, DWORD[rcx + 4]

skip_first:

	mov r11d, DWORD[rcx + 28]
	mov r13d, DWORD[rcx + 40]
	cmp r11d, r13d
	jb skip_second

	mov r11d, DWORD[rcx + 40]
	mov r13d, DWORD[rcx + 28]

skip_second:

	cmp r10d, r11d
	jb skip_third

	mov r15d, r10d
	mov r10d, r11d
	mov r11d, r15d

skip_third:

	cmp r12d, r13d
	jb skip_fourth

	mov r15d, r12d
	mov r12d, r13d
	mov r13d, r15d

skip_fourth:

	cmp r11d, r12d
	jb skip_fifth

	mov r15d, r11d
	mov r11d, r12d
	mov r12d, r15d

skip_fifth:

	mov r15, temp_integer
	mov DWORD[r15], r10d
	mov DWORD[r15 + 4], r11d
	mov DWORD[r15 + 8], r12d
	mov DWORD[r15 + 12], r13d


	mov r10, 3
	mov r11, rcx
	add r11, 4
	mov r12, temp_integer
swift_loop_first:
	mov r13d, DWORD[r12]
	mov r14, r11
swift_loop_second:
	add r14, 12
	; movsxd rbx, DWORD[r14]
	; mov QWORD[r9], rb
	cmp r13d, DWORD[r14 - 12]
	jne swift_loop_second

	sub r14, 12
	mov r15d, DWORD[r11]
	mov r13d, DWORD[r14]
	mov DWORD[r14], r15d
	mov DWORD[r11], r13d
	mov r15d, DWORD[r11 + 4]
	mov r13d, DWORD[r14 + 4]
	mov DWORD[r14 + 4], r15d
	mov DWORD[r11 + 4], r13d
	mov r15d, DWORD[r11 - 4]
	mov r13d, DWORD[r14 - 4]
	mov DWORD[r14 - 4], r15d
	mov DWORD[r11 - 4], r13d

	add r11, 12
	add r12, 4
	dec r10
	cmp r10, 0
	jne swift_loop_first

			;end of section which sort coordinates

	movsxd r10, DWORD[rcx]
	movsxd r11, DWORD[rcx + 12]
	movsxd r12, DWORD[rcx + 4]
	movsxd r13, DWORD[rcx + 16]
	sub r10, r11
	sub r12, r13

	; mov QWORD[temp_floating], r10
	cvtsi2sd xmm1, r10
	cvtsi2sd xmm0, r12
	divsd xmm0, xmm1
	cvtsi2sd xmm2, DWORD[rcx]
	cvtsi2sd xmm1, DWORD[rcx + 4]
	mulsd xmm2, xmm0
	subsd xmm1, xmm2
	movsd QWORD[temp_floating], xmm0
	movsd QWORD[temp_floating + 8], xmm1

	mov r12d, DWORD[rdx]
	mov DWORD[temp_integer], r12d
	mov r12d, DWORD[rdx + 4]
	mov DWORD[temp_integer + 4], r12d
	mov r12d, DWORD[rdx + 8]
	mov DWORD[temp_integer + 8], r12d

	push rdx
	movsxd r10, DWORD[rcx + 4]
	movsxd r15, DWORD[rcx + 16]
loop:
	mov r12, rdi
	cvtsi2sd xmm2, r10
	subsd xmm2, xmm1
	divsd xmm2, xmm0
	cvtsd2si r11, xmm2
	movsxd rax, DWORD[temp_integer + 8]
	mul r10
	mov r13, rax
	mov rax, r11
	mov r14, 3
	mul r14
	add rax, r13

	add r12, rax
	mov BYTE[r12], 60
	mov BYTE[r12 + 1], 60
	mov BYTE[r12 + 2], 60

	add r10, 1
	cmp r10, r15
	jne loop

	pop rdx

	; cvtsi2sd xmm2, r11
	movq [r9], xmm1










			;end of second section
	pop rdx
exit:

	mov rsp, rbp
	pop rbp
	ret
