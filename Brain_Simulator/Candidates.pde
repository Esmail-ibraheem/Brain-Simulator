class Candidates{
    Snake[] snakes;
    Snake bestSnake;
   
    int bestSnakeScore = 0;
    int generation = 0;
    int samebest = 0;
   
    float bestFitness = 0;
    float fitnessSum = 0;

    Candidates(int size){
        snakes = new Snake[size] ;
        for(int i=0; i<snakes.length; i++){
            snakes[i] = new Snake() ; 
        }
        bestSnake = snakes[0].clone();
        bestSnake.replay = true;
    }
    void visualizer() {  
      if(replayBest) {
        bestSnake.snake_Visualizer();
        bestSnake.brain.neuralNetwork_Visualizer(0,0,360,790,bestSnake.vision, bestSnake.decision);  
      } else {
         for(int i = 0; i < snakes.length; i++) {
            snakes[i].snake_Visualizer(); 
         }
      }
   }
    boolean check_dead(){
        for(int i=0; i<snakes.length; i++){
            if(!snakes[i].dead){
                return false;
            }
        }
        if(!bestSnake.dead){
            return false;
        }
        return true;
    }
    void update_snakes(){
        if(!bestSnake.dead){
            bestSnake.snake_vision() ;
            bestSnake.snake_decision() ;
            bestSnake.move() ; 
        }
        for(int i=0; i<snakes.length; i++){
            if(!snakes[i].dead){
                snakes[i].snake_vision() ;
                snakes[i].snake_decision() ;
                snakes[i].move() ; 
            }
        }
    }
    void set_Best_Snake(){
        float maximum = 0;
        int maximumIndex = 0;

        for(int i=0; i<snakes.length; i++){
            if(snakes[i].fitness>maximum){
                maximum = snakes[i].fitness ; 
                maximumIndex = i ; 
            }
        }
        if(maximum>bestFitness){
            bestFitness = maximum ;
            bestSnake = snakes[maximumIndex].clone_for_replay() ; 
            bestSnakeScore = snakes[maximumIndex].score ;  
        }else{
            bestSnake = bestSnake.clone_for_replay() ;
        }
    }
    Snake parent_Selection(){
        float rand = random(fitnessSum) ;
        float summation = 0;
        for(int i=0; i<snakes.length; i++){
            summation+=snakes[i].fitness ;

            if(summation>rand){
                return snakes[i] ; 
            } 
        }
        return snakes[0] ; 
    }
    void natural_Selection() {

        Snake[] newSnakes = new Snake[snakes.length];
      
        set_Best_Snake();
        calculate_Finess_summation();
      
        newSnakes[0] = bestSnake.clone();  
        for(int i = 1; i < snakes.length; i++) {
            Snake child = parent_Selection().corssOver_Operator(parent_Selection());
            child.mutate();
            newSnakes[i] = child;
        }
        snakes = newSnakes.clone();
        evolution.add(bestSnakeScore);
        generation+=1;
    }
    void mutate(){
        for(int i=0; i<snakes.length; i++){
            snakes[i].mutate() ; 
        }
    }
    void calculate_Fitness(){
        for(int i=0; i<snakes.length; i++){
            snakes[i].calculate_Fitness() ; 
        }
    }
    void calculate_Finess_summation(){
        fitnessSum = 0;
        for(int i=0; i<snakes.length; i++){
            fitnessSum = snakes[i].fitness ; 
        }
    }
}