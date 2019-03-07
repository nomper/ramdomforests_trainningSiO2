clear
tic
xs_off = 3;
ys_off = 1;
xe_off = 2;
ye_off = 1;
print_flag = true;
X = 26;
Y = 26;
samplename = "S1_2";

% FilenameRT = replace("C:/Users/kenya/Desktop/ramdomforests_trainningSiO2/S2_4/20190202_RT/001S2_4PLWSe2SiO2300KCW633nm30uW20s_%.0f_1.txt","/","//");
% FilenameLT = replace("C:/Users/kenya/Desktop/ramdomforests_trainningSiO2/S2_4/20190129_LT/001S2_4PLWSe2SiO215KCW633nm30uW20s_%.0f_1.txt","/","//");
ParentFolder = cd(strcat("../",samplename,"/"));
if(exist(strcat(samplename,".mat"),"file")>0)
    load(strcat(samplename,".mat"));
    %     "load"
else
    %     "each load"
    
    FilenameRT = replace("RT/001S1_2PLWSe2SiO2300KCW633nm30uW20s_%.0f_1.txt","/","//");
    FilenameLT = replace("LT/004PLWSe2SiO215KCW633nm30uW20s_%.0f_1.txt","/","//");
    pickupLT = 543:578;
    pickupRT = 570:740;
    Inteinsity_sigm_rt = zeros(length(pickupRT),X*Y);
    Inteinsity_sigp_rt = zeros(length(pickupRT),X*Y);
    Inteinsity_sigm_lt = zeros(length(pickupLT),X*Y);
    Inteinsity_sigp_lt = zeros(length(pickupLT),X*Y);
    
    a = load("cal.txt");
    cal_rt_m = a(pickupRT,3);
    cal_rt_p = a(pickupRT+1340,3);
    cal_rt=cal_rt_p./cal_rt_m;
    cal_lt_m = a(pickupLT,3);
    cal_lt_p = a(pickupLT+1340,3);
    cal_lt=cal_lt_p./cal_lt_m;
    
    parfor f = 1:X*Y
        a = load(sprintf(FilenameRT,f));
        Inteinsity_sigm_rt(:,f) = a(pickupRT,3).*cal_rt;
        Inteinsity_sigp_rt(:,f) = a(pickupRT+1340,3);
        
        a = load(sprintf(FilenameLT,f));
        Inteinsity_sigm_lt(:,f) = a(pickupLT,3).*cal_lt;
        Inteinsity_sigp_lt(:,f) = a(pickupLT+1340,3);
    end
    toc
    a = load(sprintf(FilenameLT,randi(X*Y)));
    xRT = 1240./a(pickupRT,1);
    xLT = 1240./a(pickupLT,1);
    
    %     save(strcat(samplename,".mat"),'x','Inteinsity_sigm_rt','Inteinsity_sigp_rt','Inteinsity_sigm_lt','Inteinsity_sigp_lt','xs_off','ys_off','xe_off','ye_off');
    save(strcat(samplename,".mat"),'xRT','xLT','Inteinsity_sigm_rt','Inteinsity_sigp_rt','Inteinsity_sigm_lt','Inteinsity_sigp_lt');
end
toc
%小さいところを0に
% Inteinsity_sigm_rt(:,mean(Inteinsity_sigm_rt,1)<1) = 0;
% Inteinsity_sigp_rt(:,mean(Inteinsity_sigp_rt,1)<1) = 0;
% Inteinsity_sigm_lt(:,mean(Inteinsity_sigm_lt,1)<1) = 0;
% Inteinsity_sigp_lt(:,mean(Inteinsity_sigp_lt,1)<1) = 0;
Inteinsity_sigm_rt(Inteinsity_sigm_rt<0) = 0;
Inteinsity_sigp_rt(Inteinsity_sigp_rt<0) = 0;
Inteinsity_sigm_lt(Inteinsity_sigm_lt<0) = 0;
Inteinsity_sigp_lt(Inteinsity_sigp_lt<0) = 0;

% figure,plot(xRT,Inteinsity_sigp_rt)
% figure,plot(xRT,Inteinsity_sigm_rt)
% figure,plot(xLT,Inteinsity_sigp_lt)
% figure,plot(xLT,Inteinsity_sigm_lt)
%cosmic ray cut
Inteinsity_sigm_rt(Inteinsity_sigm_rt>300) = 0;
Inteinsity_sigp_rt(Inteinsity_sigp_rt>300) = 0;
% Inteinsity_sigm_lt(Inteinsity_sigm_lt>500) = 0;
% Inteinsity_sigp_lt(Inteinsity_sigp_lt>500) = 0;

%mapping of intensity
value_sigm_rt = sum(Inteinsity_sigm_rt,1);
value_sigp_rt = sum(Inteinsity_sigp_rt,1);
value_sigm_lt = sum(Inteinsity_sigm_lt,1);
value_sigp_lt = sum(Inteinsity_sigp_lt,1);

mapping_m_rt = reshape(value_sigm_rt,X,Y);
mapping_p_rt = reshape(value_sigp_rt,X,Y);
mapping_m_lt = reshape(value_sigm_lt,X,Y);
mapping_p_lt = reshape(value_sigp_lt,X,Y);

mapping_m_rt = mapping_m_rt(1+xs_off:X-xe_off,1+ys_off:Y-ye_off);
mapping_p_rt = mapping_p_rt(1+xs_off:X-xe_off,1+ys_off:Y-ye_off);
mapping_m_lt = mapping_m_lt(1+xe_off:X-xs_off,1+ye_off:Y-ys_off);
mapping_p_lt = mapping_p_lt(1+xe_off:X-xs_off,1+ye_off:Y-ys_off);

%mapping of max and maxEnergy
[value_sigm_rt_max, value_sigm_rt_max_Energy] = max(Inteinsity_sigm_rt,[],1);
[value_sigp_rt_max, value_sigp_rt_max_Energy] = max(Inteinsity_sigp_rt,[],1);
[value_sigm_lt_max, value_sigm_lt_max_Energy] = max(Inteinsity_sigm_lt,[],1);
[value_sigp_lt_max, value_sigp_lt_max_Energy] = max(Inteinsity_sigp_lt,[],1);

mapping_m_rt_max = reshape(value_sigm_rt_max,X,Y);
mapping_p_rt_max = reshape(value_sigp_rt_max,X,Y);
mapping_m_lt_max = reshape(value_sigm_lt_max,X,Y);
mapping_p_lt_max = reshape(value_sigp_lt_max,X,Y);

mapping_m_rt_max_Energy = reshape(xRT(value_sigm_rt_max_Energy),X,Y);
mapping_p_rt_max_Energy = reshape(xRT(value_sigp_rt_max_Energy),X,Y);
mapping_m_lt_max_Energy = reshape(xRT(value_sigm_lt_max_Energy),X,Y);
mapping_p_lt_max_Energy = reshape(xRT(value_sigp_lt_max_Energy),X,Y);

mapping_m_rt_max = mapping_m_rt_max(1+xs_off:X-xe_off,1+ys_off:Y-ye_off);
mapping_p_rt_max = mapping_p_rt_max(1+xs_off:X-xe_off,1+ys_off:Y-ye_off);
mapping_m_lt_max = mapping_m_lt_max(1+xe_off:X-xs_off,1+ye_off:Y-ys_off);
mapping_p_lt_max = mapping_p_lt_max(1+xe_off:X-xs_off,1+ye_off:Y-ys_off);

mapping_m_rt_max_Energy(or(mapping_m_rt_max_Energy<1.62,1.69<mapping_m_rt_max_Energy)) = 0;
mapping_p_rt_max_Energy(or(mapping_p_rt_max_Energy<1.62,1.69<mapping_p_rt_max_Energy)) = 0;
mapping_m_lt_max_Energy(or(mapping_m_lt_max_Energy<1.62,1.69<mapping_m_lt_max_Energy)) = 0;
mapping_p_lt_max_Energy(or(mapping_p_lt_max_Energy<1.62,1.69<mapping_p_lt_max_Energy)) = 0;

mapping_m_rt_max_Energy = mapping_m_rt_max_Energy(1+xs_off:X-xe_off,1+ys_off:Y-ye_off);
mapping_p_rt_max_Energy = mapping_p_rt_max_Energy(1+xs_off:X-xe_off,1+ys_off:Y-ye_off);
mapping_m_lt_max_Energy = mapping_m_lt_max_Energy(1+xe_off:X-xs_off,1+ye_off:Y-ys_off);
mapping_p_lt_max_Energy = mapping_p_lt_max_Energy(1+xe_off:X-xs_off,1+ye_off:Y-ys_off);


%マップ後、最大値の2割以下のエリアを0に
mapping_m_rt(mapping_m_rt<0.2*max(mapping_m_rt(:))) = 0;
mapping_p_rt(mapping_p_rt<0.2*max(mapping_p_rt(:))) = 0;
mapping_m_lt(mapping_m_lt<0.12*max(mapping_m_lt(:))) = 0;
mapping_p_lt(mapping_p_lt<0.12*max(mapping_p_lt(:))) = 0;

%他がゼロなら、アレする
locate_of_zero_rt = ~((mapping_m_rt)&(mapping_p_rt)&(mapping_m_rt_max)&(mapping_p_rt_max)&(mapping_m_rt_max_Energy)&(mapping_p_rt_max_Energy));
locate_of_zero_lt = ~((mapping_m_lt)&(mapping_p_lt)&(mapping_m_lt_max)&(mapping_p_lt_max)&(mapping_m_lt_max_Energy)&(mapping_p_lt_max_Energy));

mapping_m_rt(locate_of_zero_rt) = 0;
mapping_p_rt(locate_of_zero_rt) = 0;
mapping_m_lt(locate_of_zero_lt) = 0;
mapping_p_lt(locate_of_zero_lt) = 0;
mapping_m_rt_max(locate_of_zero_rt) = 0;
mapping_p_rt_max(locate_of_zero_rt) = 0;
mapping_m_lt_max(locate_of_zero_lt) = 0;
mapping_p_lt_max(locate_of_zero_lt) = 0;
mapping_m_rt_max_Energy(locate_of_zero_rt) = 0;
mapping_p_rt_max_Energy(locate_of_zero_rt) = 0;
mapping_m_lt_max_Energy(locate_of_zero_lt) = 0;
mapping_p_lt_max_Energy(locate_of_zero_lt) = 0;

mapping_m_rt_normalized = mapping_m_rt./max(mapping_m_rt(:));
mapping_p_rt_normalized = mapping_p_rt./max(mapping_p_rt(:));
mapping_m_lt_normalized = mapping_m_lt./max(mapping_m_lt(:));
mapping_p_lt_normalized = mapping_p_lt./max(mapping_p_lt(:));

%% Make Maps.
figure(1),imagesc(mapping_m_rt);colorbar;title("\sigma- @RT");print_en(print_flag,"-f1","mapping_m_rt.png","-dpng","-r250");
figure(2),imagesc(mapping_p_rt);colorbar;title("\sigma+ @RT");print_en(print_flag,"-f2","mapping_p_rt.png","-dpng","-r250");
f=figure(3);imagesc(mapping_m_lt);colorbar;title("\sigma- @LT");f.CurrentAxes.CLim = [0 52000];print_en(print_flag,"-f3","mapping_m_lt.png","-dpng","-r250");
f=figure(4);imagesc(mapping_p_lt);colorbar;title("\sigma+ @LT");f.CurrentAxes.CLim = [0 52000];print_en(print_flag,"-f4","mapping_p_lt.png","-dpng","-r250");

figure(5),imagesc(mapping_m_rt_normalized-mapping_m_lt_normalized);colorbar;title(strcat("\sigma- LT-RT : ",num2str(sum(abs(mapping_m_rt_normalized(:)-mapping_m_lt_normalized(:)))))); colormap(abs((-1:0.1:1)'*[1 1 1]));print_en(print_flag,"-f5","mapping_m_df.png","-dpng","-r250");
figure(6),imagesc(mapping_p_rt_normalized-mapping_p_lt_normalized);colorbar;title(strcat("\sigma+ LT-RT : ",num2str(sum(abs(mapping_p_rt_normalized(:)-mapping_p_lt_normalized(:)))))); colormap(abs((-1:0.1:1)'*[1 1 1]));print_en(print_flag,"-f6","mapping_m_df.png","-dpng","-r250");
mapping_v_rt = (mapping_p_rt-mapping_m_rt)./(mapping_m_rt+mapping_p_rt);
mapping_v_lt = (mapping_p_lt-mapping_m_lt)./(mapping_m_lt+mapping_p_lt);
% return;
% mapping_v_rt(or(or(-0.95>mapping_v_rt,mapping_v_rt>0.95),or((mapping_m_rt<max(mapping_m_rt(:))/3),(mapping_p_rt<max(mapping_p_rt(:))/3)))) = 0;
% mapping_v_lt(or(or(-0.95>mapping_v_lt,mapping_v_lt>0.95),or((mapping_m_lt<max(mapping_m_lt(:))/3),(mapping_p_lt<max(mapping_p_lt(:))/3)))) = 0;% %% Exciton
% value_sigm_lt_ex = sum(Inteinsity_sigm_lt(and(1.72<x,x<1.74),:));
% value_sigp_lt_ex = sum(Inteinsity_sigp_lt(and(1.72<x,x<1.74),:));
% mapping_m_lt_ex = reshape(value_sigm_lt_ex,X,Y);
% mapping_p_lt_ex = reshape(value_sigp_lt_ex,X,Y);
%
% mapping_v_rt_ex = (mapping_p_rt_ex-mapping_m_rt_ex)./(mapping_m_rt_ex+mapping_p_rt_ex);
% mapping_v_lt_ex = (mapping_p_lt_ex-mapping_m_lt_ex)./(mapping_m_lt_ex+mapping_p_lt_ex);
%
% mapping_v_rt_ex(or(or(-0.95>mapping_v_rt_ex,mapping_v_rt_ex>0.95),or((mapping_m_rt_ex<max(mapping_m_rt_ex(:))/3),(mapping_p_rt_ex<max(mapping_p_rt_ex(:))/3)))) = 0;
% mapping_v_lt_ex(or(or(-0.95>mapping_v_lt_ex,mapping_v_lt_ex>0.95),or((mapping_m_lt_ex<max(mapping_m_lt_ex(:))/3),(mapping_p_lt_ex<max(mapping_p_lt_ex(:))/3)))) = 0;
% figure(09),imagesc(mapping_v_rt_ex);colorbar;title("Valley Polarization of Exction @RT");print_en(print_flag,"-f9","mapping_v_rt_ex.png","-dpng","-r250");
% figure(10),imagesc(mapping_v_lt_ex);colorbar;title("Valley Polarization of Exction @LT");print_en(print_flag,"-f10","mapping_v_lt_ex.png","-dpng","-r250");

toc

%mapping smoothing intensity

frame = zeros(X,Y);
frame(1+xs_off:X-xe_off,1+ys_off:Y-ye_off) = 1;
%locate_of_zero_rt;
frame_l(1,:) = frame(:);

value_sigm_rt_s = smoothdata(Inteinsity_sigm_rt,1,'gaussian',3).*frame_l;
value_sigp_rt_s = smoothdata(Inteinsity_sigp_rt,1,'gaussian',3).*frame_l;
value_sigm_lt_s = smoothdata(Inteinsity_sigm_lt,1,'gaussian',3).*frame_l;
value_sigp_lt_s = smoothdata(Inteinsity_sigp_lt,1,'gaussian',3).*frame_l;

%mapping of max and maxEnergy
[value_sigm_rt_smoothed_max, value_sigm_rt_smoothed_max_Energy] = max(Inteinsity_sigm_rt,[],1);
[value_sigp_rt_smoothed_max, value_sigp_rt_smoothed_max_Energy] = max(Inteinsity_sigp_rt,[],1);
[value_sigm_lt_smoothed_max, value_sigm_lt_smoothed_max_Energy] = max(Inteinsity_sigm_lt,[],1);
[value_sigp_lt_smoothed_max, value_sigp_lt_smoothed_max_Energy] = max(Inteinsity_sigp_lt,[],1);

mapping_m_rt_smoothed_max = reshape(value_sigm_rt_smoothed_max,X,Y);
mapping_p_rt_smoothed_max = reshape(value_sigp_rt_smoothed_max,X,Y);
mapping_m_lt_smoothed_max = reshape(value_sigm_lt_smoothed_max,X,Y);
mapping_p_lt_smoothed_max = reshape(value_sigp_lt_smoothed_max,X,Y);

mapping_m_rt_smoothed_max_Energy = reshape(xRT(value_sigm_rt_smoothed_max_Energy),X,Y);
mapping_p_rt_smoothed_max_Energy = reshape(xRT(value_sigp_rt_smoothed_max_Energy),X,Y);
mapping_m_lt_smoothed_max_Energy = reshape(xRT(value_sigm_lt_smoothed_max_Energy),X,Y);
mapping_p_lt_smoothed_max_Energy = reshape(xRT(value_sigp_lt_smoothed_max_Energy),X,Y);

mapping_m_rt_smoothed_max = mapping_m_rt_smoothed_max(1+xs_off:X-xe_off,1+ys_off:Y-ye_off);
mapping_p_rt_smoothed_max = mapping_p_rt_smoothed_max(1+xs_off:X-xe_off,1+ys_off:Y-ye_off);
mapping_m_lt_smoothed_max = mapping_m_lt_smoothed_max(1+xe_off:X-xs_off,1+ye_off:Y-ys_off);
mapping_p_lt_smoothed_max = mapping_p_lt_smoothed_max(1+xe_off:X-xs_off,1+ye_off:Y-ys_off);

mapping_m_rt_smoothed_max_Energy(or(mapping_m_rt_smoothed_max_Energy<1.62,1.69<mapping_m_rt_smoothed_max_Energy)) = 0;
mapping_p_rt_smoothed_max_Energy(or(mapping_p_rt_smoothed_max_Energy<1.62,1.69<mapping_p_rt_smoothed_max_Energy)) = 0;
mapping_m_lt_smoothed_max_Energy(or(mapping_m_lt_smoothed_max_Energy<1.62,1.69<mapping_m_lt_smoothed_max_Energy)) = 0;
mapping_p_lt_smoothed_max_Energy(or(mapping_p_lt_smoothed_max_Energy<1.62,1.69<mapping_p_lt_smoothed_max_Energy)) = 0;

mapping_m_rt_smoothed_max_Energy = mapping_m_rt_smoothed_max_Energy(1+xs_off:X-xe_off,1+ys_off:Y-ye_off); %後で使う
mapping_p_rt_smoothed_max_Energy = mapping_p_rt_smoothed_max_Energy(1+xs_off:X-xe_off,1+ys_off:Y-ye_off); %後で使う
mapping_m_lt_smoothed_max_Energy = mapping_m_lt_smoothed_max_Energy(1+xe_off:X-xs_off,1+ye_off:Y-ys_off);
mapping_p_lt_smoothed_max_Energy = mapping_p_lt_smoothed_max_Energy(1+xe_off:X-xs_off,1+ye_off:Y-ys_off);

%normalized
%trion intensity

value_sigm_rt_smoothed_normalized = value_sigm_rt_s./max(value_sigm_rt_s,[],1);
value_sigp_rt_smoothed_normalized = value_sigp_rt_s./max(value_sigp_rt_s,[],1);

value_sigm_rt_smoothed_normalized(isnan(value_sigm_rt_smoothed_normalized)) = 0;
value_sigp_rt_smoothed_normalized(isnan(value_sigp_rt_smoothed_normalized)) = 0;

value_sigm_rt_smoothed_normalized_trion = value_sigm_rt_smoothed_normalized(abs(xRT-value_sigm_rt_smoothed_max_Energy+0.04) == min(abs(xRT-value_sigm_rt_smoothed_max_Energy+0.04)));
value_sigp_rt_smoothed_normalized_trion = value_sigp_rt_smoothed_normalized(abs(xRT-value_sigp_rt_smoothed_max_Energy+0.04) == min(abs(xRT-value_sigp_rt_smoothed_max_Energy+0.04)));


mapping_m_rt_smoothed_normalized_trion = reshape(value_sigm_rt_smoothed_normalized_trion,X,Y);
mapping_p_rt_smoothed_normalized_trion = reshape(value_sigp_rt_smoothed_normalized_trion,X,Y);

mapping_m_rt_smoothed_normalized_trion = mapping_m_rt_smoothed_normalized_trion(1+xs_off:X-xe_off,1+ys_off:Y-ye_off);
mapping_p_rt_smoothed_normalized_trion = mapping_p_rt_smoothed_normalized_trion(1+xs_off:X-xe_off,1+ys_off:Y-ye_off);

%normalized
%halfwidth
value_sigm_rt_smoothed_normalized_Low  = value_sigm_rt_smoothed_normalized;
value_sigm_rt_smoothed_normalized_High = value_sigm_rt_smoothed_normalized;
value_sigp_rt_smoothed_normalized_Low  = value_sigp_rt_smoothed_normalized;
value_sigp_rt_smoothed_normalized_High = value_sigp_rt_smoothed_normalized;

temp(:,1)=1:length(xRT);
value_sigm_rt_smoothed_normalized_Low(value_sigm_rt_smoothed_normalized_Low>0.5) = 0;
value_sigm_rt_smoothed_normalized_High(value_sigm_rt_smoothed_normalized_High>0.5) = 0;
value_sigp_rt_smoothed_normalized_Low(value_sigp_rt_smoothed_normalized_Low>0.5) = 0;
value_sigp_rt_smoothed_normalized_High(value_sigp_rt_smoothed_normalized_High>0.5) = 0;

value_sigm_rt_smoothed_normalized_Low(temp<value_sigm_rt_smoothed_max_Energy) = 0;
value_sigm_rt_smoothed_normalized_High(temp>value_sigm_rt_smoothed_max_Energy) = 0;
value_sigp_rt_smoothed_normalized_Low(temp<value_sigm_rt_smoothed_max_Energy) = 0;
value_sigp_rt_smoothed_normalized_High(temp>value_sigm_rt_smoothed_max_Energy) = 0;

[~,value_sigm_rt_smoothed_normalized_Low_max_Energypos] = max(value_sigm_rt_smoothed_normalized_Low);
[~,value_sigm_rt_smoothed_normalized_High_max_Energypos] = max(value_sigm_rt_smoothed_normalized_High);
[~,value_sigp_rt_smoothed_normalized_Low_max_Energypos] = max(value_sigp_rt_smoothed_normalized_Low);
[~,value_sigp_rt_smoothed_normalized_High_max_Energypos] = max(value_sigp_rt_smoothed_normalized_High);

mapping_sigm_rt_smoothed_normalized_Low_max_Energy = reshape(xRT(value_sigm_rt_smoothed_normalized_Low_max_Energypos),X,Y);
mapping_sigm_rt_smoothed_normalized_High_max_Energy = reshape(xRT(value_sigm_rt_smoothed_normalized_High_max_Energypos),X,Y);
mapping_sigp_rt_smoothed_normalized_Low_max_Energy = reshape(xRT(value_sigp_rt_smoothed_normalized_Low_max_Energypos),X,Y);
mapping_sigp_rt_smoothed_normalized_High_max_Energy = reshape(xRT(value_sigp_rt_smoothed_normalized_High_max_Energypos),X,Y);

mapping_sigm_rt_smoothed_normalized_Low_max_Energy = mapping_sigm_rt_smoothed_normalized_Low_max_Energy(1+xs_off:X-xe_off,1+ys_off:Y-ye_off);
mapping_sigm_rt_smoothed_normalized_High_max_Energy = mapping_sigm_rt_smoothed_normalized_High_max_Energy(1+xs_off:X-xe_off,1+ys_off:Y-ye_off);
mapping_sigp_rt_smoothed_normalized_Low_max_Energy = mapping_sigp_rt_smoothed_normalized_Low_max_Energy(1+xs_off:X-xe_off,1+ys_off:Y-ye_off);
mapping_sigp_rt_smoothed_normalized_High_max_Energy = mapping_sigp_rt_smoothed_normalized_High_max_Energy(1+xs_off:X-xe_off,1+ys_off:Y-ye_off);

mapping_sigm_rt_smoothed_normalized_Width = mapping_sigm_rt_smoothed_normalized_High_max_Energy - mapping_sigm_rt_smoothed_normalized_Low_max_Energy;
mapping_sigp_rt_smoothed_normalized_Width = mapping_sigp_rt_smoothed_normalized_High_max_Energy - mapping_sigp_rt_smoothed_normalized_Low_max_Energy;

mapping_sigm_rt_smoothed_normalized_Width(mapping_sigm_rt_smoothed_normalized_Width<0) = 0;
mapping_sigp_rt_smoothed_normalized_Width(mapping_sigp_rt_smoothed_normalized_Width<0) = 0;


figure(07),imagesc(mapping_v_rt);colorbar;title("Valley Polarization @RT");print_en(print_flag,"-f7","mapping_v_rt.png","-dpng","-r250");
figure(08),imagesc(mapping_v_lt);colorbar;title("Valley Polarization @LT");print_en(print_flag,"-f8","mapping_v_lt.png","-dpng","-r250");
mapping_v_lt(isnan(mapping_v_lt))=0;

locate_of_zero_rt = ~((mapping_v_lt)&(mapping_m_rt_max)&(mapping_p_rt_max)&(mapping_p_rt_max)&(mapping_m_rt_max_Energy)&(mapping_p_rt_max_Energy)&(mapping_m_rt_smoothed_normalized_trion)&(mapping_p_rt_smoothed_normalized_trion)&(mapping_sigm_rt_smoothed_normalized_Width)&(mapping_sigp_rt_smoothed_normalized_Width));
locate_of_zero_rt = ~((mapping_v_lt)&(mapping_m_rt_max)&(mapping_p_rt_max)&(mapping_p_rt_max)&(mapping_m_rt_max_Energy)&(mapping_p_rt_max_Energy));
locate_of_zero_lt = ~((mapping_v_lt)&(mapping_m_lt_max)&(mapping_m_lt_max)&(mapping_p_lt_max)&(mapping_m_lt_max_Energy)&(mapping_p_lt_max_Energy)&(mapping_p_rt_smoothed_normalized_trion)&(mapping_p_rt_max_Energy));
locate_of_zero=or(locate_of_zero_rt,locate_of_zero_lt);
% locate_of_zero=zeros('like',locate_of_zero);

mapping_v_rt(locate_of_zero)=0;
mapping_v_lt(locate_of_zero)=0;
mapping_m_rt_max(locate_of_zero)=0;
mapping_p_rt_max(locate_of_zero)=0;
mapping_m_lt_max(locate_of_zero)=0;
mapping_p_lt_max(locate_of_zero)=0;
mapping_m_rt_max_Energy(locate_of_zero)=0;
mapping_p_rt_max_Energy(locate_of_zero)=0;
mapping_m_lt_max_Energy(locate_of_zero)=0;
mapping_p_lt_max_Energy(locate_of_zero)=0;
mapping_m_rt_smoothed_normalized_trion(locate_of_zero)=0;
mapping_p_rt_smoothed_normalized_trion(locate_of_zero)=0;
mapping_sigm_rt_smoothed_normalized_Width(locate_of_zero)=0;
mapping_sigp_rt_smoothed_normalized_Width(locate_of_zero)=0;

f = figure(07);imagesc(mapping_v_rt);f.CurrentAxes.CLim = [0 0.4];colorbar;title("Valley Polarization @RT");print_en(print_flag,"-f7","mapping_v_rt_0.png","-dpng","-r250");
f = figure(08);imagesc(mapping_v_lt);f.CurrentAxes.CLim = [0 0.4];colorbar;title("Valley Polarization @LT");print_en(print_flag,"-f8","mapping_v_lt_0.png","-dpng","-r250");
figure(09),imagesc(mapping_m_rt_max);colorbar;title("maxinum \sigma- @RT");print_en(print_flag,"-f9","mapping_m_rt_max.png","-dpng","-r250");
figure(10),imagesc(mapping_p_rt_max);colorbar;title("maxinum \sigma+ @RT");print_en(print_flag,"-f10","mapping_p_rt_max.png","-dpng","-r250");
figure(11),imagesc(mapping_m_lt_max);colorbar;title("maxinum \sigma- @LT");print_en(print_flag,"-f11","mapping_m_lt_max.png","-dpng","-r250");
figure(12),imagesc(mapping_p_lt_max);colorbar;title("maxinum \sigma+ @LT");print_en(print_flag,"-f12","mapping_p_lt_max.png","-dpng","-r250");
f = figure(13);imagesc(mapping_m_rt_max_Energy);f.CurrentAxes.CLim = [1.6 1.7];colorbar;title("maxinum position \sigma- @RT");print_en(print_flag,"-f13","mapping_m_rt_max_Energy.png","-dpng","-r250");
f = figure(14);imagesc(mapping_p_rt_max_Energy);f.CurrentAxes.CLim = [1.6 1.7];colorbar;title("maxinum position \sigma+ @RT");print_en(print_flag,"-f14","mapping_p_rt_max_Energy.png","-dpng","-r250");
f = figure(15);imagesc(mapping_m_lt_max_Energy);f.CurrentAxes.CLim = [1.6 1.7];colorbar;title("maxinum position \sigma- @LT");print_en(print_flag,"-f15","mapping_m_lt_max_Energy.png","-dpng","-r250");
f = figure(16);imagesc(mapping_p_lt_max_Energy);f.CurrentAxes.CLim = [1.6 1.7];colorbar;title("maxinum position \sigma+ @LT");print_en(print_flag,"-f16","mapping_p_lt_max_Energy.png","-dpng","-r250");

f = figure(17);imagesc(mapping_m_rt_smoothed_normalized_trion);f.CurrentAxes.CLim = [0 0.4];colorbar;title("Trion \sigma- @RT");print_en(print_flag,"-f17","mapping_m_rt_smoothed_normalized_trion.png","-dpng","-r250");
f = figure(18);imagesc(mapping_p_rt_smoothed_normalized_trion);f.CurrentAxes.CLim = [0 0.4];colorbar;title("Trion \sigma+ @RT");print_en(print_flag,"-f18","mapping_p_rt_smoothed_normalized_trion.png","-dpng","-r250");

f = figure(19);imagesc(mapping_sigm_rt_smoothed_normalized_Width);f.CurrentAxes.CLim = [0 0.075];colorbar;title("FWHM \sigma- @RT");print_en(print_flag,"-f19","mapping_sigm_rt_smoothed_normalized_Width.png","-dpng","-r250");
f = figure(20);imagesc(mapping_sigp_rt_smoothed_normalized_Width);f.CurrentAxes.CLim = [0 0.075];colorbar;title("FWHM \sigma+ @RT");print_en(print_flag,"-f20","mapping_sigp_rt_smoothed_normalized_Width.png","-dpng","-r250");
cd(ParentFolder);
save(strcat(samplename,".treated.mat"),"xRT","xLT","mapping_sigm_rt_smoothed_normalized_Width","mapping_sigp_rt_smoothed_normalized_Width","mapping_m_rt_smoothed_normalized_trion","mapping_p_rt_smoothed_normalized_trion","mapping_v_rt","mapping_v_lt","mapping_m_rt_max","mapping_p_rt_max","mapping_m_rt_max_Energy","mapping_p_rt_max_Energy","mapping_p_lt_max");
