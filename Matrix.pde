class Matrix{
    int rows, colunms;
    float[][] matrix;

    public Matrix(int rows, int colunms){
        this.rows = rows;
        this.colunms = colunms;
        matrix = new float[rows][colunms];
    }
    public Matrix(float[][]matrix){
        this.matrix = matrix;
        rows = matrix.length;
        colunms = matrix[0].length;
    }
    public void matrix_Output(){
        for(int i=0; i<rows; i++){
            for(int j=0; j<colunms; j++){
                println(matrix[i][j] + " ") ;
            }
            println() ;
        }
        println() ;
    }
    public void randomize(){
        for(int i=0; i<rows; i++){
            for(int j=0; j<colunms; j++){
                matrix[i][j] = random(-1, 1);
            }
        }
    }
    public void mutation(float mutationRate){
        for(int i=0; i<rows; i++){
            for(int j=0; j<colunms; j++){
                float rand = random(1);
                if(rand<mutationRate){
                    matrix[i][j] += randomGaussian()/5;

                    if(matrix[i][j]>1){
                        matrix[i][j] = 1;
                    }
                    if(matrix[i][j]<-1){
                        matrix[i][j] = -1 ;
                    }
                }
            }
        }
    }
    public float ReLU_Activation_Function(float y){
        return max(0,y) ;
    }
    public Matrix add_Bias(){
        Matrix biasMatrix = new Matrix(rows+1, 1);
        for(int i=0; i<rows; i++){
            biasMatrix.matrix[i][0] = matrix[i][0] ;
        }
        biasMatrix.matrix[rows][0] = 1;
        return biasMatrix;
    }
    public Matrix activation_Function(){
        Matrix activationMatrix = new Matrix(rows, colunms);
        for(int i=0; i<rows; i++){
            for(int j=0; j<colunms; j++){
                activationMatrix.matrix[i][j] = ReLU_Activation_Function(matrix[i][j]) ;
            }
        }
        return activationMatrix;
    }
    public Matrix crossOVer(Matrix partnerMatrix){
        Matrix childMatrix = new Matrix(rows, colunms);

        int randomRow = floor(random(rows));
        int randomColunm = floor(random(colunms));

        for(int i=0; i<rows; i++){
            for(int j=0; j<colunms; j++){
                if((i<randomRow) || (i==randomRow && j<=randomColunm)){
                    childMatrix.matrix[i][j] = matrix[i][j] ;
                }else{
                    childMatrix.matrix[i][j] = partnerMatrix.matrix[i][j] ; 
                }
            }
        }
        return childMatrix ;
    }
    public Matrix dot_Product(Matrix secondMatrix){
        Matrix resaultMatrix = new Matrix(rows, secondMatrix.colunms);

        if(rows==secondMatrix.colunms){
            for(int i=0; i<rows; i++){
                for(int j=0; j<colunms; j++){
                    float sumation = 0;
                    for(int k=0; k<colunms; k++){
                        sumation+= matrix[i][k] * secondMatrix.matrix[k][j] ; 
                    }
                    resaultMatrix.matrix[i][j] = sumation;
                }
            }
        }
        return resaultMatrix ;
    }
    public Matrix clone(){
        Matrix cloneMatrix = new Matrix(rows, colunms);

        for(int i=0; i<rows; i++){
            for(int j=0; j<colunms; j++){
                cloneMatrix.matrix[i][j] = matrix[i][j] ;
            }
        }
        return cloneMatrix;
    }

    public Matrix convert_Singl_Colunm_To_Array(float[] arr){
        Matrix colunmMatrix = new Matrix(arr.length, 1);

        for(int i=0; i<arr.length; i++){
            colunmMatrix.matrix[i][0] = arr[i] ; 
        }
        return colunmMatrix;
    }
    public float[] convert_To_Array(){
        float[] arr = new float[rows*colunms];

        for(int i=0; i<rows; i++){
            for(int j=0; j<colunms; j++){
                arr[i+j * colunms] = matrix[i][j] ; 
            }
        }
        return arr ; 
    }
}