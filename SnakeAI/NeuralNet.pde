class NeuralNet {
  
  int inNeurons, hNeurons, oNeurons;
  Matrix w_hidden_in, w_hidden_hidden, w_output_hidden;
  
  NeuralNet(int input, int hidden, int output) {
    inNeurons = input;
    hNeurons = hidden;
    oNeurons = output;
    
    w_hidden_in = new Matrix(hNeurons, inNeurons+1);
    w_hidden_hidden = new Matrix(hNeurons, hNeurons+1);
    w_output_hidden = new Matrix(oNeurons, hNeurons+1);
    
    w_hidden_in.randomize();
    w_hidden_hidden.randomize();
    w_output_hidden.randomize();
  }
  
  void show(float x, float y, float w, float h, float[] vision, float[] decision) {
     float dif = h/inNeurons;
     float space = dif/3;
     float neuronsize = dif - space;
     x = x + 10;
     y = y + 5;
     float ibuff = (h - (inNeurons*dif))/2;
     float hbuff = (h - (hNeurons*dif))/2;
     float obuff = (h - (oNeurons*dif))/2;
     float xbuff = (w - (4*15))/4;
     //INPUT TO FIRST HIDDEN LAYER
     for(int i = 0; i < w_hidden_in.rows; i++) {
        for(int j = 0; j < w_hidden_in.cols-1; j++) {
          if(w_hidden_in.matrix[i][j] > 0) {
             stroke(0,0,255);
          } else {
             stroke(255,0,0); 
          }
          line(x + neuronsize, y + ibuff+space+(j*dif), x +neuronsize+xbuff, y + hbuff+space+(i*dif));
        }
     }
     //HIDDEN LAYER TO HIDDEN LAYER
     for(int i = 0; i < w_hidden_hidden.rows; i++) {
        for(int j = 0; j < w_hidden_hidden.cols-1; j++) {
          if(w_hidden_hidden.matrix[i][j] > 0) {
             stroke(0,0,255);
          } else {
             stroke(255,0,0); 
          }
          line(x + neuronsize*2+xbuff, y + hbuff+space+(j*dif), x + neuronsize*3+xbuff*2, y + hbuff+space+(i*dif));
        }
     }
     //HIDDEN LAYER TO OUTPUT
     for(int i = 0; i < w_output_hidden.rows; i++) {
        for(int j = 0; j < w_output_hidden.cols-1; j++) {
          if(w_output_hidden.matrix[i][j] > 0) {
             stroke(0,0,255);
          } else {
             stroke(255,0,0); 
          }
          line(x + neuronsize*4+xbuff*2, y + hbuff+space+(j*dif), x+neuronsize*5+xbuff*2+xbuff/2, y + obuff+space+(i*dif));
        }
     }
     stroke(0);
     fill(255);
     ellipseMode(LEFT);
     for(int i = 0; i < inNeurons; i++) { 
        if(i != inNeurons) {
            if(vision[i] > 0) {
               fill(0,255,0); 
            } else {
               fill(255); 
            }
        }
        stroke(0);
        ellipse(x,y+ibuff+(i*dif),neuronsize,neuronsize);
     }
     for(int i = 0; i < hNeurons; i++) {
        stroke(0);
        fill(255);
        ellipse(x+neuronsize+xbuff,y+hbuff+(i*dif),neuronsize,neuronsize); 
     }
     for(int i = 0; i < hNeurons; i++) {
        stroke(0);
        fill(255);
        ellipse(x+neuronsize*3+xbuff*2,y+hbuff+(i*dif),neuronsize,neuronsize); 
     }
     int maxindex = 0;
     for(int i = 1; i < decision.length; i++) {
        if(decision[i] > decision[maxindex]) {
          maxindex = i;
        }
     }
     for(int i = 0; i < oNeurons; i++) {
        if(maxindex == i) {
           fill(0,255,0); 
        } else {
          fill(255);
        }
        stroke(0);
        ellipse(x+neuronsize*5+xbuff*2+xbuff/2,y+obuff+(i*dif),neuronsize,neuronsize); 
     }
     fill(255);
     textSize(dif/2);
     textAlign(LEFT);
     text("UP",x+5+neuronsize*6+xbuff*2+xbuff/2,y+obuff+dif/2);
     text("DOWN",x+5+neuronsize*6+xbuff*2+xbuff/2,y+obuff+(dif/2)+dif);
     text("LEFT",x+5+neuronsize*6+xbuff*2+xbuff/2,y+obuff+(dif/2)+2*dif);
     text("RIGHT",x+5+neuronsize*6+xbuff*2+xbuff/2,y+obuff+(dif/2)+3*dif);
  }
  
  void mutate(float mr) {
     w_hidden_in.mutate(mr);
     w_hidden_hidden.mutate(mr);
     w_output_hidden.mutate(mr);
  }
  
  float[] output(float[] inputsArr) {
     Matrix inputs = w_output_hidden.singleColumnMatrixFromArray(inputsArr);
     
     Matrix ip_bias = inputs.addBias();
     
     Matrix hidden_ip = w_hidden_in.dot(ip_bias);
     
     Matrix hidden_op = hidden_ip.activate();
     
     Matrix hidden_op_bias = hidden_op.addBias();
     
     Matrix hidden_ip2 = w_hidden_hidden.dot(hidden_op_bias);
     Matrix hidden_op2 = hidden_ip2.activate();
     Matrix hidden_op_bias2 = hidden_op2.addBias();
     
     Matrix output_ip = w_output_hidden.dot(hidden_op_bias2);
     Matrix output = output_ip.activate();
     
     return output.toArray();
  }
  
  NeuralNet crossover(NeuralNet partner) {
     NeuralNet child = new NeuralNet(inNeurons,hNeurons,oNeurons);
     child.w_hidden_in = w_hidden_in.crossover(partner.w_hidden_in);
     child.w_hidden_hidden = w_hidden_hidden.crossover(partner.w_hidden_hidden);
     child.w_output_hidden = w_output_hidden.crossover(partner.w_output_hidden);
     return child;
  }
  
  NeuralNet clone() {
     NeuralNet clone = new NeuralNet(inNeurons, hNeurons, oNeurons);
     clone.w_hidden_in = w_hidden_in.clone();
     clone.w_hidden_hidden = w_hidden_hidden.clone();
     clone.w_output_hidden = w_output_hidden.clone();
     
     return clone;
  }
}
