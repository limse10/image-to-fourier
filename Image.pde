class Image {
  PImage img;
  float[] pix;
  int w, h;
  float[][] pixarr;
  boolean[][] visited;
  Complex[] connected = new Complex[0];

  Image(PImage img) {
    this.img=img;
    this.img.loadPixels();
    this.w=img.width;
    this.h=img.height;
    pix=new float[img.pixels.length];
    for (int i =0; i<pix.length; i++) {
      pix[i]=img.pixels[i];
    }
  }
  Image(int w, int h) {

    this.w=w;
    this.h=h;
    pix=new float[w*h];
  }
 void connect() {
    pixarr = new float[w][h];
    visited = new boolean[w][h];
    for (int j = 0; j<h; j++) {
      for (int i = 0; i<w; i++) {
        pixarr[i][j]=pix[j*w+i];
      }
    }
    search(0, 0, 1);
  }

  void search(int i, int j, int x) {
    println(x);
    if (x>w) {
      return;
    }
    for (int dy=-x; dy<=x; dy++) {
      for (int dx=-x; dx<=x; dx++) {
        try {
          if (!visited[i+dx][j+dy]) {
            visited[i+dx][j+dy]=true;
            if (!(dx==0&&dy==0)) {
              if (pixarr[i+dx][j+dy]==255) {
                connected=(Complex[])append(connected, new Complex(i, j));
                search(i+dx, j+dy, 1);
              }
            }
          }
        }
        catch(Exception e) {
        }
      }
    }
    search(i, j, x+1);
  }

  PImage toPImage() {
    PImage output=new PImage(w, h, RGB);
    output.loadPixels();
    for (int i=0; i<pix.length; i++) {
      output.pixels[i]=color(pix[i], pix[i], pix[i]);
    }
    output.updatePixels();
    return output;
  }


  void clean() {

    for (int j=0; j<h; j++) {
      for (int i=0; i<w; i++) {
        if(i<=3||i>=w-3||j<=3||j>=h-3){
        pix[j*w+i]=0;
        }
      }
    }
  }
} 
