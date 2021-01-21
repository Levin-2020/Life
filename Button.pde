class button{
  int[] loc;
  int[] size;
  int destination_scene;
  int active_scene;
  String text;
  
  //------------------------------------------------------------------------------------------------------------s
  
  button(int[] loc1, int[] size1, String text1, int destination_scene1, int active_scene1){
    loc = loc1;
    size = size1;
    destination_scene = destination_scene1;
    active_scene = active_scene1;
    text = text1;
  }
  
   //------------------------------------------------------------------------------------------------------------
  
  void check_click(){
    //checks for a button press and executes given function
    if(scene == active_scene){
      if(mouseX > loc[0] && mouseX < loc[0]+size[0] &&
         mouseY > loc[1] && mouseY < loc[1]+size[1]){
         matrix = new int[m_s][m_s];
         population = 0;
         generation = 0;
         scene = destination_scene;
      }
    }
  }
  
   //------------------------------------------------------------------------------------------------------------
  
  void check_hover(){
    //checks for a mouse hover over the button and makes it visible
    if(scene == active_scene){
      if(mouseX > loc[0] && mouseX < loc[0]+size[0] &&
         mouseY > loc[1] && mouseY < loc[1]+size[1]){
         noStroke();
         fill(180,130);
         rect(loc[0],loc[1],size[0],size[1]);
      }
    }
  }
  
  //------------------------------------------------------------------------------------------------------------
 
  void draw_button(){
    //draws the button
    if(scene == active_scene){
      fill(150,100);
      stroke(20);
      textSize(20);
      rect(loc[0],loc[1],size[0],size[1]);
      fill(255);
      text(text, loc[0],loc[1],size[0],size[1]);  
    }
  }

}
