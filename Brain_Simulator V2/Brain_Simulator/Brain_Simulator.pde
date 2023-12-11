private static final int SIZE = 20;
private static final int hiddenNodes = 18; 
private static final int hiddenLayers = 2; 
private static final int fps = 100;

int highscore = 0;

float mutationRate = 0.05;
float defaultmutation = mutationRate;

boolean humanPlaying = false; 
boolean replayBest = true;  
boolean seeVision = false;  
boolean modelLoaded = false;

PFont font;

ArrayList<Integer> evolution;

Snake snake;
Snake model;

Candidates candidate ; 

void settings() {
    size(1200,800);
}

void setup() {
    font = createFont("IBMPlexSans-BoldItalic.ttf",32);
    evolution = new ArrayList<Integer>();
    frameRate(fps);
    if(humanPlaying) {
        snake = new Snake();
    } else {
        candidate = new Candidates(2000); 
    }
}

void draw() {
    background(255);
    noFill();
    stroke(0);
    line(400,0,400,height);
    rectMode(CORNER);
    rect(400 + SIZE,SIZE,width-400-40,height-40);
    textFont(font);

    if(humanPlaying) {
        snake.move();
        snake.snake_Visualizer();
        fill(150);
        textSize(20);
        text("SCORE : "+snake.score,500,50);
        if(snake.dead) {
            snake = new Snake(); 
        }
    } else {
        if(!modelLoaded) {
            if(candidate.check_dead()) {
                highscore = candidate.bestSnake.score;
                candidate.calculate_Fitness();
                candidate.natural_Selection();
            } else {
                candidate.update_snakes();
                candidate.visualizer(); 
            }
            fill(0);
            textSize(20);
            textAlign(LEFT);
            text("NN Architecture Type: FeedForword",50,30);
            text("GEN ALGORITHM: "+candidate.generation,125,60);
            text("BEST FITNESS : "+candidate.bestFitness,125,90);
            text("MOVES LEFT : "+candidate.bestSnake.movesLeft,450,60);
            text("SCORE : "+candidate.bestSnake.score,450,80);
            text("HIGHSCORE : "+highscore,450,100);
      
            text("Activation Function: ReLU",450,height-90);
            text("NN Architecture: [24, 18, 18, 4]",450,height-60);
            text("Snake Vision: 8 directions",450,height-30);

            text("INPUT LAYER: 24 Nodes",90,height-70);
            text("HIDDEN LAYER: 2/18 Nodes",90,height-40);
            text("OUTPUT LAYER: 4 Nodes",90,height-10);
        } else {
            model.snake_vision();
            model.snake_decision();
            model.move();
            model.snake_Visualizer();
            model.brain.neuralNetwork_Visualizer(0,0,360,790,model.vision, model.decision);
            if(model.dead) {
                Snake newmodel = new Snake();
                newmodel.brain = model.brain.clone();
                model = newmodel;
        
            }
            textSize(25);
            fill(150);
            textAlign(LEFT);
            text("SCORE : "+model.score,120,height-45);
        }
        textAlign(LEFT);
        textSize(18);
        fill(255,0,0);
        text("RED < 0",110,height-90);
        fill(0,0,255);
        text("BLUE > 0",220,height-90);
    }
}
