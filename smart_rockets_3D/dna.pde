class DNA{
  NeuralNet genes;
  DNA(int IN,int HN,int ON){
    genes=new NeuralNet(IN,HN,ON);
  }
  DNA(NeuralNet genes){
    this.genes=genes.clone();
  }
  void mutate(float mr){
    genes.mutate(mr);
  }
  DNA crossOver(DNA partner){
    return new DNA(genes.crossOver(partner.genes));
  }
  DNA clone(){
    return new DNA(genes);
  }
}