function DigitalLPF=LPF

Wc = 10; 
N = 2;


[Nz, Dz] = butter(N, Wc, 'low', 's') ;
DigitalLPF = tf(Nz, Dz);


end