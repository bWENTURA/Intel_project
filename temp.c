#include <stdio.h>
#include <allegro5/allegro.h>
#include "f.h"

const int SCREEN_W = 512;
const int SCREEN_H = 512;
const int XYMATRIX_WIDTH = 512;
const int XYMATRIX_HEIGHT = 256;
enum ANGLES{
  SWIFT_UP, SWIFT_DOWN, SWIFT_LEFT, SWIFT_RIGHT
};

int main()
{
   ALLEGRO_DISPLAY *display = NULL;
   ALLEGRO_EVENT_QUEUE *event_queue = NULL;
   ALLEGRO_BITMAP *xy_matrix= NULL;
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
   do{
    //  f(xy_matrix, NULL, XYMATRIX_WIDTH, XYMATRIX_HEIGHT, NULL, NULL);
     if(!event_queue) printf("%d %d\n", XYMATRIX_WIDTH, XYMATRIX_HEIGHT);
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
     al_flush_event_queue(event_queue);
   }  while(1);
   al_destroy_bitmap(xy_matrix);
   al_destroy_display(display);
   al_destroy_event_queue(event_queue);

   return 0;
}
