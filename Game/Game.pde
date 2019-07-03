import ddf.minim.*;
import ddf.minim.analysis.*;
import controlP5.*;
import java.awt.Frame;
import javax.swing.*;

Minim minim;
AudioPlayer[] song = new AudioPlayer[2];
AudioPlayer soundEffect;
FFT fft;
FFT fft2;
Beat  filter;
healthBar healthBar;

ControlFrame cf;
File file;

// this is for the note pressing
float pressBar = 700;
float maxDist = 200;
int score = 0;
int combo = 0;
boolean didBeat = false;
ArrayList<Notes> noteArray = new ArrayList<Notes>();
float px;
float x;
float y;
float oy = 10;
float[] newSoundBuffer;
float threshold = 120f;
float lowerBeatThreshold = 0.2f;
float upperBeatThreshold = 0.4f;
int health = 100;
int newHealth = 100;
int point = 1;
int mult = 0;
boolean difficultySelected = false;

boolean isSelected = false;
boolean isPressed = false;

String buttonName;
Boolean songSelected = false;
Boolean newSong;
String musicName;

float sliderForHigh = 1;
float sliderForMid = 0.6;
float sliderForLow = 0.22;

float sliderForHighFreq = 6000;
float sliderForMidFreq = 2000;
float sliderForLowFreq = 0;

//setting the range of the frequency
float lowSoundRange = 0.04;
float midSoundRange = 0.13;
float highSoundRange = 0.20;

//creating variables for the sound
float highSound = 0;
float midSound = 0;
float lowSound = 0;

//keep track of how loud the previous sounds are
float prevHighSound = highSound;
float prevMidSound = midSound;
float prevLowSound = lowSound;

float x1;
float x2;
float y1;
float y2;

float eRadius;

boolean state = true;
boolean pause;
boolean hitEffect = false;

Circles[] circle = new Circles[100];

void settings() {
  size(1024, 768);
}

void setup() {
  colorMode(HSB, 360, 100, 100);
  minim = new Minim(this);
  cf = new ControlFrame(this, 240, 580, "Controls");
  song[0] = minim.loadFile("test2.mp3");
  song[1] = minim.loadFile("test2.mp3");
  soundEffect = minim.loadFile("sound_effect.mp3");
  selectInput("Select a file to process:", "fileSelected");
  fft = new FFT(song[1].bufferSize(), song[1].sampleRate());
  fft2 = new FFT(song[1].bufferSize(), song[1].sampleRate());
  fft.window(FFT.HAMMING);
  newSoundBuffer = new float[song[1].bufferSize()];
  filter = new Beat();
  healthBar = new healthBar();
  
  // making the circles 
  for (int i = 0; i < circle.length; i++) {
    circle[i] = new Circles();
  }
  
  ellipseMode(RADIUS);
  eRadius = 20; 
  textFont(createFont("Arial", 10));
  textAlign(RIGHT, TOP);
  noStroke();
  background(0);
}


void draw() {
  stroke(255);
  fill(25, 50);
  noStroke();
  rect(0, 0, width, height);
  noFill();
  
  fill(0, 0, 100);
  textSize(25);
  text("Health: " + health, width, 50);
  text("Score: " + score, width, 80);
  text("Multiplier: x" + multiplier(), width, 110);
  text("Combo: " + combo, width, 140);
  if (hitEffect == true) {
    textSize(15);
    text("Sound Effect: ON", 1020, 500);
  }
  else {
    textSize(15);
    text("Sound Effect: OFF", 1020, 500);
  }
  textSize(25);
  text("Please Read!!", 1020, 540);
  textSize(18);
  text("Select difficulty to start the song you have chosen", 1020, 570); 
  text("Press 'm' for mute/unmute", 1020, 590);
  text("Press 'p' for pause/unpause", 1020, 610);
  text("Wait 3 seconds after unpause/continue from death", 1020, 630);
  fill(0, 100, 100);
  ellipse(580, 660, 7, 7);
  text("Red Circle means do not press", 1020, 650);
  fill(33, 33, 255);
  ellipse(580, 680, 7, 7);
  text("Yellow Circle means hit for reduced points", 1020, 670);
  fill(120, 100, 50);
  ellipse(580, 700, 7, 7);
  text("Green Circle means hit for max points", 1020, 690);
  healthBar.draw();

  song[1].addListener(filter);
  frequency();
  visual();
  stroke(0, 100, 100);
  strokeWeight(10);
  line(80, pressBar, width/2, pressBar);
  
  if (isSelected == true) {
    if (difficultySelected == true) {
      song[1].play();
      song[1].mute();
      fft.forward(song[0].mix);
      filter.lowPass(newSoundBuffer);
      filter.draw();
      if (song[1].position() > 2250 && state == true) {
        song[0].play();
        state = false;
      }
    }
  }
  if (isSelected == false && songSelected == false) {
    song[0].pause();
    song[1].pause();
    state = true;
    health = 100;
    score = 0;
    mult = 0;
    combo = 0;
    difficultySelected = false;
  }
  if (songSelected == true) {
    if (difficultySelected == true) {
      song[1].play();
      song[1].mute();
      fft.forward(song[0].mix);
      filter.lowPass(newSoundBuffer);
      filter.draw();
      if (song[1].position() > 2250 && state == true) {
        song[0].play();
        state = false;
      }
    }
  }
  
  fill(0, 0, 100);
  textSize(18);
  text("D", 550 - (5 * 80.0f), 710);
  text("F", 550 - (4 * 80.0f), 710);
  text("SPACE", 540 - (3 * 68.0f), 710);
  text("J", 550 - (2 * 80.0f), 710);
  text("K", 550 - (1 * 80.0f), 710);
}

void LPFilter() {
  fft.forward(song[1].mix);
  filter.lowPass(newSoundBuffer);
}

void visual(){ 
  prevHighSound = highSound;
  prevMidSound = midSound;
  prevLowSound = lowSound;

  highSound = 0;
  midSound = 0;
  lowSound = 0;

  // get the band of sounds that is within the low frequency range
  for (int i = 0; i < fft.specSize()*lowSoundRange; i++) {
    lowSound += fft.getBand(i);
  }

  // get the band of sounds that is within the mid frequency range
  for (int i = (int)(fft.specSize()*lowSoundRange); i < fft.specSize()*midSoundRange; i++) {
    midSound += fft.getBand(i);
  }

  // get the band of sounds that is within the high frequency range
  for (int i = (int)(fft.specSize()*midSoundRange); i < fft.specSize()*highSoundRange; i++) {
    highSound += fft.getBand(i);
  }

  // calculate the global sound volume, this speed of the animation is depending the values from
  // the sliders
  float globalSound = sliderForLow*lowSound + sliderForMid*midSound + sliderForHigh*highSound;
  
  pushMatrix();
  //  translate(width/3.2, height/6);
    translate(width/2, height/2);
  popMatrix();
  for (int i = 0; i < circle.length; i++) {
    // find how loud the band is
    circle[i].update(globalSound);
    circle[i].show(lowSound, midSound, highSound);
  }
}

void frequency() {
  stroke(255);
  fill(10, 255);
  noStroke();
  rect(74, 0, 444, height);
  pushMatrix();
  //translate(700, -70);
    translate(width/2, height/2);
  popMatrix();
  float maxAmp = 0;
  int maxAmpIndex = 0;
  // find the max amplitude from the spectrum along with its index
  for (int i = 0; i < fft.specSize(); i++) {
    // offset the band so that higher frequency can be viewed better
    float amp = abs(fft.getBand(i) * fft.indexToFreq(i));
    if (amp > maxAmp) {
      maxAmp = amp;
      maxAmpIndex = i;
    }
  }  
  // find the frequency that have the max amplitude for the given band
  float maxAmpFreq = fft.indexToFreq(maxAmpIndex);
  
  // if the frequency is greater than 0 but lower than 2000 - blue
  if (sliderForLowFreq <= maxAmpFreq && maxAmpFreq < sliderForMidFreq)
    stroke(197, 56, 92, 80);

  // if the frequency is greater than 2000 but lower than 4000 - dark red
  else if (sliderForMidFreq <= maxAmpFreq && maxAmpFreq < sliderForHighFreq)
    stroke(335, 71, 100, 80);
    
  // if the frequency is greater than 6000 - gold
  else if (sliderForHighFreq <= maxAmpFreq /*&& maxAmpFreq < 20000*/)
    stroke(56, 100, 80, 80);

  // got through the whole frequency spectrum
  for(int i = 0; i < fft.specSize(); i+=5)
  { 
    x1 = map(i, 0, fft.specSize(), 0, width);
    x2 = map(i + 1, 0, fft.specSize(), 0, width);
    
    strokeWeight(5);
    pushMatrix();
    {
      rotate(PI/2);
      translate(-200, -570);
      //translate(-200, -width/2);
      line (x1, 50 + song[0].left.get(i)*30, x2, 50 + song[0].left.get(i+1)*30);
    }
    popMatrix();
    pushMatrix();
    {
      rotate(PI/2);
      translate(-200, -220);
      line (x1, 150 + song[0].right.get(i)*30, x2, 150 + song[0].right.get(i+1)*30);
    }
    popMatrix();
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    exit();
  }
  else {
    println("User selected " + selection.getAbsolutePath());
    musicName = selection.getAbsolutePath();
    
    song[0] = minim.loadFile(musicName, 1024);
    song[1] = minim.loadFile(musicName, 1024);
    isSelected = true;
  }
}

void controlEvent(ControlEvent theEvent){
  buttonName = theEvent.getController().getName();
  if(theEvent.isController()){
    if(buttonName == "Select"){
      isPressed = true;
      isSelected = false;
      songSelected = false;
      try { 
        UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
      } 
      catch (Exception e) { 
        e.printStackTrace();
      }
      
      if (isPressed == true) {
        JFileChooser musicSelect = new JFileChooser();
        File workingDirectory = new File(System.getProperty("user.dir"));
        musicSelect.setCurrentDirectory(workingDirectory);
        int returnSelect = musicSelect.showOpenDialog(null);
        
        if(returnSelect == JFileChooser.APPROVE_OPTION){
          song[0].close();
          song[1].close();
          file = musicSelect.getSelectedFile();
          song[0] = minim.loadFile(file.getName(), 1024);
          song[1] = minim.loadFile(file.getName(), 1024);
          songSelected = true;
        }
      }

    }
    
    else if(buttonName == "Easy"){
      difficultySelected = true;
      threshold = 100f;
      lowerBeatThreshold = 0.2f;
      upperBeatThreshold = 0.21f;
    }
    else if(buttonName == "Medium"){
      difficultySelected = true;
      threshold = 140f;
      lowerBeatThreshold = 0.2f;
      upperBeatThreshold = 0.23f;
    }
    else if(buttonName == "Hard"){
      difficultySelected = true;
      threshold = 180f;
      lowerBeatThreshold = 0.2f;
      upperBeatThreshold = 0.3f;
    }
    else if(buttonName == "Sound Effect On Hit"){
      if (hitEffect == false) {
        hitEffect = true;
      }
      else 
        hitEffect = false;
    }
    else if(buttonName == "Exit"){
      song[0].close();
      song[1].close();
      minim.stop();
      exit();
    }
  }
}

void keyPressed() {
  if ( key == 'm'|| key == 'M' ) {
    if ( song[0].isMuted() ) {
      song[0].unmute();
    } else {
      song[0].mute();
    }
  }
  
  if ( key == 'p'|| key == 'P' ) {
    if ( song[1].isPlaying() || song[0].isPlaying()) {
      pause = true;
      song[0].pause();
      song[1].pause();
      if (pause == true) {
        textSize(30);
        text("Game is Paused", 1020, 450);
      }
      noLoop();
    } else {
      pause = false;
      new java.util.Timer().schedule(
        new java.util.TimerTask() {
          @Override
          public void run() {
            song[0].play();
            song[1].play();
            loop();
          }
        },
      3000
      );
    }
  }
  
  if (noteArray.size() > 0) {
    Notes bottomNote = noteArray.get(0);  
    boolean rightKey = false;
    boolean mpKey = false;
    int keepCombo = 0;
    switch(key){
      case ' ': 
      if (bottomNote.x == 540 - (3 * 80.0f)) {
        rightKey = true;
      }
      break;
      case 'j':
      if (bottomNote.x == 540 - (2 * 80.0f)) {
        rightKey = true;
      }
      break;
      case 'k':  
      if (bottomNote.x == 540 - (1 * 80.0f)) {        
        rightKey = true;
      }
      break;
      case 'd':
      if (bottomNote.x == 540 - (5 * 80.0f)) {
        rightKey = true;
      }
      break;
      case 'f':
      if (bottomNote.x == 540 - (4 * 80.0f)) {
        rightKey = true;
      }
      break;
      case 'p': {
        keepCombo = combo;
        mpKey = true;
        break;
      }
      case 'm': {
        keepCombo = combo;
        mpKey = true;
        break;
      }
    }
    if (rightKey && abs(pressBar - bottomNote.y) <= maxDist){
      if (hitEffect == true) {
        soundEffect.rewind();
        soundEffect.play();
        soundEffect.setGain(80);
      }
      score += scoreCalculator();
      combo += 1;
      health += 1;
       if (bottomNote.y > pressBar) {
        noteArray.remove(1);
      }
      else
        noteArray.remove(0);
    } 
    else {
      combo = 0;
      health -= 2;     
    } 
    if (mpKey) {
      combo = keepCombo;
      health += 2;   
    }
    healthCheck();
    
  }
}

void healthCheck() {
  if (isSelected == true) {
    if (health <= 0) {
      health = 0;
      song[0].pause();
      song[1].pause();
      textSize(25);
      text("Your died! Press mouse to continue.", 1020, 450);
      noLoop();
    }     
    else if (health > 100) {
      health = 100;
    }
  }
  
  else if (songSelected == true) {
    if (health <= 0) {
      health = 0;
      song[0].pause();
      song[1].pause();
      textSize(25);
      text("Your died! Press mouse to continue.", 1020, 450);
      noLoop();
    }     
    else if (health > 100) {
      health = 100;
    }
  }
}

void mousePressed() {
  if (isSelected == true) {
    if (pause == false) {
      if (song[0].isPlaying() == false && health <= 0 && song[1].isPlaying() == false) {
        new java.util.Timer().schedule(
        new java.util.TimerTask() {
          @Override
          public void run() {
            health = 100;
            score = 0;
            mult = 0;
            combo = 0;
            song[0].play();
            loop();
          }
        },
      3000
      ); 
      }
      //loop();
    }
  }
  else if (songSelected == true) {
    if (pause == false) {
      if (song[0].isPlaying() == false && health <= 0 && song[1].isPlaying() == false) {
        new java.util.Timer().schedule(
        new java.util.TimerTask() {
          @Override
          public void run() {
            health = 100;
            score = 0;
            mult = 0;
            combo = 0;
            song[0].play();
            loop();
          }
        },
      3000
      ); 
      }
      //loop();
    }
  }
}

int scoreCalculator() {
  Notes n = noteArray.get(0);

  if (abs(pressBar - n.y) <= maxDist)
    point = 1;
  if (abs(pressBar - n.y) <= 55)
    point = 3;
  
  return min((combo/4) + point, 8);
}

int multiplier() {
  mult = min((combo/4) + 1, 8);
  return mult;
}
