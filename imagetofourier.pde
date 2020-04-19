import gab.opencv.*;




Fourier[] fts;
Fourier ft;
Complex[] drawing = new Complex[0];
//CV cv;
OpenCV cv;
ArrayList<Contour> contours;
PVector[][] cPoints;
Contour[] ordered;
boolean[] visited;
PImage src;
PImage canny;

PImage bg;

String path = "Images/z.jpeg";





float scale = 0.9;
float paf = 2;
int min =20;
int max=50;
int speed = 15;


int mode = 0;

void setup() {
  //fullScreen();
  size(1000, 600);
  surface.setResizable(true);
  //bg = loadImage(path);
  //cv = new CV(path);
  //cv.canny();

  //for (int j =0; j<cv.img.h; j++) {
  //  for (int i = 0; i<cv.img.w; i++) {
  //    if (cv.img.pix[j*cv.img.w+i]==255) {
  //      drawing=(Complex[])append(drawing, new Complex(i, j));
  //    }
  //  }
  //}
  src = loadImage(path);
  cv = new OpenCV(this, src);
  cv.findCannyEdges(min, min);
  //cv.dilate();
  //cv.erode();

  canny = cv.getSnapshot();
  contours=cv.findContours();
  //fts=new Fourier[contours.size()];
  ordered = new Contour[0];
  visited = new boolean[contours.size()];
  cPoints = new PVector[contours.size()][0]; 
  for (int i=0; i<contours.size(); i++) {
    contours.get(i).setPolygonApproximationFactor(paf);
    ArrayList<PVector> pts = contours.get(i).getPolygonApproximation().getPoints();
    for (int j =0; j<pts.size(); j++) {
      cPoints[i]=(PVector[])append(cPoints[i], pts.get(j));
    }
  }
  println("image processed");
  search(0);
  for (Contour c : ordered) {
    for (PVector p : c.getPolygonApproximation().getPoints()) {
      drawing=(Complex[])append(drawing, new Complex(p.x, p.y));
    }
  }

  println("calculating fourier...");
  ft = new Fourier(drawing);
  println("calculation done!");

  canny.resize((int)(canny.width*scale), (int)(canny.height*scale));
  src.resize((int)(src.width*scale), (int)(src.height*scale));
}

void search(int index) {
  visited[index]=true;
  ordered=(Contour[])append(ordered, contours.get(index));
  if (!allTrue(visited)) {
    int closestcontour=0;
    float closestdist=100000;
    for (int i =0; i<contours.size(); i++) {
      if (!visited[i]) {
        float dist = dist(cPoints[index][cPoints[index].length-1].x, cPoints[index][cPoints[index].length-1].y, cPoints[i][0].x, cPoints[i][0].y);
        if (dist<closestdist) {
          closestdist=dist;
          closestcontour=i;
        }
      }
    }
    search(closestcontour);
  }
}

boolean allTrue(boolean[] input) {
  for (boolean b : input) {
    if (!b) {
      return false;
    }
  }
  return true;
}

void draw() {
  for (int i=0;i<speed;i++) {
    background(200);
    translate(0, 0);


    if (mode==1) {

      image(canny, 0, 0);
    }
    if (mode==0) {
      image(src, 0, 0);
    }
    if (mode==2) {

      //int I = (int)map(mouseX, 0, width, 0, cPoints.length-1);
      //for (int i =0;i<I;i++) {
      //  stroke(0);
      //  noFill();
      //  ordered[i].draw();
      //}

      ft.render(scale);
    }
  }
}



void keyPressed() {
  if (key=='`') {
    mode=0;
  }
  if (key=='1') {
    mode=1;
  }
  if (key=='2') {
    mode=2;
  }
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
