tic
xs_off=0;
ys_off=0;
xe_off=1;
ye_off=2;

xlime=1;
ylime=2;


% FilenameRT=replace("C:/Users/kenya/Desktop/ramdomforests_trainningSiO2/S3_2/20190202_RT/001S3_2PLWSe2SiO2300KCW633nm30uW20s_%.0f_1.txt","/","//");
% FilenameLT=replace("C:/Users/kenya/Desktop/ramdomforests_trainningSiO2/S3_2/20190129_LT/001S3_2PLWSe2SiO215KCW633nm30uW20s_%.0f_1.txt","/","//");
pfloder=cd("../S3_2/");
if(exist("S3.mat","file")>0)
    load("S3.mat");
    "load"
else
    "each load"
    FilenameRT=replace("20190202_RT/001S3_2PLWSe2SiO2300KCW633nm30uW20s_%.0f_1.txt","/","//");
    FilenameLT=replace("20190129_LT/001S3_2PLWSe2SiO215KCW633nm30uW20s_%.0f_1.txt","/","//");
    pickup=500:700;
    
    Inteinsity_sigm_rt=zeros(length(pickup),961);
    Inteinsity_sigp_rt=Inteinsity_sigm_rt;
    Inteinsity_sigm_lt=Inteinsity_sigm_rt;
    Inteinsity_sigp_lt=Inteinsity_sigm_rt;
    parfor f=1:961
        a=load(sprintf(FilenameRT,f));
        Inteinsity_sigm_rt(:,f)=a(pickup,3);
        Inteinsity_sigp_rt(:,f)=a(pickup+1340,3);
        
        a=load(sprintf(FilenameLT,f));
        Inteinsity_sigm_lt(:,f)=a(pickup,3);
        Inteinsity_sigp_lt(:,f)=a(pickup+1340,3);
    end
    toc
    a=load(sprintf(FilenameLT,randi(961)));
    x=1240./a(pickup,1);
    
    save("S3.mat",'x','Inteinsity_sigm_rt','Inteinsity_sigp_rt','Inteinsity_sigm_lt','Inteinsity_sigp_lt','xs_off','ys_off','xe_off','ye_off');
end
toc
%小さいところを0に
Inteinsity_sigm_rt(mean(Inteinsity_sigm_rt,2)<30)=0;
Inteinsity_sigp_rt(mean(Inteinsity_sigp_rt,2)<30)=0;
Inteinsity_sigm_lt(mean(Inteinsity_sigm_lt,2)<30)=0;
Inteinsity_sigp_lt(mean(Inteinsity_sigp_lt,2)<30)=0;

%cosmic ray cut
Inteinsity_sigm_rt(Inteinsity_sigm_rt<2*mean(Inteinsity_sigm_rt,1))=0;
Inteinsity_sigp_rt(Inteinsity_sigp_rt<2*mean(Inteinsity_sigp_rt,1))=0;
Inteinsity_sigm_lt(Inteinsity_sigm_lt<2*mean(Inteinsity_sigm_lt,1))=0;
Inteinsity_sigp_lt(Inteinsity_sigp_lt<2*mean(Inteinsity_sigp_lt,1))=0;

value_sigm_rt=sum(Inteinsity_sigm_rt);
value_sigp_rt=sum(Inteinsity_sigp_rt);
value_sigm_lt=sum(Inteinsity_sigm_lt);
value_sigp_lt=sum(Inteinsity_sigp_lt);

mapping_m_rt=reshape(value_sigm_rt,31,31);
mapping_p_rt=reshape(value_sigp_rt,31,31);
mapping_m_lt=reshape(value_sigm_lt,31,31);
mapping_p_lt=reshape(value_sigp_lt,31,31);

mapping_m_rt=mapping_m_rt(1+xs_off:31-xe_off,1+ys_off:31-ye_off);
mapping_p_rt=mapping_p_rt(1+xs_off:31-xe_off,1+ys_off:31-ye_off);
mapping_m_lt=mapping_m_lt(1+xe_off:31-xs_off,1+ye_off:31-ys_off);
mapping_p_lt=mapping_p_lt(1+xe_off:31-xs_off,1+ye_off:31-ys_off);

%マップ後、最大値の2割以下のエリアを0に
mapping_m_rt(mapping_m_rt<0.2*max(mapping_m_rt(:)))=0;
mapping_p_rt(mapping_p_rt<0.2*max(mapping_p_rt(:)))=0;
mapping_m_lt(mapping_m_lt<0.2*max(mapping_m_lt(:)))=0;
mapping_p_lt(mapping_p_lt<0.2*max(mapping_p_lt(:)))=0;

%他がゼロなら、アレする
locate_of_zero=or(or(mapping_m_rt==0,mapping_p_rt==0),or(mapping_m_lt==0,mapping_p_lt==0));
mapping_m_rt(locate_of_zero)=0;
mapping_p_rt(locate_of_zero)=0;
mapping_m_lt(locate_of_zero)=0;
mapping_p_lt(locate_of_zero)=0;



%% Make Maps.
figure(1),imagesc(mapping_m_rt);colorbar;title("\sigma- @RT");print("-f1","mapping_m_rt.png","-dpng","-r250");
figure(2),imagesc(mapping_p_rt);colorbar;title("\sigma+ @RT");print("-f2","mapping_p_rt.png","-dpng","-r250");
figure(3),imagesc(mapping_m_lt);colorbar;title("\sigma- @LT");print("-f3","mapping_m_lt.png","-dpng","-r250");
figure(4),imagesc(mapping_p_lt);colorbar;title("\sigma+ @LT");print("-f4","mapping_p_lt.png","-dpng","-r250");
figure(5),imagesc(abs(mapping_m_rt./max(mapping_m_rt)-mapping_m_lt./max(mapping_m_lt)));colorbar;title("\sigma- LT-RT");print("-f5","mapping_m_df.png","-dpng","-r250");
figure(6),imagesc(abs(mapping_p_rt./max(mapping_p_rt)-mapping_p_lt./max(mapping_p_lt)));colorbar;title("\sigma+ LT-RT");print("-f6","mapping_m_df.png","-dpng","-r250");

mapping_v_rt=(mapping_p_rt-mapping_m_rt)./(mapping_m_rt+mapping_p_rt);
mapping_v_lt=(mapping_p_lt-mapping_m_lt)./(mapping_m_lt+mapping_p_lt);

mapping_v_rt(or(or(-0.95>mapping_v_rt,mapping_v_rt>0.95),or((mapping_m_rt<max(mapping_m_rt(:))/3),(mapping_p_rt<max(mapping_p_rt(:))/3))))=0;
mapping_v_lt(or(or(-0.95>mapping_v_lt,mapping_v_lt>0.95),or((mapping_m_lt<max(mapping_m_lt(:))/3),(mapping_p_lt<max(mapping_p_lt(:))/3))))=0;
figure(7),imagesc(mapping_v_rt);colorbar;title("Valley Polarization @RT");print("-f7","mapping_v_rt.png","-dpng","-r250");
figure(8),imagesc(mapping_v_lt);colorbar;title("Valley Polarization @LT");print("-f8","mapping_v_lt.png","-dpng","-r250");

%% Exciton
value_sigm_rt=sum(Inteinsity_sigm_rt);
value_sigp_rt=sum(Inteinsity_sigp_rt);
value_sigm_lt_ex=sum(Inteinsity_sigm_lt(and(1.72<x,x<1.74),:));
value_sigp_lt_ex=sum(Inteinsity_sigp_lt(and(1.72<x,x<1.74),:));
mapping_m_lt_ex=reshape(value_sigm_lt_ex,31,31);
mapping_p_lt_ex=reshape(value_sigp_lt_ex,31,31);

% mapping_v_rt_ex=(mapping_p_rt_ex-mapping_m_rt_ex)./(mapping_m_rt_ex+mapping_p_rt_ex);
mapping_v_lt_ex=(mapping_p_lt_ex-mapping_m_lt_ex)./(mapping_m_lt_ex+mapping_p_lt_ex);

% mapping_v_rt_ex(or(or(-0.95>mapping_v_rt_ex,mapping_v_rt_ex>0.95),or((mapping_m_rt_ex<max(mapping_m_rt_ex(:))/3),(mapping_p_rt_ex<max(mapping_p_rt_ex(:))/3))))=0;
mapping_v_lt_ex(or(or(-0.95>mapping_v_lt_ex,mapping_v_lt_ex>0.95),or((mapping_m_lt_ex<max(mapping_m_lt_ex(:))/3),(mapping_p_lt_ex<max(mapping_p_lt_ex(:))/3))))=0;
% figure(9),imagesc(mapping_v_rt_ex);colorbar;print("-f9","mapping_v_rt_ex.png","-dpng","-r250");
figure(10),imagesc(mapping_v_lt_ex);colorbar;print("-f10","mapping_v_lt_ex.png","-dpng","-r250");

%% Trion
value_sigm_rt=sum(Inteinsity_sigm_rt);
value_sigp_rt=sum(Inteinsity_sigp_rt);
[value_sigm_lt_tr, value2_sigm_lt_tr]=max(Inteinsity_sigm_lt(and(1.69<x,x<1.71),:));
[value_sigp_lt_tr, value2_sigp_lt_tr]=max(Inteinsity_sigp_lt(and(1.69<x,x<1.71),:));
mapping_m_lt_tr=reshape(value_sigm_lt_tr,31,31);
mapping_p_lt_tr=reshape(value_sigp_lt_tr,31,31);
mapping_me_lt_tr=reshape(x(value2_sigm_lt_tr),31,31);
mapping_pe_lt_tr=reshape(x(value2_sigp_lt_tr),31,31);

% mapping_v_rt_tr=(mapping_p_rt_tr-mapping_m_rt_tr)./(mapping_m_rt_tr+mapping_p_rt_tr);
mapping_v_lt_tr=(mapping_p_lt_tr-mapping_m_lt_tr)./(mapping_m_lt_tr+mapping_p_lt_tr);

% mapping_v_rt_tr(or(or(-0.95>mapping_v_rt_tr,mapping_v_rt_tr>0.95),or((mapping_m_rt_tr<max(mapping_m_rt_tr(:))/3),(mapping_p_rt_tr<max(mapping_p_rt_tr(:))/3))))=0;
mapping_v_lt_tr(or(or(-0.95>mapping_v_lt_tr,mapping_v_lt_tr>0.95),or((mapping_m_lt_tr<max(mapping_m_lt_tr(:))/3),(mapping_p_lt_tr<max(mapping_p_lt_tr(:))/3))))=0;
% figure(11),imagesc(mapping_v_rt_tr);colorbar;print("-f11","mapping_v_rt_tr.png","-dpng","-r250");
figure(12),imagesc(mapping_v_lt_tr);colorbar;print("-f12","mapping_v_lt_tr.png","-dpng","-r250");



%% Exciton2
value_sigm_rt=sum(Inteinsity_sigm_rt);
value_sigp_rt=sum(Inteinsity_sigp_rt);
[value_sigm_lt_tr, value2_sigm_lt_tr]=max(Inteinsity_sigm_lt(and(1.72<x,x<1.74),:));
[value_sigp_lt_tr, value2_sigp_lt_tr]=max(Inteinsity_sigp_lt(and(1.72<x,x<1.74),:));
mapping_m_lt_tr=reshape(value_sigm_lt_tr,31,31);
mapping_p_lt_tr=reshape(value_sigp_lt_tr,31,31);
mapping_me_lt_tr=reshape(x(value2_sigm_lt_tr),31,31);
mapping_pe_lt_tr=reshape(x(value2_sigp_lt_tr),31,31);

% mapping_v_rt_tr=(mapping_p_rt_tr-mapping_m_rt_tr)./(mapping_m_rt_tr+mapping_p_rt_tr);
mapping_v_lt_tr=(mapping_p_lt_tr-mapping_m_lt_tr)./(mapping_m_lt_tr+mapping_p_lt_tr);

% mapping_v_rt_tr(or(or(-0.95>mapping_v_rt_tr,mapping_v_rt_tr>0.95),or((mapping_m_rt_tr<max(mapping_m_rt_tr(:))/3),(mapping_p_rt_tr<max(mapping_p_rt_tr(:))/3))))=0;
mapping_v_lt_tr(or(or(-0.95>mapping_v_lt_tr,mapping_v_lt_tr>0.95),or((mapping_m_lt_tr<max(mapping_m_lt_tr(:))/3),(mapping_p_lt_tr<max(mapping_p_lt_tr(:))/3))))=0;
% figure(11),imagesc(mapping_v_rt_tr);colorbar;print("-f11","mapping_v_rt_tr.png","-dpng","-r250");
figure(12),imagesc(mapping_m_lt_tr);colorbar;print("-f12","mapping_v_lt_tr.png","-dpng","-r250");
figure(13),imagesc(mapping_me_lt_tr);colorbar;print("-f12","mapping_v_lt_tr.png","-dpng","-r250");
% figure(14),imagesc(mapping_me_lt_tr);colorbar;print("-f12","mapping_v_lt_tr.png","-dpng","-r250");


toc
cd(pfloder);
