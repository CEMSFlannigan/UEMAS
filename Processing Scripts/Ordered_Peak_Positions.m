function [time_ordered, peaks_ordered] = Ordered_Peak_Positions(times, peak_centers)

numNaN = 0;

for i = 1:length(times)
    
    if isnan(peak_centers(i)) == 1
        numNaN = numNaN + 1;
    end
    
end

time_ordered = zeros(length(times) - numNaN,1);
peaks_ordered = zeros(length(times) - numNaN,1);

index_track = 1;
for i = 1:length(times)
    
    if isnan(peak_centers(i)) == 0
        time_ordered(index_track) = times(i);
        peaks_ordered(index_track) = peak_centers(i);
        index_track = index_track + 1;
    end
    
end

end