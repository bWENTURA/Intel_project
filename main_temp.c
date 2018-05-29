#include <stdio.h>
#include <allegro5/allegro.h>

const int SCREEN_W = 512;
const int SCREEN_H = 512;
const int XYMATRIX_SIZE = 256;
enum MYKEYS {
   KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_ESC
};
enum ANGLE{
  SWIFT_UP, SWIFT_DOWN, SWIFT_LEFT, SWIFT_RIGHT
};

int main()
{
   ALLEGRO_DISPLAY *display = NULL;
   ALLEGRO_EVENT_QUEUE *event_queue = NULL;
   ALLEGRO_BITMAP *xy_matrix= NULL;
   bool key[4] = {false, false, false, false};
   int angle[4] = {0, 0, 0, 0};
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
   xy_matrix = al_create_bitmap(XYMATRIX_SIZE, XYMATRIX_SIZE);
   if(!xy_matrix) {
      fprintf(stderr, "failed to create bouncer bitmap!\n");
      al_destroy_display(display);
      return -1;
   }
   al_set_target_bitmap(xy_matrix);
  //  al_clear_to_color(al_map_rgb(255, 0, 255));
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
      f(xy_matrix);
      al_draw_bitmap(xy_matrix, 0, 0, 0);
      al_flip_display();
      ALLEGRO_EVENT ev;
      al_wait_for_event(event_queue, &ev);
        if(ev.type == ALLEGRO_EVENT_DISPLAY_CLOSE || ev.keyboard.keycode == ALLEGRO_KEY_ESCAPE) {
           break;
        }
        else if(ev.type == ALLEGRO_EVENT_KEY_DOWN) {
          switch(ev.keyboard.keycode) {
            case ALLEGRO_KEY_UP:{
              key[KEY_UP] = true;
              break;
            }
            case ALLEGRO_KEY_DOWN:{
              key[KEY_DOWN] = true;
              break;
            }
            case ALLEGRO_KEY_LEFT:{
              key[KEY_LEFT] = true;
              break;
            }
            case ALLEGRO_KEY_RIGHT:{
              key[KEY_RIGHT] = true;
              break;
            }
          }
        }
   }  while(1);

   al_destroy_bitmap(xy_matrix);
   al_destroy_display(display);
   al_destroy_event_queue(event_queue);

   return 0;
}
