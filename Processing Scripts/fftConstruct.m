function [freq, power] = fftConstruct(time,data)
% Provides real frequency (angular freq * 2 * pi)
dt = time(2) - time(1);
fs = 1/dt;
L = length(time);
if mod(L,2) ~= 0
    time = time(1:end-1);
    data = data(1:end-1);
    L = length(time);
end

fftData = fft(data);

P2 = abs(fftData/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
freq = fs*(0:(L/2))/L;

power = P1;

end