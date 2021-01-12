/* Sources:
- https://processing.org/
- https://forum.processing.org/one/
- https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
- https://www.conwaylife.com/wiki/
*/

import javax.swing.*;
import static javax.swing.JOptionPane.*;


int m_s = 1000; //matrix_size
int padding = 100; //infinite grid illusion
int[][] matrix = new int[m_s][m_s];
int[] zoom_levels = {800,400,200,100,50,25}; //different zoom levels e.g. [2] = 200x200 grid
int zoom_level = 4; //initial zoom level
int cell_size; //0=800x800, 1=400x400, 2=200x200, 3=100x100, 4=50x50, 5=25x25
int[] location = {300,300}; //initial location
boolean grid = false; //initially the grid is not drawn
int population = 0;
int generation = 0;
PFont f;
int scene = 0; //0=menu, 1=build, 2=watch, 3=info, 4=exit, 5=info1
boolean editing = false;
boolean running = false;
JSONArray json_matrix = new JSONArray();
PImage conway;
int[][] button_loc = {{600,300},{600,360},{600,420},{600,480},{650,700},{50,700}};
int[][] button_size = {{100,50},{100,50},{100,50},{100,50},{100,50},{100,50}};

String[] protected_names = {"gosper_glider_gun","simkin_glider_gun","still_vs_oscillators",
                            "infinite_growth1","infinite_growth2","infinite_growth3", 
                            "glider","spaceships","main_menu","main_menu1","main_menu2",
                            "main_menu3","main_menu4"};
boolean allowed = true;

PImage matrix_img;

int[] fps_list = {5,10,20,40,60,80,100,120};
int fps = 2; //default is 10 frames per second
float current_fps;
float time = millis();

boolean testing = false;
int[][] backup_matrix = new int[m_s][m_s];
float[] gaussian_kernel;

PImage color_gradient;
boolean animation_load = true;


public void setup(){
  size(800,800);
  conway = loadImage("images/conway1.jpg");
  color_gradient = loadImage("images/color_gradient.jpg");
  f = createFont("Calibri", 50, true);
  textFont(f, 20);
  textAlign(CENTER,CENTER);
  matrix_img = new PImage(800,800);
  cell_size = width/zoom_levels[zoom_level];
  //as soon as it gets crowded it's limited by the computer hardware
  gaussian_kernel = create_gaussian(1.5,5);
}

public void draw(){
  //depending on the current scene different function are called
  //thus different scences are drawn
  
  //calculating current framerate
  if(frameCount%10==0){
    float dt = (millis() - time)/10/1000;
    current_fps = 1/dt;
    time = millis();
  }
  //setting current max framerate
  frameRate(fps_list[fps]);
  
  if(scene == 0){
    fps = 1;
    background(70);
    draw_menu();
    draw_menu_animation(50,180,animation_load);
    animation_load = false;
  }
  
  if(scene == 1){
    editing = true;
    draw_matrix_img();
    draw_minimap(100,120);
  }
  
  if(scene == 2){
    editing = false;
    //float asdf = millis();
    //asdf = millis();
    draw_matrix_img();
    //println("time wasted drawing: " + (millis()-asdf));
    if(running){matrix = step(matrix);}
    //println("time wasted calculating: " + (millis()-asdf));
    
    
    draw_minimap(100,120);
    
  }
  
  if(scene == 3){
    fps = 2;
    background(70);
    draw_info();
  }
  
  if(scene == 4){
    exit();
  }
  
  if(scene == 5){
    fps = 2;
    background(70);
    draw_info1();
  }
}

void mouseClicked(){
  //checking for cell creations/destructions (in build mode)
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
  
  
  //checking for button clicks (in main menu, info, info1)
  if(scene == 0){
    for(int i = 0; i < 4; i++){
      if(mouseX > button_loc[i][0] && mouseX < button_loc[i][0]+button_size[i][0] &&
         mouseY > button_loc[i][1] && mouseY < button_loc[i][1]+button_size[i][1]){
        scene = i+1;
        matrix = new int[m_s][m_s];
      }
    }
  }
  
  if(scene == 3){
    if(mouseX > button_loc[4][0] && mouseX < button_loc[4][0]+button_size[4][0] &&
         mouseY > button_loc[4][1] && mouseY < button_loc[4][1]+button_size[4][1]){
        scene = 5;
      }
  }
  
  if(scene == 5){
    if(mouseX > button_loc[5][0] && mouseX < button_loc[5][0]+button_size[5][0] &&
         mouseY > button_loc[5][1] && mouseY < button_loc[5][1]+button_size[5][1]){
        scene = 3;
      }
  }
}


void keyPressed() {
  //checking for key presses and calling according function
  
  //return to main menu
  if (key == ESC){
    key=0;
    scene = 0;
    animation_load = true;}
  
  //build and watch mode
  if(scene == 1 || scene == 2){
    
    //toggle grid
    if(key == 'g'){grid = !grid;}
    
    //set location to home coordinates
    if(key == 'h'){location = new int[] {300,300};}
    
    //adjusting the fps
    if(key == '3'){fps--;}
    if(key == '4'){fps++;}
    //checking wheter fps is valid
    check_fps();
    
    //zooming in and out
    if(key == '1'){zoom_level++;}
    if(key == '2'){zoom_level--;}
    //checking whether the zoom level is valid
    check_zoom();
    //updating the cell_size according to new zoom_level
    cell_size = width/zoom_levels[zoom_level];
    //println("zoom level: " + zoom_level);
    
    //adjusting location with arrow keys
    if(keyCode == 39){location[0] += 10;}
    if(keyCode == 38){location[1] -= 10;}
    if(keyCode == 37){location[0] -= 10;}
    if(keyCode == 40){location[1] += 10;}
    //checking whether the screen left the grid
    check_location();
    //println("location: " + location[0] + "," + location[1]);
    
    //load a build
    if(key == 'l'){
      user_load();
    }
  }
  
  //build mode only
  if(scene == 1){
    //saving a build
    if(key == 's'){
      user_save();
    }
    //testing a build (without losing it)
    if(key == 't'){
      if(!testing){
        for(int i = 0; i < m_s; i++){
          arrayCopy(matrix[i],backup_matrix[i]);
        }
      }
      testing = true;
      matrix = step(matrix);
    }
    //reseting after testing
    if(key == 'z'){
      testing = false;
      for(int i = 0; i < m_s; i++){
        arrayCopy(backup_matrix[i],matrix[i]);
      }
    }
  }
  
  //watch mode only 
  if(scene == 2){
    if(key == 'p'){
      //play/pause
      running = !running;
    }
    if(key == 't'){
      //single generation step
      matrix = step(matrix);
    }
  }
  
}


private void draw_menu(){
  //title
  fill(255);
  textSize(60);
  text("John Conway's Game of Life",0,0,800,150);
  
  //buttons
  //build
  draw_button("Build", button_loc[0], button_size[0]);
  //watch
  draw_button("Watch", button_loc[1], button_size[1]);
  //info
  draw_button("Info", button_loc[2], button_size[2]);
  //exit
  draw_button("Exit", button_loc[3], button_size[3]);
  
  //detect mouse
  for(int i = 0; i < 4; i++){
    if(mouseX > button_loc[i][0] && mouseX < button_loc[i][0]+button_size[i][0] &&
       mouseY > button_loc[i][1] && mouseY < button_loc[i][1]+button_size[i][1]){
      noStroke();
      fill(180,130);
      rect(button_loc[i][0],button_loc[i][1],button_size[i][0],button_size[i][1]);
    }
  }
}

private PImage update_matrix_img(){
  //updates the matrix_img to fit the current matrix
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
  //draw the current matrix onto the screen
  
  //turns the matrix into a image
  int scale = width/zoom_levels[zoom_level];
  
  //updates matrix_img
  matrix_img = update_matrix_img();
  
  //custom scale function without bluring the pixels
  matrix_img = pixel_scaler(matrix_img,scale);
  image(matrix_img,0,0);
  
  if(grid){
    stroke(100,130);
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
    for(int i = 0; i < zoom_levels[zoom_level]; i++){
      line(i*scale,0,i*scale,height);
      line(0,i*scale,width,i*scale);
    }
  }
}

private void draw_info(){
  //simply a lot of text on the info screen
  fill(255);
  textSize(60);
  text("John Conway's Game of Life",0,0,800,150);
  textAlign(LEFT,CENTER);
  textSize(30);
  text("Rules: ",30,150,100,50);
  textSize(15);
  text("The universe of the Game of Life is an infinite (here 800x800), two-dimensional orthogonal grid of square cells, \neach of "+
        "which is in one of two possible states, live or dead, (or populated and unpopulated, respectively). " +
        "\nEvery cell interacts with its eight neighbours, which are the cells that are horizontally, vertically, " +
        "\nor diagonally adjacent. At each step in time, the following transitions occur:",60,200,800,80);
  text("1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.",70,280,800,20);
  text("2. Any live cell with two or three live neighbours lives on to the next generation.",70,300,800,20);
  text("3. Any live cell with more than three live neighbours dies, as if by overpopulation.",70,320,800,20);
  text("4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.",70,340,800,20);
  textSize(12);
  text("Source: https://en.wikipedia.org/wiki/Conway's_Game_of_Life",60,360,800,20);
  
  textSize(30);
  text("Controls:",30,390,120,50);
  textSize(15);
  text("- Use ESC to get back to the Main Menu",60,440,800,20);
  text("- Use the arrow keys to move around on the grid",60,460,800,20);
  text("- Use 1 and 2 to zoom in and out respectively",60,480,800,20);
  text("- Use 3 and 4 to decrease and increase the max FPS respectively",60,500,800,20);
  text("- Use G to toggle the grid",60,520,800,20);
  text("- Use H to get back to your initial location",60,540,800,20);
  text("- Use L to load a build",60,560,800,20);
  text("- Use P to pause an play, Watch mode only!",60,580,800,20);
  text("- Use T to execute a single generation step, Watch mode only!",60,600,800,20);
  text("- Use S to save a build, Build mode only!",60,620,800,20);
  text("- Use the left and right mouse button to create and destroy a cell respectively, Build mode only!",60,640,800,20);
  text("- Use T to execute a single generation step and then Z to reset it to the initial conditions, Build mode only!",60,660,800,20);
  
  
  textAlign(CENTER,CENTER);
  
  //next page button
  draw_button("Next Page",button_loc[4],button_size[4]);
  
  if(mouseX > button_loc[4][0] && mouseX < button_loc[4][0]+button_size[4][0] &&
     mouseY > button_loc[4][1] && mouseY < button_loc[4][1]+button_size[4][1]){
    noStroke();
    fill(180,130);
    rect(button_loc[4][0],button_loc[4][1],button_size[4][0],button_size[4][1]);
  }
}

private void draw_info1(){
  //just a lot of text on the info1 screen
  fill(255);
  textSize(60);
  text("John Conway's Game of Life",0,0,800,150);
  textAlign(LEFT,CENTER);
  textSize(30);
  text("Presets: ",30,150,300,50);
  textSize(15);
  text("There are a few presets (builds) already available to watch and/or modify. Following is a list of their names:",60,200,800,20);
  text("- still_vs_oscillators",70,220,800,20);
  text("- glider",70,240,800,20);
  text("- gosper_glider_gun",70,260,800,20);
  text("- simkin_glider_gun",70,280,800,20);
  text("- infinite_growth1",70,300,800,20);
  text("- infinite_growth2",70,320,800,20);
  text("- infinite_growth3",70,340,800,20);
  text("- spaceships",70,360,800,20);
  
  textAlign(CENTER,CENTER);
  
  //previous page button
  draw_button("Previous Page",button_loc[5],button_size[5]);
  
  if(mouseX > button_loc[5][0] && mouseX < button_loc[5][0]+button_size[5][0] &&
     mouseY > button_loc[5][1] && mouseY < button_loc[5][1]+button_size[5][1]){
    noStroke();
    fill(180,130);
    rect(button_loc[5][0],button_loc[5][1],button_size[5][0],button_size[5][1]);
  }
}

private void check_location(){
  //to check whether the current location is still inside the visible zone
  //padding zone may not be seen by the user (infinite grid illusion)
  if(location[0] < padding){location[0]=padding;}
  if(location[1] < padding){location[1]=padding;}
  if(location[0] > m_s-padding-zoom_levels[zoom_level]){location[0] = m_s-padding-zoom_levels[zoom_level];}
  if(location[1] > m_s-padding-zoom_levels[zoom_level]){location[1] = m_s-padding-zoom_levels[zoom_level];}
}

private void check_zoom(){
  //to check whether the zoom level is valid
  if(zoom_level >= zoom_levels.length){zoom_level--;}
  if(zoom_level < 0){zoom_level++;} 
}

private void check_fps(){
  //to check whether the fps index is valid
  if(fps >= fps_list.length){fps--;}
  if(fps < 0){fps++;} 
}

private int[][] step(int[][] m){
  //generation step
  generation++;
  
  //creating new matrix
  int[][] m_new = new int[m_s][m_s];
  int alive_neighbours;
  
  //deepcopy of the old matrix to the new
  for(int i = 0; i < m_s; i++){
    arrayCopy(m[i],m_new[i]);
  }
  
  cell_size = width/zoom_levels[zoom_level];
  for(int i = 0; i < m_s; i++){
    for(int j = 0; j < m_s; j++){
      //calculating alive neighbours, considering edge cases
      if(i == 0 || i == m_s-1 || j == 0 || j == m_s-1){alive_neighbours = 0;}
      else{alive_neighbours = m[j-1][i-1] + m[j-1][i] + m[j-1][i+1] + 
                              m[j][i-1] +               m[j][i+1] + 
                              m[j+1][i-1] + m[j+1][i] + m[j+1][i+1];}
      
      //changing new matrix according to the rules
      //changing population accordingly
      if(m[j][i] == 1){
        if(alive_neighbours < 2 || alive_neighbours > 3){m_new[j][i] = 0;population--;}
      }
      if(m[j][i] == 0){
        if(alive_neighbours == 3){m_new[j][i] = 1;population++;}
      }
    }
  }
  return m_new;
}

private void draw_minimap(int size, float opacity){
  //drawing a minimap in build and watch mode, to not get lost on the 800x800 grid
  
  //first layer
  noStroke();
  fill(120,opacity);
  float temp = width-1.2*size;
  rect(temp,temp,size,size);
  
  //second layer showing current location
  fill(50,opacity);
  float scaler = m_s-2*padding;
  float scale = zoom_levels[zoom_level]/scaler;
  float[] loc = {(location[0]-padding)/scaler,(location[1]-padding)/scaler};
  float[] temp1 = {temp+loc[0]*size,temp+loc[1]*size};
  rect(temp1[0],temp1[1],size*scale,size*scale);
  
  textSize(12);
  fill(50,opacity*1.2);
  text("Generation: " + generation, temp, temp-35,100,20);
  text("Population: " + population, temp, temp-20,100,20);
  text("max FPS: " + fps_list[fps], temp, temp-50,100,20);
  text("current FPS: " + floor(current_fps), temp, temp-65,100,20);
}


private void m_save(int[][] m, String name){
  //saves a given array under given name
  json_matrix = new JSONArray();
  for(int j = 0; j < m_s; j++){
    for(int i = 0; i < m_s; i++){
      json_matrix.setInt(j*m_s+i,m[j][i]);
    }
  }
  saveJSONArray(json_matrix, "data/"+name);
}


private int[][] m_load(String name){
  //loads an array with given name
  json_matrix = loadJSONArray("data/"+name);
  int[][] m = new int[m_s][m_s];
  for(int j = 0; j < m_s; j++){
    for(int i = 0; i < m_s; i++){
      m[j][i] = json_matrix.getInt(j*m_s+i);
    }
  }
  
  //reseting population and generation and pausing
  generation = 0;
  population = 0;
  running = false;
  for(int j = 0; j < m_s; j++){
    for(int i = 0; i < m_s; i++){
      if(m[j][i] == 1){population++;}
    }
  }
  return m;
}

private void user_save(){
  //using the m_save function and adding a UI to make it usable by the user
  
  //name input
  String name = JOptionPane.showInputDialog(frame, "please enter a file name, to save your build", "[name]");
  //the "try" is incase the user closes the input dialog without entering a name
  try{
    
    //given string may not be empty
    if("".equals(name))
    showMessageDialog(null, "That is not a valid input!! A file name must have at least one cahracter", "Alert", ERROR_MESSAGE);
    
    //given name may not be protected (presets)
    for(int i = 0; i < protected_names.length; i++){
      if(name.equals(protected_names[i]) == true){
        allowed = false;
      }
    }
    
    //if everything is fine with the name it is saved
    if(allowed){
      m_save(matrix,name+".json");
      showMessageDialog(null, "Successfully saved your build under \""+name+"\" !", "Info", INFORMATION_MESSAGE);
    }
    
    //error message incase the name is protected
    else{
      println("This is a protected name, please choose a different one");
      showMessageDialog(null, "Protected name!!! Please choose a different one!", "Alert", ERROR_MESSAGE);
      allowed=true;
    }
  }
  catch(Exception e){}
}

private void user_load(){
  //using the m_load function and adding a UI to make it usable by the user
  String name = JOptionPane.showInputDialog(frame, "please enter a file name, you wish to load", "[name]");
  try{matrix = m_load(name+".json");}
  catch(Exception e){showMessageDialog(null, "This file does not exist!!! Please choose a different one!", "Alert", ERROR_MESSAGE);}
}

private void draw_button(String text, int[] loc, int[] s){
  //draw a button with the given inputs:
  //text, location, and bounding box
  noFill();
  stroke(20);
  textSize(20);
  rect(loc[0],loc[1],s[0],s[1]);
  text(text, loc[0],loc[1],s[0],s[1]);
}

private PImage pixel_scaler(PImage img, int scale){
  PImage new_img = new PImage(img.width*scale, img.height*scale);
  for(int j = 0; j < new_img.height; j++){
    for(int i = 0; i < new_img.width; i++){
      int[] p = {floor(i/scale),floor(j/scale)};
      new_img.pixels[j*new_img.width+i] = img.pixels[p[1]*img.width+p[0]];
    }
  }
  return new_img;
}

private PImage custom_filter(PImage original){
  //applies the gaussian_kernel on a given image
  PImage img = original.copy();
  for (int y = 2; y < img.height-2; y++) {
    for (int x = 2; x < img.width-2; x++) {
      int w = img.width;
      
      //Pixelnummer im pixels-Array mit Koordinaten x,y
      int pNum = x+w*y;
      
      int[] pix = {pNum-2-2*w, pNum-1-2*w, pNum-2*w, pNum-2*w+1, pNum-2*w+2,
                   pNum-2-w,   pNum-1-w,   pNum-w,   pNum-w+1,   pNum-w+2,
                   pNum-2,     pNum-1,     pNum,     pNum+1,     pNum+2, 
                   pNum-2+w,   pNum-1+w,   pNum+w,   pNum+w+1,   pNum+w+2, 
                   pNum-2+2*w, pNum-1+2*w, pNum+2*w, pNum+2*w+1, pNum+2*w+2};
      
      int r = 0;
      int g = 0;
      int b = 0;
      
      //Filter auf Nachbarpixel anwenden (jeden Farbkanal einzeln)
      for (int i = 0; i < 25; i++){
        r += red(original.pixels[pix[i]])*gaussian_kernel[i];
        g += green(original.pixels[pix[i]])*gaussian_kernel[i];
        b += blue(original.pixels[pix[i]])*gaussian_kernel[i];
      }
      
      //Farbkanäle wieder zusammenführen
      img.pixels[y*w+x] = color(r,g,b);
    }
  }
  return img;
}

private float[] create_gaussian(float sigma, int size){
  //creates a 2d gaussian kernel
  float[] g = new float[size*size];
  int center = floor(size/2);
  for(int y = 0; y < size; y++){
    for(int x = 0; x < size; x++){
      g[y*size+x] = (1/(TWO_PI*pow(sigma,2))) * exp(-(pow(x-center,2)+pow(y-center,2))/(2*pow(sigma,2)));
    }
  }
  return g;
}


private void draw_menu_animation(int x, int y, boolean first){
  if(first){
  matrix = m_load("main_menu4.json");
  location = new int[] {300,300};
  zoom_level = 4;
  }
  matrix_img = update_matrix_img();
  matrix_img = pixel_scaler(matrix_img,10);
  matrix_img = custom_filter(matrix_img);
  matrix_img.mask(conway);
  image(matrix_img,x,y);
  noFill();
  stroke(40);
  strokeWeight(10);
  rect(x+2,y+2,498,498);
  strokeWeight(1);
  matrix = step(matrix);
}
