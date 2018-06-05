section .text
global f

section .data
	temp_integer:	times 20 db	0
	temp_double: times 32 db 0
	colours:	times 12 db 0
	temp_coordinates: times 144 db 0
	temp_indexes: times 144 db 0
	temp_calculations: times 72 db 0
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
	mov r15, -255
	cvtsi2sd xmm0, r15
z_buffer_clear_loop:
	movsd QWORD[r10], xmm0
	add r10, 8
	dec rax
	jne z_buffer_clear_loop

			;end of bitmap and z-buffer section
			;store sets of coordinates

  mov r10, rcx
	mov rax, temp_coordinates
	mov r9, r8
	push r8
	mov rbx, temp_indexes
	mov r12, 2
	mov r13, 1
	sub r10, 12
	sub r9, 4
loop_sets_outside:
	add r13, 1
	add r10, 12
	add r9, 4
	mov r15, r10
	mov	r8, r9
loop_sets_inside:
	add r15, 12
	add r8, 4

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

	mov r11d, DWORD[r9]
	mov DWORD[rbx], r11d
	mov r11d, DWORD[r8]
	mov DWORD[rbx + 4], r11d
	mov r11d, DWORD[r8 + 4]
	mov DWORD[rbx + 8], r11d

	add rax, 36
	add rbx, 12
	dec r13
	cmp r13, 0
	jne loop_sets_inside
	dec r12
	cmp r12, 0
	jne loop_sets_outside

	pop r8

	mov r10, rcx
	mov r9, r8
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

	mov r11d, DWORD[r9]
	mov DWORD[rbx], r11d
	mov r11d, DWORD[r9 + 4]
	mov DWORD[rbx + 4], r11d
	mov r11d, DWORD[r9 + 12]
	mov DWORD[rbx + 8], r11d


			;temp_coordinates set is good

			;section filling the bitmap with values

	mov BYTE[colours], 255
	mov BYTE[colours + 1], 0
	mov BYTE[colours + 2], 0
	mov BYTE[colours + 3], 0
	mov BYTE[colours + 4], 0
	mov BYTE[colours + 5], 255
	mov BYTE[colours + 6], 0
	mov BYTE[colours + 7], 255
	mov BYTE[colours + 8], 0
	mov BYTE[colours + 9], 127
	mov BYTE[colours + 10], 127
	mov BYTE[colours + 11], 127

	mov r12d, DWORD[rdx]
	mov DWORD[temp_integer], r12d
	mov r12d, DWORD[rdx + 8]
	mov DWORD[temp_integer + 4], r12d

	mov DWORD[iterator_2], 4
	mov rbx, temp_coordinates
	sub rbx, 36
	mov r15, temp_indexes
	sub r15, 12

loop_outside:
	add rbx, 36
	add r15, 12

		;calculating a and b from y = a*x + b

	movsxd r10, DWORD[rbx]
	movsxd r11, DWORD[rbx + 12]
	movsxd r12, DWORD[rbx + 4]
	movsxd r13, DWORD[rbx + 16]
	sub r10, r11
	sub r12, r13

	cvtsi2sd xmm1, r10
	cvtsi2sd xmm0, r12
	divsd xmm0, xmm1
	cvtsi2sd xmm2, DWORD[rbx]
	cvtsi2sd xmm1, DWORD[rbx + 4]
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
	cvtsi2sd xmm2, DWORD[rbx]
	cvtsi2sd xmm1, DWORD[rbx + 4]
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
	cvtsi2sd xmm2, DWORD[rbx + 12]
	cvtsi2sd xmm1, DWORD[rbx + 16]
	mulsd xmm2, xmm0
	subsd xmm1, xmm2
	movsd QWORD[temp_calculations + 32], xmm0
	movsd QWORD[temp_calculations + 40], xmm1

		;end of calculating a and b from y = a*x + b

		;calculating thing for z-buffer

	cvtsi2sd xmm0, DWORD[rbx + 8]				;z0
	cvtsi2sd xmm1, DWORD[rbx + 20]			;z1
	cvtsi2sd xmm2, DWORD[rbx + 32]			;z2
	cvtsi2sd xmm3, DWORD[rbx + 4]				;y0
	cvtsi2sd xmm4, DWORD[rbx + 16]			;y1
	cvtsi2sd xmm5, DWORD[rbx + 28]			;y2
	subsd xmm1, xmm0
	subsd xmm2, xmm0
	subsd xmm4, xmm3
	subsd xmm5, xmm3
	mulsd xmm1, xmm5
	mulsd xmm2, xmm4
	subsd xmm1, xmm2
	movsd QWORD[temp_calculations + 48], xmm1

	cvtsi2sd xmm0, DWORD[rbx + 8]				;z0
	cvtsi2sd xmm1, DWORD[rbx + 20]			;z1
	cvtsi2sd xmm2, DWORD[rbx + 32]			;z2
	cvtsi2sd xmm3, DWORD[rbx]						;x0
	cvtsi2sd xmm4, DWORD[rbx + 12]			;x1
	cvtsi2sd xmm5, DWORD[rbx + 24]			;x2
	subsd xmm1, xmm0
	subsd xmm2, xmm0
	subsd xmm4, xmm3
	subsd xmm5, xmm3
	mulsd xmm1, xmm5
	mulsd xmm2, xmm4
	subsd xmm2, xmm1
	movsd QWORD[temp_calculations + 56], xmm2

	cvtsi2sd xmm0, DWORD[rbx]						;x0
	cvtsi2sd xmm1, DWORD[rbx + 12]			;x1
	cvtsi2sd xmm2, DWORD[rbx + 24]			;x2
	cvtsi2sd xmm3, DWORD[rbx + 4]				;y0
	cvtsi2sd xmm4, DWORD[rbx + 16]			;y1
	cvtsi2sd xmm5, DWORD[rbx + 28]			;y2
	subsd xmm1, xmm0
	subsd xmm2, xmm0
	subsd xmm4, xmm3
	subsd xmm5, xmm3
	mulsd xmm1, xmm5
	mulsd xmm2, xmm4
	subsd xmm1, xmm2
	movsd QWORD[temp_calculations + 64], xmm1

		;end of calculating things for z-buffer

	mov r9d, DWORD[rbx + 4]
	mov DWORD[temp_integer + 8], r9d
	mov r9d, DWORD[rbx + 28]
	mov DWORD[temp_integer + 12], r9d
	mov r9d, DWORD[rbx + 16]

	mov DWORD[iterator_1], 2
	mov rax, temp_calculations
	sub rax, 16

loop_middle:
	add rax, 16

	cmp DWORD[temp_integer + 8], r9d
	jz skip_y

	dec DWORD[temp_integer + 8]
loop_inside:
	mov r10, rdi
	inc DWORD[temp_integer + 8]

	cvtsi2sd xmm2, DWORD[temp_integer + 4]
	cvtsi2sd xmm3, DWORD[temp_integer + 8]
	mulsd xmm2, xmm3

	cvtsi2sd xmm0, DWORD[temp_integer + 8]
	subsd xmm0, [rax + 8]
	divsd xmm0, [rax]
	cvtsd2si r11, xmm0

	cvtsi2sd xmm1, DWORD[temp_integer + 8]
	subsd xmm1, [rax + 24]
	divsd xmm1, [rax + 16]
	cvtsd2si r12, xmm1

	cmp r11, r12
	jb skip_change

	mov r13, r11
	mov r11, r12
	mov r12, r13

skip_change:
	mov r14, r11
	sub r12, r11
	jz skip_z_and_colour

	cvtsi2sd xmm0, r11
	mov r11, 3
	cvtsi2sd xmm1, r11
	mulsd xmm1, xmm0
	addsd xmm1, xmm2
	cvtsd2si r11, xmm1

	add r10, r11

	cvtsi2sd xmm0, DWORD[temp_integer + 8]
	cvtsi2sd xmm1, DWORD[rdx]
	cvtsi2sd xmm2, r14
	mov r11, 8
	cvtsi2sd xmm3, r11
	mulsd xmm0, xmm1
	addsd xmm0, xmm2
	mulsd xmm0, xmm3
	cvtsd2si r11, xmm0

	mov QWORD[temp_double], r11
	mov r11, rsi
	add r11, QWORD[temp_double]

	cvtsi2sd xmm0, DWORD[temp_integer + 8]		;y
	cvtsi2sd xmm1, DWORD[rbx + 4]							;y0
	movsd xmm2, QWORD[temp_calculations + 56]

	subsd xmm0, xmm1
	mulsd xmm0, xmm2

	cvtsi2sd xmm3, DWORD[rbx + 8]							;z0
	cvtsi2sd xmm2, DWORD[rbx]									;x0

colour_loop:
	push r14

	cvtsi2sd xmm1, r14												;x
	movsd xmm4, QWORD[temp_calculations + 48]
	movsd xmm5, QWORD[temp_calculations + 64]
	movsd xmm6, QWORD[r11]

	subsd xmm1, xmm2
	mulsd xmm1, xmm4
	addsd xmm1, xmm0
	divsd xmm1, xmm5
	addsd xmm1, xmm3

	comisd xmm1, xmm6
	jc skip_colour

	mov r14d, DWORD[r15]
	add r14d, DWORD[r15 + 4]
	add r14d, DWORD[r15 + 8]

	push r15

	mov r15, colours
	cmp r14d, 6
	je skip_colour_change

	mov r15, colours + 3
	cmp r14d, 7
	je skip_colour_change

	mov r15, colours + 6
	cmp r14d, 8
	je skip_colour_change

	mov r15, colours + 9

skip_colour_change:
	mov r14b, BYTE[r15]
	mov BYTE[r10], r14b
	mov r14b, BYTE[r15 + 1]
	mov BYTE[r10 + 1], r14b
	mov r14b, BYTE[r15 + 2]
	mov BYTE[r10 + 2], r14b

	movsd QWORD[r11], xmm1

	pop r15

skip_colour:
	pop r14
	inc r14
	add r10, 3
	add r11, 8
	dec r12
	cmp r12, 0
	jne colour_loop

skip_z_and_colour:

	cmp DWORD[temp_integer + 8], r9d
	jnz loop_inside

skip_y:

	mov r9d, DWORD[temp_integer + 12]

	dec DWORD[iterator_1]
	jnz loop_middle

	dec DWORD[iterator_2]
	jnz loop_outside
;










			;end of second section
exit:

	mov rsp, rbp
	pop rbp
	ret
