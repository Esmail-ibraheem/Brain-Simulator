class Snake{
    int score = 1;
    int movesLeft = 200;
    int survivleTime = 0;
    int foodIteration = 0;
    float fitness = 0;
    float xVelocity, yVelocity ;
    boolean dead = false;
    boolean replay = false ;
    float[] vision ;
    float[] decision ;

    PVector head;

    ArrayList<PVector>body ;
    ArrayList<Food> foodList ;

    NeuralNetwork brain;
    Food food ;

    Snake(){
        this(hiddenLayers) ;
    }
    Snake(int layers){
        head = new PVector(800,height/2);
        body = new ArrayList<PVector>() ;
        food = new Food() ;
        if(!humanPlaying){
            vision = new float[24] ;
            decision = new float[4] ; 
            foodList = new ArrayList<Food>() ; 
            foodList.add(food.clone()) ;
            brain = new NeuralNetwork(24, hiddenNodes, 4, layers) ; 
            body.add(new PVector(800,(height/2)+SIZE));  
            body.add(new PVector(800,(height/2)+(2*SIZE)));
            score+=2;
        }
    }
    Snake(ArrayList<Food> foods){
        replay = true ;
        body = new ArrayList<PVector>() ;
        vision = new float[24] ;
        decision = new float[4] ; 
        foodList = new ArrayList<Food>(foods.size()) ;
        for(Food f:foods){
            foodList.add(f.clone()) ; 
        } 
        food = foodList.get(foodIteration) ;
        foodIteration++ ;
        head = new PVector(800,height/2);
        body.add(new PVector(800,(height/2)+SIZE));
        body.add(new PVector(800,(height/2)+(2*SIZE)));
        score+=2;
    }
    boolean check_body_collide(float x, float y){
        for(int i=0; i<body.size(); i++){
            if(x==body.get(i).x && y==body.get(i).y){
                return true ;
            }
        }
        return false;
    }
    boolean check_food_collide(float x, float y){
        if(x==food.pos.x && y== food.pos.y){
            return true ;
        }
        return false; 
    }
    boolean check_wall_collide(float x, float y){
        if(x >= width-(SIZE) || x < 400 + SIZE || y >= height-(SIZE) || y < SIZE){
            return true;
        }
        return false; 
    }
    Snake corssOver_Operator(Snake partnerSnake){
        Snake childSnake = new Snake(hiddenLayers);
        childSnake.brain = brain.corssOver_Operator(partnerSnake.brain) ; 
        return childSnake ;
    }
    Snake clone_for_replay(){
        Snake clone = new Snake(foodList) ;
        clone.brain = brain.clone() ; 
        return clone;
    }
    Snake clone(){
        Snake clone = new Snake() ;
        clone.brain = brain.clone() ; 
        return clone; 
    }
    void mutate(){
        brain.mutate(mutationRate) ; 
    }
    void calculate_Fitness(){
        if(score<10){
            fitness = (survivleTime*survivleTime) * pow(2,score) ;
        }else{
            fitness = (survivleTime*survivleTime) ; 
            fitness *= pow(2,10) ;
            fitness *= (score-9) ; 
        }
    }
    void snake_Visualizer() {  
        food.food_Visualizer() ;
        fill(0,255,0);
        stroke(0);
     
        for(int i = 0; i < body.size(); i++) {
            rect(body.get(i).x,body.get(i).y,SIZE,SIZE); 
        }
        if(dead) {
            fill(255);
        } else {
            fill(0,255,0);
        }
        rect(head.x,head.y,SIZE,SIZE);
    }
    void move() {  
        if(!dead){
            if(!humanPlaying && !modelLoaded) {
                survivleTime++;
                movesLeft--;
            }
            if(check_food_collide(head.x,head.y)) {
                eat();
            }
            shiftBody();
            if(check_wall_collide(head.x,head.y)) {
                dead = true;
            } else if(check_body_collide(head.x,head.y)) {
                dead = true;
            } else if(movesLeft <= 0 && !humanPlaying) {
                dead = true;
            }
        }
    }
    void eat() {  
        int len = body.size()-1;
        score++;
        if(!humanPlaying && !modelLoaded) {
            if(movesLeft < 500) {
                if(movesLeft > 400) {
                    movesLeft = 500; 
                } else {
                    movesLeft+=100;
                }
            }
        }
        if(len >= 0) {
            body.add(new PVector(body.get(len).x,body.get(len).y));
        } else {
            body.add(new PVector(head.x,head.y)); 
        }
        if(!replay) {
            food = new Food();
            while(check_body_collide(food.pos.x,food.pos.y)) {
                food = new Food();
            }
            if(!humanPlaying) {
                foodList.add(food);
            }
        } else {  
            food = foodList.get(foodIteration);
            foodIteration++;
        }
    }
    void shiftBody() {  
        float tempx = head.x;
        float tempy = head.y;
        head.x += xVelocity;
        head.y += yVelocity;
        float temp2x;
        float temp2y;
        for(int i = 0; i < body.size(); i++) {
            temp2x = body.get(i).x;
            temp2y = body.get(i).y;
            body.get(i).x = tempx;
            body.get(i).y = tempy;
            tempx = temp2x;
            tempy = temp2y;
        } 
    }

    float[] look_In_Directions(PVector direction){
        float[] look = new float[3] ;
        boolean foodFound = false;
        boolean bodyFound = false;
        float distance = 0;
        PVector pos = new PVector(head.x, head.y) ;
        pos.add(direction) ;
        distance++ ; 
        while(!check_wall_collide(pos.x, pos.y)){
            if(!foodFound && check_food_collide(pos.x, pos.y)){
                foodFound = true;
                look[0] = 1;
            }
            if(!bodyFound && check_body_collide(pos.x, pos.y)){
                bodyFound = true;
                look[1] = 1 ;
            }
            if(replay && seeVision) {
                stroke(0,255,0);
                point(pos.x,pos.y);
                if(foodFound) {
                    noStroke();
                    fill(255,255,51);
                    ellipseMode(CENTER);
                    ellipse(pos.x,pos.y,5,5); 
                }
                if(bodyFound) {
                    noStroke();
                    fill(102,0,102);
                    ellipseMode(CENTER);
                    ellipse(pos.x,pos.y,5,5); 
                }
            }
            pos.add(direction);
            distance +=1;
        }
        if(replay && seeVision) {
            noStroke();
            fill(0,255,0);
            ellipseMode(CENTER);
            ellipse(pos.x,pos.y,5,5); 
        }
        look[2] = 1/distance;
        return look;
    }

    void snake_vision(){
        vision = new float[24] ; 
        float[] temp = look_In_Directions(new PVector(-SIZE,0));
        vision[0] = temp[0];
        vision[1] = temp[1];
        vision[2] = temp[2];
        temp = look_In_Directions(new PVector(-SIZE,-SIZE));
        vision[3] = temp[0];
        vision[4] = temp[1];
        vision[5] = temp[2];
        temp = look_In_Directions(new PVector(0,-SIZE));
        vision[6] = temp[0];
        vision[7] = temp[1];
        vision[8] = temp[2];
        temp = look_In_Directions(new PVector(SIZE,-SIZE));
        vision[9] = temp[0];
        vision[10] = temp[1];
        vision[11] = temp[2];
        temp = look_In_Directions(new PVector(SIZE,0));
        vision[12] = temp[0];
        vision[13] = temp[1];
        vision[14] = temp[2];
        temp = look_In_Directions(new PVector(SIZE,SIZE));
        vision[15] = temp[0];
        vision[16] = temp[1];
        vision[17] = temp[2];
        temp = look_In_Directions(new PVector(0,SIZE));
        vision[18] = temp[0];
        vision[19] = temp[1];
        vision[20] = temp[2];
        temp = look_In_Directions(new PVector(-SIZE,SIZE));
        vision[21] = temp[0];
        vision[22] = temp[1];
        vision[23] = temp[2];
    }
    void snake_decision(){
        decision = brain.activation_Function_Output(vision) ; 
        float maximum = 0;
        int maximumIndex = 0;
        for(int i=0; i<decision.length; i++){
            if(decision[i]>maximum){
                maximum = decision[i];
                maximumIndex = i ; 
            }
        }
        switch(maximumIndex){
            case 0:
                moveUp() ;
                break ;
            case 1:
                moveDown() ;
                break; 
            case 2:
                moveLeft() ;
                break; 
            case 3:
                moveRight() ; 

        }
    }
    void moveUp() { 
        if(yVelocity!=SIZE) {
            xVelocity = 0; yVelocity = -SIZE;
        }
    }
    void moveDown() { 
        if(yVelocity!=-SIZE) {
            xVelocity = 0; yVelocity = SIZE; 
        }
    }
    void moveLeft() { 
        if(xVelocity!=SIZE) {
            xVelocity = -SIZE; yVelocity = 0; 
        }
    }
    void moveRight() { 
        if(xVelocity!=-SIZE) {
            xVelocity = SIZE; yVelocity = 0;
        }
    }
}