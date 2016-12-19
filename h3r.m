function [hr, breaths, rr] = h3r(signal, freq)
%Input:
%signal - a vector (ECG signal)
%freq - the sampling frequency of the ECG signal
%Output:
%hr - heart rate
%breaths - the number of breathings in the ECG signal
%rr - the respiratory rate (number of breathings in a minute)

seconds =  round(length(signal)/freq);
%R-R peak detection
[qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(signal,freq,0);

%---------------------Heart Rate-------------------------------
bps = 1/(seconds/length(qrs_i_raw));
hr = bps * 60;

%-------------------Respiratory Rate---------------------------
%Number of peaks
k = zeros(length(qrs_i_raw)-1,1);

%Find the kurtosis of between the intervals of peaks
for i=1:length(qrs_i_raw)-1
    k(i) = kurtosis(signal(qrs_i_raw(i):qrs_i_raw(i+1)),1);
end

%Smooth the kurtosis
smoothed_k = smooth(k,'rlowess');

%Find the peaks (breathings)
pnum = findpeaks(smoothed_k);
breaths = length(pnum);
rr = (1/(seconds/breaths))* 60;

end

