/*
collage_6 
 by Alejandro García Salas based on P_4_2_1_01.pde from Generative Gestaltung, ISBN: 978-3-87439-759-9 Licensed under the Apache License, Version 2.0 (the "License");
 

/**
 * collage generator. 
 * 
 * KEYS
 * 1-3                  : create a new collage (layer specific)
 * s                    : save jpg
 */

import java.util.Calendar;

PImage[] MyImages;
String[] ImageNames;

int ImageCount;

CollageItem[] Layer1_Items, Layer2_Items, Layer3_Items;


void setup () {
  size (800, 800);
  imageMode (CENTER);
  background (64);

  // ------ load images ------
  
  File dir = new File(sketchPath,"data");

  if (dir.isDirectory ()) {
    String[] contents = dir.list ();
    MyImages = new PImage[contents.length]; 
    ImageNames = new String[contents.length]; 
    for (int i = 0 ; i < contents.length; i++) {
      // skip hidden files and folders starting with a dot, load .jpg files only
      if (contents[i].charAt(0) == '.') continue;
      else if (contents[i].toLowerCase ().endsWith(".jpg")) {
        File childFile = new File(dir, contents[i]);        
        MyImages[ImageCount] = loadImage (childFile.getPath());
        ImageNames[ImageCount] = childFile.getName ();
        println (ImageCount+" "+contents[i]+"  "+childFile.getPath ());
        ImageCount++;             
      }
    }
  }

  // ------ init ------
  Layer1_Items = generateCollageItems ("Layer1", 8, width / 2, height / 2, width, height, 0.4, 1.0, radians (270), radians (270));
  Layer2_Items = generateCollageItems ("Layer2", 8, width / 2, height / 2, width, height, 0.4, 1.0, 0, 0);
  Layer3_Items = generateCollageItems ("Layer3", 8, width / 2, height / 2, width, height, 0.4, 1.0, radians (45), radians (45));


  
  drawCollageItems (Layer1_Items);
  drawCollageItems (Layer2_Items);
  drawCollageItems (Layer3_Items); 
}

void draw() {
  // keep the programm running
}


// ------ interactions and generation of the collage ------
void keyReleased() {
  if (key == 's' || key == 'S') saveFrame (timestamp () + "_##.jpg");

  if (key == '1') Layer1_Items = generateCollageItems ("Layer1", (int) random (1, 8), width / 2, height / 2, width, height, 0.4, 1.0, radians (270), radians (270));
  if (key == '2') Layer2_Items = generateCollageItems ("Layer2", (int) random (1, 8), width / 2, height / 2, width, height, 0.4, 1.0, 0, 0);
  if (key == '3') Layer3_Items = generateCollageItems ("Layer3", (int) random (1, 8), width / 2, height / 2, width, height, 0.4, 1.0, radians (45), radians (45));

  // draw collage
  background (64);
  drawCollageItems (Layer1_Items);
  drawCollageItems (Layer2_Items);
  drawCollageItems (Layer3_Items);
}


// ------ collage class ------
class CollageItem {
  float x = 0, y = 0;
  float rotation = 0;
  float scaling = 1;
  int indexToImage = -1;
}


// ------ collage items helper functions ------
CollageItem[] generateCollageItems (String thePrefix, int theCount, float thePosX, float thePosY, float theRangeX, float theRangeY, float theScaleStart, float theScaleEnd, float theRotationStart, float theRotationEnd) {
  // collect all images with the specified prefix
  int[] indexes = new int[0];
  for (int i = 0 ; i < ImageNames.length; i++) {
    if (ImageNames[i] != null) {
      if (ImageNames[i].startsWith(thePrefix)) {
        indexes = append (indexes, i);
      }
    }
  }

  CollageItem[] items = new CollageItem[theCount];
  for (int i = 0 ; i < items.length; i++) {
    items[i] = new CollageItem();
    items[i].indexToImage = indexes[i%indexes.length];
    items[i].x = thePosX + random (-theRangeX / 2, theRangeX / 2);
    items[i].y = thePosY + random (-theRangeY / 2, theRangeY / 2);
    items[i].scaling = random (theScaleStart, theScaleEnd);
    items[i].rotation = random (theRotationStart, theRotationEnd);
  }
  return items;
}


void drawCollageItems (CollageItem[] theItems) {
  for (int i = 0 ; i < theItems.length; i++) {
    pushMatrix ();
    translate (theItems[i].x, theItems[i].y);
    rotate (theItems[i].rotation);
    scale (theItems[i].scaling);
    image (MyImages[theItems[i].indexToImage], 0, 0);
    popMatrix ();
  }
}


// timestamp
String timestamp () {
  Calendar now = Calendar.getInstance ();
  return String.format ("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}










