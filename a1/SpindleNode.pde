class SpindleNode{
  PVector pos;
  PVector home;
  float dist_from_home;
  
  SpindleNode(PVector home, PVector pos){
    this.pos = pos;
    this.home = home; 
    dist_from_home = PVector.dist(pos,home);
  }
  
  PVector getPos(){
    return pos;
    
  }
  
  float getDist(){
    return dist_from_home;
  }
}