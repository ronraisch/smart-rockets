class DNA{
  PVector[] genes;
  // constructor for given genes
  DNA(PVector[] genes){
    this.genes=new PVector[framesPerRun];
    this.genes=genes.clone();
  }
  // constructor for new genes
  DNA(){
    this.genes=new PVector[framesPerRun];
    for (int i=0;i<framesPerRun;i++){
      genes[i]=new PVector(random(-forceMag,forceMag),random(-angleRange,angleRange));
    }
  }
  // mutation function
  void mutate(){
    for (int i=0;i<genes.length;i++){
      if (random(1)<mutationRate)
        genes[i].x+=randomGaussian()*MCF*forceMag;
        genes[i].y+=randomGaussian()*MCA*angleRange;
    }
  }
  // returning a child of this and given partner DNA
  DNA crossOver(DNA partner){
    DNA child=new DNA();
    for (int i=0;i<framesPerRun;i++){
      if (random(1)<0.5){
        child.genes[i]=genes[i].copy();
      }
      else{
        child.genes[i]=genes[i].copy();
      }
    }
    return child;
  }
  // returning a copy of the dna
  DNA clone(){
    return new DNA(genes);
  }
}