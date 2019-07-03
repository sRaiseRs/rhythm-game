class Notes {
  float x;
  float y;  
  float speed;
  float pos;
  
  public Notes(float x, float speed) {
    this.x = x;
    this.speed = speed;
  }
  
  public boolean update() {
    y += speed;
    if (y > 702) {
      return true;
    }
    return false;
  }

  public void draw(){
    pushMatrix();
    {
      translate(0, y);
      ellipse(x, oy, eRadius, eRadius);
    }
    popMatrix();
  }
}
