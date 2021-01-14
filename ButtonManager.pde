class button_manager{
  
  button_manager(){
  }
  
  //------------------------------------------------------------------------------------------------------------
  
  void check_click(){
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
  
  //------------------------------------------------------------------------------------------------------------
  
  void check_hover(){
    noStroke();
    fill(180,130);
    if(scene == 0){
      for(int i = 0; i < 4; i++){
        if(mouseX > button_loc[i][0] && mouseX < button_loc[i][0]+button_size[i][0] &&
           mouseY > button_loc[i][1] && mouseY < button_loc[i][1]+button_size[i][1]){
             rect(button_loc[i][0],button_loc[i][1],button_size[i][0],button_size[i][1]);
        }
      }
    }
    
    if(scene == 3){
      if(mouseX > button_loc[4][0] && mouseX < button_loc[4][0]+button_size[4][0] &&
         mouseY > button_loc[4][1] && mouseY < button_loc[4][1]+button_size[4][1]){
          rect(button_loc[4][0],button_loc[4][1],button_size[4][0],button_size[4][1]);
      }
    }
  
    if(scene == 5){
      if(mouseX > button_loc[5][0] && mouseX < button_loc[5][0]+button_size[5][0] &&
         mouseY > button_loc[5][1] && mouseY < button_loc[5][1]+button_size[5][1]){
          rect(button_loc[5][0],button_loc[5][1],button_size[5][0],button_size[5][1]);
      }
    }
    
  }
  
  //------------------------------------------------------------------------------------------------------------
  
  void draw_button(String text, int[] loc, int[] s){
    //draw a button with the given inputs:
    //text, location, and bounding box
    fill(150,100);
    stroke(20);
    textSize(20);
    rect(loc[0],loc[1],s[0],s[1]);
    fill(255);
    text(text, loc[0],loc[1],s[0],s[1]);  
  }

}
