//a basic rectangular platform that has "depth" affected 
class Platform {
  PVector pos, location;
  int pHeight, pWidth;
  color c;

  //In order to make life easier, the constructor takes in intial on screen position instead of an abstract location, then converts the position to a location in space
  //0 is used by the floor in order to make sure it's always in the front
  Platform(PVector pos, int pWidth, int pHeight, color c) {
    if (pos.z == 0) this.location = pos;
    else {
      this.pos = pos;
      location = new PVector(pos.x + camera.x/pos.z, pos.y + camera.y/pos.z, pos.z);
    }
    this.pHeight = pHeight;
    this.pWidth = pWidth;
    this.c = c;
  }

  //Update the platform's position on screen based on the camera's location and the platforms's depth
  void update() {
    if (location.z == 0)
      pos = new PVector(location.x - camera.x, location.y - camera.y);
    else pos = new PVector(location.x - (camera.x/location.z), location.y - (camera.y/location.z));
  }

  //Draw the platform
  void render() {
    //float distanceFade = (1 - (location.z - 1)) * (maxOpacity - minOpacity) + minOpacity;
    fill(c);
    rect(pos.x, pos.y, pWidth, pHeight);
  }

  //checks if the platform is visible on screen
  boolean isVisible() {
    return pos.x + pWidth > 0 && pos.x < width && pos.y + pHeight > 0 && pos.y < height;
  }
}
