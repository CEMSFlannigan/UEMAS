function [] = plot_Averages(avg_data)

frames = avg_data(end).frame;

for frame_iter = 1:frames
    
    plot(avg_data(frame_iter).distance,avg_data(frame_iter).average);
    hold on;
    pause(0.05)
    
end

end