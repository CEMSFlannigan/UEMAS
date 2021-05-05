function FFTMap(hObject, eventdata, handles)

data = guidata(hObject);

if data.prcToggle == 1
    backData = RMOuts(data.backData,data.highprc_cutoff,data.lowprc_cutoff);
else
    data.backData = RMOuts(data.backData);
end

if data.normToggle == 1 && data.backToggle == 1
    backData = (backData - ones(size(backData)).*min(min(backData)))./(max(max(backData)) - min(min(backData)));
end

if ~isempty(data.degRot) && data.rotToggle == 1 && data.backToggle == 1
    backData = imrotate(backData,data.degRot);
end

ULGTime = sortrows(data.ULGData,3);

timeArr = cell2mat(ULGTime(:,3));
timeSample = mean(diff(timeArr));

curFile = [ULGTime{1,6} '.dm3'];
dm3path = [data.dm3path '\' curFile];
dm3Data = DM3Import(dm3path);
cur_img = dm3Data.image_data;
assignin('base','analysis_dm3',dm3path);
memfile = whos('cur_img');
memfileSize = memfile.bytes;
memdata = memory;
memavail = memdata.MemAvailableAllArrays;
physRAM = 8*1024*1024*1024*8; % bytes

%%%% Add ROI Toggle
if data.ROIToggle == 1
    ROIRect = data.RectROI;
    xpos = ROIRect(1);
    ypos = ROIRect(2);
    xdim = ROIRect(3);
    ydim = ROIRect(4);
else
    xdim = size(dm3Data.image_data',1);
    ydim = size(dm3Data.image_data',2);
end

cur_pixel_data = zeros(1,length(timeArr));

NFFT = 2^nextpow2(length(timeArr));
freq_list = (1./timeSample)/2*linspace(0,1,NFFT/2+1);
frequency_maps = zeros(xdim,ydim,length(freq_list));

if (memfileSize*length(timeArr) < memavail && memfileSize*length(timeArr) < physRAM)
    canLoadAll = 1;
    imageStack = zeros(xdim,ydim,length(timeArr));
    w = waitbar(0,'Collecting Pixels');
    for i = 1:length(data.ULGData(:,3))
        
        curFile = [ULGTime{i,6} '.dm3'];
        dm3path = [data.dm3path '\' curFile];
        dm3Data = DM3Import(dm3path);
        assignin('base','analysis_dm3',dm3path);
        cur_img_data = dm3Data.image_data';
        
        if data.prcToggle == 1
            cur_img_data = RMOuts(cur_img_data,data.highprc_cutoff,data.lowprc_cutoff);
        else
            cur_img_data = RMOuts(cur_img_data);
        end
        
        if data.normToggle == 1
            cur_img_data = (cur_img_data - ones(size(cur_img_data)).*min(min(cur_img_data)))./(max(max(cur_img_data)) - min(min(cur_img_data)));
        end
        
        if ~isempty(data.degRot) && data.rotToggle == 1
            cur_img_data = imrotate(cur_img_data,data.degRot);
        end
        
        if data.driftToggle == 1
            cur_img_data = circshift(cur_img_data, [data.drift_correct(i, 3), data.drift_correct(i, 2)]);
        end
        
        if data.backToggle == 1
            cur_img_data = cur_img_data - backData;
        end
        
        imageStack(:,:,i) = cur_img_data;
        figure(w);
        waitbar(i/length(timeArr));
    end
    close(w);
else
    canLoadAll = 0;
end

%h4 = figure;
if (canLoadAll == 1)
    w = waitbar(0,'Collecting FFT');
    for j = 1:xdim
        for k = 1:ydim
            %figure(h4);
            %subplot(1,2,1);
            pixel_data = imageStack(j,k,:);
            pixel_data = pixel_data(:);
            %plot(timeArr,pixel_data);
            pixel_fft = fft(pixel_data,NFFT)/length(timeArr);
            pixel_fft = 2*abs(pixel_fft(1:NFFT/2+1));
            %subplot(1,2,2);
            %plot(freq_list,pixel_fft);
            
            frequency_maps(j,k,:) = pixel_fft;
            (j*xdim+k)
            %figure(w);
            waitbar(((j-1)*xdim+k)/(xdim*ydim));
        end
    end
else
    w = waitbar(0,'Collecting Pixels');
    %h1 = figure;
    %h2 = figure;
    for j = 1:xdim
        for k = 1:ydim
            for i = 1:length(data.ULGData(:,3))
                
                curFile = [ULGTime{i,6} '.dm3'];
                dm3path = [data.dm3path '\' curFile];
                dm3Data = DM3Import(dm3path);
                assignin('base','analysis_dm3',dm3path);
                cur_img_data = dm3Data.image_data';
                
                if data.prcToggle == 1
                    cur_img_data = RMOuts(cur_img_data,data.highprc_cutoff,data.lowprc_cutoff);
                else
                    cur_img_data = RMOuts(cur_img_data);
                end
                
                if data.normToggle == 1
                    cur_img_data = (cur_img_data - ones(size(cur_img_data)).*min(min(cur_img_data)))./(max(max(cur_img_data)) - min(min(cur_img_data)));
                end
                
                if ~isempty(data.degRot) && data.rotToggle == 1
                    cur_img_data = imrotate(cur_img_data,data.degRot);
                end
                
                if data.driftToggle == 1
                    cur_img_data = circshift(cur_img_data, [data.drift_correct(i, 3), data.drift_correct(i, 2)]);
                end
                
                if data.backToggle == 1
                    cur_img_data = cur_img_data - backData;
                end
                
                cur_pixel_data(i) = cur_img_data(j,k);
            end
            
            pixel_fft = fft(cur_pixel_data,NFFT)/length(timeArr);
            pixel_fft = 2*abs(pixel_fft(1:NFFT/2+1));
            
            frequency_maps(j,k,:) = pixel_fft;
            
            waitbar((j*xdim+k)/(xdim*ydim));
        end
    end
end

close(w);



assignin('base','frequency_maps',frequency_maps);
assignin('base','freq_list',freq_list);

end