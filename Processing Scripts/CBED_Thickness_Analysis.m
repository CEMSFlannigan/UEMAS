extinction_length = 79.6080; % nm for (113)

g = 5.86; % nm^-1
a = .5658; % nm
d = a./sqrt(1+1+9); % nm
lambda = 2.5079e-3; % nm


num_extinct = 10;
subplot_sqr = round(sqrt(num_extinct))+1;

extinctions = zeros(1,num_extinct);
thicknesses = zeros(1,num_extinct);

for i = 1:num_extinct
    X = g*2-2.1;
    
    DX_Arr = finDistArr(min_indexes);
    peak_pos = max_indexes(1);
    DX_Arr = [finDistArr(peak_pos),DX_Arr(1:end)];
    DX_Arr = fliplr(diff(DX_Arr));
    for j = 2:length(DX_Arr)
        DX_Arr(j) = DX_Arr(j)+DX_Arr(j-1);
    end
    
    S_g = DX_Arr.*lambda./g./d.^2;
    
    n_arr = i:i+length(DX_Arr)-1;
    
    n_inv = -(1./n_arr).^2;
    S_inv = (S_g./n_arr).^2;
    
    coeffs = polyfit(n_inv,S_inv,1);
    fittedY = polyval(coeffs,n_inv);
    
    subplot(subplot_sqr,subplot_sqr,i);
    scatter(n_inv,S_inv);
    hold on;
    plot(n_inv,fittedY);
    hold off;
    title(strcat(strcat(num2str(1/sqrt(abs(coeffs(1)))),' , '),num2str(1/sqrt(abs(coeffs(2))))));
    
    extinctions(i) = 1/sqrt(abs(coeffs(1)));
    thicknesses(i) = 1/sqrt(abs(coeffs(2)));
end

figure;
scatter(extinctions,thicknesses);
f = fit(extinctions',thicknesses','linearinterp');
hold on;
plot(f,extinctions',thicknesses');
scatter(extinction_length,f(extinction_length));
hold off;

f(extinction_length)