class NNdna{
  NeuralNet genes;
  NNdna(int[] sizes){
    genes=new NeuralNet(sizes);
  }
  NNdna(NeuralNet genes){
    this.genes=genes.clone();
  }
  void mutate(float mr){
    genes.mutate(mr);
  }
  NNdna crossOver(NNdna partner,float chance){
    return new NNdna(genes.crossOver(partner.genes,chance));
  }
  NNdna clone(){
    return new NNdna(genes);
  }
}
