#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include <iostream>
#include <fstream>
#include <iomanip> 
using namespace std;

const int TAPS =  73;
const int SAMPLES = 100;
const double PI = 3.1415926535;

// FRACTION part
const int ip_frac = 10;
const int coeff_frac = 14;
const int op_frac = 13;

double h_float[TAPS] = {
    0.025804122, 0.020552684, 0.028396631, 0.037923047, 0.049296639, 0.062671826, 0.078188509,
    0.095967794, 0.116107786, 0.138679546, 0.163723333, 0.191245225, 0.221214225, 0.253559961,
    0.288171034, 0.324894126, 0.363533898, 0.403853725, 0.445577304, 0.488391123, 0.53194777,
    0.575870065, 0.61975593,  0.663183933, 0.705719403, 0.746921012, 0.786347677, 0.82356567,
    0.858155769, 0.889720317, 0.917890027, 0.942330394, 0.962747575, 0.978893597, 0.990570797,
    0.997635377, 1.0,         0.997635377, 0.990570797, 0.978893597, 0.962747575, 0.942330394,
    0.917890027, 0.889720317, 0.858155769, 0.82356567,  0.786347677, 0.746921012, 0.705719403,
    0.663183933, 0.61975593,  0.575870065, 0.53194777,  0.488391123, 0.445577304, 0.403853725,
    0.363533898, 0.324894126, 0.288171034, 0.253559961, 0.221214225, 0.191245225, 0.163723333,
    0.138679546, 0.116107786, 0.095967794, 0.078188509, 0.062671826, 0.049296639, 0.037923047,
    0.028396631, 0.020552684, 0.025804122
};
// TO fix coeffecients Q(2,14)
int16_t fixed_int(double float_value, int frac_bits){
    double scaled = float_value * (double)(1 << frac_bits); // value = float_point x 2^(#fraction bits)
    double rounded_value  = round(scaled); // round to nearest integer

    if(rounded_value > 32767){
        rounded_value = 32767;
    }
    if(rounded_value < -32768){
        rounded_value = -32768;
    }
    return (int16_t)rounded_value;
}
//To fix inputs Q(3,10)
int16_t fixed_x(double real_value, int frac_bits) {
    double scaled = real_value * (double)(1 << frac_bits); // value = float_point x 2^(#fraction bits)
    double rounded_value  = round(scaled); // round to nearest integer

     if(rounded_value > 4095){
        rounded_value = 4095;             // max representable: +3.999
    }
    if(rounded_value < -4096){
        rounded_value = -4096;            // min representable: -4.0
    }
    return (int16_t)rounded_value;
   
}

int main(){
    int cof_h[TAPS];
    int ip_x[SAMPLES];
    int op_y[SAMPLES];

    //Step1: Fixing coffe

    for(int i = 0; i < TAPS; i++){
        cof_h[i] = fixed_int(h_float[i], coeff_frac);
    }

    //Step2: input fixed

    for(int j = 0; j<SAMPLES ; j++){
        double x_real = 1 * sin(2 * PI * j / 25);
        ip_x[j] = fixed_x(x_real, ip_frac);
    }

    //Step3: Run the Filter

    for(int n = 0; n < SAMPLES ; n++){
        int acc = 0;
        int ip_sample;

        for(int k = 0; k < TAPS ; k++){
            int index = n - k; // get the index of all previous samples
            if(index >= 0){
                ip_sample = ip_x[index];
            }
            else{
                 ip_sample = 0;
            }
            acc = acc + (cof_h[k] * ip_sample);
            //accumulator add current and prevoius samples multiplication with coeffecients
        }

        //STEP4: Rescalling the output
        //       input = 10 frac_bits,
        //       coeff = 14 frac_bits,  => total= 24 frac_bits
        //       but output should be in Q(3,13)
        // Rounding and truncating

        int rmv_bits  = (ip_frac + coeff_frac) - op_frac; //(10+14)-13 = 11, want to remove 11 bits from LSB
        int half = 1<<(rmv_bits - 1); 

        int fixed_op = (acc + half) >> rmv_bits; // right shift to remove extra bits and add half to it

        if(fixed_op > 32767){
            fixed_op = 32767;
        }
        if(fixed_op < -32768){
            fixed_op = -32768;
        }
        op_y[n] = (int16_t)fixed_op;
    }
       // CREATING coeffecient File 
    ofstream file_coeff("coeffs_fixed.txt");
    if(!file_coeff.is_open()){
        cout << "Error opening coeffs_fixed.txt" << endl;
        return 1;
    }
    for(int k = 0; k < TAPS; k++){
        file_coeff << hex << (int16_t)cof_h[k] << "\n";
    }
    file_coeff.close();

    // Write input samples file
    ofstream file_input("input_samples.txt");
    if(!file_input.is_open()){
        cout << "Error opening input_samples.txt" << endl;
        return 1;
    }
    for(int n = 0; n < SAMPLES; n++){
        double x_real = 1.5 * sin(2.0 * PI * n / 25.0);
        file_input << hex << (int16_t)ip_x[n] << "\n";
    }
    file_input.close();

    // Write output samples file
    ofstream file_output("golden_output.txt");
    if(!file_output.is_open()){
        cout << "Error opening golden_output.txt" << endl;
        return 1;
    }
    for(int n = 0; n < SAMPLES; n++){
        file_output << hex << (int16_t)op_y[n] << "\n";
    }
    file_output.close();


//============TO Show input/Output ==========================

    for (int k = 0; k < TAPS; k++) {
    cout << "  h[" << setw(2) << k << "] = " << fixed << setprecision(9) << h_float[k] << "  ->  0x" << hex << uppercase << setw(4) << setfill('0') << (uint16_t)cof_h[k] << dec << setfill(' ') << endl;
}

cout << "\nInput samples (float -> fixed hex):" << endl;
for (int n = 0; n < SAMPLES; n++) {
    cout << "  x[" << setw(2) << n << "] = " << fixed << setprecision(9) << ip_x[n] << "  ->  0x" << hex << uppercase << setw(4) << setfill('0') << (uint16_t)ip_x[n] << dec << setfill(' ') << endl;
}

cout << "\nFilter outputs (fixed hex, Q(3,13)):" << endl;
for (int n = 0; n < SAMPLES; n++) {
    cout << "  y[" << setw(2) << n << "] = 0x" << hex << uppercase << setw(4) << setfill('0') << (uint16_t)op_y[n] << dec << setfill(' ') << endl;
}
    return 0;

}
