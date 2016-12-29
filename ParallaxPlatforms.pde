//Written by Kevin Zhan 
//Depth is subjective when you live in 2D.
//This is a simple 2D platforming game where platforms are affected by parralax, despite having no depth.
//Because of this platforms move unpredictably.
//Controls: left and right or a and d to move, up or w to jump, down or s to fall through platforms

//lots of adjustable parameters
int jumpVel = 45, friction = 2, maxVel = 20, numPlats = 10, maxFall = 30, checkBoardSize = 200, playerSize = 50, backDepth = 5;
float gravity = 9.8/5;
color playerColor = color(0, 190, 255);
PVector camera = new PVector(0, 0), startingPos;
Player p;
boolean up = false, down = false, left = false, right = false, grounded = false, drawGrid = true, orderedPlats = true;
ArrayList<Platform> platforms = new ArrayList<Platform>();

//make a windows with stuff. yay stuff
void setup() {
  //use P2D instead of the default software renderer because lots of platforms = lag
  size(1600, 900, P2D);

  //no blurry bullshit here
  noSmooth();

  //because the default strokeWeight of 1 is ugly as sin
  strokeWeight(2);

  //set the player's position on screen based on the window size
  startingPos = new PVector(width/2 - playerSize/2, height*2/3 - playerSize/2);
  p = new Player(startingPos, playerSize, playerColor);

  //set the floor's location based on the player's location
  int floorHeight = (int)(startingPos.y + playerSize);
  platforms.add(new Platform(new PVector(-10000/2, floorHeight, 0), 10000, 10000, color(0)));

  //generate a set grid of platforms
  //good for demonstrating the parralax
  if (orderedPlats) {
    for (int i = -numPlats; i < numPlats; i++) 
      for (int j = -numPlats; j*300 < (floorHeight); j++) 
        platforms.add(new Platform(new PVector (i * 400, j*200, random(0.8, 2)), 200, 75, color(random(0, 255), random(0, 255), random(0, 255))));
  } else {
    //randomly generates platforms
    for (int i = 0; i < numPlats; i++) 
      platforms.add(new Platform(new PVector(random(-5000, 5000), random(-2000, floorHeight - jumpVel*2), random(0.7, 3)), (int)random(50, 900), (int)random(50, 300), color(random(0, 255), random(0, 255), random(0, 255))));
  }

  //sort the platforms by depth in so platforms that are lower in depth are in front when rendered later
  for (int i = 0; i < platforms.size() - 1; i++) {
    float min = platforms.get(i).location.z;
    int mIndex = i;
    for (int j = i + 1; j < platforms.size(); j++)
      if (platforms.get(j).location.z > min) {
        min = platforms.get(j).location.z;
        mIndex = j;
      }
    if (mIndex != i)
      platforms.set(mIndex, platforms.set(i, platforms.get(mIndex)));
  }
}

//main game runs here
void draw() {
  //draws a grid background so the player has a sense of movement
  //lines are more efficient then squares
  //the grid is behind everything and has the greatest depth
  background(255);
  if (drawGrid) {
    for (int i = -1; i <= height/checkBoardSize + 1; i++)
      line(0, i*checkBoardSize - (camera.y/backDepth % checkBoardSize), width, i*checkBoardSize - (camera.y/backDepth % checkBoardSize));
    for (int i = -1; i <= width/checkBoardSize + 1; i++) 
      line (i*checkBoardSize - (camera.x/backDepth % checkBoardSize), 0, i*checkBoardSize - (camera.x/backDepth % checkBoardSize), height);
  }

  //update the player's location based on user input and momentum
  p.update();

  //update the location of all platforms based on the player platform
  boolean rendered = false;
  for (Platform plat : platforms) {
    plat.update();

    //check if the player is on top of a platform
    //render the player on the same layer of the platform it's standing on
    if (p.collide(plat)) {
      p.render();
      plat.update();
      rendered = true;
    }

    //render the player before platforms that are in front of the player
    if (plat.location.z < 1 && !rendered) {
      p.render();
      rendered = true;
    }

    //render the platform is it's on the screen
    if (plat.isVisible())
      plat.render();
  }

  //render the player
  if (!rendered)
    p.render();
}

//activates the keys that are pressed down
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) up = true;
    if (keyCode == DOWN) down = true;
    if (keyCode == LEFT) left = true;
    if (keyCode == RIGHT) right = true;
  }
  if (key == 'w' || key == 'W') up = true;
  if (key == 's' || key == 'S') down = true;
  if (key == 'a' || key == 'A') left = true;
  if (key == 'd' || key == 'D') right = true;
}

//deactivates the keys that are released
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) up = false;
    if (keyCode == DOWN) down = false;
    if (keyCode == LEFT) left = false;
    if (keyCode == RIGHT) right = false;
  }  
  if (key == 'w' || key == 'W') up = false;
  if (key == 's' || key == 'S') down = false;
  if (key == 'a' || key == 'A') left = false;
  if (key == 'd' || key == 'D') right = false;
}