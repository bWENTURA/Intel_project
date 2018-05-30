#include <stdio.h>
#include <stdlib.h>
#include <allegro5/allegro.h>
#include </home/mylittlemachine/allegro5/include/allegro5/internal/aintern_bitmap.h>
// #include "allegro5/internal/aintern_bitmap.h"
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
  ALLEGRO_TIMER *timer = NULL;
  ALLEGRO_BITMAP *xy_matrix = NULL;
  bool redraw = true;
  int coordinates[12] = {60, 60, 50, 200, 50, 10, 100, 200, 100, 0, 0, 0};
  char * z_buffer;
  z_buffer = malloc(sizeof(*z_buffer) * 256 * 256);
  int angles[4] = {0, 0, 0, 0};

  if(!al_init()) {
    fprintf(stderr, "failed to initialize allegro!\n");
    return -1;
  }

  timer = al_create_timer(1.0);
   if(!timer) {
      fprintf(stderr, "failed to create timer!\n");
      return -1;
   }

  if(!al_install_keyboard()) {
    fprintf(stderr, "failed to initialize the keyboard!\n");
    return -1;
  }

  al_set_new_bitmap_format(ALLEGRO_PIXEL_FORMAT_BGR_888);
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
  al_register_event_source(event_queue, al_get_timer_event_source(timer));
  al_register_event_source(event_queue, al_get_keyboard_event_source());
  al_start_timer(timer);

  int a = 0;


  do{
    ALLEGRO_EVENT ev;
    al_wait_for_event(event_queue, &ev);
    if(ev.type == ALLEGRO_EVENT_TIMER){
       redraw = true;
    }
    else if(ev.type == ALLEGRO_EVENT_DISPLAY_CLOSE || ev.keyboard.keycode == ALLEGRO_KEY_ESCAPE) {
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
    if(redraw && al_is_event_queue_empty(event_queue)){
      ALLEGRO_LOCKED_REGION *locked;
      unsigned char *data;

      locked = al_lock_bitmap(xy_matrix, ALLEGRO_PIXEL_FORMAT_BGR_888, ALLEGRO_LOCK_READWRITE);
      data = locked->data;
      f(data, z_buffer, XYMATRIX_WIDTH, XYMATRIX_HEIGHT, coordinates, angles);
      // for(int j = 0; j < 256; ++j){
      //   for(int i = 0; i < 256; ++i){
      //     data[i*3 + j*locked->pitch] = 255;
      //     data[i*3 + j*locked->pitch + 1] = 255;
      //     data[i*3 + j*locked->pitch + 2] = 255;
      //   }
      // }

      data = NULL;
      al_unlock_bitmap(xy_matrix);
      for(int i = 0; i < 4; ++i){
        angles[i] = 0;
      }
      redraw = false;
      al_clear_to_color(al_map_rgb(0,0,0));
      al_draw_bitmap(xy_matrix, a, a, 0);
      a += 64;
      a %= 318;
      al_flip_display();
    }

  }  while(1);
  // for(int i = 0; i < 256*256; ++i) printf("%c", z_buffer[i]);
  free(z_buffer);
  al_destroy_bitmap(xy_matrix);
  al_destroy_display(display);
  al_destroy_event_queue(event_queue);
  return 0;
}
