class Population{
  Rocket[] rockets;
  boolean death=false;
  Population(){
    //initializing rockets
    rockets=new Rocket[nRockets];
    for (int i=0;i<nRockets;i++){
      rockets[i]=new Rocket();
    }
  }
  //drawing and calculating a frame
  void calcFrame(){
    fill(240,100);
    for (Rocket r:rockets){
      r.update();
      r.show();
    }
    count++;
    newGen();
  }
  void calcFrameBest(){
    for (int i=0;i<nRockets;i++){
      rockets[i].update();
      if (rockets[i].bestRocket){
        fill(240,100);
        rockets[i].show();
      }
    }
    count++;
    newGen();
  }
  //finding best rocket
  DNA bestRocket(){
    float best=0;
    Rocket bestR=new Rocket();
    prevDist=bestDist;
    for (int i=0;i<nRockets;i++){
      if (rockets[i].fitness>best){
        best=rockets[i].fitness;
        bestR=rockets[i];
      }
      bestDist=min(bestDist,rockets[i].distance);
    }
    return bestR.dna;
  }
  //managing the whole repopulation stuff
  void newGen(){
    //checks if population is dead
    checkPop();
    if (death){
      if (prevDist>bestDist){
        stuckCount=0;
      }
      else{
        stuckCount++;
      }
      if (stuckCount>stuckLimit){
        stuckCount=0;
        mutationRate*=1.05;
        MCA*=1.05;
        MCA=min(MCA,maxMCA);
        mutationRate=min(mutationRate,maxMutationRate);
      }
      count=0;
      changeMutation();
      //updating generation and anyHit
      generation++;
      prevHit=anyHit;
      anyHit=false;
      //assigns probablity to each rocket
      makeProbs();
      //array for the new population
      Rocket[] newRockets=new Rocket[nRockets];
      //kepping best rocket
      Rocket best=new Rocket(bestRocket());
      best.bestRocket=true;
      newRockets[0]=best;
      for (int i=1;i<nRockets;i++){
        //picking 2 parents
        Rocket parentA=pickOne();
        Rocket parentB=pickOne();
        //breed then: crossover and mutation
        Rocket child=new Rocket();
        DNA childna=parentA.dna.crossOver(parentB.dna);
        childna.mutate();
        child.dna=childna.clone();
        //adding the child to the new rockets array
        newRockets[i]=child;
      }
      rockets=newRockets;
    }
  }
  //assigning values to each rocket
  void makeProbs(){
    float sum=0;
    //summing the fitness values
    for (Rocket r:rockets){
      r.calcFitness();
      sum+=r.fitness;
    }
    //assigning the probability for each rocket
    for (Rocket r:rockets){
      r.prob=r.fitness/sum;
    }
  }
  //returns a random rocket according to his .prob value
  Rocket pickOne(){
    //picks a random value
    float r=random(1);
    int index=0;
    //substracting rockets' values until r<0
    while(r>0 && index<nRockets){
      r-=rockets[index].prob;
      index++;
    }
    //to prevent numerical errors causing a very rare bug
    if (index>0){
      index--;
    }
    return rockets[index];
  }
  //calculates n frames and draw the last one only
  void calcFrames(int n){
    //loop for all the frames
    for (int i=0;i<n;i++){
      //all frames but last one
      if (i<n-1){
        //calculation of the frames
        for (Rocket r:rockets){
          r.update();
        }
        count++;
        newGen();
      }
      //drawing the last frame
      else{
        calcFrame();
      }
      
    }
  }
  //updates death value of the population
  void checkPop(){
    death=true;
    //if all the rockets finished their run
    for (Rocket r:rockets){
      if (!r.hit && !r.crashed){
        death=false;
        break;
      }
    }
    //or if the count is over
    if (count>=framesPerRun){
      death=true;
    }
  }
}