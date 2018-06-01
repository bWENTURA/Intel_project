section .text
global f

section .data
	temp_integer:	times 16 db	0
	temp_double: times 32 db 0
	colors:	times 4 db 0
	temp_coordinates: times 144 db 0
	temp_calculations: times 48 db 0
	temp_sorted_pair: times	16 db 0
	iterator_1: times 4 db 0
	iterator_2: times 4 db 0

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

			;store sets of coordinates

  mov r10, rcx
	mov rax, temp_coordinates
	mov r12, 2
	mov r13, 1
	sub r10, 12
loop_sets_outside:
	add r13, 1
	add r10, 12
	mov r15, r10
loop_sets_inside:
	add r15, 12
	mov r11d, DWORD[r10]
	mov DWORD[rax], r11d
	mov r11d, DWORD[r10 + 4]
	mov DWORD[rax + 4], r11d
	mov r11d, DWORD[r10 + 8]
	mov DWORD[rax + 8], r11d
	mov r11d, DWORD[r15]
	mov DWORD[rax + 12], r11d
	mov r11d, DWORD[r15 + 4]
	mov DWORD[rax + 16], r11d
	mov r11d, DWORD[r15 + 8]
	mov DWORD[rax + 20], r11d
	mov r11d, DWORD[r15 + 12]
	mov DWORD[rax + 24], r11d
	mov r11d, DWORD[r15 + 16]
	mov DWORD[rax + 28], r11d
	mov r11d, DWORD[r15 + 20]
	mov DWORD[rax + 32], r11d
	add rax, 36
	dec r13
	cmp r13, 0
	jne loop_sets_inside
	dec r12
	cmp r12, 0
	jne loop_sets_outside

	mov r10, rcx
	mov r11d, DWORD[r10]
	mov DWORD[rax], r11d
	mov r11d, DWORD[r10 + 4]
	mov DWORD[rax + 4], r11d
	mov r11d, DWORD[r10 + 8]
	mov DWORD[rax + 8], r11d
	mov r11d, DWORD[r10 + 12]
	mov DWORD[rax + 12], r11d
	mov r11d, DWORD[r10 + 16]
	mov DWORD[rax + 16], r11d
	mov r11d, DWORD[r10 + 20]
	mov DWORD[rax + 20], r11d
	mov r11d, DWORD[r10 + 36]
	mov DWORD[rax + 24], r11d
	mov r11d, DWORD[r10 + 40]
	mov DWORD[rax + 28], r11d
	mov r11d, DWORD[r10 + 44]
	mov DWORD[rax + 32], r11d

			;temp_coordinates set is good

			;section filling the bitmap with values

	push r9

	mov r12d, DWORD[rdx]
	mov DWORD[temp_integer], r12d
	mov r12d, DWORD[rdx + 4]
	mov DWORD[temp_integer + 4], r12d
	mov r12d, DWORD[rdx + 8]
	mov DWORD[temp_integer + 8], r12d

	mov rbx, temp_coordinates

	movsxd r10, DWORD[rbx]
	movsxd r11, DWORD[rbx + 12]
	movsxd r12, DWORD[rbx + 4]
	movsxd r13, DWORD[rbx + 16]
	sub r10, r11
	sub r12, r13

	cvtsi2sd xmm1, r10
	cvtsi2sd xmm0, r12
	divsd xmm0, xmm1
	cvtsi2sd xmm2, DWORD[rcx]
	cvtsi2sd xmm1, DWORD[rcx + 4]
	mulsd xmm2, xmm0
	subsd xmm1, xmm2
	movsd QWORD[temp_calculations], xmm0
	movsd QWORD[temp_calculations + 8], xmm1

	movsxd r10, DWORD[rbx]
	movsxd r11, DWORD[rbx + 24]
	movsxd r12, DWORD[rbx + 4]
	movsxd r13, DWORD[rbx + 28]
	sub r10, r11
	sub r12, r13

	cvtsi2sd xmm1, r10
	cvtsi2sd xmm0, r12
	divsd xmm0, xmm1
	cvtsi2sd xmm2, DWORD[rcx]
	cvtsi2sd xmm1, DWORD[rcx + 4]
	mulsd xmm2, xmm0
	subsd xmm1, xmm2
	movsd QWORD[temp_calculations + 16], xmm0
	movsd QWORD[temp_calculations + 24], xmm1

	movsxd r10, DWORD[rbx + 12]
	movsxd r11, DWORD[rbx + 24]
	movsxd r12, DWORD[rbx + 16]
	movsxd r13, DWORD[rbx + 28]
	sub r10, r11
	sub r12, r13

	cvtsi2sd xmm1, r10
	cvtsi2sd xmm0, r12
	divsd xmm0, xmm1
	cvtsi2sd xmm2, DWORD[rcx + 24]
	cvtsi2sd xmm1, DWORD[rcx + 28]
	mulsd xmm2, xmm0
	subsd xmm1, xmm2
	movsd QWORD[temp_calculations + 32], xmm0
	movsd QWORD[temp_calculations + 40], xmm1

	movsxd r9, DWORD[rbx + 4]
	movsxd r10, DWORD[rbx + 16]
	movsxd r11, DWORD[rbx + 28]

	mov rax, 2
	mov rbx, temp_calculations
	sub rbx, 16

loop_middle:
	add rbx, 16
	dec r9
loop_inside:
	mov r12, rdi
	inc r9

	cvtsi2sd xmm0, r9
	subsd xmm0, [rbx + 8]
	divsd xmm0, [rbx]
	mov r13, 3
	cvtsi2sd xmm1, r13
	mulsd xmm0, xmm1

	cvtsi2sd xmm1, r9
	subsd xmm1, [rbx + 24]
	divsd xmm1, [rbx + 16]
	mov r13, 3
	cvtsi2sd xmm2, r13
	mulsd xmm1, xmm2

	cvtsi2sd xmm2, DWORD[temp_integer + 8]
	cvtsi2sd xmm3, r9
	mulsd xmm2, xmm3

	addsd xmm0, xmm2
	cvtsd2si r13, xmm0

	addsd xmm1, xmm2
	cvtsd2si r14, xmm1

	cmp r13, r14
	jb skip_change

	mov r15, r13
	mov r13, r14
	mov r14, r15

	movsd xmm0, xmm1

skip_change:
	sub r14, r13
	inc r14
	add r12, r13

color_loop:
	mov BYTE[r12], 90
	; mov BYTE[r12 + 1], 60
	; mov BYTE[r12 + 2], 60
	add r12, 1
	sub r14, 1
	cmp r14, 0
	jne color_loop

	; inc r9
	cmp r9, r10
	jne loop_inside

	mov r10, r11

	dec rax
	cmp rax, 0
	jne loop_middle

	; pop r9
	cvtsi2sd xmm1, r11
	pop r9
	movq [r9], xmm1










			;end of second section
exit:

	mov rsp, rbp
	pop rbp
	ret
