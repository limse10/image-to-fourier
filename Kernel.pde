class Kernel {

  float[][] kernel;
  int cx, cy;
  int minx, maxx, miny, maxy;
  Kernel(float[][] kernel) {
    this.kernel = kernel;
    if (kernel.length%2==0||kernel[0].length%2==0) {
      println("kernel is invalid");
    } else {
      cx=(kernel[0].length-1)/2;
      cy=(kernel.length-1)/2;
      minx=-(kernel[0].length-1)/2;
      maxx=(kernel[0].length-1)/2;
      miny=-(kernel.length-1)/2;
      maxy=(kernel.length-1)/2;
      this.normalise();


      println(kernel[1][1]);
    }
  }

  void normalise() {
    float sum=0;
    for (int i =0; i<kernel[0].length; i++) {
      for (int j =0; j<kernel.length; j++) {
        sum+=kernel[i][j];
      }
    }
    if (sum!=0) {
      for (int i =0; i<kernel[0].length; i++) {
        for (int j =0; j<kernel.length; j++) {
          kernel[i][j]=kernel[i][j]/sum;
        }
      }
    }
  }
}
