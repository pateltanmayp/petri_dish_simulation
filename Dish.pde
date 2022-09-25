/**
  * Petri Dish Simulation - Dish Object
  * Author: Tanmay Patel
  * Description: Renders the container onto the screen at certain location and with certain size
  */
  
class Dish {
  float m_fRadius;           // Radius of container: used to detect collision
  float m_fCentre;           // Centrepoint of container: used to identify normal axis during collision
  color m_cDishColour;       // Fill colour of container
  color m_cBorderColour;     // Colour of border
  float m_fBorderThickness;  // Stroke weight of petri dish border
  
  // Constructor: Sets up container with specified radius and location
  Dish (float r, float c, color dish, color border, float strokeWgt) {
    m_fRadius = r;
    m_fCentre = c;
    m_cDishColour = dish;
    m_cBorderColour = border;
    m_fBorderThickness = strokeWgt;
  }
  
  // Method: Returns radius
  float getRadius() {
    return m_fRadius;
  }
  
  // Method: Returns centrepoint
  float getCentre() {
    return m_fCentre;
  }
  
  // Method: Renders dish in certain location with specific size
  void renderDish() {
    fill(m_cDishColour);
    stroke(m_cBorderColour);
    strokeWeight(m_fBorderThickness);
    ellipse(m_fCentre, m_fCentre, 2*m_fRadius, 2*m_fRadius); 
  }
}
