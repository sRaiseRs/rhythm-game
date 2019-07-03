class Circles {
 float x;
 float y;
 float z;
 
 float previousZ;

 
 Circles() {
   x = random(-width/2, width/2);
   y = random(-height/2, height/2);
   z = random(width/2);
   previousZ = z;
 }
 
 void update(float globalSound) {
   z -= pow(globalSound/100, 2);
   if (z < 1) {
     z = width/2;
     x = random(-width/2, width/2);
     y = random(-height/2, height/2);
     previousZ = z;
   }
 }
 
 void show(float lowSound, float midSound, float highSound) {
   color colourForCircle = color(lowSound*0.65, midSound*0.65, highSound*0.65); 
   fill(colourForCircle, 255);
   noStroke();
   
   float x2 = map(x / z, 0, 1, 0, width/2);
   float y2 = map(y / z, 0, 1, 0, height/2);
   float circleSize = map(z, 0, width, 10, 0);
   ellipse(x2, y2, circleSize, circleSize);
   
   float lineX = map(x / previousZ, 0, 1, 0, width/2);
   float lineY = map(y / previousZ, 0, 1, 0, height/2);
   
   previousZ = z;
   
   color colourForLine = color(lowSound*0.85, midSound*0.85, highSound*0.85); 
   stroke(colourForLine, 255);
   line(lineX, lineY, x2, y2);

 }
}
