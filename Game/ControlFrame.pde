class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;

  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w,h);
  }

  public void setup() {
    surface.setLocation(10,10);
    cp5 = new ControlP5(this);
    cp5.addTextlabel("label").setText("Amplitude Speed Control:").setPosition(20, 20);
    cp5.addSlider("Slider for high sound").plugTo(parent, "sliderForHigh").setPosition(20, 40).setRange(0, 1).setSize(100,20).setValue(1);
    cp5.addSlider("Slider for mid sound").plugTo(parent, "sliderForMid").setPosition(20, 70).setRange(0, 1).setSize(100,20).setValue(0.6);
    cp5.addSlider("Slider for low sound").plugTo(parent, "sliderForLow").setPosition(20, 100).setRange(0, 1).setSize(100,20).setValue(0.22);
    cp5.addTextlabel("label1").setText("Frequency Range Control:").setPosition(20, 130);
    cp5.addSlider("High frequency range").plugTo(parent, "sliderForHighFreq").setPosition(20, 150).setRange(0, 10000).setSize(100,20).setValue(6000);
    cp5.addSlider("Mid frequency range").plugTo(parent, "sliderForMidFreq").setPosition(20, 180).setRange(0, 10000).setSize(100,20).setValue(2000);
    cp5.addSlider("Low frequency range").plugTo(parent, "sliderForLowFreq").setPosition(20, 210).setRange(0, 10000).setSize(100,20).setValue(0);
    //cp5.addSlider("Beat Threshold").plugTo(parent, "threshold").setPosition(20, 260).setRange(0, 1500).setSize(100,20).setValue(120f);
    //cp5.addSlider("Beat Lower Bound").plugTo(parent, "lowerBeatThreshold").setPosition(20, 300).setRange(0, 1).setSize(100,20).setValue(0.2f);
    //cp5.addSlider("Beat Upper Bound").plugTo(parent, "upperBeatThreshold").setPosition(20, 340).setRange(0, 1).setSize(100,20).setValue(0.4f);
    cp5.addTextlabel("label2").setText("Difficulty:").setPosition(20, 240);
    cp5.addButton("Easy").setValue(0).setPosition(20, 260).setSize(200,19).plugTo(parent, "buttonName");
    cp5.addButton("Medium").setValue(0).setPosition(20, 290).setSize(200,19).plugTo(parent, "buttonName");
    cp5.addButton("Hard").setValue(0).setPosition(20, 320).setSize(200,19).plugTo(parent, "buttonName");
    cp5.addTextlabel("label3").setText("Manual Difficulty Selection:").setPosition(20, 350);
    cp5.addSlider("threshold").setLabel("Beat Threshold").plugTo(parent, "threshold").setPosition(20, 370).setRange(0, 400).setSize(100,20).setValue(threshold);
    cp5.addSlider("lowerBeatThreshold").setLabel("Beat Lower Bound").plugTo(parent, "lowerBeatThreshold").setPosition(20, 400).setRange(0, 1).setSize(100,20).setValue(lowerBeatThreshold);
    cp5.addSlider("upperBeatThreshold").setLabel("Beat Upper Bound").plugTo(parent, "upperBeatThreshold").setPosition(20, 430).setRange(0, 1).setSize(100,20).setValue(upperBeatThreshold);
    cp5.addTextlabel("label4").setText("Music Selection").setPosition(20, 460);
    cp5.addButton("Sound Effect On Hit").setValue(0).setPosition(20, 480).setSize(200,19).plugTo(parent, "buttonName");
    cp5.addButton("Select").setValue(0).setPosition(20, 510).setSize(200,19).plugTo(parent, "buttonName");
    cp5.addButton("Exit").setValue(0).setPosition(20, 540).setSize(200,19).plugTo(parent, "buttonName");
  }

  void draw() {
    background(40);
  }
}
