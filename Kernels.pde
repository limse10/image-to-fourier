Kernel gaussblur3 = new Kernel(new float[][] {
  {1, 2, 1}, 
  {2, 4, 2}, 
  {1, 2, 1}});
Kernel gaussblur5_1 = new Kernel(new float[][] {
  {1, 4, 6, 4, 1}, 
  {4, 16, 24, 16, 4}, 
  {6, 24, 36, 24, 6}, 
  {4, 16, 24, 16, 4}, 
  {1, 4, 6, 4, 1}});

Kernel gaussblur5_2 = new Kernel(new float[][] {
  {2, 4, 5, 4, 2}, 
  {4, 9, 12, 9, 4}, 
  {5, 12, 15, 12, 5}, 
  {4, 9, 12, 9, 4}, 
  {2, 4, 5, 4, 2}});

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


Kernel sobelX = new Kernel(new float[][] {
  {-1, 0, 1}, 
  {-2, 0, 2}, 
  {-1, 0, 1}});

Kernel sobelY = new Kernel(new float[][] {
  {1, 2, 1}, 
  {0, 0, 0}, 
  {-1, -2, -1}});
