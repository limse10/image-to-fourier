class CV {
  PImage raw;
  PImage image;
  Image img;

  int mint=0;
  int maxt=255;


  Kernel blur = gaussblur5_1;

  CV(String path) {
    raw = loadImage(path);
    image = loadImage(path);
    surface.setSize(raw.width, raw.height);
    img=new Image(image);
  }

  void canny() {
    int w=image.width;
    int h=image.height;
    img = toGreyscale(img);
    img = convolve(img, blur);
    Image Gx = convolve(img, sobelX);
    Image Gy = convolve(img, sobelY);

    float[] G = new float[w*h];
    float[] gtheta = new float[G.length];

    for (int i =0; i<G.length; i++) {
      float val = sqrt(sq(Gx.pix[i])+sq(Gy.pix[i]));
      G[i]=val;
      gtheta[i]=atan2(Gy.pix[i], Gx.pix[i]);
      if (gtheta[i]<0) {
        gtheta[i]+=PI;
      }
    }
    float max = max(G);
    for (int i =0; i<G.length; i++) {

      G[i]=G[i]*255/max;
    }
    Image output=new Image(w, h);
    for (int j = 0; j<h; j++) {
      for (int i = 0; i<w; i++) {
        float a=255;
        float b=255;
        try {
          float angle = gtheta[j*w+i];
          if ((angle>=0&&angle<PI/8)||(angle>=7*PI/8)) {
            a=G[(j)*w+(i+1)];
            b=G[(j)*w+(i-1)];
          } else if ((angle>=PI/8&&angle<3*PI/8)) {

            a=G[(j+1)*w+(i-1)];
            b=G[(j-1)*w+(i+1)];
          } else if ((angle>=3*PI/8&&angle<5*PI/8)) {

            a=G[(j-1)*w+(i)];
            b=G[(j+1)*w+(i)];
          } else if ((angle>=5*PI/8&&angle<7*PI/8)) {

            a=G[(j-1)*w+(i-1)];
            b=G[(j+1)*w+(i+1)];
          }
        }
        catch(Exception e) {
        }
        if (G[j*w+i]>=a&&G[j*w+i]>=b) {
          output.pix[j*w+i]=G[j*w+i];
        } else {
          output.pix[j*w+i]=0;
        }
      }
    }

    img=output;

    for (int i=0; i<img.pix.length; i++) {
      if (img.pix[i]>mint&&img.pix[i]<maxt) {
      } else {
        img.pix[i]=0;
      }
    }

    for (int j=0; j<h; j++) {
      for (int i=0; i<w; i++) { 
        if (img.pix[j*w+i]!=0) {
          if (connected(img.pix, i, j, w)) {
            img.pix[j*w+i]=255;
          } else {
            img.pix[j*w+i]=0;
          }
        }
      }
    }

    img.clean();

    img.toPImage();
  }

  
  
  
  
  
  
  boolean connected(float[] p, int i, int j, int w) {
    try {
      if (p[(j-1)*w+(i-1)]!=0) {
        return true;
      }
      if (p[(j-1)*w+(i)]!=0) {
        return true;
      }
      if (p[(j-1)*w+(i+1)]!=0) {
        return true;
      }
      if (p[(j)*w+(i-1)]!=0) {
        return true;
      }
      if (p[(j)*w+(i+1)]!=0) {
        return true;
      }
      if (p[(j+1)*w+(i-1)]!=0) {
        return true;
      }
      if (p[(j+1)*w+(i)]!=0) {
        return true;
      }
      if (p[(j+1)*w+(i+1)]!=0) {
        return true;
      }
    }
    catch(Exception e) {
    }
    return false;
  }

  //CV(PImage img) {
  //  raw = img;
  //  //image = loadImage(path);
  //  surface.setSize(raw.width, raw.height);
  //  image = toGreyscale(image);
  //  image = convolve(image, blur);
  //  image = convolve(image, edge);
  //  image = cutoff(image, 18);
  //}

  void render() {
    image(img.toPImage(), 0, 0);
  }



  Image convolve(Image input, Kernel kernel) {
    Image result = new Image(input.img);
    input.img.loadPixels();
    int w=input.img.width;
    int h=input.img.height;

    for (int i = 0; i<w*h; i++) {
      result.pix[i]=input.pix[i];
    }
    for (int j=0; j<h; j++) {
      for (int i=0; i<w; i++) {

        int wsum=0;

        for (int dy = kernel.miny; dy<=kernel.maxy; dy++) {
          for (int dx = kernel.minx; dx<=kernel.maxx; dx++) {

            try {

              wsum+=kernel.kernel[kernel.cx+dx][kernel.cy+dy]*input.pix[w*(j+dy)+i+dx];
            }
            catch(Exception e) {
            }
          }

          result.pix[w*j+i]=wsum;
        }
      }
    }

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

  Image toGreyscale(Image input) {
    Image result = new Image(input.img);



    for (int i = 0; i<input.w*input.h; i++) {
      float r = red(input.img.pixels[i]);
      float g = green(input.img.pixels[i]);
      float b = blue(input.img.pixels[i]);
      result.pix[i]=0.2126*r + 0.7152*g + 0.0722*b;
    }


    return result;
  }
}
