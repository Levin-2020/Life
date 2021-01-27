class data_manager{
  
  data_manager(){
    
  }
  
  //------------------------------------------------------------------------------------------------------------

  void m_save(int[][] m, String name){
    //saves a given array under given name
    json_matrix = new JSONArray();
    for(int j = 0; j < m_s; j++){
      for(int i = 0; i < m_s; i++){
        json_matrix.setInt(j*m_s+i,m[j][i]);
      }
    }
    saveJSONArray(json_matrix, "data/"+name);
  }
  
  //------------------------------------------------------------------------------------------------------------
  
  int[][] m_load(String name){
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
  
  //------------------------------------------------------------------------------------------------------------
  
  void user_save(){
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
  
  //------------------------------------------------------------------------------------------------------------
  
  void user_load(){
    //using the m_load function and adding a UI to make it usable by the user
    String name = JOptionPane.showInputDialog(frame, "please enter a file name, you wish to load", "[name]");
    try{matrix = m_load(name+".json");}
    catch(Exception e){showMessageDialog(null, "This file does not exist!!! Please choose a different one!", "Alert", ERROR_MESSAGE);}
  }
  
}
