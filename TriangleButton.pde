/**
  *Petri Dish Simulation - TriangleButton Object
  * Author: Tanmay Patel
  * Description: Creates each system of up/down buttons, with text, and detects clicks
  */

class TriangleButton {
 
  // Properties same as above object
  float m_fXPos;         // Right-most point on button system
  float m_fYPos;         // Lower-most point on button system
  float m_fGap;          // Vertical gap between upper and lower buttons
  float m_fHgt;
  float m_fWdt;
  color m_cColour;
  String m_sButtonName;
 
  // Constructor: Sets up button with bottom-right x and y coordinates
  TriangleButton(float x, float y, float w, float h, float gap, color c, String n) {
    m_fXPos = x;
    m_fYPos = y;
    m_fGap = gap;
    m_fWdt = w;
    m_fHgt = h;
    m_cColour = c;
    m_sButtonName = n;
  }
 
  // Methods: Following 4 methods return the max and min x/y values necessary for a button click on lower button
  float getLowerMinX() {
    return m_fXPos;
  }
 
  float getLowerMinY() {
    return m_fYPos - m_fHgt;
  }
 
  float getLowerMaxX() {
    return m_fXPos + m_fWdt;
  }
 
  float getLowerMaxY() {
    return m_fYPos;
  }
 
  // Methods: Following 4 methods return the max and min x/y values necessary for a button click on upper button
  float getUpperMinX() {
    return m_fXPos;
  }
 
  float getUpperMinY() {
    return m_fYPos - 2*m_fHgt - m_fGap;
  }
 
  float getUpperMaxX() {
    return m_fXPos + m_fWdt;
  }
 
  float getUpperMaxY() {
    return m_fYPos - m_fHgt - m_fGap;
  }
 
  // Method: Renders upper and lower buttons with text in between
  void renderButtons() {
    noStroke();
    fill(m_cColour);
    triangle(m_fXPos, m_fYPos - m_fHgt - m_fGap, m_fXPos + m_fWdt, m_fYPos - m_fHgt - m_fGap, m_fXPos + m_fWdt/2, m_fYPos - 2*m_fHgt - m_fGap);
    triangle(m_fXPos, m_fYPos - m_fHgt, m_fXPos + m_fWdt, m_fYPos - m_fHgt, m_fXPos + m_fWdt/2, m_fYPos);
    fill(255);
    textAlign(CENTER, CENTER);
    text(m_sButtonName, m_fXPos + m_fWdt/2, m_fYPos - m_fHgt - m_fGap/2);
  }
}
