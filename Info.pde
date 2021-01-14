class info_screen{
  
  
  info_screen(){
    
  }

  //------------------------------------------------------------------------------------------------------------

  void draw_info(){
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
    button_manager.draw_button("Next Page",button_loc[4],button_size[4]);
  }
  
  //------------------------------------------------------------------------------------------------------------
  
  void draw_info1(){
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
    button_manager.draw_button("Previous Page",button_loc[5],button_size[5]);
  }
  
  
}
