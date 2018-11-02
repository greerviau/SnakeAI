class NeuralNet {
  
  int iNodes, hNodes, oNodes;
  Matrix whi, whh, woh;
  
  NeuralNet(int inputNo, int hiddenNo, int outputNo) {
    iNodes = inputNo;
    hNodes = hiddenNo;
    oNodes = outputNo;
    
    whi = new Matrix(hNodes, iNodes+1);
    whh = new Matrix(hNodes, hNodes+1);
    woh = new Matrix(oNodes, hNodes+1);
    
    whi.randomize();
    whh.randomize();
    woh.randomize();
  }
  
  void show(float x, float y, float w, float h, float[] vision, float[] decision) {
     x = x + 50;
     float ibuff = (h - (iNodes*30))/2;
     float hbuff = (h - (hNodes*30))/2;
     float obuff = (h - (oNodes*30))/2;
     float xbuff = (w - (4*15))/4;
     //INPUT TO FIRST HIDDEN LAYER
     for(int i = 0; i < whi.rows; i++) {
        for(int j = 0; j < whi.cols; j++) {
          if(whi.matrix[i][j] > 0) {
             stroke(0,0,255);
          } else {
             stroke(255,0,0); 
          }
          line(x + 10, y + ibuff+10+(j*30), x + 10+xbuff, y + hbuff+10+(i*30));
        }
     }
     //HIDDEN LAYER TO HIDDEN LAYER
     for(int i = 0; i < whh.rows; i++) {
        for(int j = 0; j < whh.cols-1; j++) {
          if(whh.matrix[i][j] > 0) {
             stroke(0,0,255);
          } else {
             stroke(255,0,0); 
          }
          line(x + 10+xbuff, y + hbuff+10+(j*30), x + 10+xbuff*2, y + hbuff+10+(i*30));
        }
     }
     //HIDDEN LAYER TO OUTPUT
     for(int i = 0; i < woh.rows; i++) {
        for(int j = 0; j < woh.cols-1; j++) {
          if(woh.matrix[i][j] > 0) {
             stroke(0,0,255);
          } else {
             stroke(255,0,0); 
          }
          line(x + 10+xbuff*2, y + hbuff+10+(j*30), x +10+xbuff*3, y + obuff+10+(i*30));
        }
     }
     stroke(0);
     fill(255);
     for(int i = 0; i < iNodes+1; i++) { 
        if(i != iNodes) {
            if(vision[i] > 0) {
               fill(0,255,0); 
            } else {
               fill(255); 
            }
        }
        stroke(0);
        ellipse(x,y+10+ibuff+(i*30),20,20);
     }
     for(int i = 0; i < hNodes; i++) {
        stroke(0);
        fill(255);
        ellipse(x+10+xbuff,y+10+hbuff+(i*30),20,20); 
     }
     for(int i = 0; i < hNodes; i++) {
        stroke(0);
        fill(255);
        ellipse(x+10+xbuff*2,y+10+hbuff+(i*30),20,20); 
     }
     int maxindex = 0;
     for(int i = 1; i < decision.length; i++) {
        if(decision[i] > decision[maxindex]) {
          maxindex = i;
        }
     }
     for(int i = 0; i < oNodes; i++) {
        if(maxindex == i) {
           fill(0,255,0); 
        } else {
          fill(255);
        }
        stroke(0);
        ellipse(x+15+xbuff*3,y+10+obuff+(i*30),20,20); 
     }
     fill(255);
     textSize(14);
     textAlign(LEFT);
     text("UP",x+30+xbuff*3,y+obuff+15);
     text("DOWN",x+30+xbuff*3,y+obuff+45);
     text("LEFT",x+30+xbuff*3,y+obuff+75);
     text("RIGHT",x+30+xbuff*3,y+obuff+105);
  }
  
  void mutate(float mr) {
     whi.mutate(mr);
     whh.mutate(mr);
     woh.mutate(mr);
  }
  
  float[] output(float[] inputsArr) {
     Matrix inputs = woh.singleColumnMatrixFromArray(inputsArr);
     
     Matrix inputsBias = inputs.addBias();
     
     Matrix hiddenInputs = whi.dot(inputsBias);
     
     Matrix hiddenOutputs = hiddenInputs.activate();
     
     Matrix hiddenOutputsBias = hiddenOutputs.addBias();
     
     Matrix hiddenInputs2 = whh.dot(hiddenOutputsBias);
     Matrix hiddenOutputs2 = hiddenInputs2.activate();
     Matrix hiddenOutputsBias2 = hiddenOutputs2.addBias();
     
     Matrix outputInputs = woh.dot(hiddenOutputsBias2);
     Matrix outputs = outputInputs.activate();
     
     return outputs.toArray();
  }
  
  NeuralNet crossover(NeuralNet partner) {
     NeuralNet child = new NeuralNet(iNodes,hNodes,oNodes);
     child.whi = whi.crossover(partner.whi);
     child.whh = whh.crossover(partner.whh);
     child.woh = woh.crossover(partner.woh);
     return child;
  }
  
  NeuralNet clone() {
     NeuralNet clone = new NeuralNet(iNodes, hNodes, oNodes);
     clone.whi = whi.clone();
     clone.whh = whh.clone();
     clone.woh = woh.clone();
     
     return clone;
  }
}
