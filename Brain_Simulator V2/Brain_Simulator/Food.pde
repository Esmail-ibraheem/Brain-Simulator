class Food {
    PVector pos;
    
    Food() {
      int x = 400 + SIZE + floor(random(38))*SIZE;
      int y = SIZE + floor(random(38))*SIZE;
      pos = new PVector(x,y);
    }
    
    void food_Visualizer() {
       stroke(0);
       fill(0,255,0);
       ellipse(pos.x,pos.y,SIZE,SIZE);
    }
    
    Food clone() {
       Food clone = new Food();
       clone.pos.x = pos.x;
       clone.pos.y = pos.y;
       
       return clone;
    }
}