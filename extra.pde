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
*/
