function [enf,sig,c] = enf_extract_same(file,win,overlap)

Y= audioread(file);

Fs = 1000;
info=audioinfo(file);
Y=decimate(Y,round(info.SampleRate/Fs));

[sig,c]=nominaltypecombined(file);


nfft=32768;

harmonic_multiples=1:(ceil(Fs/(2*c))-1);
% harmonic_multiples=1:1;


duration = min([info.Duration/60,30]);
frame_size_secs=win;%100 samples window(50 hz)
overlap_amount_secs=overlap;%60 samples overlapping



strip_index=1;
tol=12;
nominal=c;
width_band=[1 3 8];


    width_signal=[0.1 1 5];

[enf,~]=findenfhampel(Y, Fs, harmonic_multiples,strip_index, duration, frame_size_secs,overlap_amount_secs, nfft, nominal, width_signal, width_band,tol );

%enf=enfsoft(enf,2,0.9,2);


end