//Written for Computation & Design Course @ University of Toronto, 2017; 
//documentation can be made available upon request


SpindleGraph graph;
boolean display_hint = true;

void setup(){
  randomSeed(0);
  size(displayWidth,displayHeight);
  graph = new SpindleGraph();
  graph.seedFromPoint(87,68);
  graph.seedFromPoint(419,250);
  graph.seedFromPoint(655,417);
  graph.seedFromPoint(939,282);
  graph.seedFromPoint(1280,114);
  graph.seedFromPoint(1252,658);
  graph.seedFromPoint(699,696);
  graph.seedFromPoint(253,658);
  graph.drawGraph();
  smooth(8);
}

void draw(){

  background(0);
  graph.display();
    if(display_hint){
      pushStyle();
      fill(250);
      textSize(16);
      text("Press c to cycle through algorithm steps",width/2-200,50);
      popStyle();
  }
}

int image_counter = 0;
void keyPressed(){
  
  if(key == 'c'){
    graph.cycleRender();
  }
  
  else if(key == 's'){
    saveFrame("im" + str(image_counter)+".png");
    image_counter++;
  }
}