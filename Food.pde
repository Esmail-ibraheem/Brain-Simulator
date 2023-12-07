class Food {
    PVector pos;
    
    public Food() {
      int x = 400 + SIZE + floor(random(38))*SIZE;
      int y = SIZE + floor(random(38))*SIZE;
      pos = new PVector(x,y);
    }
    
    public void show() {
       stroke(0);
       fill(255,0,0);
       ellipse(pos.x,pos.y,SIZE,SIZE);
    }
    
    public Food clone() {
       Food clone = new Food();
       clone.pos.x = pos.x;
       clone.pos.y = pos.y;
       
       return clone;
    }
}