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
     x = x + 50;
     float ibuff = (h - (inNeurons*30))/2;
     float hbuff = (h - (hNeurons*30))/2;
     float obuff = (h - (oNeurons*30))/2;
     float xbuff = (w - (4*15))/4;
     //INPUT TO FIRST HIDDEN LAYER
     for(int i = 0; i < w_hidden_in.rows; i++) {
        for(int j = 0; j < w_hidden_in.cols; j++) {
          if(w_hidden_in.matrix[i][j] > 0) {
             stroke(0,0,255);
          } else {
             stroke(255,0,0); 
          }
          line(x + 10, y + ibuff+10+(j*30), x + 10+xbuff, y + hbuff+10+(i*30));
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
          line(x + 10+xbuff, y + hbuff+10+(j*30), x + 10+xbuff*2, y + hbuff+10+(i*30));
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
          line(x + 10+xbuff*2, y + hbuff+10+(j*30), x +10+xbuff*3, y + obuff+10+(i*30));
        }
     }
     stroke(0);
     fill(255);
     for(int i = 0; i < inNeurons+1; i++) { 
        if(i != inNeurons) {
            if(vision[i] > 0) {
               fill(0,255,0); 
            } else {
               fill(255); 
            }
        }
        stroke(0);
        ellipse(x,y+10+ibuff+(i*30),20,20);
     }
     for(int i = 0; i < hNeurons; i++) {
        stroke(0);
        fill(255);
        ellipse(x+10+xbuff,y+10+hbuff+(i*30),20,20); 
     }
     for(int i = 0; i < hNeurons; i++) {
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
     for(int i = 0; i < oNeurons; i++) {
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
