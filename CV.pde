class CV {
  PImage raw;
  PImage image;

  Kernel gaussblur3 = new Kernel(new float[][] {
    {1, 2, 1}, 
    {2, 4, 2}, 
    {1, 2, 1}});
  Kernel gaussblur5 = new Kernel(new float[][] {
    {1, 4, 6, 4, 1}, 
    {4, 16, 24, 16, 4}, 
    {6, 24, 36, 24, 6}, 
    {4, 16, 24, 16, 4}, 
    {1, 4, 6, 4, 1}});

  Kernel boxblur = new Kernel(new float[][] {
    {1, 1, 1}, 
    {1, 1, 1}, 
    {1, 1, 1}});
  Kernel sharpen = new Kernel(new float[][] {
    {0, -1, 0}, 
    {-1, 5, -1}, 
    {0, -1, 0}});
  Kernel edge = new Kernel(new float[][] {
    {-1, -1, -1}, 
    {-1, 8, -1}, 
    {-1, -1, -1}});
  Kernel edge2 = new Kernel(new float[][] {
    {-1, 0, 1}, 
    {0, 0, 0}, 
    {1, 0, -1}});


  CV(String path) {
    raw = loadImage(path);
    image = loadImage(path);
    surface.setSize(raw.width, raw.height);
    image = toGreyscale(image);
    image = convolve(image, gaussblur5);
    image = convolve(image, edge);
    image = cutoff(image, 18);
  }
  
  CV(PImage img) {
    raw = img;
    //image = loadImage(path);
    surface.setSize(raw.width, raw.height);
    image = toGreyscale(image);
    image = convolve(image, gaussblur5);
    image = convolve(image, edge);
    image = cutoff(image, 18);
  }
  
  void render() {
    image(image, 0, 0);
  }

  PImage convolve(PImage input, Kernel kernel) {
    PImage result = createImage(input.width, input.height, RGB);
    input.loadPixels();
    result.loadPixels();
    int w=input.width;
    int h=input.height;

    for (int i = 0; i<w*h; i++) {
      result.pixels[i]=input.pixels[i];
    }
    for (int j=0; j<h; j++) {
      for (int i=0; i<w; i++) {

        int wsum=0;

        for (int dy = kernel.miny; dy<=kernel.maxy; dy++) {
          for (int dx = kernel.minx; dx<=kernel.maxx; dx++) {

            try {

              wsum+=kernel.kernel[kernel.cx+dx][kernel.cy+dy]*red(input.pixels[w*(j+dy)+i+dx]);
            }
            catch(Exception e) {
            }
          }

          result.pixels[w*j+i]=color(wsum, wsum, wsum);
        }
      }
    }

    result.updatePixels();
    return result;
  }

  PImage cutoff(PImage input, int thresh) {
    PImage result = createImage(input.width, input.height, RGB);
    input.loadPixels();
    result.loadPixels();
    int w=input.width;
    int h=input.height;


    for (int i = 0; i<w*h; i++) {
      if (red(input.pixels[i])>thresh) {
        result.pixels[i]=color(255);
      } else {
        result.pixels[i]=color(0);
      }
    }


    result.updatePixels();
    return result;
  }

  PImage toGreyscale(PImage input) {
    PImage result = createImage(input.width, input.height, RGB);
    input.loadPixels();
    result.loadPixels();
    int w=input.width;
    int h=input.height;


    for (int i = 0; i<w*h; i++) {
      float r = red(input.pixels[i]);
      float g = green(input.pixels[i]);
      float b = blue(input.pixels[i]);
      result.pixels[i]=color(0.2126*r + 0.7152*g + 0.0722*b);
    }


    result.updatePixels();
    return result;
  }
}
