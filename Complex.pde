class Complex{

  float re;
  float im;
  float amp;
  float angle;
  float freq;
  
  Complex(float re, float im){
  this.re=re;
  this.im=im;
  this.amp = sqrt(sq(re)+sq(im));
  this.angle = atan2(im,re);
   
  }
Complex mult(Complex other)
  {
    float rea = re * other.re - im * other.im;
    float ima = re * other.im + im * other.re;
    return new Complex(rea, ima);
  }

}
