/**
  * Petri Dish Simulation - RectButton Object
  * Author: Tanmay Patel
  * Description: Creates all rectangular buttons, with text, and detects clicks
  */

class RectButton {
  float m_fXPos;         // X position of button (right-most point on button)
  float m_fYPos;         // Y position of button (top-most point on button)
  float m_fHgt;          // Height of button
  float m_fWdt;          // Length of button
  color m_cColour;       // Button colour
  String m_sButtonName;  // Name to be rendered onto the button
  
  // Constructor: Sets up button with dimensions, location, colour and name
  RectButton(float x, float y, float w, float h, color c, String n) {
    this.m_fXPos = x;
    this.m_fYPos = y;
    m_fWdt = w;
    m_fHgt = h;
    m_cColour = c;
    m_sButtonName = n;
  }
  
  // Methods: Following 4 methods return the max and min x/y values necessary for a button click
  float getMinX() {
    return m_fXPos;
  }
  
  float getMinY() {
    return m_fYPos;
  }
  
  float getMaxX() {
    return m_fXPos + m_fWdt;
  }
  
  float getMaxY() {
    return m_fYPos + m_fHgt;
  }
  
  // Method: Renders button with text
  void renderButton() {
    noStroke();
    fill(m_cColour);
    rect(m_fXPos, m_fYPos, m_fWdt, m_fHgt, 5);
    textAlign(CENTER, CENTER);
    fill(255);
    text(m_sButtonName, m_fXPos + m_fWdt/2, m_fYPos + m_fHgt/2);
  }
}
