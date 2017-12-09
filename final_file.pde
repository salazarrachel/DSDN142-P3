/*
References

Sound from: 
https://www.freesound.org/people/rhodesmas/sounds/320655/
https://freesound.org/people/cabled_mess/sounds/370846/

Some code based on:
DSDN142 Lectures: SVGs in Processing, Toggle On/Off, Sequential Animation, Keyboard Interactivity, Transfrom the Animation
Using Sound with Minim: https://www.youtube.com/watch?v=LcX36OxgZgg&t=4s 
Maze: https://forum.processing.org/two/discussion/1028 
How to Make Object Disappear Upon Collision: https://forum.processing.org/one/topic/how-do-i-make-an-object-disappear-upon-collision.html 
How to Control Image with Arrow Keys: https://forum.processing.org/two/discussion/1880  
*/

import ddf.minim.*;
int numFrames = 2; // change this number accordingly to the number of frames your animation has 
int slow = 5; 
int frame = 0;
int frameRate = 25;

AudioPlayer sound;
AudioPlayer sound2;
Minim minim;
 
Person myPerson;
Target myTarget;
Shape cube, triangle, cylinder, semicircle, zigzag, arc;
Boundaries[] boundaries;

void setup() {
  size(1280, 720);
  smooth();
  
  //Person & Strawberry
  myTarget = new Target();
  myPerson = new Person();
  
  //Animated Shapes
  cube = new Shape();
  triangle = new Shape();
  cylinder = new Shape();
  semicircle = new Shape();
  zigzag = new Shape();
  arc = new Shape();
  
  //Boundary Square Background
  boundaries = new Boundaries[6];
  boundaries[0] = new Boundaries(100,100,100,100);
  boundaries[1] = new Boundaries(150,450, 200,200);
  boundaries[2] = new Boundaries(400,180,200,160);
  boundaries[3] = new Boundaries(770,70,170,120);
  boundaries[4] = new Boundaries(1100,150,100,425);
  boundaries[5] = new Boundaries(600,490,290,110);
  
  //Sound
  minim = new Minim(this);
  sound = minim.loadFile("sound.wav");
  sound2  = minim.loadFile("sound2.wav");
}

void draw() {
  background(#F6AAC1);
  
  myPerson.display();
  myPerson.move(boundaries);
  
  boundaries[0].display();
  boundaries[1].display();
  boundaries[2].display();
  boundaries[3].display();
  boundaries[4].display();
  boundaries[5].display();
  
  cube.display();
  triangle.display();
  cylinder.display();
  semicircle.display();
  zigzag.display();
  arc.display();
  
  
  //Display Different Frames
   if (frameCount%slow == 0) {
    frame = (frame+1) % numFrames;
   }
   
   //Reposition Strawberry
  if (myPerson.xpos >= myTarget.xpos-60 && myPerson.ypos >= myTarget.ypos-60 &&
    myPerson.xpos <= myTarget.xpos+60 && myPerson.ypos <= myTarget.ypos+60 ) {
    println ("target hit");
    
    //Play Sound Effect
    myTarget = new Target();
    sound.rewind();
    sound.play();
    
    //Prevent Shape Overlap
   boolean overlap = false;
    for(int i = 0; i < boundaries.length; i++){
      if(myTarget.xpos > boundaries[i].xpos && myTarget.xpos < (boundaries[i].xpos + boundaries[i].w) && myTarget.ypos > boundaries[i].ypos && myTarget.ypos < boundaries[i].ypos + boundaries[i].h){
        overlap = true;
        }
                if (overlap ==true) {
                myTarget = new Target();
                 }
    }     
    

  }
  
   else {
    myTarget.display();
  }
  
  
}

void keyPressed() {
  if (keyCode==UP) myPerson.up = true;
  if (keyCode==DOWN) myPerson.down = true;
  if (keyCode==RIGHT) myPerson.right = true;
  if (keyCode==LEFT) myPerson.left = true;  
}

void keyReleased() {
  if (keyCode == UP)     myPerson.up    = false;
  if (keyCode == DOWN)   myPerson.down  = false;
  if (keyCode == LEFT)   myPerson.left  = false;
  if (keyCode == RIGHT)  myPerson.right = false;
}


class Person {
 
  PImage personUp, personDown, personRight, personLeft;
  boolean up, down, left, right;
  float xpos = 600;
  float ypos = 100;
  float speed = 15;

  Person() {
    personUp = loadImage("personUp.png");
    personDown = loadImage("personDown.png");
    personRight = loadImage("personRight.png");
    personLeft = loadImage("personLeft.png");   
  }


  void display() {
    if (keyCode==UP) image(personUp, xpos, ypos);
    else if (keyCode==DOWN) image(personDown, xpos, ypos);
    else if (keyCode==RIGHT) image(personRight, xpos,ypos);
    else if (keyCode==LEFT) image(personLeft, xpos, ypos);
    else image(personUp,xpos,ypos); 
  }
  
  void move(Boundaries[]boundaries){
    
    float possibleX = xpos;
    float possibleY = ypos;
       
    //Moves Person Position
    if (up) possibleY -= speed;
    if (down) possibleY += speed;
    if (left) possibleX -= speed;
    if (right) possibleX += speed;
     
       
  //Prevents Person & Shape Overlap
   boolean didCollide = false;
    for(int i = 0; i < boundaries.length; i++){
      if(possibleX > boundaries[i].xpos && possibleX < (boundaries[i].xpos + boundaries[i].w) && possibleY > boundaries[i].ypos && possibleY < boundaries[i].ypos + boundaries[i].h){
        didCollide = true;
      }
      
      //Play Sound Effect
      if (didCollide==true) {
        sound2.rewind();
        sound2.play();        
      }     
    }
 
    if(didCollide == false){
     xpos = possibleX;
     ypos = possibleY;
    }    
  }
}

class Target {
 
  PImage targetimg;
  float xpos, ypos;

  Target() {
    targetimg = loadImage("strawberry.png");
    xpos = int(random(width-200));
    ypos = int(random(height-200));
    }
    
    void display() {
    image(targetimg, xpos, ypos);
     }    
}

class Shape {
  PImage[] cube = new PImage[numFrames];
  PImage[] triangle = new PImage[numFrames];
  PImage[] cylinder = new PImage[numFrames];
  PImage[] semicircle = new PImage[numFrames];
  PImage[] zigzag = new PImage[numFrames];
  PImage[] arc = new PImage[numFrames];
  
  Shape() {
  //Cube PNG
     cube[0]  = loadImage("cube1.png");
     cube[1] = loadImage("cube2.png");
  
  //Triangle PNG
    triangle[0]  = loadImage("triangle1.png");
    triangle[1] = loadImage("triangle2.png");
  
  //Cylinder PNG
    cylinder[0] = loadImage("cylinder1.png");
    cylinder[1] = loadImage("cylinder2.png");
  
  //Semi Circle PNG
   semicircle[0] = loadImage("semicircle1.png");
   semicircle[1] = loadImage("semicircle2.png");
  
  //Zigzag PNG
   zigzag[0] = loadImage("zigzag1.png");
   zigzag[1] = loadImage("zigzag2.png");

  //Arc PNG
  arc[0] = loadImage("arc1.png");
  arc[1] = loadImage("arc2.png");   
  }
  
  void display() {
    //Draws PNG Images
     image(cube[frame], 100, 100, 100, 100);
     image(triangle[frame], 150, 450,200,200);
     image(cylinder[frame], 400, 180,200,150);
     image(semicircle[frame], 770,70);
     image(zigzag[frame],1100,150);
     image(arc[frame],600,490);   
  }
  
}

class Boundaries {
  float xpos, ypos, w, h;
  
  Boundaries (float xBoundary, float yBoundary, float wBoundary, float hBoundary) {
    xpos = xBoundary;
    ypos = yBoundary;
    w = wBoundary;
    h = hBoundary;
  }
 
 void display() {
   noStroke();
   fill(#F6AAC1);
   rect(xpos,ypos,w,h);
 }
 
 
}