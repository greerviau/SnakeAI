class NeuralNet {
  
  int iNodes, hNodes, oNodes;
  Matrix h_i_weights, h_h_weights, o_h_weights;
  
  NeuralNet(int input, int hidden, int output) {
    iNodes = input;
    hNodes = hidden;
    oNodes = output;
    
    h_i_weights = new Matrix(hNodes, iNodes+1);
    h_h_weights = new Matrix(hNodes, hNodes+1);
    o_h_weights = new Matrix(oNodes, hNodes+1);
    
    h_i_weights.randomize();
    h_h_weights.randomize();
    o_h_weights.randomize();
  }
  
  void mutate(float mr) {
     h_i_weights.mutate(mr);
     h_h_weights.mutate(mr);
     o_h_weights.mutate(mr);
  }
  
  float[] output(float[] inputsArr) {
     Matrix inputs = o_h_weights.singleColumnMatrixFromArray(inputsArr);
     
     Matrix ip_bias = inputs.addBias();
     
     Matrix hidden_ip = h_i_weights.dot(ip_bias);
     
     Matrix hidden_op = hidden_ip.activate();
     
     Matrix hidden_op_bias = hidden_op.addBias();
     
     Matrix hidden_ip2 = h_h_weights.dot(hidden_op_bias);
     Matrix hidden_op2 = hidden_ip2.activate();
     Matrix hidden_op_bias2 = hidden_op2.addBias();
     
     Matrix output_ip = o_h_weights.dot(hidden_op_bias2);
     Matrix output = output_ip.activate();
     
     return output.toArray();
  }
  
  NeuralNet crossover(NeuralNet partner) {
     NeuralNet child = new NeuralNet(iNodes,hNodes,oNodes);
     child.h_i_weights = h_i_weights.crossover(partner.h_i_weights);
     child.h_h_weights = h_h_weights.crossover(partner.h_h_weights);
     child.o_h_weights = o_h_weights.crossover(partner.o_h_weights);
     return child;
  }
  
  NeuralNet clone() {
     NeuralNet clone = new NeuralNet(iNodes, hNodes, oNodes);
     clone.h_i_weights = h_i_weights.clone();
     clone.h_h_weights = h_h_weights.clone();
     clone.o_h_weights = o_h_weights.clone();
     
     return clone;
  }
  
  void load(float[][] w1, float[][] w2, float[][] w3) {
      h_i_weights = new Matrix(w1);
      h_h_weights = new Matrix(w2);
      o_h_weights = new Matrix(w3);
  }
  
  Matrix[] pull() {
     Matrix[] model = new Matrix[3];
     model[0] = h_i_weights;
     model[1] = h_h_weights;
     model[2] = o_h_weights;
     return model;
  }
  
  void show(float x, float y, float w, float h, float[] vision, float[] decision) {
     float space = 5;
     float nSize = (h - (space*(iNodes-2))) / iNodes;
     float nSpace = (w - (4*nSize)) / 3;
     float hBuff = (h - (space*(hNodes-1)) - (nSize*hNodes))/2;
     float oBuff = (h - (space*(oNodes-1)) - (nSize*oNodes))/2;
     
     int maxIndex = 0;
     for(int i = 1; i < decision.length; i++) {
        if(decision[i] > decision[maxIndex]) {
           maxIndex = i; 
        }
     }
     
     //DRAW NODES
     for(int i = 0; i < iNodes; i++) {  //DRAW INPUTS
         if(vision[i] != 0) {
           fill(0,255,0);
         } else {
           fill(255); 
         }
         stroke(0);
         ellipseMode(CORNER);
         ellipse(x,y+(i*(nSize+space)),nSize,nSize);
     }
     for(int i = 0; i < hNodes; i++) {  //DRAW HIDDEN
         fill(255);
         stroke(0);
         ellipseMode(CORNER);
         ellipse(x+nSize+nSpace,y+hBuff+(i*(nSize+space)),nSize,nSize);
         ellipse(x+(2*nSpace)+(2*nSize),y+hBuff+(i*(nSize+space)),nSize,nSize);
     }
     for(int i = 0; i < oNodes; i++) {  //DRAW OUTPUTS
         if(i == maxIndex) {
           fill(0,255,0);
         } else {
           fill(255); 
         }
         stroke(0);
         ellipseMode(CORNER);
         ellipse(x+(3*nSpace)+(3*nSize),y+oBuff+(i*(nSize+space)),nSize,nSize);
     }
     
     //DRAW WEIGHTS
     for(int i = 0; i < h_i_weights.rows; i++) {  //INPUT TO HIDDEN
        for(int j = 0; j < h_i_weights.cols-1; j++) {
            if(h_i_weights.matrix[i][j] < 0) {
               stroke(255,0,0); 
            } else {
               stroke(0,0,255); 
            }
            line(x+nSize,y+(nSize/2)+(j*(space+nSize)),x+nSize+nSpace,y+hBuff+(nSize/2)+(i*(space+nSize)));
        }
     }
     
     for(int i = 0; i < h_h_weights.rows; i++) {  //HIDDEN TO HIDDEN
        for(int j = 0; j < h_h_weights.cols-1; j++) {
            if(h_h_weights.matrix[i][j] < 0) {
               stroke(255,0,0); 
            } else {
               stroke(0,0,255); 
            }
            line(x+(2*nSize)+nSpace,y+hBuff+(nSize/2)+(j*(space+nSize)),x+(2*nSize)+(2*nSpace),y+hBuff+(nSize/2)+(i*(space+nSize)));
        }
     }
     
     for(int i = 0; i < o_h_weights.rows; i++) {  //HIDDEN TO OUTPUT
        for(int j = 0; j < o_h_weights.cols-1; j++) {
            if(o_h_weights.matrix[i][j] < 0) {
               stroke(255,0,0); 
            } else {
               stroke(0,0,255); 
            }
            line(x+(3*nSize)+(2*nSpace),y+hBuff+(nSize/2)+(j*(space+nSize)),x+(3*nSize)+(3*nSpace),y+oBuff+(nSize/2)+(i*(space+nSize)));
        }
     }
     fill(255);
     textSize(15);
     textAlign(LEFT,CENTER);
     text("UP",x+(4*nSize)+(3*nSpace)+5,y+oBuff+(nSize/2));
     text("DOWN",x+(4*nSize)+(3*nSpace)+5,y+oBuff+space+nSize+(nSize/2));
     text("LEFT",x+(4*nSize)+(3*nSpace)+5,y+oBuff+(2*space)+(2*nSize)+(nSize/2));
     text("RIGHT",x+(4*nSize)+(3*nSpace)+5,y+oBuff+(3*space)+(3*nSize)+(nSize/2));
  }
}
