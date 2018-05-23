class NNPopulation {
  NNRocket[] rockets;
  boolean death=false;
  NNPopulation() {
    //initializing rockets
    rockets=new NNRocket[nnRockets];
    for (int i=0; i<nnRockets; i++) {
      rockets[i]=new NNRocket();
    }
  }
  NNRocket[] findTopRockets(){
    for (int i=0;i<nnRockets;i++){
      for(int j=i+1;j<nnRockets;j++){
        if (rockets[i].fitness>rockets[j].fitness){
          rockets[i].rank--;
        }
        else{
          rockets[j].rank--;
        }
      }
    }
    NNRocket[] TopRockets=new NNRocket[nnRockets/4];
    for (int i=0;i<nnRockets/4;i++){
      for (NNRocket r:rockets){
        if (r.rank==i+1){
          NNRocket rocket=new NNRocket(r.dna);
          TopRockets[i]=rocket;
        }
      }
    }
    return TopRockets;
  }
  //drawing and calculating a frame
  void calcFrame() {
    fill(240, 100);
    for (NNRocket r : rockets) {
      r.update();
      r.show();
    }
    count++;
    newGen();
  }
  //reseting movement of currnt generation for retesting them
  void resetGen(){
    for (int i=0;i<nnRockets;i++){
      rockets[i].pos.x=width/2;
      rockets[i].pos.y=height-2;
      rockets[i].vel.x=0;
      rockets[i].vel.y=-0.01;
      rockets[i].acc.mult(0);
      rockets[i].hit=false;
      rockets[i].crashed=false;
      rockets[i].distance=maxDist;
      rockets[i].Xdist=width;
      rockets[i].Ydist=height;
      rockets[i].bestRocket=false;
    }
    count=0;
  }
  void calcFrameBest() {
    for (int i=0; i<nnRockets; i++) {
      rockets[i].update();
      if (rockets[i].bestRocket) {
        fill(240, 100);
        rockets[i].show();
      }
    }
    count++;
    newGen();
  }
  //saving population
  void savePop(){
    for (int i=0;i<nnRockets;i++){
      saveTable(rockets[i].dna.genes.NetToTable(),"good_rockets/rocket_"+i,"html");
      println("rocket "+i+" saved");
    }
  }
  void loadPop(){
    for (int i=0;i<nnRockets;i++){
      NeuralNet tmp=new NeuralNet(inputN,hidden1N,hidden2N,outputN);
      tmp.TableToNet(loadTable("good_rockets/rocket_"+i,"html"));
      println("rocket_"+i+" loaded");
      rockets[i].dna.genes=tmp.clone();
    }
  }
  //finding best rocket
  NNdna bestRocket() {
    float best=0;
    NNRocket bestR=new NNRocket();
    for (int i=0; i<nnRockets; i++) {
      if (rockets[i].fitness>best) {
        best=rockets[i].fitness;
        bestR=rockets[i];
      }
      bestDist=min(bestDist, rockets[i].distance);
    }
    //bestR.dna.genes.NetToTable().print();
    return bestR.dna;
  }
  //managing the whole repopulation stuff
  void newGen() {
    //checks if population is dead
    checkPop();
    if (death) {
      //updating FPR and count
      framesPerRun=bestTime+60;
      count=0;
      //updating generation
      generation++;
      //assigns probablity to each rocket
      makeProbs();
      //array for the new population
      NNRocket[] newRockets=new NNRocket[nnRockets];
      //kepping best rocket
      NNRocket best=new NNRocket(bestRocket());
      best.bestRocket=true;
      newRockets[0]=best;
      //find top rockets
      NNRocket[] topRockets=findTopRockets();
      //only mutate top rockets
      for (int i=1;i<nnRockets/4+1;i++){
        NNRocket parent=topRockets[i-1];
        NNdna childna=parent.dna.clone();
        childna.mutate(mutationRate);
        newRockets[i]=new NNRocket(childna);
      }
      //crossover and mutation for the rest
      for (int i=nnRockets/4+1; i<nnRockets; i++) {
        //picking 2 parents
        NNRocket parentA=pickOne();
        NNRocket parentB=pickOne();
        //breed them: crossover and mutation
        NNRocket child=new NNRocket();
        NNdna childna=parentA.dna.crossOver(parentB.dna,parentA.fitness/(parentA.fitness+parentB.fitness));
        //NNdna childna=parentA.dna.clone();
        childna.mutate(mutationRate);
        child.dna=childna.clone();
        //adding the child to the new rockets array
        newRockets[i]=child;
      }
      rockets=newRockets;
    }
  }
  //assigning values to each rocket
  void makeProbs() {
    float sum=0;
    //summing the fitness values
    for (NNRocket r : rockets) {
      r.calcFitness();
      sum+=r.fitness;
    }
    //assigning the probability for each rocket
    for (NNRocket r : rockets) {
      r.prob=r.fitness/sum;
    }
  }
  //returns a random rocket according to his .prob value
  NNRocket pickOne() {
    //picks a random value
    float r=random(1);
    int index=0;
    //substracting rockets' values until r<0
    while (r>0 && index<nnRockets) {
      r-=rockets[index].prob;
      index++;
    }
    //to prevent numerical errors causing a very rare bug
    if (index>0) {
      index--;
    }
    return rockets[index];
  }
  //calculates n frames and draw the last one only
  void calcFrames(int n) {
    if (n==0){
      resetGen();
    }
    else{
      //loop for all the frames
      for (int i=0; i<n; i++) {
        //all frames but last one
        if (i<n-1) {
          //calculation of the frames
          for (NNRocket r : rockets) {
            r.update();
          }
          count++;
          newGen();
        }
        //drazwing the last frame
        else {
          calcFrame();
        }
      }
    }
  }
  //updates death value of the population
  void checkPop() {
    death=true;
    //if all the rockets finished their run
    for (NNRocket r : rockets) {
      if (!r.hit && !r.crashed) {
        death=false;
        break;
      }
    }
    //or if the count is over
    if (count>=framesPerRun) {
      death=true;
    }
  }
}
