class healthBar {
  float max;
  float x;
  float y;
  float w;
  float h;
  
  healthBar() {
    max = 100;
    x = 620;
    y = 20;
    w = 400;
    h = 20;
  }
  
  void draw() {
    fill(0, 0, 50);
    noStroke();
    rect(x, y, w, h);
    if (health > 50) {
      fill(120, 100, 50);
    }
    else {
      fill(33, 33, 255);
    }
    if (health < 25) {
      fill(0, 100, 100);
    }
    rect(x, y, map(health, 0, max, 0, w), h);
  }
}
