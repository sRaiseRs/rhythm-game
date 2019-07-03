class Beat implements AudioListener{ 
  private float[] left;
  private float[] right;
  
  Beat() {
    left = null;
    right = null;
  }
  
  public synchronized void samples(float[] samp) {
    left = samp;
    lowPass(left);
  }
  
  public synchronized void samples(float[] sampL, float[] sampR) {
    left = sampL;
    right = sampR;
    lowPass(left);
    lowPass(right);
  }
  
  public synchronized void lowPass(float[] output){
    fft2.forward(output);
    for (int i = 0; i < fft2.specSize(); i++) {
      if (fft2.indexToFreq(i) > threshold) {
        fft2.setBand(i, 0.0);
      }
    }
    fft2.inverse(newSoundBuffer);
  }
  
  public synchronized void draw () {  
    // we've got a stereo signal if right or left are not null
    if ( left != null && right != null ) {
      stroke(50);
      strokeWeight(1);
      noStroke();
      //pushMatrix();
        //translate(-width * 1.2, -320);
        //translate(-width/2, -height/2);
      //popMatrix();
      // if is a beat and the beat is not done
      if(isBeat() && didBeat == false) {
        // pick note x position
        xPos();
        // add note to the note array
        noteArray.add(new Notes(px, 5));
        didBeat = true;
      }
      else if(!isBeat()) {
        didBeat = false;
      }
    }
    
    eRadius = 30;
    for (int i = noteArray.size()-1; i >= 0; --i) {
      Notes n = noteArray.get(i);
      
      // colours of the notes changes depending on what range the note it is in
      if (abs(pressBar - n.y) <= maxDist) { 
        // yellowish orange
        fill(33, 33, 255);
      }      
      else 
        fill(0, 100, 100);
      
      // green
      if (abs(pressBar - n.y) <= 55 ) {
        fill(120, 100, 50);
      }
      
      if (n.y > pressBar) {
        fill(240, 100, 100);
      }

      if (n.update()) {
        noteArray.remove(0);
        combo = 0;
        health -= 2;            
        healthCheck();
      }
        
      n.draw();
    }  
  }
  
  public boolean isBeat() {
    for (int i = 0; i < fft2.specSize(); i++) {
      // if is a beat
      if(lowerBeatThreshold < newSoundBuffer[i] && newSoundBuffer[i] < upperBeatThreshold){
        return true;
      }
    }
    return false;
  }
  
  public void xPos() {
    float position = random(0, 5);
    switch((int)position) {
      case 0: 
      {
        px = 540 - (1 * 80.0f);
        break;
      }
      case 1: 
      {
        px = 540 - (2 * 80.0f);
        break;
      }
      case 2: 
      {
        px = 540 - (3 * 80.0f);
        break;
      }
      case 3: 
      {
        px = 540 - (4 * 80.0f);
        break;
      }
      case 4: 
      {
        px = 540 - (5 * 80.0f);
        break;
      }
    }
  }
}
