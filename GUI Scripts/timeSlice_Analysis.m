% slope_travel = (LINE_ANALYSIS_CENTERED(4) - LINE_ANALYSIS_CENTERED(2))/(LINE_ANALYSIS_CENTERED(3) - LINE_ANALYSIS_CENTERED(1));
% theta = atand(slope_travel);
% averaging_line = LINE_MISALIGN_ANALYSIS;
% 
% centerx = mean([LINE_ANALYSIS_CENTERED(1), LINE_ANALYSIS_CENTERED(3)]);
% centery = mean([LINE_ANALYSIS_CENTERED(2), LINE_ANALYSIS_CENTERED(4)]);
% 
% distArr = 1:1:size(spaceTimePlot,1);
% distanceScale = 0.0063;
% distanceScale = distanceScale*sqrt(1+abs(slope_travel)^2);
% trueDistArr = distanceScale*distArr;
% % says timePoints, but is actually frames
% timePoints_Interest = {[38,39], [43,44,45], [49,50], [54,55,56], [60,61,62], [65,66,67], [71,72,73], [76,77,78], [82,83,84], [88,89], [92,93,94]};
% numSlices = 0;
% Wavelengths = [1281.55575956995,1194.90829141437,1024.11633248567,889.065659123026,773.929213995751,705.772140287658,673.504551281793,621.930815165188,565.526571658581,530.576730848753,534.691518244014]; % nm
% Wavelengths = Wavelengths/6;
% Wavelengths_Px = Wavelengths/distanceScale; % px
% 
% smoothing_params = 0.999;%[0.9997694725185614, 0.9993736094565439, 2.526015066824279E-6, 1.1320714553086055E-5, 4.164687946192583E-6, 5.636312524593189E-7, 5.636312524593189E-7, 9.292704949829573E-7, 9.292704949829573E-7, 1.532107107700764E-6, 9.292704949829572E-7, 1.532107107700764E-6, 6.866391051638735E-6, 2.526015066824278E-6, 2.526015066824278E-6, 2.526015066824278E-6, 2.526015066824278E-6, 1.5321071077007624E-6, 4.16468794619258E-6, 4.16468794619258E-6, 1.5321071077007622E-6, 4.164687946192577E-6, 1.132071455308604E-5, 2.5260150668242756E-6, 4.164687946192576E-6, 4.164687946192576E-6, 4.164687946192576E-6, 6.866391051638744E-6, 4.164687946192576E-6, 0.9999485531525399];
% 
% length_STP = size(spaceTimePlot,1);
% 
% for i = 1:length(timePoints_Interest)
%     numSlices = numSlices + length(timePoints_Interest{i});
% end
% 
% timeSlices = cell(1,numSlices);
% xSlices = cell(1,numSlices);
% xSlices_detailed = cell(1,numSlices);
% mini_Slices = cell(1,numSlices);
% maxi_Slices = cell(1,numSlices);
% fits = cell(1,numSlices);
% rt_slices = round(sqrt(numSlices))+1;
% count = 0;
% figure;
% for i = 1:length(timePoints_Interest)
%     curWav = timePoints_Interest{i};
%     if length(curWav) == 2
%         halfCut = 1;
%     else
%         halfCut = 0;
%     end
%     
%     for j = 1:length(curWav)
%         count = count + 1;
%         timeSlices{count} = spaceTimePlot(:,curWav(j)); % round(length_STP/2-Wavelengths_Px(i)*0.6):round(length_STP/2 + Wavelengths_Px(i)*0.6)
%         curtimeSlice = timeSlices{count};
%         xrange = trueDistArr;%(round(length_STP/2-Wavelengths_Px(i)*0.6):round(length_STP/2 + Wavelengths_Px(i)*0.6));
%         xSlices{count} = xrange;
%         xSlices_detailed{count} = xrange(1):(xrange(end)-xrange(1))/(100*length(xrange)):xrange(end);
%         xrange_detailed = xSlices_detailed{count};
%         
% %         if halfCut == 1
% %             if j == 2
% %                 timeSlices{count} = spaceTimePlot(round(length_STP/2-Wavelengths_Px(i)/2):round(length_STP/2 + Wavelengths_Px(i)),curWav(j));
% %                 xrange = trueDistArr(round(length_STP/2-Wavelengths_Px(i)/2):round(length_STP/2 + Wavelengths_Px(i)));
% %             elseif j == 1
% %                 timeSlices{count} = spaceTimePlot(round(length_STP/2-Wavelengths_Px(i)):round(length_STP/2 + Wavelengths_Px(i)/2),curWav(j));
% %                 xrange = trueDistArr(round(length_STP/2-Wavelengths_Px(i)):round(length_STP/2 + Wavelengths_Px(i)/2));
% %             end
% %         elseif halfCut == 0
% %             if j == 3
% %                 timeSlices{count} = spaceTimePlot(round(length_STP/2-Wavelengths_Px(i)/2):round(length_STP/2 + Wavelengths_Px(i)),curWav(j));
% %                 xrange = trueDistArr(round(length_STP/2-Wavelengths_Px(i)/2):round(length_STP/2 + Wavelengths_Px(i)));
% %             elseif j == 2
% %                 timeSlices{count} = spaceTimePlot(round(length_STP/2-Wavelengths_Px(i)*3/4):round(length_STP/2 + Wavelengths_Px(i)*3/4),curWav(j));
% %                 xrange = trueDistArr(round(length_STP/2-Wavelengths_Px(i)*3/4):round(length_STP/2 + Wavelengths_Px(i)*3/4));
% %             elseif j == 1
% %                 timeSlices{count} = spaceTimePlot(round(length_STP/2-Wavelengths_Px(i)):round(length_STP/2 + Wavelengths_Px(i)/2),curWav(j));
% %                 xrange = trueDistArr(round(length_STP/2-Wavelengths_Px(i)):round(length_STP/2 + Wavelengths_Px(i)/2));
% %             end
% %         end
% 
%         f = fit(xrange',timeSlices{count},'smoothingspline','SmoothingParam',smoothing_params); %(count)
%         fits{count} = f;
%         
%         [mini_Slices{count} maxi_Slices{count}] = findExtrema(xSlices_detailed{count}, f(xSlices_detailed{count}));
%                 
%         subplot(rt_slices,rt_slices,count);
%         plot(f,xrange,timeSlices{count});
%         hold on;
%         plot(trueDistArr(round(length_STP/2))*[1 1], [-0.1 0.05]);
%         scatter(xrange_detailed(mini_Slices{count}), f(xrange_detailed(mini_Slices{count})), 'r');
%         scatter(xrange_detailed(maxi_Slices{count}), f(xrange_detailed(maxi_Slices{count})), 'b');
%         title(curWav(j));
%         legend('off');
%         ylim([-0.1 0.05]);
%         xlim([min(xrange) max(xrange)]);
%     end
% end

center_pos = [1.311691018417112, 1.240788801205377, 1.373730458477381, 1.285102686962712, 1.178749361145108, 1.329416572720046, 1.231926024053910, 1.391456012780315, 1.320553795568580, 1.196474915448042, 1.311691018417112, 1.267377132659778, 1.178749361145108, 1.373730458477381, 1.302828241265646, 1.231926024053910, 1.302828241265646, 1.240788801205377, 1.161023806842174, 1.356004904174448, 1.311691018417112, 1.240788801205377, 1.302828241265646, 1.240788801205377, 1.187612138296575, 1.302828241265646, 1.249651578356844, 1.382593235628848, 1.293965464114179, 1.240788801205377];
center_intens = [-0.048383833568115, -0.048826842939940, -0.032313304549712, -0.058219106256316, -0.062169171011368, -0.063290030886419, -0.071319720430244, -0.048979588488521, -0.069466795044540, -0.081917339460015, -0.061473259726973, -0.069835788925391, -0.070888066454235, -0.060729493384034, -0.073645262643455, -0.062680882065778, -0.057210999409103, -0.059094989247263, -0.051928339871058, -0.055768622304958, -0.063385210944706, -0.060646333248553, -0.055555610940463, -0.059208919651861, -0.045566271217908, -0.054789074342061, -0.051640839179501, -0.046696890037176, -0.049504407198944, -0.040805483334614];
right_pos = [1.745967098838994, 1.719378767384593, 1.799143761747796, 1.719378767384593, 1.666202104475792, 1.763692653141928, 1.657339327324325, 1.745967098838994, 1.692790435930193, 1.586437110112589, 1.683927658778726, 1.630750995869924, 1.550986001506721, 1.710515990233126, 1.630750995869924, 1.550986001506721, 1.639613773021391, 1.550986001506721, 1.480083784294985, 1.666202104475792, 1.621888218718457, 1.524397670052320, 1.630750995869924, 1.542123224355254, 1.462358229992051, 1.568711555809655, 1.488946561446452, 1.666202104475792, 1.613025441566990, 1.533260447203787];
left_pos = [0.788787166480561, 0.682433840662957, 1.098984366781905, 0.797649943632028, 0.753336057874693, 1.072396035327504, 0.824238275086429, 1.134435475387773, 1.045807703873103, 0.841963829389363, 1.107847143933372, 1.028082149570169, 0.895140492298165, 1.187612138296575, 1.090121589630438, 1.001493818115768, 1.134435475387773, 1.054670481024570, 0.957179932358433, 1.178749361145108, 1.125572698236306, 1.045807703873103, 1.161023806842174, 1.081258812478971, 1.019219372418702, 1.143298252539240, 1.081258812478971, 1.240788801205377, 1.161023806842174, 1.116709921084839];
wavelengths = right_pos - left_pos;

true_center_time = zeros(1,length(timePoints_Interest));
true_intens = zeros(1,length(timePoints_Interest));
true_wav = zeros(1,length(timePoints_Interest));
true_vel = zeros(1,length(timePoints_Interest));

target_center = trueDistArr(round(length_STP/2));

h1 = figure;
h2 = figure;
h3 = figure;

rt_groups = round(sqrt(length(timePoints_Interest))) + 1;
count = 1;
for i = 1:length(timePoints_Interest)

    curWav = timePoints_Interest{i};
    
    figure(h1);
    subplot(rt_groups,rt_groups,i);
    scatter(curWav, center_pos(count:count + length(curWav) - 1));
    
    curPosSet = center_pos(count:count + length(curWav) - 1);
    curIntensSet = center_intens(count:count + length(curWav) - 1);
    curLengthSet = wavelengths(count:count + length(curWav) - 1);
    timeSet = (0:5:5*(curWav(end) - curWav(1)))';
    
    x = [timeSet, ones(size(timeSet))];    
    y = curPosSet';
    
    coeff = x \ y;
    
    true_vel(i) = abs(coeff(1));
    
    true_center_time(i) = (target_center - coeff(2))/coeff(1);
    
    if length(curPosSet == 2)
        x = [0 1; 5 1];
        y = [curIntensSet(1); curIntensSet(2)];
        
        coeff = x \ y;
        
        true_intense(i) = coeff(1)*true_center_time(i) + coeff(2);
        
        x = [0 1; 5 1];
        y = [curLengthSet(1); curLengthSet(2)];
        
        coeff = x \ y;
        
        true_wav(i) = coeff(1)*true_center_time(i) + coeff(2);
    elseif length(curPosSet == 3)
        if true_center_time < 0
            x = [0 1; 5 1];
            y = [curIntensSet(1); curIntensSet(2)];
        elseif true_center_time > 10
            x = [5 1; 10 1];
            y = [curIntensSet(1); curIntensSet(2)];
        elseif true_center_time <= 5 && true_center_time >= 0
            x = [0 1; 5 1];
            y = [curIntensSet(1); curIntensSet(2)];
        elseif true_center_time <= 10 && true_center_time >= 5
            x = [5 1; 10 1];
            y = [curIntensSet(1); curIntensSet(2)];
        end
        
        coeff = x \ y;
        
        true_intense(i) = coeff(1)*true_center_time(i) + coeff(2);
        
        if true_center_time < 0
            x = [0 1; 5 1];
            y = [curLengthSet(1); curLengthSet(2)];
        elseif true_center_time > 10
            x = [5 1; 10 1];
            y = [curLengthSet(1); curLengthSet(2)];
        elseif true_center_time <= 5 && true_center_time >= 0
            x = [0 1; 5 1];
            y = [curLengthSet(1); curLengthSet(2)];
        elseif true_center_time <= 10 && true_center_time >= 5
            x = [5 1; 10 1];
            y = [curLengthSet(1); curLengthSet(2)];
        end
        
        coeff = x \ y;
        
        true_wav(i) = coeff(1)*true_center_time(i) + coeff(2);
    end

    figure(h2);
    subplot(rt_groups,rt_groups,i);
    scatter(curWav, center_intens(count:count + length(curWav) - 1));
    
    figure(h3);
    subplot(rt_groups,rt_groups,i);
    scatter(curWav, wavelengths(count:count + length(curWav) - 1));
    
    count = count + length(curWav);
    
    true_center_time(i) = true_center_time(i) + (curWav(1)*5-30);
    
end

true_wav = true_wav * 1000;
timeArr = [-30;-25;-20;-15;-10;-5;0;5;10;15;20;25;30;35;40;45;50;55;60;65;70;75;80;85;90;95;100;105;110;115;120;125;130;135;140;145;150;155;160;165;170;175;180;185;190;195;200;205;210;215;220;225;230;235;240;245;250;255;260;265;270;275;280;285;290;295;300;305;310;315;320;325;330;335;340;345;350;355;360;365;370;375;380;385;390;395;400;405;410;415;420;425;430;435;440;445;450;455;460;465;470;475;480;485;490;495;500;510;520;530;540;550;560;570;580;590;600;610;620;630;640;650;660;670;680;690;700;710;720;730;740;750;760;770;780;790;800;810;820;830;840;850;860;870;880;890;900;910;920;930;940;950;960;970;980;990];
timeSum = [0,-0.000745206319379377,-0.00751027261865668,0.00748584999082544,-0.00171739415717783,-0.0100600224846910,-0.0101037314049326,-0.00446278501143858,-0.00447381062592749,-0.0118060668735846,-0.00141422153662632,-0.00643896933316183,0.00485328124592398,0.000472739284445144,-0.0100430779238638,-0.0176232800393266,-0.00535050577509573,-0.00845500700529910,-0.00382592386951645,-0.00833277646821173,-0.00396392290032384,0.000992000521749078,-0.00966091843360708,-0.0109088197257882,-0.0108189202500309,-0.0100351332459010,-0.0237380130280530,-0.0125005943439393,-0.0166451021847180,-0.00634692139491141,-0.0137096751063624,-0.0228678773076955,-0.0301022332942438,-0.0147507937250685,-0.00909038188800678,-0.0182365855989905,-0.0232373668556661,-0.0454905400944449,-0.0425664937679920,-0.0309755692390936,-0.0242741102374323,-0.0106524020597251,-0.0267620045596327,-0.0607345435284725,-0.0542376564365156,-0.0407706395620353,-0.0157537661305906,-0.0307207920458389,-0.0537965966608532,-0.0684409983762914,-0.0552275783082919,-0.0321608610308259,-0.0233580125545499,-0.0403515952409374,-0.0666173792117683,-0.0741019101596428,-0.0518563116017592,-0.0198889680107560,-0.0380759531148427,-0.0597156465650100,-0.0637611864885626,-0.0616553560051376,-0.0559559553111533,-0.0213235287290695,-0.0540780632711436,-0.0735507445368023,-0.0574347218154718,-0.0511108096490363,-0.0288856477459174,-0.0493554712429817,-0.0595331333658967,-0.0547481949461974,-0.0498685032358166,-0.0431971552509040,-0.0279957498918969,-0.0509208073913311,-0.0651847276645086,-0.0537744313512517,-0.0463945146160021,-0.0231794792212663,-0.0303775148125811,-0.0535089153318695,-0.0579913924840926,-0.0438864984973598,-0.0302949479950059,-0.0101612388539908,-0.0359433581073096,-0.0495425117171959,-0.0553277307200021,-0.0421459032550505,-0.0130150145274300,-0.0289446641581095,-0.0523734152795946,-0.0460264440533364,-0.0308794286755926,-0.0160966749484935,-0.00691390319428477,-0.0154879633381551,-0.0121619013658695,-0.0158239107618563,0.00218272033749421,-0.00211437680973648,-0.0109093096666736,-0.0115093950846292,-0.00246191337534797,0.00756909173722104,-0.00872680345935880,0.00215010565541328,-0.00872363502171024,-0.0190821062135901,-0.0299801283123461,-0.0218836381144227,-0.0122076771970897,-0.0414787232385697,-0.0136997506691918,-0.0300028064236038,-0.0335869262537023,-0.0274895089338196,-0.0460631539029182,-0.0223778148902338,-0.0170674038343662,-0.0395768676586006,-0.00422919879133255,-0.0345184097324671,-0.00731412863871396,-0.000608019269058798,-0.00485865964160761,-0.00278578232981640,0.0299568172245526,-0.000891294969405966,0.0123234160139414,0.00577857956049603,0.0257682014646657,0.0321319758282542,0.0137216287462463,0.0237701108147779,0.00662622916413316,0.0146054651646959,0.0135157597824798,-0.00388396235136483,-0.0103855029595351,0.0238784793026718,-0.00399323114641316,0.0227421455886596,0.00947899679815080,-0.00713607810006377,0.0338813429839755,0.00195737033818073,0.0122881460570912,0.0133934299160711,0.00643113131199060,0.0391140356276375,-0.00490884972921002,0.00753288614374980,0.0202507187001450,0.0273654730867131];

overall_timeSum_Spline = 3.81219675015946E-5;
timeSum_fit = fit(timeArr,timeSum','smoothingspline','SmoothingParam',overall_timeSum_Spline);

intensity_points = timeSum_fit(true_center_time);
timeSumSpline = timeSum_fit(timeArr);

trough_intensity_variance = true_intense - intensity_points';