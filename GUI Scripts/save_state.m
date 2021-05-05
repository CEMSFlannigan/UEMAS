function save_state(source, eventdata, handles)

data = guidata(source);

[FileName, FilePath] = uiputfile('*.txt','Save file name, overwrites previous data (do not include extension).');
saveName = [FilePath '\' FileName];
% Values required to be loaded in: ULGData, cur_img_data, dm3files,
% scanPop, Img_Box, frameSetReq, frameSetSlide, jframeSetSlide,
% hframeSetSlide, drift_correct,order_callback, rectROI, lineROI, backData,
% misalLineROI, FolderStitchPaths, full_path_data

% Required to be added: drift_correct_file, background_file

% Fixes: order-callback uses wrong notation (state of button vs. variable
% state)
saveFile = fopen(saveName,'wt');
fprintf(saveFile,'%s\n',num2str(data.curScan));
fprintf(saveFile,'%s\n',num2str(data.scanNum));
fprintf(saveFile,'%s\n',num2str(data.curTime));
fprintf(saveFile,'%s\n',num2str(data.TimeIncr));
fprintf(saveFile,'%s\n',data.ulgpath);
fprintf(saveFile,'%s\n',data.dm3path);
fprintf(saveFile,'%s\n',num2str(data.lowprc_cutoff));
fprintf(saveFile,'%s\n',num2str(data.highprc_cutoff));
fprintf(saveFile,'%s\n',num2str(data.prcToggle));
fprintf(saveFile,'%s\n',num2str(data.degRot));
fprintf(saveFile,'%s\n',num2str(data.rotToggle));
fprintf(saveFile,'%s\n',num2str(data.frames));
fprintf(saveFile,'%s\n',num2str(data.curFrame));
fprintf(saveFile,'%s\n',num2str(data.driftToggle));
fprintf(saveFile,'%s\n',num2str(data.ordered));
fprintf(saveFile,'%s\n',num2str(data.rectROIx));
fprintf(saveFile,'%s\n',num2str(data.rectROIy));
fprintf(saveFile,'%s\n',num2str(data.rectROIxRes));
fprintf(saveFile,'%s\n',num2str(data.rectROIyRes));
fprintf(saveFile,'%s\n',num2str(data.lineROIx1));
fprintf(saveFile,'%s\n',num2str(data.lineROIx2));
fprintf(saveFile,'%s\n',num2str(data.lineROIy1));
fprintf(saveFile,'%s\n',num2str(data.lineROIy2));
fprintf(saveFile,'%s\n',num2str(data.lineWidth));
fprintf(saveFile,'%s\n',num2str(data.scale));
fprintf(saveFile,'%s\n',num2str(data.width));
fprintf(saveFile,'%s\n',num2str(data.backToggle));
fprintf(saveFile,'%s\n',num2str(data.vToggle));
fprintf(saveFile,'%s\n',num2str(data.hToggle));
fprintf(saveFile,'%s\n',num2str(data.degVar));
fprintf(saveFile,'%s\n',num2str(data.normToggle));
fprintf(saveFile,'%s\n',num2str(data.misalLineToggle));
fprintf(saveFile,'%s\n',num2str(data.misalLineROIx1));
fprintf(saveFile,'%s\n',num2str(data.misalLineROIx2));
fprintf(saveFile,'%s\n',num2str(data.misalLineROIy1));
fprintf(saveFile,'%s\n',num2str(data.misalLineROIy2));
fprintf(saveFile,'%s\n',data.FolderPath);
fprintf(saveFile,'%s\n',num2str(data.num_stitched));
fprintf(saveFile,'%s\n',num2str(data.InSituToggle));
fprintf(saveFile,'%s\n',num2str(data.ROIToggle));
fprintf(saveFile,'%s\n',num2str(data.drift_correct_path));
fprintf(saveFile,'%s\n',num2str(data.back_data_path));
fprintf(saveFile,'%s\n',num2str(data.back_first_frame));
fprintf(saveFile,'%s\n',num2str(data.back_last_frame));

t = datetime('now');
disp(['Saved state at time: ' datestr(t)]);

fclose(saveFile);

save([saveName(1:end-4) '_ws']);

end