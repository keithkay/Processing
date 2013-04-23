/*
 * Bitmap generator for an 8x8 LED matrix
 * by Keith Kay
 * 2/2/2013
 * CC by-sa v3.0 - http://creativecommons.org/licenses/by-sa/3.0/
 * http://keithkay.com
 *
 * portions of this code modified from:
 * Two-Dimensional Arrays - Example: 2D Array of Objects
 * arduno.cc
 * http://processing.org/learning/2darray/
 *
 */


Cell[][] bitmap;

PrintWriter bitmapOutput;
int bitmapOutputCount=0;
int imgFrameCount=0;
String filename="";

int cols = 8;
int rows = 8;

void setup() {
  
  size(360,450);
  bitmap = new Cell[rows][cols];
  
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      // Initialize each object
      bitmap[i][j] = new Cell(i*45,j*45,45,45);
    }
  }
  background(204);
  textSize(11);
  textAlign(LEFT);
  fill(0);
  text("Press 'f' on your keyboard to save the current bitmap frame", 10, 380);
  text("Press 's' on your keyboard to save the current set of frames", 10, 400);
  text("to a file", 10, 420);
  text("Press the spacebar to clear the entire bitmap", 10, 440);
  
  // open the file for the bitmap
  openFile();
  
}

void draw() {
  
  drawBitMap();
  

}

void drawBitMap() {
  // The counter variables i and j are also the column and row numbers and 
  // are used as arguments to the constructor for each object in the grid.  
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      bitmap[i][j].display();
    }
  }
}

// using the mouseClicked() event instead of mousePressed, because it was too erratic
void mouseClicked() {
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      int temp = bitmap[i][j].clickedOnMe();
        // we can drop out as soon as we get a match because only one cell can be clicked at a time
        if (temp == 1) break;     
    }
  }
}

void keyReleased() {
  
  // f - save the current frame
  if ((key =='f') || (key == 'F')) {
    // export the bitmap to a file
    saveFrame("bitmaps/bitmap-####.jpg");
    
    // write the header line and then traverse the array to write the bits
    imgFrameCount++;
    bitmapOutput.print("{ ");
    for (int i = 0; i < rows; i++) {
      bitmapOutput.print("  B");
      for (int j = 0; j < cols; j++) {
        bitmapOutput.print(bitmap[i][j].cell_set);
      }
      if (i < rows-1) {
        bitmapOutput.print(", ");
      } else {
        bitmapOutput.println("},");
      }
    }
  }
    
  if ((key =='s') || (key == 'S')) {

    bitmapOutput.println("};"); 
    bitmapOutput.println("");
    
    // print the number of frames
    bitmapOutput.println("const int frames = " + imgFrameCount +";");
    
    // close the current file and open the next
    bitmapOutput.flush();
    bitmapOutput.close();
    imgFrameCount=0;
    openFile();
  }

  // simply clear the grid
  if (key == ' ') {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        bitmap[i][j].clear();
        bitmap[i][j].display();
      }
    }    
  }
}

void openFile() {

  bitmapOutputCount++;
  filename = "bitmaps/bitmap_" + bitmapOutputCount + ".txt";
  println("Opening output file : " + filename);
  bitmapOutput = createWriter(filename);    
  bitmapOutput.println("byte imgFrame[frames][8] = {");
}

// A Cell object
class Cell {
  // A cell object knows about its location in the grid as well as its size with the variables x,y,w,h.
  float x,y;   // x,y location
  float w,h;   // width and height
  byte cell_set;

  // Cell Constructor
  Cell(float tempY, float tempX, float tempW, float tempH) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    cell_set = 0;
  }

  void clear() {
    cell_set = 0;
  }
  
  int clickedOnMe() {
    if ((mouseX > x) && (mouseX < x+w) && (mouseY > y) && (mouseY < y+h)) {
      // we need to flip the current setting of cell_set
      if (cell_set == 1) {
        cell_set = 0;
      } else {
        cell_set = 1;
      }
      return 1;
    } else {
      return 0; 
    }  
  }
    
 
  void display() {
    stroke(204);
    
    // determine fill color
    if (cell_set == 1) {
      fill(0);
    } else {
      fill(255);
    }
    
    rect(x,y,w,h); 
  }
}

