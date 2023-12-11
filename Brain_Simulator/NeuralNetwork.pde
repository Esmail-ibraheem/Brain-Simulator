class NeuralNetwork{
    int inputNodes, hiddenNodes, outputNodes, hiddenLayers ;
    Matrix[] weights ;

    NeuralNetwork(int iNodes, int hNodes, int oNodes, int hLayers){
        inputNodes = iNodes ;
        hiddenNodes = hNodes;
        outputNodes = oNodes;
        hiddenLayers = hLayers ;

        weights = new Matrix[hiddenLayers+1] ;
        weights[0] = new Matrix(hiddenNodes, inputNodes+1) ;
        for(int i=1; i<hiddenLayers; i++){
            weights[i] = new Matrix(hiddenNodes, hiddenNodes+1) ; 
        }
        weights[weights.length-1] = new Matrix(outputNodes, hiddenNodes+1) ;

        for(Matrix weight:weights){
            weight.weights_Randomize() ; 
        }
    }
    void mutate(float mutationRate){
        for(Matrix weight:weights){
            weight.mutation(mutationRate) ; 
        }
    }
    float[] activation_Function_Output(float[] inputArray){
        Matrix input = weights[0].convert_singl_colunm_to_Array(inputArray) ;
        Matrix currentBias = input.add_Bias() ;

        for(int i=0; i<hiddenLayers; i++){
            Matrix hiddenLayerInput = weights[i].dot_Product(currentBias) ; 
            Matrix hiddenLayerOutput = hiddenLayerInput.activation_Function() ; 
            currentBias = hiddenLayerOutput.add_Bias() ; 
        }

        Matrix outputLayerInput = weights[weights.length-1].dot_Product(currentBias) ;
        Matrix output = outputLayerInput.activation_Function() ; 

        return output.convert_to_Array() ;  
    }
    NeuralNetwork corssOver_Operator(NeuralNetwork partnerNeuralNetwork){
        NeuralNetwork childNeuralNetwork = new NeuralNetwork(inputNodes, hiddenNodes, outputNodes, hiddenLayers) ;
        for(int i=0; i<weights.length; i++){
            childNeuralNetwork.weights[i] = weights[i].corssOver_Operator(partnerNeuralNetwork.weights[i]) ; 
        }
        return childNeuralNetwork;
    }
    NeuralNetwork clone(){
        NeuralNetwork cloneNeuralNetwork = new NeuralNetwork(inputNodes, hiddenNodes, outputNodes, hiddenLayers) ;
        for(int i=0; i<weights.length; i++){
            cloneNeuralNetwork.weights[i] = weights[i].clone() ; 
        }
        return cloneNeuralNetwork;
    }
    Matrix[] pull(){
        Matrix[] model = weights.clone(); 
        return model ; 
    }

    void neuralNetwork_Visualizer(float xPosition, float yPosition, float w, float h, float[]vision, float[]decision){
        float space = 5;
        float neuronSize = (h - (space*(inputNodes-2))) / inputNodes;
        float neuronSpace = (w - (weights.length*neuronSize)) / weights.length;
        float hiddenBuffer = (h - (space*(hiddenNodes-1)) - (neuronSize*hiddenNodes))/2;
        float outputBuffer = (h - (space*(outputNodes-1)) - (neuronSize*outputNodes))/2;

        int maximumIndex = 0;
        for(int i=0; i<decision.length; i++){
            if(decision[i]>decision[maximumIndex]){
                maximumIndex = i ;
            }
        }

        int layer_Count = 0;

        for(int i=0; i<inputNodes; i++){
            if(vision[i]!=0){
                fill(0,255,0) ; 
            }else{
                fill(255);
            }
            stroke(255);
            ellipseMode(CORNER);
            ellipse(xPosition,yPosition+(i*(neuronSize+space)),neuronSize,neuronSize);
            textSize(neuronSize/2);
            textAlign(CENTER,CENTER);
            fill(0);
            text(i,xPosition+(neuronSize/2),yPosition+(neuronSize/2)+(i*(neuronSize+space)));
        }
        layer_Count++ ; 

        for(int l=0; l<hiddenLayers; l++){
            for(int i=0; i<hiddenNodes; i++){
                if(vision[i]!=0){
                    fill(0,255,0) ; 
                }else{
                    fill(255);
                }
                ellipseMode(CORNER);
                ellipse(xPosition+(layer_Count*neuronSize)+(layer_Count*neuronSpace),yPosition+hiddenBuffer+(i*(neuronSize+space)),neuronSize,neuronSize);
            }
            layer_Count++ ; 
        }

        for(int i=0; i<outputNodes; i++){
            if(i==maximumIndex){
                fill(0,255,0) ; 
            }else{
                fill(255);
            }
            stroke(255);
            ellipseMode(CORNER);
            ellipse(xPosition+(layer_Count*neuronSpace)+(layer_Count*neuronSize),yPosition+outputBuffer+(i*(neuronSize+space)),neuronSize,neuronSize);
        }

        layer_Count = 1;

        for(int i=0; i<weights[0].rows; i++){
            for(int j=0; j<weights[0].colunms-1; j++){
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

        layer_Count++ ;

        for(int l=1; l<hiddenLayers; l++){
            for(int i=0; i<weights[l].rows; i++){
                for(int j=0; j<weights[l].colunms-1; j++){
                    if(weights[l].matrix[i][j]<0){
                        if(vision[j]!=0){
                            stroke(255,0,0) ;
                        }
                    }else{
                        if(vision[j]!=0){
                            stroke(0,0,255) ; 
                        }
                    }
                    line(xPosition+(layer_Count*neuronSize)+((layer_Count-1)*neuronSpace),yPosition+hiddenBuffer+(neuronSize/2)+(j*(space+neuronSize)),xPosition+(layer_Count*neuronSize)+(layer_Count*neuronSpace),yPosition+hiddenBuffer+(neuronSize/2)+(i*(space+neuronSize)));
                }
            }
            layer_Count++ ; 
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
                line(xPosition+(layer_Count*neuronSize)+((layer_Count-1)*neuronSpace),yPosition+hiddenBuffer+(neuronSize/2)+(j*(space+neuronSize)),xPosition+(layer_Count*neuronSize)+(layer_Count*neuronSpace),yPosition+outputBuffer+(neuronSize/2)+(i*(space+neuronSize)));
            }
        }

        fill(0);
        textSize(12);
        textAlign(CENTER,CENTER);
        text("Up",xPosition+(layer_Count*neuronSize)+(layer_Count*neuronSpace)+neuronSize/2,yPosition+outputBuffer+(neuronSize/2));
        text("Down",xPosition+(layer_Count*neuronSize)+(layer_Count*neuronSpace)+neuronSize/2,yPosition+outputBuffer+space+neuronSize+(neuronSize/2));
        text("Left",xPosition+(layer_Count*neuronSize)+(layer_Count*neuronSpace)+neuronSize/2,yPosition+outputBuffer+(2*space)+(2*neuronSize)+(neuronSize/2));
        text("Right",xPosition+(layer_Count*neuronSize)+(layer_Count*neuronSpace)+neuronSize/2,yPosition+outputBuffer+(3*space)+(3*neuronSize)+(neuronSize/2));
    }
}
