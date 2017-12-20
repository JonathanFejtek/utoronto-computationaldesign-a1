class SpindleGraph{
  ArrayList<PVector> nodes = new ArrayList<PVector>();
  ArrayList<SpindleNode> s_nodes = new ArrayList<SpindleNode>();
  ArrayList<PVector> homes = new ArrayList<PVector>();
  PVector pos;
  ArrayList<Spindle> spindles = new ArrayList<Spindle>();
  float max_dist = 250;
  PImage pixel_buffer;
  boolean not_rendered = true;
  boolean bloom = false;
  int cycle_render = -1;
  boolean draw_homes = false;
  boolean draw_nodes = false;
  boolean display_home_radius = false;
  boolean display_node_radius = false;
  
  SpindleGraph(){
    pixel_buffer = createImage(displayWidth,displayHeight,HSB);
  }
  
  void addNode(float x, float y){
    nodes.add(new PVector(x,y));
  }
  
  void toggleBloom(){
    bloom = true;
  }
  
  void resetRenderBooleans(){
    draw_homes = false;
    draw_nodes = false;
    bloom = false;
    display_home_radius = false;
    display_node_radius = false;
  }
  
  void cycleRender(){

    for(Spindle s : spindles){
      s.cycleRender();
    }
    
    switch(cycle_render){
      case 0: resetRenderBooleans(); draw_homes = true;
      break;
      case 1: resetRenderBooleans(); draw_homes = true; display_home_radius = true;
      break;
      case 2: resetRenderBooleans();draw_homes = true; draw_nodes = true; break;
      case 3: resetRenderBooleans(); draw_nodes = true; display_node_radius = true; break; 
      case 4: resetRenderBooleans(); draw_nodes = true; display_node_radius = true; break;
      case 5: resetRenderBooleans(); draw_nodes = true; break;
      case 6: resetRenderBooleans(); draw_nodes = true; break;
      case 7: resetRenderBooleans(); draw_nodes = true; break;
      case 8: break;
      case 9: break;
      case 10: break;
      case 11: break;
      case 12: bloom = true; break; 
    }
    cycle_render ++;
    cycle_render %=13; 
  }
  
  void seedFromPoint(int x, int y){
    homes.add(new PVector(x,y));
    for(int i = 0; i < 3; i++){
    for(float t = 0; t < TWO_PI; t+=TWO_PI/(18/(i+3))){
    SpindleNode new_node = new SpindleNode(new PVector(x,y),
      new PVector(x+random(i*100,(i*100)+100)*sin(t+random(TWO_PI/(9/(i+1)))),
      y+random(i*100,(i*100)+100)*cos(t+random(TWO_PI/(9/(i+1))))));
    s_nodes.add(new_node);
    }
    }
  }
  
  void drawHomes(){
    pushStyle();
    for(PVector v : homes){
      ellipse(v.x,v.y,5,5);
      if(display_home_radius){
      for(int i = 0; i < 3; i++){
          for(float t = 0; t < TWO_PI; t+=TWO_PI/256){
            fill(250);
            stroke(250);
            ellipse(v.x+(((i*100)+100)*cos(t)),v.y+(((i*100)+100)*sin(t)),0.1,0.1);
          }
      }
      }
    }
    popStyle();

  }
  
  void drawGraph(){
      generateBackground();
    for(int i = 0; i < s_nodes.size(); i++){
      for(int j = i; j < s_nodes.size(); j++){
       PVector home = s_nodes.get(i).home;
      PVector p1 = s_nodes.get(i).getPos();
      PVector p2 = s_nodes.get(j).getPos();
      if(PVector.dist(p1,p2) < max_dist){
        Spindle new_spindle = new Spindle(p1.x,p1.y,p2.x,p2.y,max_dist);
        new_spindle.setMaxDist(max_dist);
        new_spindle.setHome(home);
        spindles.add(new_spindle);
      }
      }
    }
    not_rendered = false;
  }
  
  void generateBackground(){
    
    for(int x = 0; x < displayWidth; x++){
      for(int y = 0; y < displayHeight; y++){
        float dist = 0; 
        for(SpindleNode n : s_nodes){
          PVector v = n.getPos();
          pixel_buffer.loadPixels();
          
          dist += 250/(dist(x,y,v.x,v.y)*3);
          pixel_buffer.updatePixels();
        }
        pixel_buffer.set(x,y,color(dist));
    }
    }
    
    
  }
  
  void drawNodes(){
        for(SpindleNode node : s_nodes){
      pushStyle();
      noStroke();
    ellipse(node.getPos().x,node.getPos().y,2,2);
      popStyle();
      if(display_node_radius){
        pushStyle();
        colorMode(RGB,255);
        fill(255,0,0,10);
        noStroke();
        ellipse(node.getPos().x,node.getPos().y,max_dist,max_dist);
        popStyle();
      }
    }
  }
  
  void display(){
    if(bloom){
      image(pixel_buffer,0,0,width,height);
    }
    if(draw_nodes){
      drawNodes();
    }
    if(draw_homes){
      drawHomes();
    }
    
    for(Spindle s : spindles){
      s.display();
    }
  }
}