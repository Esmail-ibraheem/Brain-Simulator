class Matrix{
    int rows, colunms ;
    float[][] matrix ;

    Matrix(int r, int c){
        rows = r ;
        colunms = c;
        matrix = new float[rows][colunms] ;
    }
    Matrix(float[][] m){
        matrix = m ;
        rows = matrix.length;
        colunms = matrix[0].length;
    }
    void matrix_Output(){
        for(int i=0; i<rows; i++){
            for(int j=0; j<colunms; j++){
                print(matrix[i][j] + " ") ; 
            }println() ;
        }println() ;
    }
    void weights_Randomize(){
        for(int i=0; i<rows; i++){
            for(int j=0; j<colunms; j++){
                matrix[i][j] = random(-1, 1);
            }
        }
    }
    void mutation(float mutationRate){
        for(int i=0; i<rows; i++){
            for(int j=0; j<colunms; j++){
                float rand = random(1) ; 
                if(rand<mutationRate){
                    matrix[i][j]+=randomGaussian()/5;

                    if(matrix[i][j]>1){
                        matrix[i][j]=1 ;
                    }
                    if(matrix[i][j]<-1){
                        matrix[i][j]=-1 ;
                    }
                }
            }
        }
    }
    float reLU_Function(float y){
        return max(0,y) ;
    }
    Matrix add_Bias(){
        Matrix biasMatrix = new Matrix(rows+1, 1) ; 
        for(int i=0; i<rows; i++){
            biasMatrix.matrix[i][0] = matrix[i][0] ; 
        }
        biasMatrix.matrix[rows][0] = 1;
        return biasMatrix ;
    }
    Matrix activation_Function(){
        Matrix activationMatrix = new Matrix(rows, colunms) ;
        for(int i=0; i<rows; i++){
            for(int j=0; j<colunms; j++){
                activationMatrix.matrix[i][j] = reLU_Function(matrix[i][j]) ; 
            }
        }
        return activationMatrix ;
    }
    Matrix corssOver_Operator(Matrix partnerMatrix){
        Matrix childMatrix = new Matrix(rows, colunms) ;

        int randomRows = floor(random(rows)) ;
        int randomColunms = floor(random(colunms)) ;

        for(int i=0; i<rows; i++){
            for(int j=0; j<colunms; j++){
                if((i<randomRows) || (i==randomRows && j<=randomColunms)){
                    childMatrix.matrix[i][j] = matrix[i][j] ;
                }else{
                    childMatrix.matrix[i][j] = partnerMatrix.matrix[i][j] ; 
                }
            }
        }
        return childMatrix ; 
    }
    Matrix dot_Product(Matrix secondMatrix){
        Matrix resaultMatrix = new Matrix(rows, secondMatrix.colunms);

        if(colunms==secondMatrix.rows){
            for(int i=0; i<rows; i++){
                for(int j=0; j<secondMatrix.colunms; j++){
                    float summation = 0;
                    for(int k=0; k<colunms; k++){
                        summation+= matrix[i][k] * secondMatrix.matrix[k][j] ; 
                    }
                    resaultMatrix.matrix[i][j] = summation ; 
                }
            }
        }
        return resaultMatrix;
    }
    Matrix clone(){
        Matrix cloneMatrix = new Matrix(rows, colunms) ;
        for(int i=0; i<rows; i++){
            for(int j=0; j<colunms; j++){
                cloneMatrix.matrix[i][j] = matrix[i][j] ; 
            }
        }
        return cloneMatrix ; 
    }
    Matrix convert_singl_colunm_to_Array(float[] arr){
        Matrix colunmMatrix = new Matrix(arr.length, 1);
        for(int i=0; i<arr.length; i++){
            colunmMatrix.matrix[i][0] = arr[i] ; 
        }
        return colunmMatrix ; 
    }
    float[] convert_to_Array(){
        float[] arr = new float[rows * colunms] ;
        for(int i=0; i<rows; i++){
            for(int j=0; j<colunms; j++){
                arr[i+j * colunms] = matrix[i][j] ; 
            }
        }
        return arr ; 
    }
}