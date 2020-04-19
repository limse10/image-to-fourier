class Fourier {

  Complex[] x;
  Complex[] X;
  float step;
  float theta;
  PVector pos = new PVector(0, 0);
  PVector[] trace = new PVector[0];
  float speed=1;



  Fourier(Complex[] x) {
    this.x=x;
    this.X=sortX(dft(x));
    this.step=speed*(2*PI/x.length);
  }


  void render(float scl) {
    pos.x=0;
    pos.y=0;
    int lower=0;
    int upper = 0;
    //if(type==0){
    lower=0;
    upper=150;

    //}else if (type==1){
    //lower=5;
    //upper=50;
    //}

    beginShape();
    for (int i=trace.length-1; i>0; i--) {
      vertex(trace[i].x, trace[i].y);
    }
    endShape();
    for (int k = 0; k < x.length; k++) {

      float prevX=pos.x;
      float prevY=pos.y;
      float amp = X[k].amp;
      float freq = X[k].freq;
      float angle = X[k].angle;
      pos.x += scl*amp*cos(freq*theta+angle);
      pos.y += scl*amp*sin(freq*theta+angle);
      if (k>lower&&k<=upper) {

        stroke(50);
        line(prevX, prevY, pos.x, pos.y);
        strokeWeight(2);
        noFill();
        stroke(100, 200);
        if (k==upper) {
          stroke(255,30,30);
        }
        if(k<25||k==upper){
        ellipse(prevX, prevY, scl*amp*2, scl*amp*2);
      }}
    }


    trace=(PVector[])append(trace, new PVector(pos.x, pos.y));
    noFill();
    stroke(0);



    theta+=step;
    if (theta>2*PI-70*step) {
      theta=0;
      noLoop();
      //trace = new PVector[0];
    }
  }

  Complex[] dft(Complex[] x) {
    int N = x.length;
    Complex[] X = new Complex[N];
    for (int k = 0; k<N; k++) {
      float re=0;
      float im=0;
      for (int n = 0; n < N; n++) {
        float angle = 2*PI*k*n/N;
        Complex c = new Complex(cos(angle), -sin(angle));
        re+=x[n].mult(c).re;
        im+=x[n].mult(c).im;
      }
      X[k]=new Complex(re/N, im/N);
      X[k].freq=k;
    }

    return X;
  }



  Complex[] sortX(Complex[] unsorted) {
    int size = unsorted.length;
    Complex[] output = new Complex[size];
    float[] amps = new float[size];

    for (int i = 0; i<size; i++) {
      amps[i] = unsorted[i].amp;
    }
    float[] sortedamps = reverse(sort(amps));
    for (int i = 0; i<sortedamps.length; i++) {
      for (int j = 0; j<amps.length; j++) {
        if (sortedamps[i]==amps[j]) {
          output[i]=unsorted[j];
        }
      }
    }
    return output;
  }
}
