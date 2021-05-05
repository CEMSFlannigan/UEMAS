% Loc_01 = cell(1,10);
% Loc_01{1} = [0;3.5255404;3.5221457;3.0429947;3.0427065;3.0609820;3.0611582;4.9877987;4.9895248];
% Loc_01{2} = [0;3.5255783;3.5220869;3.0429580;3.0427241;3.0610578;3.0610712;4.9877019;4.9894896];
% Loc_01{3} = [0;3.5254834;3.5221925;3.0430002;3.0426836;3.0609081;3.0615335;4.9878502;4.9894490];
% Loc_01{4} = [0;3.5251322;3.4022660;3.0431361;3.0425544;3.0608373;3.0616288;4.9880323;4.9891138];
% Loc_01{5} = [0;3.5255265;3.5221350;3.0429645;3.0427444;3.0614009;3.0617244;4.9877853;4.9897366];
% Loc_01{6} = [0;3.5255678;3.5221128;3.0433497;3.0423486;3.0606625;3.0617425;4.9881973;4.9889278];
% Loc_01{7} = [0;3.5257647;3.5219121;3.0424297;3.0429311;3.0614626;3.0606675;4.9873519;4.9897957];
% Loc_01{8} = [0;3.5255721;3.5221100;3.0428014;3.0428836;3.0616262;3.0614378;4.9875402;4.9897823];
% Loc_01{9} = [0;3.5255034;3.5221453;3.0429733;3.0427170;3.0609648;3.0611706;4.9877877;4.9895053];
% Loc_01{10} = [0;3.5256045;3.5220673;3.0428298;3.0428686;3.0612168;3.0613441;4.9875598;4.9897461];
% 
% Space_01 = cell(1,10);
% Strain_01 = cell(1,10);
% for i = 1:10
%     Space_01{i} = 1./Loc_01{i};
%     Strain_01{i} = zeros(1,8);
%     CurSpace = Space_01{i};
%     for j = 1:8
%         spacing = 0;
%         if j <= 2
%             spacing = 1/3.54;
%         elseif j > 2 && j <= 6
%             spacing = 1/3.06;
%         elseif j > 6
%             spacing = 1/5.00;
%         end
%         CurSpace(j) = (CurSpace(j+1) - spacing)/spacing;
%     end
%     Strain_01{i} = CurSpace;
% end

MF2Loc_01 = cell(1,10);
MF2Loc_01{1} = 
MF2Loc_01{2} = 
MF2Loc_01{3} = 
MF2Loc_01{4} = 
MF2Loc_01{5} = 
MF2Loc_01{6} = 
MF2Loc_01{7} = 
MF2Loc_01{8} = 
MF2Loc_01{9} = 
MF2Loc_01{10} = 

MF2Space_01 = cell(1,10);
MF2Strain_01 = cell(1,10);
for i = 1:10
    MF2Space_01{i} = 1./MF2Loc_01{i};
    MF2Strain_01{i} = zeros(1,8);
    MF2CurSpace = MF2Space_01{i};
    for j = 1:8
        spacing = 0;
        if j <= 2
            spacing = 1/3.54;
        elseif j > 2 && j <= 6
            spacing = 1/3.06;
        elseif j > 6
            spacing = 1/5.00;
        end
        MF2CurSpace(j) = (MF2CurSpace(j+1) - spacing)/spacing;
    end
    MF2Strain_01{i} = MF2CurSpace;
end

% spots = cell(1,8);
MF2spots = cell(1,8);
for i = 1:10
%     CurTrial = Strain_01{i};
    MF2CurTrial = MF2Strain_01{i};
    for j = 1:8
%         spots{j} = [spots{j} CurTrial(j)]; 
        MF2spots{j} = [MF2spots{j} MF2CurTrial(j)];
    end
end

% vari = zeros(1,8);
% avg = zeros(1,8);
MF2vari = zeros(1,8);
MF2avg = zeros(1,8);
MF2std = zeros(1,8);
MF2errprct = zeros(1,8);

for i = 1:8
%     curspot = spots{i};
    curMF2spot = MF2spots{i};
    
    MF2avg(i) = mean(curMF2spot);
    MF2vari(i) = var(curMF2spot);
    MF2std(i) = sqrt(MF2vari(i));
    
    for j = 1:length(curMF2spot)
        if abs(curMF2spot(j)-MF2avg(i)) >= abs(MF2std(i))
            curMF2spot = [curMF2spot(1:j-1) curMF2spot(j + 1:end)];
        end
        
        if j >= length(curMF2spot)
            break;
        end
    end
    
%     avg(i) = mean(curspot);
%     vari(i) = var(curspot);
%     std(i) = sqrt(vari(i));
%     
%     for j = 1:length(curspot)
%         if abs(curspot(j)-avg(i)) >= abs(2*std(i))
%             curspot = [curspot(1:j-1) curspot(j + 1:end)];
%         end
%         
%         if j == length(curspot)
%             break;
%         end
%     end
%     
%     avg(i) = mean(curspot);
%     vari(i) = var(curspot);
%     std(i) = sqrt(vari(i));
%     errprct(i) = std(i)/avg(i);
    
    MF2avg(i) = mean(curMF2spot);
    MF2vari(i) = var(curMF2spot);
    MF2std(i) = sqrt(MF2vari(i));
    MF2errprct(i) = MF2std(i)/MF2avg(i);
end