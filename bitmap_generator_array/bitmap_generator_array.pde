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
Cell[][] thumbnail;



PrintWriter bitmapOutput;
int bitmapOutputCount=0;
int imgFrameCount=0;
String filename="";

int cols = 8;
int rows = 8;

void setup() {
  
  size(400,450);
  imgFrame = new ArrayList();
  
  // initialize the main grid
  bitmap = new Cell[rows][cols];
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      // Initialize each object
      bitmap[i][j] = new Cell(i*45,j*45,45,45);
    }
  }

  // initialize the thumbnail
  thumbnail = new Cell[rows][cols];
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      // Initialize each object
      thumbnail[i][j] = new Cell(i*5,360+j*5,5,5);
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
  bitmapOutputCount++;
  filename = "bitmaps/bitmap_" + bitmapOutputCount + ".h";
  println("Opening output file : " + filename);
  bitmapOutput = createWriter(filename);    

}

void draw() {
  
  drawBitMap();
  
  drawThumb();

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

void drawThumb() {
  
   for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      thumbnail[i][j].display();
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
    
    // traverse the array to write the bits
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        imgFrame[imgFrameCount-1][i][j] = bitmap[i][j].cell_set;
      }
    }
    imgFrameCount++;    
  }
    
  if ((key =='s') || (key == 'S')) {

    // print the number of frame
    bitmapOutput.println("const int frames = " + imgFrameCount +";");
    bitmapOutput.println("byte imgFrame[imgFrameCount][8] = {");

    // traverse the array to write the bits
    for (int i = 0; i < imgFrameCount; i++) {
      bitmapOutput.println("  { B");
      for (int j = 0; j < rows; j++) {
        for (int k = 0; k < cols; k++) {
          imgFrame[i][j][k] = bitmap[j][k].cell_set;
        }
        if (j < rows-1) {
          bitmapOutput.print(",");
        } else if ( i < imgFrameCount-1) {
          bitmapOutput.println("},");
        } else {
          bitmapOutput.println("}");          
          bitmapOutput.println("};"); 
        }         
      }
    }
    
    // close the current file and open the next
    bitmapOutput.flush();
    bitmapOutput.close();
    bitmapOutputCount++;
    imgFrameCount=0;
    filename = "bitmaps/bitmap_" + bitmapOutputCount + ".h";
    println("Opening output file : " + filename);
    bitmapOutput = createWriter(filename);

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

