class EvolutionGraph extends PApplet {
  
   EvolutionGraph() {
       super();
       PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
   }
   
   void settings() {
      size(900,600); 
   }
   
   void setup() {
       background(150);
       frameRate(30);
   }
   
   void draw() {
      background(150);
      fill(0);
      strokeWeight(1);
      textSize(15);
      textAlign(CENTER,CENTER);
      text("Generation", width/2,height-10);
      translate(10,height/2);
      rotate(PI/2);
      text("Score", 0,0);
      rotate(-PI/2);
      translate(-10,-height/2);
      textSize(10);
      float x = 50;
      float y = height-35;
      float xbuff = (width-50) / 51.0;
      float ybuff = (height-50) / 200.0;
      for(int i=0; i<=50; i++) {
         text(i,x,y); 
         x+=xbuff;
      }
      x = 35;
      y = height-50;
      float ydif = ybuff * 10.0;
      for(int i=0; i<200; i+=10) {
         text(i,x,y); 
         line(50,y,width,y);
         y-=ydif;
      }
      strokeWeight(2);
      stroke(255,0,0);
      int score = 0;
      for(int i=0; i<evolution.size(); i++) {
         int newscore = evolution.get(i);
         line(50+(i*xbuff),height-50-(score*ybuff),50+((i+1)*xbuff),height-50-(newscore*ybuff));
         score = newscore;
      }
      stroke(0);
      strokeWeight(5);
      line(50,0,50,height-50);
      line(50,height-50,width,height-50);
   }
   
   void exit() {
      dispose();
      graph = null;
   }
}
