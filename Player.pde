//stores a controllable player square 
//the player's position on screen is constant and the player "moves" my moving the camera
//this is necessary in order for the parallax system to work properly

class Player {

  PVector pos, vel, acc;
  int size;
  color c;

  Player(PVector p, int size, color c) {
    pos = p;
    this.size = size;
    this.c = c;
    acc = new PVector(0.0, gravity);
    vel = new PVector(0.0, 0.0);
  }

  //updates the position based on controls and gravity and momentum
  void update() {
    //gravity
    if (grounded) {
      if (vel.y > 0) vel.y = 0;
      acc.y = 0;
    } else acc.y = gravity;
    //friction
    if (vel.x < 0) acc.x = friction;
    else if (vel.x > 0) acc.x =- friction;

    //apply acceleration
    vel.add(acc);
    if (vel.y > maxFall) vel.y = maxFall;
    //Controls
    if (up && grounded)
      vel.y = -jumpVel;
    if (left) {
      if ( vel.x > -maxVel) vel.x-=5;      
      else vel.x = -maxVel;
    }
    if (right) {
      if ( vel.x < maxVel)  vel.x+=5;
      else vel.x = maxVel;
    }

    //Apply minimum movement threshold
    if (abs(vel.x) < friction - 0.000000001) {
      acc.x = 0;
      vel.x = 0;
    }

    //Apply Velocity
    camera.add(vel);
    grounded = false;
  }

  //draw the player
  void render() {
    fill(c);
    rect(pos.x, pos.y, size, size);
  }

  //checks if the player is on a platform and reacts accordingly
  //the player can jump through platforms, so collision only applies when the player isn't moving up
  boolean collide(Platform p) {
    if (vel.y < 0 || down)
      return false;
    //checks overlapping of the bottom edge of the player, and a small strip at the top of the platform
    //the strip's thickness is relative to the maximum fall speed of the platform in order to prevent the player from passing through a platform while falling
    else if (pos.x < p.pos.x + p.pWidth && pos.x + size > p.pos.x && pos.y + size < p.pos.y + maxFall/p.location.z && pos.y + size >= p.pos.y) {
      vel.y = 0;
      camera.y -= (int)(pos.y - (p.pos.y - size));
      grounded = true;
      return true;
    }
    return false;
  }
}