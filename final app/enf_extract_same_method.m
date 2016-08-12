function [enf,sig,c] = enf_extract_same_method(filename,win,overlap)

Fs = 1000;

[Y,fs]= audioread(filename);
 Y=decimate(Y,round(fs/Fs));

[sig,c] = nominaltypecombined(filename);

nfft=32768;

harmonic_multiples=1:(ceil(Fs/(2*c))-1);


duration = 5;
frame_size_secs=win;%100 samples window(50 hz)
overlap_amount_secs=overlap;%60 samples overlapping



strip_index=1;
tol=15;
nominal=c;
width_band=[1 3 8];


width_signal=[0.1 1 5];

[enf,~]=findenfhampel(Y, Fs, harmonic_multiples,strip_index, duration, frame_size_secs,overlap_amount_secs, nfft, nominal, width_signal, width_band,tol );



end






