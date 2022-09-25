/**
  * Petri Dish Simulation - Ball Object
  * Author: Tanmay Patel
  * Description: Allows application to render molecules onto the screen 
  */

class Ball2 {
  float m_fRadius;  // Radius of molecule - variant by +/- 20%
  color m_fColour;  // Colour of molecule - variant based on which molecule
  
  // Constructor: Creates molecule with certain size and colour
  Ball2(float r, color c) {
    m_fRadius = r;
    m_fColour = c;
  }
  
  // Method: Returns radius of molecule (used in collision detection)
  float getRadius() {
    return m_fRadius;
  }
  
  // Renders ball onto screen using radius and colour values
  void renderBall(float x, float y) {
    fill(m_fColour);
    noStroke();
    ellipse(x, y, 2*m_fRadius, 2*m_fRadius);
  }
}
