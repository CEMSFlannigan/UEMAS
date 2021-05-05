BW = cross_sign_indices;%edge(spaceTimePlot,'canny');

figure;
imagesc(BW);

[H,theta,rho] = hough(BW,'RhoResolution',1, 'Theta', 0:0.01:89.99); %

figure
imshow(imadjust(rescale(H)),[],...
       'XData',theta,...
       'YData',rho,...
       'InitialMagnification','fit');
xlabel('\theta (degrees)')
ylabel('\rho')
axis on
axis normal 
hold on
colormap(gca,hot)

P = houghpeaks(H,12,'threshold',ceil(0.5*max(H(:))));

x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y,'s','color','black');

hough_lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',50);

figure; imagesc(STPROI), hold on
max_len = 0;
for k = 1:length(hough_lines)
   xy = [hough_lines(k).point1; hough_lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(hough_lines(k).point1 - hough_lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');

hough_line_slopes = zeros(1,length(hough_lines));
hough_line_start = zeros(1,length(hough_lines));
for i = 1:length(hough_lines)
    
    x_dist = hough_lines(i).point2(1) - hough_lines(i).point1(1);
    y_dist = hough_lines(i).point2(2) - hough_lines(i).point1(2);
    
    hough_line_start(i) = hough_lines(i).point1(1);
    hough_line_slopes(i) = abs(y_dist/x_dist)*(mean(diff(distArr)))/5;
    
end

[hough_line_start sort_indices] = sort(hough_line_start);
slope_times = 5*hough_line_start + timeArr(25);
hough_line_slopes = hough_line_slopes(sort_indices);
figure;
scatter(slope_times,hough_line_slopes);

