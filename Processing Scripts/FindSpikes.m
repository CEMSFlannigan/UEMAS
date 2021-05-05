SpikePoints = [];

for i = 1:length(IGP2)
    if IGP2(i)>7.5e-5 && IGP2(i-1) < IGP2(i)
        SpikePoints = [SpikePoints TimefromZeros(i)];
    end
end

TimeElapsed = zeros(1,length(SpikePoints));

for i = 2:length(SpikePoints)
    TimeElapsed(i) = SpikePoints(i) - SpikePoints(i-1);
end