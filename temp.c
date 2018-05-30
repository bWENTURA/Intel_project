#include <stdio.h>
#include <stdlib.h>
#include <allegro5/allegro.h>
#include "f.h"

const int SCREEN_W = 512;
const int SCREEN_H = 512;
const int XYMATRIX_WIDTH = 256;
const int XYMATRIX_HEIGHT = 256;
enum ANGLES{
  SWIFT_UP, SWIFT_DOWN, SWIFT_LEFT, SWIFT_RIGHT
};

int main()
{
   ALLEGRO_DISPLAY *display = NULL;
   ALLEGRO_EVENT_QUEUE *event_queue = NULL;
   ALLEGRO_BITMAP *xy_matrix = NULL;
   int coordinates[12] = {60, 60, 50, 200, 50, 10, 100, 200, 100, 0, 0, 0};
   char * z_buffer;
   z_buffer = malloc(sizeof(*z_buffer) * 256 * 256);
   int angles[4] = {0, 0, 0, 0};
   if(!al_init()) {
      fprintf(stderr, "failed to initialize allegro!\n");
      return -1;
   }
   if(!al_install_keyboard()) {
      fprintf(stderr, "failed to initialize the keyboard!\n");
      return -1;
   }
   display = al_create_display(SCREEN_W, SCREEN_H);
   if(!display) {
      fprintf(stderr, "failed to create display!\n");
      return -1;
   }
   xy_matrix = al_create_bitmap(XYMATRIX_WIDTH, XYMATRIX_HEIGHT);
   if(!xy_matrix) {
      fprintf(stderr, "failed to create bouncer bitmap!\n");
      al_destroy_display(display);
      return -1;
   }
   al_set_target_bitmap(xy_matrix);
   al_clear_to_color(al_map_rgb(255, 0, 255));
   al_set_target_bitmap(al_get_backbuffer(display));
   event_queue = al_create_event_queue();
   if(!event_queue) {
      fprintf(stderr, "failed to create event_queue!\n");
      al_destroy_bitmap(xy_matrix);
      al_destroy_display(display);
      return -1;
   }
   al_register_event_source(event_queue, al_get_display_event_source(display));
   al_register_event_source(event_queue, al_get_keyboard_event_source());
   al_flip_display();
   for(int i = 0; i < 256*256; ++i) z_buffer[i] = '1';
   do{
     for(int i = 0; i < 10; ++i)  printf("%c", z_buffer[i]);
      f(xy_matrix->line, z_buffer, XYMATRIX_WIDTH, XYMATRIX_HEIGHT, coordinates, angles);
      printf("----");
      // for(int i = 0; i < 256*256; ++i)  printf("%c", z_buffer[i]);
      for(int i = 0; i < 12; ++i) printf("%d ", coordinates[i]);
      al_clear_to_color(al_map_rgb(0,0,0));
     al_draw_bitmap(xy_matrix, 0, 0, 0);
     al_flip_display();
     for(int i = 0; i < 4; ++i){
       angles[i] = 0;
     }
     ALLEGRO_EVENT ev;
     al_wait_for_event(event_queue, &ev);
     if(ev.type == ALLEGRO_EVENT_DISPLAY_CLOSE || ev.keyboard.keycode == ALLEGRO_KEY_ESCAPE) {
       break;
     }
     else if(ev.type == ALLEGRO_EVENT_KEY_DOWN) {
       switch(ev.keyboard.keycode) {
         case ALLEGRO_KEY_UP:{
           angles[SWIFT_UP] = 10;
           break;
         }
         case ALLEGRO_KEY_DOWN:{
           angles[SWIFT_DOWN] = 10;
           break;
         }
         case ALLEGRO_KEY_LEFT:{
           angles[SWIFT_LEFT] = 10;
           break;
         }
         case ALLEGRO_KEY_RIGHT:{
           angles[SWIFT_RIGHT] = 10;
           break;
         }
       }
     }
   }  while(1);
   free(z_buffer);
   al_destroy_bitmap(xy_matrix);
   al_destroy_display(display);
   al_destroy_event_queue(event_queue);
   return 0;
}
