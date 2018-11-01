class Food {
    PVector pos;
    
    Food() {
      int x = 400 + SIZE + floor(random(38))*SIZE;
      int y = SIZE + floor(random(38))*SIZE;
      pos = new PVector(x,y);
    }
    
    void show() {
       stroke(0);
       fill(255,0,0);
       rect(pos.x,pos.y,SIZE,SIZE);
    }
    
    Food clone() {
       Food clone = new Food();
       clone.pos.x = pos.x;
       clone.pos.y = pos.y;
       
       return clone;
    }
}
