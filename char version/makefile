CC = gcc
CFLAGS = -g -m64 -Wall -no-pie

all:	main.o f.o
	$(CC) $(CFLAGS) main.o f.o -o fun  `pkg-config --cflags --libs allegro-5.0 allegro_acodec-5.0 allegro_audio-5.0 allegro_color-5.0 allegro_dialog-5.0 allegro_font-5.0 allegro_image-5.0 allegro_main-5.0 allegro_memfile-5.0 allegro_physfs-5.0 allegro_primitives-5.0 allegro_ttf-5.0`

main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

f.o:	f.s
	nasm -f elf64  f.s

clean: rm -f *.o
