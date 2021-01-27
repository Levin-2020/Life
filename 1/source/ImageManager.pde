class image_manager{

  image_manager(){
  
  }
  
  //------------------------------------------------------------------------------------------------------------

  PImage pixel_scaler(PImage img, int scale){
    PImage new_img = new PImage(img.width*scale, img.height*scale);
    for(int j = 0; j < new_img.height; j++){
      for(int i = 0; i < new_img.width; i++){
        int[] p = {floor(i/scale),floor(j/scale)};
        new_img.pixels[j*new_img.width+i] = img.pixels[p[1]*img.width+p[0]];
      }
    }
    return new_img;
  }
  
  //------------------------------------------------------------------------------------------------------------
  
  PImage gaussian_filter(PImage original, float sigma, int size){
    //applies the gaussian_kernel on a given image
    gaussian_kernel = create_gaussian(sigma,size);
    
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
  
  //------------------------------------------------------------------------------------------------------------
  
  float[] create_gaussian(float sigma, int size){
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
}
