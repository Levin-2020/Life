int m_s = 1000; //matrix_size
int padding = 100;
int[][] matrix = new int[m_s][m_s];
int cell_size;
//0=800x800, 1=400x400, 2=200x200, 3=100x100, 4=50x50, 5=25x25
int[] zoom_levels = {800,400,200,100,50,25};
int zoom_level = 4;
int[] location = {400,400};
boolean grid = true;
int population;
int generation;
PFont f;
int scene = 2;
boolean editing = false;
//PImage conways = loadImage("conway.jpg");


public void setup(){
  size(800,800);
  background(0);
  f = createFont("Calibri", 50, true);
  textFont(f, 15);
  /*
  matrix[407][401] = 1;
  matrix[408][401] = 1;
  matrix[409][401] = 1;
  matrix[409][400] = 1;
  matrix[408][399] = 1;
  */
  frameRate(20);
}

public void draw(){
  if(scene == 0){
  
  }
  
  if(scene == 1){
    background(0);
    matrix = step(matrix);
    draw_matrix();
    draw_minimap(100,120);
  }
  if(scene == 2){
    editing = true;
    background(0);
    draw_matrix();
    
    
  }
}

private void draw_menu(){
  print("hello");
}


private void draw_matrix(){
  if(grid){stroke(96);}
  else{noStroke();}
  //
  //
  //
  //strokeweight
  //
  //
  cell_size = width/zoom_levels[zoom_level];
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

/*
public step(){
  return;
}
*/

void keyPressed() {
  if(key == 'g'){grid = !grid;}
  
  if(key == 'h'){location = new int[] {400,400};}
  
  if(key == 's'){matrix = step(matrix);}
  
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
  if(location[0] < padding){location[0]=padding;}
  if(location[1] < padding){location[1]=padding;}
  if(location[0] > m_s-padding-zoom_levels[zoom_level]){location[0] = m_s-padding-zoom_levels[zoom_level];}
  if(location[1] > m_s-padding-zoom_levels[zoom_level]){location[1] = m_s-padding-zoom_levels[zoom_level];}
}

private void check_zoom(){
  if(zoom_level >= zoom_levels.length){zoom_level--;}
  if(zoom_level < 0){zoom_level++;} 
}

private int[][] step(int[][] m){
  int[][] m_new = new int[m_s][m_s];
  int alive_neighbours;
  
  for(int i = 0; i < m_s; i++){
    arrayCopy(m[i],m_new[i]);
  }
  for(int i = 0; i < m_s; i++){
    for(int j = 0; j < m_s; j++){
      //calculating alive neighbours, considering edge cases
      if(i == 0 || i == m_s-1 || j == 0 || j == m_s-1){alive_neighbours = 0;}
      else{alive_neighbours = m[j-1][i-1] + m[j-1][i] + m[j-1][i+1] + 
                              m[j][i-1] +               m[j][i+1] + 
                              m[j+1][i-1] + m[j+1][i] + m[j+1][i+1];}
      
      //changing new matrix according to rules
      if(m[j][i] == 1){
        if(alive_neighbours < 2 || alive_neighbours > 3){m_new[j][i] = 0;}
        else{m_new[j][i] = 1;}
      }
      if(m[j][i] == 0){
        if(alive_neighbours == 3){m_new[j][i] = 1;}
      }
    }
  }
  return m_new;
}

private void draw_minimap(int size, float opacity){
  //colorMode(RGB,255);
  noStroke();
  fill(120,opacity);
  float temp = width-1.2*size;
  rect(temp,temp,size,size);
  fill(50,opacity);
  float scaler = m_s-2*padding;
  float scale = zoom_levels[zoom_level]/scaler;
  float[] loc = {(location[0]-padding)/scaler,(location[1]-padding)/scaler};
  float[] temp1 = {temp+loc[0]*size,temp+loc[1]*size};
  rect(temp1[0],temp1[1],size*scale,size*scale);
}


void mouseClicked(){
  if(mouseButton == RIGHT){
    
  }
}
