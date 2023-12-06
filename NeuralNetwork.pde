class NeuralNetwork{
    int inputNodes, hiddenNodes, outputNodes, hiddenLayers ;
    Matrix[] weights;

    public NeuralNetwork(int inputNodes, int hiddenNodes, int outputNodes, int hiddenLayers){
        this.inputNodes = inputNodes;
        this.hiddenNodes = hiddenNodes;
        this.outputNodes = outputNodes;
        this.hiddenLayers = hiddenLayers;

        weights = new Matrix[hiddenLayers+1];
        weights[0] = new Matrix(hiddenNodes, inputNodes+1);
        for(int i=1; i<hiddenLayers; i++){
            weights[i] = new Matrix(hiddenNodes, hiddenNodes+1);
        }
        weights[weights.length-1] = new Matrix(outputNodes, hiddenNodes+1) ;

        for(Matrix weight:weights){
            weight.randomize() ;
        }
    }
    public void mutate(float mutationRate){
        for(Matrix weight:weights){
            weight.mutation(mutationRate) ;
        }
    }

    public float[] activation_Function_Output(float[] inputArray){
        Matrix inputLayer = weights[0].convert_Singl_Colunm_To_Array(inputArray) ;
        Matrix currentBias = inputLayer.add_Bias() ;

        for(int i=1; i<hiddenLayers; i++){
            Matrix hiddenLayerInput = weights[i].dot_Product(currentBias) ;
            Matrix hiddenLayerOutput = hiddenLayerInput.activation_Function() ;
            currentBias = hiddenLayerOutput.add_Bias() ;
        }

        Matrix outputLayerInput = weights[weights.length-1].dot_Product(currentBias);
        Matrix outputLayerOutput = outputLayerInput.activation_Function() ;

        return outputLayerOutput.convert_To_Array() ;
    }

    public NeuralNetwork crossOVer(NeuralNetwork partnerNeurlNet){
        NeuralNetwork childNeurlNet = new NeuralNetwork(inputNodes, hiddenNodes, outputNodes, hiddenLayers);

        for(int i=0; i<weights.length; i++){
            childNeurlNet.weights[i] = weights[i].crossOVer(partnerNeurlNet.weights[i]) ;
        }
        return childNeurlNet;
    }
    public NeuralNetwork clone(){
        NeuralNetwork cloneNeuralNet = new NeuralNetwork(inputNodes, hiddenNodes, outputNodes, hiddenLayers);

        for(int i=0; i<weights.length; i++){
            cloneNeuralNet.weights[i] = weights[i].clone() ;
        }
        return cloneNeuralNet ; 
    }

    public Matrix[] pull(){
        Matrix[] model = weights.clone();
        return model;
    }

    public void neuralNetwork_Visualizer(float xPosition, float yPosition, float width, float height, float[]vision, float[] decision){
        float space = 5;
        float neuronSize = (height - (space*(inputNodes-2))) / inputNodes;
        float neuronSpace = (width - (weights.length*neuronSize)) / weights.length;
        float hiddenBuffer = (height - (space*(hiddenNodes-1)) - (neuronSize*hiddenNodes))/2;
        float outputBuffer = (height - (space*(outputNodes-1)) - (neuronSize*outputNodes))/2;

        int maximumIndex = 0 ;

        for(int i=0; i<decision.length; i++){
            if(decision[i]>decision[maximumIndex]){
                maximumIndex = i ;
            }
        }

        int layerCount = 0;

        for(int i=0; i<inputNodes; i++){
            if(vision[i]!=0){
                fill(0,255,0) ;
            }else{
                noFill();
            }
            stroke(255);
            ellipseMode(CORNER);
            ellipse(xPosition,yPosition+(i*(neuronSize+space)),neuronSize,neuronSize);
            textSize(neuronSize/2);
            textAlign(CENTER,CENTER);
            fill(0);
            text(i,xPosition+(neuronSize/2),yPosition+(neuronSize/2)+(i*(neuronSize+space)));
        }
        layerCount++ ;

        for(int h=0; h<hiddenLayers; h++){
            for(int i=0; i<hiddenNodes; i++){
                if(vision[i]!=0){
                    fill(0,255,0) ;
                }else{
                    noFill();
                }
                ellipseMode(CORNER);
                ellipse(xPosition+(layerCount*neuronSize)+(layerCount*neuronSpace),yPosition+hiddenBuffer+(i*(neuronSize+space)),neuronSize,neuronSize);
            }
            layerCount++ ;
        }

        for(int i=0; i<outputNodes; i++){
            if(i==maximumIndex){
                fill(0,255,0) ;
            }else{
                noFill();
            }
            stroke(255);
            ellipseMode(CORNER);
            ellipse(xPosition+(layerCount*neuronSpace)+(layerCount*neuronSize),yPosition+outputBuffer+(i*(neuronSize+space)),neuronSize,neuronSize);
        }

        layerCount = 1;

        for(int i=0 ; i<weights[0].rows; i++){
            for(int j=0 ; j<weights[0].colunms-1; j++){
                if(weights[0].matrix[i][j]<0){
                    if(vision[j]!=0){
                        stroke(255,0,0) ;
                    }
                }else{
                    if(vision[j]!=0){
                        stroke(0,0,255) ;
                    }
                }
                line(xPosition+neuronSize,yPosition+(neuronSize/2)+(j*(space+neuronSize)),xPosition+neuronSize+neuronSpace,yPosition+hiddenBuffer+(neuronSize/2)+(i*(space+neuronSize)));
            }
        }

        layerCount++ ;

        for(int h=1; h<hiddenLayers; h++){
            for(int i=0; i<weights[h].rows; i++){
                for(int j=0; j<weights[h].colunms-1; j++){
                    if(weights[h].matrix[i][j]<0){
                        if(vision[j]!=0){
                            stroke(255,0,0) ;
                        }
                    }else{
                        if(vision[j]!=0){
                            stroke(0,0,255) ;
                        }
                    }
                    line(xPosition+(layerCount*neuronSize)+((layerCount-1)*neuronSpace),yPosition+hiddenBuffer+(neuronSize/2)+(j*(space+neuronSize)),xPosition+(layerCount*neuronSize)+(layerCount*neuronSpace),yPosition+hiddenBuffer+(neuronSize/2)+(i*(space+neuronSize)));

                }
            }
            layerCount++ ;
        }

        for(int i=0; i<weights[weights.length-1].rows; i++){
            for(int j=0; j<weights[weights.length-1].colunms-1; j++){
                if(weights[weights.length-1].matrix[i][j]<0){
                    if(vision[j]!=0){
                        stroke(255,0,0) ;
                    }
                }else{
                    if(vision[j]!=0){
                        stroke(0,0,255) ;
                    }
                }
                line(xPosition+(layerCount*neuronSize)+((layerCount-1)*neuronSpace),yPosition+hiddenBuffer+(neuronSize/2)+(j*(space+neuronSize)),xPosition+(layerCount*neuronSize)+(layerCount*neuronSpace),yPosition+outputBuffer+(neuronSize/2)+(i*(space+neuronSize)));

            }
        }

        fill(0);
        textSize(12);
        textAlign(CENTER,CENTER);
        text("Up",xPosition+(layerCount*neuronSize)+(layerCount*neuronSpace)+neuronSize/2,yPosition+outputBuffer+(neuronSize/2));
        text("Down",xPosition+(layerCount*neuronSize)+(layerCount*neuronSpace)+neuronSize/2,yPosition+outputBuffer+space+neuronSize+(neuronSize/2));
        text("Left",xPosition+(layerCount*neuronSize)+(layerCount*neuronSpace)+neuronSize/2,yPosition+outputBuffer+(2*space)+(2*neuronSize)+(neuronSize/2));
        text("Right",xPosition+(layerCount*neuronSize)+(layerCount*neuronSpace)+neuronSize/2,yPosition+outputBuffer+(3*space)+(3*neuronSize)+(neuronSize/2));
    }
}