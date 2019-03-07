% %% 位置合わせ
% xlime=1;
% ylime=2;
shape_l(1:31,1:31)=1;
shape_r(1:31,1:31)=1;
for j=1:31
    for k=1:31
        if 1<=j && j<=ylime || 1<=k && k<=xlime
            shape_l(j,k)=0;
        else
        end
        if j>=32-ylime || 31-xlime+1<=k
            shape_r(j,k)=0;
        else
        end
    end
end
% １列に直す
shape_l=rot90(shape_l,1);
shape_l=flipud(shape_l);
shape_l_line=zeros(31^2,1);
for j=1:31
    for k=1:31
        shape_l_line(k+(j-1)*31,1)=shape_l(32-j,k);
    end
end
shape_r=rot90(shape_r,1);
shape_r=flipud(shape_r);
shape_r_line=zeros(31^2,1);
for j=1:31
    for k=1:31
        shape_r_line(k+(j-1)*31,1)=shape_r(32-j,k);
    end
end
%% データ読み込み
num=961;
spectra=1340;
w1=570;
w2=749;
filename="C:\Users\kenya\Desktop\ramdomforests_trainningSiO2\S3_2\20190129_LT\001S3_2PLWSe2SiO215KCW633nm30uW20s_";
sigm_r=zeros(w2-w1+1,num);
sigp_r=zeros(w2-w1+1,num);
for j=1:num
   f=num2str(j);
   fname=strcat(filename,f,"_1.txt");
   a=load(fname);
   sigm_r(:,j)=a(w1:w2,3);
   sigp_r(:,j)=a(spectra+w1:spectra+w2,3);
end
x=a(w1:w2,1);
clear a
sigp_r=sigp_r(1:w2-w1+1,:);
sigm_r=sigm_r(1:w2-w1+1,:);
valuep=zeros(1,num);
valuem=zeros(1,num);
a=0;
b=0;
for j=1:num
    for k=1:w2-w1
        a=a+(sigp_r(k,j)+sigp_r(k+1,j))*(x(k+1,1)-x(k,1))/2;
        b=b+(sigm_r(k,j)+sigm_r(k+1,j))*(x(k+1,1)-x(k,1))/2;
    end
    valuep(1,j)=a;
    valuem(1,j)=b;
    a=0;
    b=0;
end
clear a b
mapping_p=zeros(31,31);
mapping_m=zeros(31,31);
for k=1:31
    for i=1:31
        mapping_p(32-k,i)=valuep(i+31*(k-1));
        mapping_m(32-k,i)=valuem(i+31*(k-1));
    end
end
mapping_p=flipud(mapping_p);
mapping_p=rot90(mapping_p,3);
mapping_m=flipud(mapping_m);
mapping_m=rot90(mapping_m,3);
figure
image(mapping_p,"CDataMapping","scaled")
colorbar
grid on
saveas(gcf,"PL_low_plus.png");
close
% figure
% image(mapping_m,"CDataMapping","scaled")
% colorbar
% grid on
% saveas(gcf,"PL_minus.png");
% close
a=1;
valueintensity_p=zeros(31^2-31*ylime-(31-ylime)*xlime,1);
valueintensity_m=zeros(31^2-31*ylime-(31-ylime)*xlime,1);
for j=1:31^2
    if shape_l_line(j,1)==0
    else
        valueintensity_m(a,1)=valuem(1,j);
        valueintensity_p(a,1)=valuep(1,j);
        a=a+1;
    end
end
mapping_p_re=zeros(31-xlime,31-ylime);
mapping_m_re=zeros(31-xlime,31-ylime);
for j=1:31-xlime
    for k=1:31-ylime
        mapping_p_re(32-xlime-j,k)=valueintensity_p((31-ylime)*(j-1)+k,1);
        mapping_m_re(32-xlime-j,k)=valueintensity_m((31-ylime)*(j-1)+k,1);
    end
end
mapping_p_re=flipud(mapping_p_re);
mapping_p_re=rot90(mapping_p_re,3);
mapping_m_re=flipud(mapping_m_re);
mapping_m_re=rot90(mapping_m_re,3);
figure
image(mapping_p_re,"CDataMapping","scaled")
colorbar
grid on
saveas(gcf,"PL_low_plus_reshape.png");
close
% figure
% image(mapping_m_re,"CDataMapping","scaled")
% colorbar
% grid on
% saveas(gcf,"PL_minus_reshape.png");
% close