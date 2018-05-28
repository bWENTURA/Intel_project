#include <stdio.h>
#include "f.h"
#include <allegro5/allegro.h>
#include <allegro5/allegro_image.h>
#include <allegro5/allegro_native_dialog.h>

int main(int argc, char * argv[]){
  if(argc < 2){
    printf("Arg. missing\n");
    return 0;
  }
  ALLEGRO_DISPLAY *display = NULL;
  ALLEGRO_BITMAP  *image   = NULL;
  if(!al_init()){
    al_show_native_message_box(display, "Error", "Error", "Failed to initialize allegro!", NULL, ALLEGRO_MESSAGEBOX_ERROR);
    return 0;
  }
  if(!al_init_image_addon()){
    al_show_native_message_box(display, "Error", "Error", "Failed to initialize al_init_image_addon!",
    NULL, ALLEGRO_MESSAGEBOX_ERROR);
    return 0;
  }
  display = al_create_display(550,550);
  if(!display) {
    al_show_native_message_box(display, "Error", "Error", "Failed to initialize display!", NULL, ALLEGRO_MESSAGEBOX_ERROR);
    return 0;
  }
  image = al_load_bitmap("bitmap_out.bmp");
  if(!image) {
    al_show_native_message_box(display, "Error", "Error", "Failed to load image!",
    NULL, ALLEGRO_MESSAGEBOX_ERROR);
    al_destroy_display(display);
    return 0;
  }
  al_draw_bitmap(image,38,38,0);
  al_flip_display();
  al_rest(5);
  al_destroy_display(display);
  al_destroy_bitmap(image);


  f(argv[1]);
  printf("%s", argv[1]);
  printf("\n");
  return 0;
}