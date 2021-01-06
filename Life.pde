int[][] matrix = new int[1000][1000];
int cell_size;
//0=800x800, 1=400x400, 2=200x200, 3=100x100, 4=50x50, 5=25x25
int[] zoom_levels = {800,400,200,100,50,25};
int zoom_level = 4;
int[] location = {400,400};
boolean grid = true;
PFont f;


public void setup(){
  size(800,800);
  background(0);
  f = createFont("Calibri", 50, true);
  textFont(f, 15);
  matrix[407][401] = 1;
}

public void draw(){
  background(0);
  draw_matrix();
}


private void draw_matrix(){
  if(grid){stroke(0);}
  cell_size = width/zoom_levels[zoom_level];
  for(int i = location[0]; i < location[0]+zoom_levels[zoom_level]; i++){
    for(int j = location[1]; j < location[1]+zoom_levels[zoom_level]; j++){
      if(matrix[j][i] == 1){fill(0);if(!grid){stroke(0);}}
      else{fill(255);if(!grid){stroke(255);}}
      int i_draw = i-(location[0]);
      int j_draw = j-(location[1]);
      rect(i_draw*cell_size,j_draw*cell_size,cell_size,cell_size);
    }
  }
}

/*
public step(){
  return;
}
*/

void keyPressed() {
  if(key == 'g'){grid = !grid;}
  
  if(key == 'h'){location = new int[] {400,400};}
  
  if(key == '1'){zoom_level++;}
  if(key == '2'){zoom_level--;}
  check_zoom();
  println("zoom level: " + zoom_level);
  
  if(keyCode == 39){location[0] += 10;}
  if(keyCode == 38){location[1] -= 10;}
  if(keyCode == 37){location[0] -= 10;}
  if(keyCode == 40){location[1] += 10;}
  println(keyCode);
  check_location();
  println("location: " + location[0] + "," + location[1]);
}

private void check_location(){
  if(location[0] < 100){location[0]=100;}
  if(location[1] < 100){location[1]=100;}
  if(location[0] > 800-zoom_levels[zoom_level]){location[0] = 800-zoom_levels[zoom_level];}
  if(location[1] > 800-zoom_levels[zoom_level]){location[1] = 800-zoom_levels[zoom_level];}
}

private void check_zoom(){
  if(zoom_level >= zoom_levels.length){zoom_level--;}
  if(zoom_level < 0){zoom_level++;} 
}

private int[][] step(int[][] m){
  int[][] m_new = m;
  for(int i = 0; i < 1000; i++){
    for(int j = 0; j < 1000; j++){
      
    }
  }
  return m;
}
