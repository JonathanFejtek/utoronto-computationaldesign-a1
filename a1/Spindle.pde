class Spindle{
  PVector p1;
  PVector p2;
  PVector normal1;
  PVector normal2;
  float max_dist;

  PVector midPoint;
  PVector normal_line1;
  PVector normal_line2;
  PVector[] normals1 = new PVector[10];
  PVector[] normals2 = new PVector[10];
  PVector[][] normal_lines = new PVector[128][2];
  int line_density = 8;
  float magnitude;
  float weave_freq;
  float weave_amp;
  int phase_iteration = 8;
  
  int render_cycler = -1;
  boolean draw_spine = false;
  boolean draw_central_normal = false;
  boolean draw_pspace = false;
  boolean draw_uvs = false;
  boolean draw_weave = false;
  boolean color_weave = false;
  boolean iterate_harmonics = false;
  boolean draw_maximal_lines = false;
  PVector home;
  float dist_from_home;
  
  
  Spindle(float x1, float y1, float x2, float y2,float max_dist){
    p1 = new PVector(x1,y1); 
    p2 = new PVector(x2,y2);
    this.max_dist = max_dist;
    
    findMidPoint();
    findNormal();
    findMag();
    weave_freq = (int)map(magnitude,0,max_dist,2,5);
    weave_amp = map(magnitude,0,max_dist,1,3);
    generateNormalLines();
  }
  
  void resetRenderBooleans(){
    draw_spine = false;
    draw_central_normal = false;
    draw_pspace = false;
    draw_uvs = false;
    draw_weave = false;
    color_weave = false;
    iterate_harmonics = false;
    draw_maximal_lines = false;
  }
  
  void cycleRender(){
    
   
    switch(render_cycler){
      case 0: resetRenderBooleans();break;
      case 1: resetRenderBooleans();break;
      case 2: resetRenderBooleans();break;
      case 3: resetRenderBooleans();break;
      case 4: resetRenderBooleans(); 
        draw_spine = true; 
        break;
        
     case 5: resetRenderBooleans(); 
        draw_spine = true; 
        break;
        
      case 6: resetRenderBooleans(); 
        draw_spine = true; 
        draw_central_normal = true; 
        break;
        
      case 7: resetRenderBooleans(); 
        draw_spine = true; 
        draw_central_normal = true;
        draw_pspace = true;
        break;
        
      case 8: resetRenderBooleans();
        draw_spine = true;
        draw_central_normal = true;
        draw_pspace = true;
        draw_uvs = true;
        break;
        
      case 9: resetRenderBooleans();
        //draw_spine = true;
        draw_maximal_lines = true;
        break;
        
      case 10: resetRenderBooleans();
        //draw_spine = true; 
        draw_weave = true;
        break;      
        
      case 11: resetRenderBooleans();
        draw_weave = true;
        iterate_harmonics = true;
        break;
        
      case 12: resetRenderBooleans();
        draw_weave = true;
        iterate_harmonics = true;
        color_weave = true;
        break;
      }
       render_cycler++;
       render_cycler %=13;
      
  }
  
  void setHome(PVector p){
    home = p.get();
    dist_from_home = PVector.dist(p,midPoint);
  }
  
  void setMaxDist(float f){
    max_dist = f;
  }
  
  PVector getVectorAtSurfaceUV(float u, float v){
    if(u == 0){
      return p1;
    }
    else if(u == 1){
      return p1;
    }
    else{
    PVector[] seg = normal_lines[int(map(u,0,1,0,127))];
    PVector result = PVector.lerp(seg[0],seg[1],v);
    return result;
    }
  }
  
  void generateNormalLines(){
    int c = 0;
    //float iter = 1/32; 
    //processing won't let me use this variable ??; so....
    for(float i = 0.0078125; i < 1; i+=0.0078125){
      normal_lines[c][0] = getLineSegForParameter(i)[0];
      normal_lines[c][1] = getLineSegForParameter(i)[1];
      c++;
    }
  }
  
  void findMag(){
    magnitude = PVector.dist(p1,p2);
  }
  
  void findNormal(){
    float dx = p2.x - p1.x;
    float dy = p2.y - p1.y;
    magnitude = PVector.dist(p1,p2);
    normal1 = new PVector(-dy,dx);
    normal1.setMag(magnitude/4);
    normal2 = new PVector(dy,-dx);
    normal2.setMag(magnitude/4);
    normal_line1 = midPoint.get().add(normal1);
    normal_line2 = midPoint.get().add(normal2);
   
   for(int i = 0; i < line_density; i++){
     magnitude = PVector.dist(p1,p2);
     normal1 = new PVector(-dy,dx);
     normal2 = new PVector(dy,-dx);
     normal1.setMag(map(i,0,line_density,0,magnitude/4));
     normal2.setMag(map(i,0,line_density,0,magnitude/4));
     normals1[i] = midPoint.get().add(normal1);
     normals2[i] = midPoint.get().add(normal2);
   }
  }
  
  void findMidPoint(){
    midPoint = PVector.lerp(p1,p2,0.5);
  }
  
  void display(){
    if(draw_spine){
      drawSpine();
    }
    
    if(draw_central_normal){
      drawCentralNormal();
    }
    
    if(draw_pspace){
      drawPSpace();
    }
    
    if(draw_uvs){
      drawUVLimitPoints();
    }
    
    if(draw_maximal_lines){
      drawMaximalLines();
      drawVariableEllipses();
    }
   
    if(draw_weave){
      drawWeave();
    }
    
    
  }
  
  void drawSpine(){
    pushStyle();
    colorMode(RGB,250);
    stroke(250,0,0);
    strokeWeight(0.3);
    line(p1.x,p1.y,p2.x,p2.y);
    popStyle();
  }
  
  void drawCentralNormal(){
    pushStyle();
    colorMode(RGB,250);
    stroke(250,0,0);
    line(normal_line1.x,normal_line1.y,normal_line2.x,normal_line2.y);
    popStyle();
  }
  
  void drawPSpace(){
    pushStyle();
    colorMode(RGB,255);
    stroke(250,0,0,70);
    for(int i = 0; i < normal_lines.length-1; i+=7){
      PVector p_1 = normal_lines[i][0];
      PVector p_2 = normal_lines[i][1];
      line(p_1.x,p_1.y,p_2.x,p_2.y);
    }
    popStyle();

  }
  
  void drawUVLimitPoints(){
    PVector p_1 = getVectorAtSurfaceUV(0.5,1);
    PVector p_2 = getVectorAtSurfaceUV(0.5,0);
    PVector p_3 = getVectorAtSurfaceUV(0.25,1);
    PVector p_4 = getVectorAtSurfaceUV(0.25,0);
    PVector p_5 = getVectorAtSurfaceUV(0.75,1);
    PVector p_6 = getVectorAtSurfaceUV(0.75,0);
    pushStyle();
      colorMode(RGB,255);
      noStroke();
      fill(0,0,255);
      ellipse(p_1.x,p_1.y,3,3);
      ellipse(p_2.x,p_2.y,3,3);
      ellipse(p_3.x,p_3.y,3,3);
      ellipse(p_4.x,p_4.y,3,3);
      ellipse(p_5.x,p_5.y,3,3);
      ellipse(p_6.x,p_6.y,3,3);
    popStyle();
  }
  
  void drawMaximalLines(){
    for(float i = 0.01; i <= 1; i+=0.01){
      PVector p_2 = getVectorAtSurfaceUV(i,0);
       PVector p_1 = getVectorAtSurfaceUV(i-0.01,0);
       PVector p_2a = getVectorAtSurfaceUV(i,1);
       PVector p_1a = getVectorAtSurfaceUV(i-0.01,1);
       pushStyle();
       colorMode(RGB,255);
       stroke(0,0,255);
       strokeWeight(0.2);
       line(p_1.x,p_1.y,p_2.x,p_2.y);
       line(p_1a.x,p_1a.y,p_2a.x,p_2a.y);
       popStyle();
    }
  }
  
  void drawVariableEllipses(){
     for(float i = 0.1; i <= 1; i+=0.1){
      PVector p_1 = getVectorAtSurfaceUV(i,0.5);
       pushStyle();
       colorMode(RGB,255);
       noStroke();
       fill(0,0,255);
       ellipse(p_1.x,p_1.y,2,2);
       popStyle();
    }   
  }
  
  void drawWeave(){
    pushStyle();
    float q = 0;float dist_color;float iter;
    if(iterate_harmonics){
      iter=phase_iteration;
    }
    else{
      iter=1;
    }
    for(float j = 0; j < TWO_PI; j+=TWO_PI/iter){
      
     for(float i = 0.01; i <= 1; i+=0.01){
       float v1 = map((sin(((6*q)/weave_freq-j))/weave_amp),-1,1,0,1);
       float v2 = map((sin(((6*q)/weave_freq)-j-(TWO_PI/256))/weave_amp),-1,1,0,1);;
       PVector p_2 = getVectorAtSurfaceUV(i,v1);
       PVector p_1 = getVectorAtSurfaceUV(i-0.01,v2);
       
       if(PVector.dist(p_1,p1) < PVector.dist(p_1,p2)){
         dist_color = PVector.dist(p_1,p1);
       }
       else{
         dist_color = PVector.dist(p_1,p2);
       }
       
      float m = PVector.dist(p1,p2);
      float sat_of_seg = map(dist_color,0,m/2,100,50);
      float hue_of_seg = map(dist_color,0,m/2,map(p_1.x,0,width,0,200),map(p_1.x,0,width,0,200)+50);
      float bright_of_seg = map(dist_color,0,m/2,250,80);
      float tran_of_seg = map(dist_color,0,m/2,250,80);
       
       
       colorMode(HSB,255);
       strokeWeight(map(j,0,TWO_PI,0.5,0.1));
       
       float hue = hue_of_seg;
       float sat = sat_of_seg;
       float bright = bright_of_seg;
       float transparency = map(magnitude,0,max_dist,tran_of_seg,60);
       
       if(color_weave){
         stroke(hue,sat,bright,transparency);
       }
       else{
         stroke(250,80);
         if(iterate_harmonics){
           strokeWeight(map(j,0,TWO_PI,0.5,0.1));
         }
         else{
           strokeWeight(1);
         }
       }
       
       line(p_1.x,p_1.y,p_2.x,p_2.y);
       q+=TWO_PI/256;
     }
   }
   popStyle();
  }
  
  PVector[] getLineSegForParameter(float t){
    PVector[] seg = new PVector[2];
    if(t < 0.5){
      PVector p_1 = PVector.lerp(p1,normal_line1,map(t,0,0.5,0,1));
      PVector p_2 = PVector.lerp(p1,normal_line2,map(t,0,0.5,0,1));
      seg[0] = p_1;
      seg[1] = p_2;
      return seg;
    }
    
    else if(t >= 0.5){
      PVector p_1 = PVector.lerp(normal_line1,p2,map(t,0.5,1,0,1));
      PVector p_2 = PVector.lerp(normal_line2,p2,map(t,0.5,1,0,1));
      seg[0] = p_1;
      seg[1] = p_2;     
      return seg;
    }
    
    return seg;
  }
    
}