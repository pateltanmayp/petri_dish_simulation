/* 
 *  Petri Dish Simulation
 *  Author: Tanmay Patel
 *  Description: This application simulates a Petri Dish. It consists of a container, with molecules moving within, 
 *               colliding realistically with container walls and other molecules. The user may interact with the 
 *               application through the GUI, consisting of restart, pause and play functionalities. Additionally, 
 *               the user is able to increment/decrement the molecule speed, as well as the number of 
 *               molecules on the screen. When the user exits the application, data shall be saved to a text file, 
 *               to allow the program to load its initial state from the file upon startup.
 */

import java.util.*;
import java.io.FileWriter;
import java.io.BufferedWriter;

PrintWriter writer;                        // Used to save data to file
PFont font;                                // Font object
int iMoleculeNumber = 0;                   // Stores number of molecules
int iFramerate = 120;                      // Stores frame rate of program. Used to determine time per frame
float fMoleculeVelocity;                   // This variable is global to ensure all molecules have the same speed
boolean bPaused = false;                   // Indicates whether program has been paused
color[] cMoleculeColours = new color[5];   // Array of colours for each molecule, in order of appearance

// Constructs all objects needed for the application (container, buttons, molecules, vectors)
Dish dish = new Dish(250, 399, (#94BFBE), (#011936), 5);
RectButton playPause = new RectButton(50, 50, 150, 100, color(163,22,33), "PLAY/PAUSE");
RectButton restart = new RectButton(600, 50, 150, 100, color(163,22,33), "RESTART");
TriangleButton molecule = new TriangleButton(50, 750, 150, 60, 30, color(163,22,33), "MOLECULE NUMBER");
TriangleButton speed = new TriangleButton(600, 750, 150, 60, 30, color(163,22,33), "VELOCITY");

// Dynamic arrays below allow user to increase/decrease number of molecules
ArrayList<Ball2> balls = new ArrayList<Ball2>(0);
ArrayList<Vector> vectors = new ArrayList<Vector>(0);

void setup() {
  println("Please ensure you have imported the Processing sound library.");
  size(800, 800);
  frameRate(iFramerate);
  font = createFont("Nunito", 30);
  
  // Load the colour array with appropriate colours in correct order
  cMoleculeColours[0] = (#114B5F);
  cMoleculeColours[1] = (#464E51);
  cMoleculeColours[2] = (#01796F);
  cMoleculeColours[3] = (#AA0114);
  cMoleculeColours[4] = (#0B6623);      
  
  loadData();  // Loads data from file and builds molecules accordingly
}

void draw() {  
  
  // Sets up the GUI with the container and all buttons 
  background(0);
  dish.renderDish();
  playPause.renderButton();
  restart.renderButton();
  molecule.renderButtons();
  speed.renderButtons();
  
  // Renders each molecule individually by iterating through all array elements
  for (int ii = 0; ii < balls.size(); ii++) {
    vectors.get(ii).lookAhead(ii);
    balls.get(ii).renderBall(vectors.get(ii).updateX(), vectors.get(ii).updateY());
  }
  
  // Checks all molecules for collision with the container and other balls. Bounces accordingly
  if (!bPaused) {
    for (int zz = 0; zz < balls.size(); zz++) {
      if (vectors.get(zz).detectDishCollision(zz)) {
        vectors.get(zz).bounce();
      }
      if (vectors.get(zz).detectBallCollision(zz)) {
        vectors.get(zz).bounce();
      }
    }
  }
  
  // Pauses all molecules when needed
  for (int aa = 0; aa < vectors.size(); aa++) {
    if (bPaused) {vectors.get(aa).pause();}
  }
}

// Function: Loads data from file, line by line, and creates molecules accordingly
void loadData() {
  
  // Reads text file and creates molecules accordingly
  BufferedReader reader = createReader("data.txt");
  String line = null;
  boolean dataInFile = false;  // True if file contains data
  
  // Reads file and loads data into program
  try {
    println("Loading data...");
    while ((line = reader.readLine()) != null) {  // Reads a line of text from file
      String[] pieces = split(line, TAB);  // Splits line into individual data pieces
      iMoleculeNumber++;
     
      // Loads all data from text file to create the initial state of molecules
      balls.add(new Ball2(float(pieces[2]), (cMoleculeColours[iMoleculeNumber - 1])));  // Determines molecule colour based on molecule number
      vectors.add(new Vector(float(pieces[0]),float(pieces[1]), float(pieces[3])));
      fMoleculeVelocity = float(pieces[4]);
      dataInFile = true;
    }
    reader.close();
  } catch (IOException e) {
    println("Error in loading data from file. Ensure data file is configured/formatted correctly.");
  }
  
  // If there is no data in text file, random molecule is produced
  if (!dataInFile) {
    balls.add(new Ball2(random(16, 24), (#114B5F)));
    vectors.add(new Vector(random(235, 565), random(235, 565), random(TAU))); 
    iMoleculeNumber++;
    fMoleculeVelocity = 500;
  }
}

// Function: Creates a new molecule by adding an element to both the balls and vectors arrays
void increaseMoleculeNumber() {
  balls.add(new Ball2(random(16, 24), cMoleculeColours[iMoleculeNumber - 1]));
  vectors.add(new Vector(random(235, 565), random(235, 565), random(TAU)));
}

// Function: Removes a molecule by taking away the last element of both the balls and vectors arrays
void decreaseMoleculeNumber() {
  balls.remove(iMoleculeNumber);
  vectors.remove(iMoleculeNumber);
}

// Method: Increases speed by 10 px/sec
void increaseSpeed() {
  fMoleculeVelocity+= 10;
}

// Method: Decreases speed by 10 px/sec
void decreaseSpeed() {
  fMoleculeVelocity-= 10;
}

// Function: Restarts program by clearing all molecules from the screen and reverting to the original state (1 molecule)
void restart() {
  balls.clear();
  vectors.clear();
  balls.add(new Ball2(random(16, 24), (#114B5F)));
  vectors.add(new Vector(random(235, 565), random(235, 565), random(TAU)));
  iMoleculeNumber = 1;
  fMoleculeVelocity = 500;
}

// User Function: Allows for user interaction
void mousePressed() {
  
  // Detects click on play/pause button using min/max method of button class - sets 'pause' boolean to opposite value if clicked
  if (mouseX >= playPause.getMinX() && mouseY >= playPause.getMinY() && mouseX <= playPause.getMaxX() && mouseY <= playPause.getMaxY()) {
    bPaused = !bPaused;
    if (bPaused) {println("Application paused");}
    if (!bPaused) {println("Application resumed");}
  }
  
  // Detects click on restart button using min/max method of button class - calls restart() function if clicked
  if (mouseX >= restart.getMinX() && mouseY >= restart.getMinY() && mouseX <= restart.getMaxX() && mouseY <= restart.getMaxY()) {
    restart();
    println("Application restarted");
  }
  
  // Detects click on upper molecule button - calls increaseMoleculeNumber() function if clicked
  if (mouseX >= molecule.getUpperMinX() && mouseY >=  molecule.getUpperMinY() && mouseX <=  molecule.getUpperMaxX() && mouseY <=  molecule.getUpperMaxY()) {
    iMoleculeNumber++;
    if (iMoleculeNumber > 5) {iMoleculeNumber = 5;}  // Caps molecule number at 5
    else {increaseMoleculeNumber();}
    println("Number of molecules increased to " + iMoleculeNumber);
  }
  
  // Detects click on lower molecule button - calls decreaseMoleculeNumber() function if clicked
  if (mouseX >= molecule.getLowerMinX() && mouseY >= molecule.getLowerMinY() && mouseX <= molecule.getLowerMaxX() && mouseY <= molecule.getLowerMaxY()) {
    iMoleculeNumber--;
    if (iMoleculeNumber < 1) {iMoleculeNumber = 1;}  // Caps molecule number at 1
    else {decreaseMoleculeNumber();}
    println("Number of molecules decreased to " + iMoleculeNumber);
  }
  
  // Detects click on upper speed button - calls increaseSpeed() function for all molecules if clicked
  if (mouseX >= speed.getUpperMinX() && mouseY >= speed.getUpperMinY() && mouseX <=  speed.getUpperMaxX() && mouseY <=  speed.getUpperMaxY()) {
    increaseSpeed();
    println("Speed increased to " + fMoleculeVelocity);
  }
  
  // Detects click on lower speed button - calls decreaseSpeed() function if clicked
  if (mouseX >= speed.getLowerMinX() && mouseY >= speed.getLowerMinY() && mouseX <=  speed.getLowerMaxX() && mouseY <=  speed.getLowerMaxY()) {
    decreaseSpeed();
    println("Speed decreased to " + fMoleculeVelocity);
  }
}

// Saves data to text file upon exit
void exit() {
  
  // Initializes writer object after reader object to ensure file is read before its contents are discarded
  try {
    writer = new PrintWriter(new BufferedWriter(new FileWriter(dataFile("data.txt"), false))); 
  } catch (IOException e) {
    println("Error in saving data to file. Ensure file is located in data folder.");
  }
  
  // Cycles through every molecule and writes data to file
  for (int aa = 0; aa < vectors.size(); aa++) {
      
    // Following array stores all data for one molecule
    String moleculeProperties = str(vectors.get(aa).m_fCurrentX) + TAB + str(vectors.get(aa).m_fCurrentY)
                                + TAB + str(balls.get(aa).m_fRadius) + TAB + str(vectors.get(aa).m_fDirection) 
                                + TAB + fMoleculeVelocity;
    writer.println(moleculeProperties);  // Data for one molecule written to file
    writer.flush();  // Data flushed
  }
  writer.close();  // Once all data saved, file closed
  println("Saving data...");
  super.exit();  // Closes program
}
