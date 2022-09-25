/**
  * Petri Dish Simulation - Vector Object
  * Author: Tanmay Patel
  * Description: Allows a molecule to travel along a specified vector, with direction and velocity
  *              Also handles collision detection and collision calculations (e.g. look-ahead algorithm)
  */

class Vector {
  float m_fCurrentX;             // Current x position
  float m_fCurrentY;             // Current y position
  float m_fFutureX;              // X position 1 frame in the future
  float m_fFutureY;              // Y position 1 frame in the future
  float m_fStartX;               // Initial x position of vector
  float m_fStartY;               // Initial y position of vector
  float m_fDirection;            // Direction of travel
  float m_fMaxRadius;            // Maximum distance between a molecule's centre and the container's centre without collision
  float m_fDistanceToCentre;     // Current distance from molecule's centrepoint, to container's centrepoint
  float m_fMinBallDistance;      // Minimum distance between the centrepoints of 2 molecules without collision
  float m_fBallDistance;         // Current distance between the centrepoints of 2 molecules
  float m_fPushbackDistance;     // Distance that a ball will penetrate its point of collision. Distance needed to push back the molecule
  float m_fPushbackAngle;        // Angle at which to push back the molecule in order to avoid penetration
  float m_fPushbackX = 0;        // Pushback vector decomposed into its x component
  float m_fPushbackY = 0;        // Pushback vector decomposed into its y component
  float m_fMagnitude;            // Magnitude of vector (distance) for each frame
  int m_iFrameCount;             // Number of frames that have passed
  float m_fNormal;               // The normal axis (as an angle) upon any collision
  float m_fInverseNormal;        // The inverse angle to the normal (+/- 180 deg)
  float m_fQi;                   // Angle of incidence for a molecule colliding with another surface
  boolean m_bCollisionDish;      // Whether or not there has been a collision with the container
  boolean m_bCollisionBall;      // Whether or not there has been a collision with another ball
  
  // Constructor: Gives the vector its direction, start position, and velocity
  Vector(float x, float y, float d) {
    setStartPos(x, y);
    setDirection(d);
    m_iFrameCount = 0;
    m_bCollisionDish = false;
    m_bCollisionBall = false;
    m_fPushbackX = 0;
    m_fPushbackY = 0;
  }
  
  // Method: Resets the start position of the vector to a new value
  void setStartPos(float x, float y) {
    m_fStartX = x;
    m_fStartY = y;
    m_fCurrentX = x;
    m_fCurrentY = y;
  }
  
  // Method: Resets the direction of the vector upon collision
  void setDirection(float d) {
    m_fDirection = d;
  }
  
  // Method: Returns x position of vector
  float getCurrentX() {
    return m_fCurrentX;
  }
  
  // MethodL Returns y position of vector
  float getCurrentY() {
    return m_fCurrentY; 
  }
  
  // Method: Pauses the respective molecule by stagnating the counter variable
  void pause() {
    m_iFrameCount--;
  }
  
  // Method: Changes direction of vector, given the incidence direction and normal
  void changeDirection(float incidenceDirection, float normal) {
    m_fInverseNormal = normal + PI;  // Inverse normal is opposite direction of normal
    if (m_fInverseNormal > TWO_PI) {m_fInverseNormal-= TWO_PI;}  // Ensures value of inverseNormal remains below 360 deg
    m_fQi = m_fInverseNormal - incidenceDirection;  // Calculates the angle of incidence relative to the normal, or surface of reflection
    setDirection(normal + m_fQi);  // Sets the new direction based on the laws of physics (Qi = Qr)
  }
  
  // Method: Handles all logistics of a collision
  void bounce() {
    m_iFrameCount = 0;
    setStartPos(m_fCurrentX - m_fPushbackX, m_fCurrentY - m_fPushbackY);
    changeDirection(m_fDirection, m_fNormal);
    m_bCollisionDish = false;
    m_bCollisionBall = false;
  }
  
  // Method: Detects collision with the container wall
  boolean detectDishCollision(int currentBall) {
    
    m_fMaxRadius = dish.getRadius() - balls.get(currentBall).getRadius();  // Max distance between centre of molecule and centre of container
    m_fDistanceToCentre = dist(m_fCurrentX, m_fCurrentY, dish.getCentre(), dish.getCentre());  // Distance between molecule and container center
    
    if (m_fDistanceToCentre >= m_fMaxRadius) {  // Checks is current distance between molecule and container centre exceeds the maximum
      m_fNormal = atan2((m_fCurrentY - dish.getCentre()), (m_fCurrentX - dish.getCentre()));  // Determine angle between molecule and container centre (normal)
      if (m_fNormal <= 0) {m_fNormal = TWO_PI - abs(m_fNormal);}  // Corrects value of normal if atan2() returns negative value
      m_bCollisionDish = true;
      println("Collision with container");
    }
    
    return m_bCollisionDish;
  }
  
  // Method: Detects collision with all other balls
  boolean detectBallCollision(int currentBall) {
    for (int ii = 0; ii < balls.size(); ii++) {  // Cycles through all other balls to check individually for collision
      if (ii == currentBall) {continue;}
   
      m_fMinBallDistance = balls.get(currentBall).getRadius() + balls.get(ii).getRadius();
      m_fBallDistance = dist(vectors.get(currentBall).getCurrentX(), vectors.get(currentBall).getCurrentY(), vectors.get(ii).getCurrentX(), vectors.get(ii).getCurrentY());
      
      if (m_fBallDistance <= m_fMinBallDistance) {  // Bounces if current distance between molecules is lower than minimum possible distance between molecules
      
        // Calculates normal as angle between the centrepoints of the 2 molecules
        m_fNormal = atan2((vectors.get(currentBall).getCurrentY() - vectors.get(ii).getCurrentY()), (vectors.get(currentBall).getCurrentX() - vectors.get(ii).getCurrentX()));
        if (m_fNormal <= 0) {m_fNormal = TWO_PI - abs(m_fNormal);}
        if (m_fNormal > TAU) {m_fNormal-= TAU;}  // Ensures value of normal remains below 360 deg
        
        m_bCollisionBall = true;
        println("Collision with ball");
      }
    }
    return m_bCollisionBall;
  }
  
  // Method: Updates x position of vector using formula taught in class
  float updateX() {
    fill(255);
    if (!bPaused) {m_iFrameCount++;}
    m_iFrameCount++;
    m_fMagnitude = fMoleculeVelocity/iFramerate;
    m_fCurrentX = cos(m_fDirection) * (m_iFrameCount * m_fMagnitude) + m_fStartX - m_fPushbackX;  // Vector formula
    m_fPushbackX = 0;
    return m_fCurrentX;
  }
  
  // Method: Updates y position of vector using formula taught in class
  float updateY() {
    fill(255);
    m_fMagnitude = fMoleculeVelocity/iFramerate;
    m_fCurrentY = sin(m_fDirection) * (m_iFrameCount * m_fMagnitude) + m_fStartY - m_fPushbackY;  // Vector formula
    m_fPushbackY = 0;
    return m_fCurrentY;
  }
  
  // Method: Ensures ball does not go beyond the point of intersection
  void lookAhead(int currentBall) {
    
    // Handles pushback/lookahead for container-ball collision
    m_fMagnitude = fMoleculeVelocity/iFramerate;  
    m_fFutureX = cos(m_fDirection) * ((m_iFrameCount + 1) * m_fMagnitude) + m_fStartX;  // Uses vector formula to calculate x position 1 frame in the future
    m_fFutureY = sin(m_fDirection) * ((m_iFrameCount + 1) * m_fMagnitude) + m_fStartY;  // Uses vector formula to calculate y position 1 frame in the future
    m_fDistanceToCentre = dist(m_fFutureX, m_fFutureY, dish.getCentre(), dish.getCentre());
    m_fMaxRadius = dish.getRadius() - balls.get(balls.size() - 1).getRadius();
    if (m_fDistanceToCentre >= m_fMaxRadius) {  // Checks for collision 1 frame in the future
      m_fPushbackDistance = (m_fDistanceToCentre - m_fMaxRadius);  // Distance to push back is amount that is penetrated
      m_fPushbackAngle = m_fDirection + PI;  // Angle at which to push back is simply the opposite of the incidence direction
        if (m_fDirection > TAU) {m_fDirection-= TAU;}  // Ensures direction remains below 360 deg
      m_fPushbackX = cos(m_fPushbackAngle) * m_fPushbackDistance;  // Decomposes pushback into x component to be subtracted from next frame
      m_fPushbackY = sin(m_fPushbackAngle) * m_fPushbackDistance;  // Decomposes pushback into y component to be subtracted from next frame
    }
    
    // Handles pushback/lookahead for ball-ball collision
    for (int ii = 0; ii < balls.size(); ii++) {
      if (ii == currentBall) {continue;}
      m_fMinBallDistance = balls.get(currentBall).getRadius() + balls.get(ii).getRadius();
      m_fBallDistance = dist(m_fFutureX, m_fFutureY, vectors.get(ii).m_fFutureX, vectors.get(ii).m_fFutureY);
      if (m_fBallDistance <= m_fMinBallDistance) {  // Checks for collision one 1 frame in the future
      
        // Same calculations as above, but for ball-ball collision instead
        m_fPushbackDistance = (m_fMinBallDistance - m_fBallDistance)/2;
        m_fPushbackAngle = m_fDirection + PI;
          if (m_fDirection > TAU) {m_fDirection-= TAU;}
        m_fPushbackX = cos(m_fPushbackAngle) * m_fPushbackDistance;
        m_fPushbackY = sin(m_fPushbackAngle) * m_fPushbackDistance;
      }
    }
  }
}
