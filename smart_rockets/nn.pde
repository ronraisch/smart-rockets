//should be more generalized for all sizes nn
class NeuralNet {

  int[] sizes;//No. of hidden nodes 

  Matrix[] matrices;//matrix containing weights between the input nodes and the hidden nodes
//---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //constructor
  NeuralNet(int[] sizes) {

    //set dimensions from parameters
    this.sizes=sizes.clone();
    matrices=new Matrix[sizes.length-1];
    //create layers 
    //included bias weight
    for (int i=0;i<matrices.length;i++){
      matrices[i]=new Matrix(sizes[i+1],sizes[i]+1);
      matrices[i].randomize(minValue,maxValue);
    }
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //mutation function for genetic algorithm
  void mutate(float mr) {
    //mutates each weight matrix
    for (Matrix m:matrices){
      m.mutate(mr);
    }
  }

//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //calculate the output values by feeding forward through the neural network
  float[] output(float[] inputsArr) {
    Matrix input = matrices[0].singleColumnMatrixFromArray(inputsArr);
    for (int i=0;i<matrices.length;i++){
       input=input.addBias();
       input=matrices[i].dot(input);
       input=input.activate();
    }
    
    return input.toArray();
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //crossover function for genetic algorithm
  NeuralNet crossOver(NeuralNet partner,float chance) {

    //creates a new child with layer matrices from both parents
    NeuralNet child = new NeuralNet(sizes);
    for (int i=0;i<matrices.length;i++){
      child.matrices[i]=matrices[i].crossOver(partner.matrices[i],chance);
    }
    return child;
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //return a neural net which is a clone of this Neural net
  NeuralNet clone() {
    NeuralNet clone  = new NeuralNet(sizes); 
    for (int i=0;i<matrices.length;i++){
      clone.matrices[i]=matrices[i].clone();
    }
    return clone;
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //converts the weights matrices to a single table 
  //used for storing the snakes brain in a file
  int biggestMatrix(){
    int biggest=0;
    for (Matrix m:matrices){
      int size=m.rows*m.cols;
      biggest=max(biggest,size);
    }
    return biggest;
  }
  Table NetToTable() {
    //create table
    Table t = new Table();
    int biggestSize=biggestMatrix();
    float[][] Arrays=new float[matrices.length][biggestSize];
    //convert the matricies to an array 
    for (int i=0;i<matrices.length;i++){
      Arrays[i]=matrices[i].toArray();
    }
    //set the amount of columns in the table
    for (int i = 0; i< biggestSize; i++) {
      t.addColumn();
    }
    for (int i=0;i<matrices.length;i++){
      TableRow tr=t.addRow();
      for (int j=0;j<Arrays[i].length;j++){
        tr.setFloat(j,Arrays[i][j]);
      }
    }
    //return table
    return t;
  }

//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //takes in table as parameter and overwrites the matrices data for this neural network
  //used to load snakes from file
  void TableToNet(Table t) {
    ArrayList<ArrayList<Float>> Arrays=new ArrayList<ArrayList<Float>>();
    //create arrays to tempurarily store the data for each matrix
    for (int i=0;i<matrices.length;i++){
      TableRow tr=t.getRow(i);
      ArrayList<Float> tmp=new ArrayList<Float>();
      for (int j=0;j<matrices[i].rows*matrices[i].cols;j++){
        tmp.set(j,tr.getFloat(j));
      }
      Arrays.set(i,tmp);
    }
    //convert the arrays to matrices and set them as the layer matrices 
    for (int i=0;i<matrices.length;i++){
      float[] array=new float[Arrays.get(i).size()];
      for (int j=0;j<array.length;j++){
        array[j]=Arrays.get(i).get(j);
      }
      matrices[i].fromArray(array);
    }
  }
}
