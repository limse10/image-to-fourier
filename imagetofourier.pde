
import processing.video.*;

Capture cam;


Fourier ft;
Complex[] drawing = new Complex[0];
CV cv;
String path = "Images/adam.jpg";





float scale = 2;


int mode = 0;

void setup() {
  //fullScreen();
  size(600, 600);
  surface.setResizable(true);

  cv = new CV(path);

  //String[] cameras = Capture.list();
  //cam = new Capture(this, cameras[0]);
  //cam.start();
}

void draw() {
  background(27);
  translate(0, 0);

  //if (cam.available() == true) {
  //    cam.read();
  //  }

  //  cv = new CV(cam);

  //  image(cam,0,0);

  if (mode==0) {
    cv.render();
  }
  if (mode==1) {
    ft.render(scale);
  }
}



void mousePressed() {
  mode=0;
}

void keyPressed() {
  mode=1;
  ft = new Fourier(drawing);
}


void renderDrawing() {
  noFill();
  stroke(255);
  drawing=(Complex[])append(drawing, new Complex(mouseX, mouseY));
  beginShape();
  for (int i=0; i<drawing.length; i++) {
    vertex(drawing[i].re, drawing[i].im);
  }
  endShape();
}
