void right_channel() {
  float x1;
  float x2;
  float y1;
  float y2;

  for(int i = 0; i < fft.specSize(); i+=5)
  {
    x1 = 250*cos(i * 2*PI/fft.specSize());
    y1 = 250*sin(i * 2*PI/fft.specSize());
    x2 = (250 + song[0].right.get(i)*100)*cos(i*2*PI/fft.specSize());
    y2 = (250 + song[0].right.get(i)*100)*sin(i*2*PI/fft.specSize());
      
    line (x1, y1, x2, y2);
  }
  beginShape();
  noFill();
  for(int i = 0; i < fft.specSize(); i+=20)
  {
    x2 = (250 + song[0].right.get(i)*100)*cos(i*2*PI/fft.specSize());
    y2 = (250 + song[0].right.get(i)*100)*sin(i*2*PI/fft.specSize());
    
    vertex(x2, y2);
    pushStyle();
    stroke(-1);
    strokeWeight(2);
    point(x2, y2);
    popStyle();
  } 
  endShape();
}
