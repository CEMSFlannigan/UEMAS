function [ f, mx ] = Find_FFT( y, t, Unit, Zero )
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    Unit = Unit_Input;
    Zero = 1;
elseif isequal(nargin, 3)
    Zero = 1;
end

y = y(:);
t = t(:);
try
    if strcmp(Unit, 'fs') == 1
        t = 1E-15.*t;
    elseif strcmp(Unit, 'ps') == 1
        t = 1E-12.*t;
    elseif strcmp(Unit, 'ns') == 1
        t = 1E-9.*t;
    end
catch
    errordlg('Ensure ns, ps or fs are your units');
    return
end

t = t(Zero:end);
y = y(Zero:end);

y_av = mean(y);
y = y - y_av;

T_Step = abs(t(2)-t(1));
Fs = 1/T_Step;

L = length(t);
nfft = L*2;

Y = fft(y, nfft);
Y = Y(1:nfft/2);
mx = abs(Y);
f = (0:nfft/2-1)*Fs/nfft;

end