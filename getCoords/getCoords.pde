/*
 * Processing Coordinates
 *
 * Simple project to display the x and y coordinates for a point selected 
 * by the mouse. 
 * by Keith Kay
 * 2/2/2013
 * CC by-sa v3.0 - http://creativecommons.org/licenses/by-sa/3.0/
 * http://keithkay.com
 *
 *
 */
 
int prevX;
int prevY;
int refLine;

void setup(){
  size(840,520);
  background(204);
    
  textSize(12);
  textAlign(LEFT);
  text ("Click with your mouse to get the x,y coordinates for the location of the mousepointer", 10, 10);
  
  //draw reference lines
  for(refLine = 120; refLine < 481; refLine += 120){
    line(refLine, 10, refLine,refLine);
    line(0, refLine, refLine, refLine);
    text("("+refLine+","+refLine+")", refLine, refLine+5);
  }
  
  line(600,0, 600,480);
  line(720,0, 720,480);
  line(540,480, 720,480);
  textAlign(CENTER);
  text("(600,480)", 600,500);
  text("(720,480)", 720,500);
  
  //set up formating for the coordinates
  textAlign(LEFT);
  textSize(18);
}

void draw(){

  if (mousePressed){
    
    // rather than refeshing the background and causing a flicker
    // we 'clear' the previous coords by drawing a rect over them
    stroke(204);
    fill(204);
    rect(20, height-30, 150, (height-(height-20)));
    
    fill(1);
    //println("Point - X: " + mouseX + ", Y: " + mouseY);
    text("X : ", 20, height-10);
    text(mouseX, 20 + 30, height-10);
    text("Y : ", 100, height-10);
    text(mouseY, 100 + 30, height-10);
    
  }
  
  // uncomment below to get a screen grab on key press
  //if (keyPressed){
  //  saveFrame("getCoords_grab_###.png");
  //}
  
  //delay(100);
}
