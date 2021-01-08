import javax.swing.*; 


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
int scene = 0;//0=menu, 1=build, 2=watch, 3=info, 4=exit
boolean editing = false;
boolean running = false;
JSONArray json_matrix = new JSONArray();
PImage conway;
int[][] button_loc = {{600,300},{600,360},{600,420},{600,480}};
int[][] button_size = {{100,50},{100,50},{100,50},{100,50}};


public void setup(){
  size(800,800);
  background(0);
  conway = loadImage("images/conway.jpg");
  f = createFont("Calibri", 50, true);
  textFont(f, 20);
  textAlign(CENTER,CENTER);
  frameRate(20);
}

public void draw(){
  if(scene == 0){
    background(70);
    draw_menu();
  }
  
  
  if(scene == 1){
    editing = true;
    background(0);
    draw_matrix();
    draw_minimap(100,120);
  }
  if(scene == 2){
    editing = false;
    background(0);
    matrix = step(matrix);
    draw_matrix();
    draw_minimap(100,120);
  }
  
  if(scene == 4){
    exit();
  }
}
void mouseClicked(){
  if(scene == 1){
    if(mouseButton == LEFT){
      int x = floor(mouseX/cell_size) + location[0];
      int y = floor(mouseY/cell_size) + location[1];
      matrix[y][x] = 1;
    }
    if(mouseButton == RIGHT){
      int x = floor(mouseX/cell_size) + location[0];
      int y = floor(mouseY/cell_size) + location[1];
      matrix[y][x] = 0;
    }
  }
  if(scene == 0){
    for(int i = 0; i < button_loc.length; i++){
      if(mouseX > button_loc[i][0] && mouseX < button_loc[i][0]+button_size[i][0] &&
         mouseY > button_loc[i][1] && mouseY < button_loc[i][1]+button_size[i][1]){
        scene = i+1;
      }
    }
  }
}

void keyPressed() {
  if (key == ESC){key=0;scene = 0;}
  
  //build and watch mode
  if(scene == 0 || scene == 1){
    if(key == 'g'){grid = !grid;}
    if(key == 'h'){location = new int[] {400,400};}
    if(key == 't'){matrix = step(matrix);}
    
    if(key == '1'){zoom_level++;}
    if(key == '2'){zoom_level--;}
    check_zoom();
    //println("zoom level: " + zoom_level);
    
    if(keyCode == 39){location[0] += 10;}
    if(keyCode == 38){location[1] -= 10;}
    if(keyCode == 37){location[0] -= 10;}
    if(keyCode == 40){location[1] += 10;}
    check_location();
    //println("location: " + location[0] + "," + location[1]);
  }
  
  //build mode only, saving and loading
  if(scene == 1){
    if(key == 's'){
      String name = JOptionPane.showInputDialog(frame, "please enter data_name (e.g., name.json)", "[].json");
      m_save(matrix,name);
    }
    if(key == 'l'){
      String name = JOptionPane.showInputDialog(frame, "please enter data_name (e.g., name.json)", "[].json");
      try{matrix = m_load(name);}
      catch(Exception e){println("this file does not exist, please enter a valid file name");}
    }
  }
  
}


private void draw_menu(){
  //conway
  fill(255);
  textSize(60);
  text("John Conway's Game of Life",0,0,800,150);
  textSize(20);
  
  image(conway,50,200,conway.width/2,conway.height/2);
  
  //build
  draw_button("Build", button_loc[0], button_size[0]);
  //watch
  draw_button("Watch", button_loc[1], button_size[1]);
  //info
  draw_button("Info", button_loc[2], button_size[2]);
  //exit
  draw_button("Exit", button_loc[3], button_size[3]);
  
  //detect mouse
  for(int i = 0; i < button_loc.length; i++){
    if(mouseX > button_loc[i][0] && mouseX < button_loc[i][0]+button_size[i][0] &&
       mouseY > button_loc[i][1] && mouseY < button_loc[i][1]+button_size[i][1]){
      noStroke();
      fill(180,130);
      rect(button_loc[i][0],button_loc[i][1],button_size[i][0],button_size[i][1]);
    }
  }
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


private void m_save(int[][] m, String name){
  json_matrix = new JSONArray();
  for(int j = 0; j < m_s; j++){
    for(int i = 0; i < m_s; i++){
      json_matrix.setInt(j*m_s+i,m[j][i]);
    }
  }
  saveJSONArray(json_matrix, "data/"+name);
}

private int[][] m_load(String name){
  json_matrix = loadJSONArray("data/"+name);
  int[][] m = new int[m_s][m_s];
  for(int j = 0; j < m_s; j++){
    for(int i = 0; i < m_s; i++){
      m[j][i] = json_matrix.getInt(j*m_s+i);
    }
  }
  return m;
}

private void draw_button(String text, int[] loc, int[] s){
  noFill();
  stroke(20);
  rect(loc[0],loc[1],s[0],s[1]);
  text(text, loc[0],loc[1],s[0],s[1]);
}
