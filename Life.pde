/* Sources:
- https://processing.org/
- https://forum.processing.org/one/
- https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
- https://www.conwaylife.com/wiki/
*/

//for user inputs
import javax.swing.*;
import static javax.swing.JOptionPane.*;

//------global-variables--------------------------------------------------------------------------------------

int m_s = 1000; //matrix_size
int padding = 100; //infinite grid illusion
int[][] matrix = new int[m_s][m_s];
int[] zoom_levels = {800,400,200,100,50,25}; //different zoom levels e.g. [2] = 200x200 grid
int zoom_level = 4; //0=800x800, 1=400x400, 2=200x200, 3=100x100, 4=50x50, 5=25x25
int cell_size; 
int[] location = {300,300}; //initial location
boolean grid = false; //initially the grid is not drawn
int population = 0;
int generation = 0;
PFont calibri;
PFont title_font;
int scene = 0; //0=menu, 1=build, 2=watch, 3=info, 4=exit, 5=info1
boolean editing = false;
boolean running = false;
JSONArray json_matrix = new JSONArray();
PImage conway;
PImage matrix_img;

//all the available button positions and sizes
int[][] button_loc = {{600,300},{600,360},{600,420},{600,480},{650,700},{50,700}};
int[][] button_size = {{100,50}};

//protected names
String[] protected_names = {"gosper_glider_gun","simkin_glider_gun","still_vs_oscillators",
                            "infinite_growth1","infinite_growth2","infinite_growth3", 
                            "glider","spaceships","main_menu","main_menu1","main_menu2",
                            "main_menu3","main_menu4","main_menu5"};
boolean allowed = true;


//fps settings
int[] fps_list = {5,10,20,40,60,80,100,120};
int fps = 2; //default is 10 frames per second
float current_fps;
float time = millis();

//testing in build mode 't'->'z'
boolean testing = false;
int[][] backup_matrix = new int[m_s][m_s];

//main menu animation
float[] gaussian_kernel;
boolean animation_load = true;

data_manager data_manager;
image_manager image_manager;
//buttons
button build_button;
button watch_button;
button info_button;
button exit_button;
button nextpage_button;
button previouspage_button;

//------------------------------------------------------------------------------------------------------------

public void setup(){
  //loading images, setting variables, creating font, ...
  size(800,800);
  conway = loadImage("images/conway1.jpg");
  calibri = createFont("Calibri", 50, true);
  title_font = createFont("Georgia",50);
  textFont(calibri, 20);
  textAlign(CENTER,CENTER);
  matrix_img = new PImage(800,800);
  cell_size = width/zoom_levels[zoom_level];
  data_manager = new data_manager();
  image_manager = new image_manager();
  //initiating buttons
  build_button = new button(button_loc[0],button_size[0],"Build",1,0);
  watch_button = new button(button_loc[1],button_size[0],"Watch",2,0);
  info_button = new button(button_loc[2],button_size[0],"Info",3,0);
  exit_button = new button(button_loc[3],button_size[0],"Exit",4,0);
  nextpage_button = new button(button_loc[4],button_size[0],"Next Page",5,3);
  previouspage_button = new button(button_loc[5],button_size[0],"Previous Page",3,5);
}

//----------------------------------------------------------------------------------------------------------

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
    draw_matrix_img();
    if(running){matrix = step(matrix);}
    draw_minimap(100,120);
  }
  
  if(scene == 3){
    draw_info();
  }
  
  if(scene == 4){
    exit();
  }
  
  if(scene == 5){
    draw_info1();
  }
  
  
  //drawing buttons
  build_button.draw_button();
  watch_button.draw_button();
  info_button.draw_button();
  exit_button.draw_button();
  nextpage_button.draw_button();
  previouspage_button.draw_button();
  
  //checking for button hover
  build_button.check_hover();
  watch_button.check_hover();
  info_button.check_hover();
  exit_button.check_hover();
  nextpage_button.check_hover();
  previouspage_button.check_hover();
}

//------------------------------------------------------------------------------------------------------------

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
  
  //checking for button clicks
  build_button.check_click();
  watch_button.check_click();
  info_button.check_click();
  exit_button.check_click();
  nextpage_button.check_click();
  previouspage_button.check_click();
}

//------------------------------------------------------------------------------------------------------------

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
      data_manager.user_load();
    }
  }
  
  //build mode only
  if(scene == 1){
    //saving a build
    if(key == 's'){
      data_manager.user_save();
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
    if(key == 'r'){
      matrix = random_state_generator();
    }
  }
    
}

//------------------------------------------------------------------------------------------------------------

private void draw_menu(){
  background(70);
  //title
  fill(255);
  textFont(title_font, 60);
  text("John Conway's Game of Life",0,0,800,150);
  textFont(calibri);
}

//------------------------------------------------------------------------------------------------------------

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

//------------------------------------------------------------------------------------------------------------

private void draw_matrix_img(){
  //draw the current matrix onto the screen
  
  //turns the matrix into a image
  int scale = width/zoom_levels[zoom_level];
  
  //updates matrix_img
  matrix_img = update_matrix_img();
  
  //custom scale function without bluring the pixels
  matrix_img = image_manager.pixel_scaler(matrix_img,scale);
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

//------------------------------------------------------------------------------------------------------------

void draw_info(){
  background(70);
  //simply a lot of text on the info screen
  fill(255);
  textFont(title_font,60);
  text("John Conway's Game of Life",0,0,800,150);
  textAlign(LEFT,CENTER);
  textFont(calibri,30);
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
  text("- Use R to generate a random state, Watch mode only!",60,620,800,20);
  text("- Use S to save a build, Build mode only!",60,640,800,20);
  text("- Use the left and right mouse button to create and destroy a cell respectively, Build mode only!",60,660,800,20);
  text("- Use T to execute a single generation step and then Z to reset it to the initial conditions, Build mode only!",60,680,800,20);
  
  
  textAlign(CENTER,CENTER);
  
}

//------------------------------------------------------------------------------------------------------------

private void draw_info1(){
  background(70);
  //just a lot of text on the info1 screen
  fill(255);
  textFont(title_font,60);
  text("John Conway's Game of Life",0,0,800,150);
  textAlign(LEFT,CENTER);
  textFont(calibri,30);
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

}

//------------------------------------------------------------------------------------------------------------

private void check_location(){
  //to check whether the current location is still inside the visible zone
  //padding zone may not be seen by the user (infinite grid illusion)
  if(location[0] < padding){location[0]=padding;}
  if(location[1] < padding){location[1]=padding;}
  if(location[0] > m_s-padding-zoom_levels[zoom_level]){location[0] = m_s-padding-zoom_levels[zoom_level];}
  if(location[1] > m_s-padding-zoom_levels[zoom_level]){location[1] = m_s-padding-zoom_levels[zoom_level];}
}

//------------------------------------------------------------------------------------------------------------

private void check_zoom(){
  //to check whether the zoom level is valid
  if(zoom_level >= zoom_levels.length){zoom_level--;}
  if(zoom_level < 0){zoom_level++;} 
}

//------------------------------------------------------------------------------------------------------------

private void check_fps(){
  //to check whether the fps index is valid
  if(fps >= fps_list.length){fps--;}
  if(fps < 0){fps++;} 
}

//------------------------------------------------------------------------------------------------------------

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

//------------------------------------------------------------------------------------------------------------

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


//------------------------------------------------------------------------------------------------------------

private void draw_menu_animation(int x, int y, boolean first){
  //draw the menu animation
  
  if(first){
    //if it is called for the first time the matrix needs to be loaded
    //as well as the location and zoom_level have to be set
    matrix = data_manager.m_load("main_menu5.json");
    location = new int[] {300,300};
    zoom_level = 4;
  }
  matrix_img = update_matrix_img();
  matrix_img = image_manager.gaussian_filter(matrix_img,0.45,5);
  matrix_img = image_manager.pixel_scaler(matrix_img,10);
  matrix_img = image_manager.gaussian_filter(matrix_img,1.5,5);
  matrix_img.mask(conway);
  image(matrix_img,x,y);
  noFill();
  stroke(40);
  strokeWeight(10);
  rect(x+2,y+2,498,498);
  strokeWeight(1);
  matrix = step(matrix);
}

//------------------------------------------------------------------------------------------------------------

private int[][] random_state_generator(){
  float probability = random(1);
  int[][] m = new int[m_s][m_s];
  for(int j = 0; j < m_s; j++){
    for(int i = 0; i < m_s; i++){
      if(random(1) < probability){m[j][i] = 1;}
    }
  }
  return m;
}
