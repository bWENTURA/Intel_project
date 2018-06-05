#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <allegro5/allegro.h>
#include </home/mylittlemachine/allegro5/include/allegro5/internal/aintern_bitmap.h>
// #include "allegro5/internal/aintern_bitmap.h"
#include "f.h"

void sort_indexes(int *coordinates, int *indexes){
  int temp_arr_int[3];
  int temp_int;
  for(int i = 1; i < 4; ++i){
    int j = i;
    while(j > 0 && coordinates[(j-1)*3 + 1] > coordinates[j*3 + 1]){
      temp_arr_int[0] = coordinates[(j-1)*3];
      temp_arr_int[1] = coordinates[(j-1)*3 + 1];
      temp_arr_int[2] = coordinates[(j-1)*3 + 2];
      coordinates[(j-1)*3] = coordinates[j*3];
      coordinates[(j-1)*3 + 1] = coordinates[j*3 + 1];
      coordinates[(j-1)*3 + 2] = coordinates[j*3 + 2];
      coordinates[j*3] = temp_arr_int[0];
      coordinates[j*3 + 1] = temp_arr_int[1];
      coordinates[j*3 + 2] = temp_arr_int[2];
      temp_int = indexes[j-1];
      indexes[j-1] = indexes[j];
      indexes[j] = temp_int;
      --j;
    }
  }
}

const int SCREEN_W = 512;
const int SCREEN_H = 512;
const int XYMATRIX_WIDTH = 512;
const int XYMATRIX_HEIGHT = 512;
enum ANGLES{
  SWIFT_UP, SWIFT_DOWN, SWIFT_LEFT, SWIFT_RIGHT
};

int main()
{
  ALLEGRO_DISPLAY *display = NULL;
  ALLEGRO_EVENT_QUEUE *event_queue = NULL;
  ALLEGRO_BITMAP *xy_matrix = NULL;
  bool redraw = true;
  int coordinates[12] = {60, 150, 120,
                        400, 190, 60,
                        300, 140, 260,
                         250, 350, 150};
  int indexes[4] = {1, 2, 3, 4};
  int bitmap_info[3] = {XYMATRIX_WIDTH, XYMATRIX_HEIGHT};
  float center[3];
  center[0] = coordinates[0] + coordinates[3] + coordinates[6] + coordinates[9];
  center[1] = coordinates[1] + coordinates[4] + coordinates[7] + coordinates[10];
  center[2] = coordinates[2] + coordinates[5] + coordinates[8] + coordinates[11];
  for(int i = 0; i < 3; ++i) center[i]/=4;
  double * z_buffer;
  z_buffer = malloc(sizeof(*z_buffer) * XYMATRIX_WIDTH * XYMATRIX_WIDTH);

  if(!al_init()) {
    fprintf(stderr, "failed to initialize allegro!\n");
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
  al_register_event_source(event_queue, al_get_keyboard_event_source());

  do{
    ALLEGRO_EVENT ev;
    al_wait_for_event(event_queue, &ev);
    if(ev.type == ALLEGRO_EVENT_DISPLAY_CLOSE || ev.keyboard.keycode == ALLEGRO_KEY_ESCAPE) {
      break;
    }
    else if(ev.type == ALLEGRO_EVENT_KEY_DOWN) {
      switch(ev.keyboard.keycode) {
        case ALLEGRO_KEY_UP:{
          for(int i = 0; i < 4; ++i){
            float temp_y = (coordinates[i*3 + 1] - center[1]) * cos(-1.57) - (coordinates[i*3 + 2] - center[2]) * sin(-1.57);
            float temp_z = (coordinates[i*3 + 1] - center[1]) * sin(-1.57) + (coordinates[i*3 + 2] - center[2]) * cos(-1.57);
            coordinates[i*3 + 1] = temp_y + center[1];
            coordinates[i*3 + 2] = temp_z + center[2];
          }
          break;
        }
        case ALLEGRO_KEY_DOWN:{
          for(int i = 0; i < 4; ++i){
            float temp_y = (coordinates[i*3 + 1] - center[1]) * cos(1.57) - (coordinates[i*3 + 2] - center[2]) * sin(1.57);
            float temp_z = (coordinates[i*3 + 1] - center[1]) * sin(1.57) + (coordinates[i*3 + 2] - center[2]) * cos(1.57);
            coordinates[i*3 + 1] = temp_y + center[1];
            coordinates[i*3 + 2] = temp_z + center[2];
          }
          break;
        }
        case ALLEGRO_KEY_LEFT:{
          for(int i = 0; i < 4; ++i){
            float temp_x = (coordinates[i*3 + 2] - center[2]) * sin(1.57) + (coordinates[i*3] - center[0]) * cos(1.57);
            float temp_z = (coordinates[i*3 + 2] - center[2]) * cos(1.57) - (coordinates[i*3] - center[0]) * sin(1.57);
            coordinates[i*3] = temp_x + center[0];
            coordinates[i*3 + 2] = temp_z + center[2];
          }
          break;
        }
        case ALLEGRO_KEY_RIGHT:{
          for(int i = 0; i < 4; ++i){
            float temp_x = (coordinates[i*3 + 2] - center[2]) * sin(-1.57) + (coordinates[i*3] - center[0]) * cos(-1.57);
            float temp_z = (coordinates[i*3 + 2] - center[2]) * cos(-1.57) - (coordinates[i*3] - center[0]) * sin(-1.57);
            coordinates[i*3] = temp_x + center[0];
            coordinates[i*3 + 2] = temp_z + center[2];
          }
          break;
        }
      }
      redraw = true;
      al_unregister_event_source(event_queue, al_get_keyboard_event_source());
    }
    if(redraw){
      for(int i = 0; i < 4; ++i){
        printf("%d %d %d----%d\n", coordinates[i*3],  coordinates[i*3 + 1],  coordinates[i*3 + 2], indexes[i]);
      }
      printf("\n");
      ALLEGRO_LOCKED_REGION *locked;
      unsigned char *data;
      locked = al_lock_bitmap(xy_matrix, ALLEGRO_PIXEL_FORMAT_BGR_888, ALLEGRO_LOCK_READWRITE);
      data = locked->data;
      bitmap_info[2] = locked->pitch;
      if(locked->pitch < 0){
        coordinates[1] = XYMATRIX_HEIGHT - coordinates[1];
        coordinates[4] = XYMATRIX_HEIGHT - coordinates[4];
        coordinates[7] = XYMATRIX_HEIGHT - coordinates[7];
        coordinates[10] = XYMATRIX_HEIGHT - coordinates[10];
      }
      sort_indexes(coordinates, indexes);
      f(data, z_buffer, bitmap_info, coordinates, indexes);
      if(locked->pitch < 0){
        coordinates[1] = XYMATRIX_HEIGHT - coordinates[1];
        coordinates[4] = XYMATRIX_HEIGHT - coordinates[4];
        coordinates[7] = XYMATRIX_HEIGHT - coordinates[7];
        coordinates[10] = XYMATRIX_HEIGHT - coordinates[10];
      }
      data = NULL;
      al_unlock_bitmap(xy_matrix);
      redraw = false;
      al_clear_to_color(al_map_rgb(0,0,0));
      al_draw_bitmap(xy_matrix, 0, 0, 0);
      al_flip_display();
      al_register_event_source(event_queue, al_get_keyboard_event_source());
    }

  }  while(1);

  free(z_buffer);
  al_destroy_bitmap(xy_matrix);
  al_destroy_display(display);
  al_destroy_event_queue(event_queue);
  return 0;
}
