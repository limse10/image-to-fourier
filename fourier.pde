Complex[] signal = new Complex[0];
Complex[] X;
float step;
float theta=0;
float scale = 1;
float zoomscale=10;
float speed = 1;

float x = 0;
float y = 0;

PVector[] tracenormal = new PVector[0];
PVector[] tracezoom = new PVector[0];

int mode = 0;
void setup() {
  fullScreen();
  //size(600, 600);
}

void draw() {
  background(27);
  translate(0, 0);
  stroke(200, 50);
  fill(27);
  rect(width-width/3-2, height-width/3-2, width/3, width/3);


  if (mode==0&&mousePressed) {
    noFill();
    stroke(255);
    signal=(Complex[])append(signal, new Complex(mouseX, mouseY));
    beginShape();
    for (int i=0; i<signal.length; i++) {
      vertex(signal[i].re, signal[i].im);
    }
    endShape();
  }
  if (mode==1) {
    translate(0, 0);
    stroke(200, 50);
    render(0, scale);
    stroke(200, 50);
    rect(x-50, y-50, 100, 100); 

    translate((-zoomscale*x+width-width/6), (-zoomscale*y+height-width/6));
    render(1, zoomscale*scale);
  }
}

void render(int type, float scl) {
  x=0;
  y=0;
  int lower=0;
  int upper = 0;
  if(type==0){
    lower=0;
  upper=100;
  
  }else if (type==1){
  lower=5;
  upper=50;
  }
  for (int k = 0; k < X.length; k++) {

    float prevX=x;
    float prevY=y;
    float amp = X[k].amp;
    float freq = X[k].freq;
    float angle = X[k].angle;
    x += scl*amp*cos(freq*theta+angle);
    y += scl*amp*sin(freq*theta+angle);
    if (k>lower&&k<upper) {
      stroke(127, 80);
      line(prevX, prevY, x, y);
      noFill();
      ellipse(prevX, prevY, scl*amp*2, scl*amp*2);
    }
  }

  if (type==0) {
    tracenormal=(PVector[])append(tracenormal, new PVector(x, y));
    noFill();
    stroke(255);
    beginShape();
    for (int i=tracenormal.length-1; i>0; i--) {
      vertex(tracenormal[i].x, tracenormal[i].y);
    }
    endShape();
  } else if (type==1) {
    tracezoom=(PVector[])append(tracezoom, new PVector(x, y));
    noFill();
    stroke(255);
    beginShape();
    for (int i=tracezoom.length-1; i>0; i--) {
      vertex(tracezoom[i].x, tracezoom[i].y);
    }
    endShape();
  }

  theta+=step;
  if (theta>2*PI) {
    theta=0;
    tracenormal = new PVector[0];
    tracezoom = new PVector[0];
  }
}

void mousePressed() {
  mode=0;
}

void mouseReleased() {
  mode=1;
  X=sortX(dft(signal));

  step = speed*(2*PI/signal.length);
  for (int i=0; i<signal.length; i++) {
    println(X[i].re, X[i].re);
  }
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
