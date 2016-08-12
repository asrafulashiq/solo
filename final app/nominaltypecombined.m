function [sig,c]=nominaltypecombined(filename)

[x, fs] = audioread(filename);
x = decimate(x,round(fs/1000));
xf = abs(fft(x));
f = (0:length(x)-1)/length(x)*fs;

mask = (f>50-1 & f < 50+1) | (f>60-1 & f<60+1 ) | (f>2*(50-1)  & f < 2*(50+1) ) | (f>2*(60-1) & f<2*(60+1));

f1 = f(mask);
xf1 = xf(mask);
[val, pos] = max(xf1);
n50 = min(abs([50 100]-f1(pos)));
n60 = min(abs([60 120]-f1(pos)));
if n50 < n60
    c  =50;
else
    c  = 60;
end

mask2 = (f<=125);
f = f(mask2);
xf = xf(mask2);
mask = (f>50-1 & f < 50+1) | (f>60-1 & f<60+1 ) | (f>2*(50-1)  & f < 2*(50+1) ) | (f>2*(60-1) & f<2*(60+1));
xf1 = xf(mask);
xf2 = xf(mask == 0);
th = sum(xf2)/sum(xf1);
if th>3
    sig = 'audio';
else
    sig = 'power';
end

end