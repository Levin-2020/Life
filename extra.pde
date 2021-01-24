/*
private void draw_matrix(){
  //draws the current matrix onto the screen
  //this one is not in use anymore due to the bad performance
  
  //toggle grid by adding/removing a stroke
  if(grid){stroke(100);}
  else{noStroke();}
  
  //adjusts the stroke weight depending on the zoom level
  switch(zoom_level){
    case 0:
      strokeWeight(0.05);
      break;
    case 1:
      strokeWeight(0.2);
      break;
    case 2:
      strokeWeight(0.3);
      break;
    default:
      strokeWeight(0.5);
      break;
  }
  
  //every cell is being drawn individually with rect()
  for(int i = location[0]; i < location[0]+zoom_levels[zoom_level]; i++){
    for(int j = location[1]; j < location[1]+zoom_levels[zoom_level]; j++){
      if(matrix[j][i] == 1){fill(0);}
      else{fill(255);}
      int i_draw = i-(location[0]);
      int j_draw = j-(location[1]);
      rect(i_draw*cell_size,j_draw*cell_size,cell_size,cell_size);
    }
  }
}



private void draw_matrix(){
  for(int i = location[0]; i < location[0]+zoom_levels[zoom_level]; i++){
    for(int j = location[1]; j < location[1]+zoom_levels[zoom_level]; j++){
      if(matrix[j][i] == 1){fill(0);}
      else{fill(255);}
      int i_draw = i-(location[0]);
      int j_draw = j-(location[1]);
      rect(i_draw*cell_size,j_draw*cell_size,cell_size,cell_size);
    }
  }
}

PImage pixel_scaler(PImage img, int scale){
  PImage new_img = new PImage(img.width*scale, img.height*scale);
  for(int j = 0; j < new_img.height; j++){
    for(int i = 0; i < new_img.width; i++){
      int[] p = {floor(i/scale),floor(j/scale)};
      new_img.pixels[j*new_img.width+i] = img.pixels[p[1]*img.width+p[0]];
    }
  }
  return new_img;
}


private PImage update_matrix_img(){
  matrix_img = new PImage(zoom_levels[zoom_level],zoom_levels[zoom_level]);
  for(int i = location[0]; i < location[0]+zoom_levels[zoom_level]; i++){
    for(int j = location[1]; j < location[1]+zoom_levels[zoom_level]; j++){
      int draw_i = i-location[0];
      int draw_j = j-location[1];
      if(matrix[j][i] == 1){
      matrix_img.pixels[draw_j*zoom_levels[zoom_level]+draw_i] = color(0);}
      else{matrix_img.pixels[draw_j*zoom_levels[zoom_level]+draw_i] = color(255);}
    }
  }
  return matrix_img;
}

private void draw_matrix_img(){
  
  int scale = width/zoom_levels[zoom_level];
  
  matrix_img = update_matrix_img();
  
  matrix_img = image_manager.pixel_scaler(matrix_img,scale);
  image(matrix_img,0,0);
}

*/
