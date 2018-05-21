class NNdna{
  NeuralNet genes;
  NNdna(int IN,int HN,int ON){
    genes=new NeuralNet(IN,HN,ON);
  }
  NNdna(NeuralNet genes){
    this.genes=genes.clone();
  }
  void mutate(float mr){
    genes.mutate(mr);
  }
  NNdna crossOver(NNdna partner){
    return new NNdna(genes.crossOver(partner.genes));
  }
  NNdna clone(){
    return new NNdna(genes);
  }
}