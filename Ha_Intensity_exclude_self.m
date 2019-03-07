clear
tic
FL=deblank(string(ls("*treated.mat")))';
LearningData=zeros(1,4);
ExpectData=zeros(1,1);
for f=replace(FL,".treated.mat","")
    
    % samplename="S2_1";
    samplename=f;
    for f=FL
        if(strcmp(f,strcat(samplename,".treated.mat")))
            continue;
        end
        a=load(f);
        
        h=horzcat(...
            a.mapping_p_rt_max(:),...
            a.mapping_p_rt_max_Energy(:),...
            a.mapping_p_rt_smoothed_normalized_trion(:),...
            a.mapping_sigp_rt_smoothed_normalized_Width(:)...
            );
        
        %     h=horzcat(...
        %         a.mapping_p_rt_max(:),...
        %         a.mapping_p_rt_max_Energy(:),...
        %         a.mapping_p_rt_smoothed_normalized_trion(:),...
        %         a.mapping_m_rt_max(:),...
        %         a.mapping_m_rt_max_Energy(:),...
        %         a.mapping_m_rt_smoothed_normalized_trion(:),...
        %         a.mapping_sigm_rt_smoothed_normalized_Width(:),...
        %         a.mapping_sigp_rt_smoothed_normalized_Width(:)...
        %     );
        %     a.mapping_v_rt;
        LearningData=vertcat(LearningData,h);
        ExpectData=vertcat(ExpectData, a.mapping_p_lt_max(:));
    end
    LearningData(isnan(LearningData))=0;
    ExpectData(isnan(ExpectData))=0;
    vz=sum(LearningData==0,2);
    % v2=zeros('like',v);
    c=1;
    for a=1:length(LearningData)
        if(vz(a,1)<1)
            L2(c,:)=LearningData(a,:);
            E2(c,:)=ExpectData(a,:);
            c=c+1;
        end
    end
    
    E2=round(E2,3);
    
    % ‰ñ‹A–Ø‚Ìì¬
    Md=fitrensemble(L2,E2);
    %Ä‘ã“üŒë·
    MSEcomb=resubLoss(Md)
    
    importance=predictorImportance(Md)
    DefaultTree = fitrtree(L2,E2);
%     view(DefaultTree,'Mode','Graph')
    t = templateTree('MaxNumSplits',1);
    Md_k = fitrensemble(L2, E2,'Learners',t,'CrossVal','on');
    % kflc = kfoldLoss(Md_k,'Mode','cumulative');
    % figure;
    % plot(kflc,'LineWidth',2);
    % ylabel('10-fold cross-validated MSE','FontSize',20);
    % xlabel('Learning cycle','FontSize',20);
    % set(gca,'FontSize',18)
    
    % for f=replace(FL,".treated.mat","")
    % samplename="S2_4";
    %     samplename=f;
    a=load(strcat(samplename,".treated.mat"));
    
    hi=horzcat(...
        a.mapping_p_rt_max(:),...
        a.mapping_p_rt_max_Energy(:),...
        a.mapping_p_rt_smoothed_normalized_trion(:),...
        a.mapping_sigp_rt_smoothed_normalized_Width(:)...
        );
    area=double(a.mapping_p_rt_max~=0);
    % hi=horzcat(...
    %         a.mapping_p_rt_max(:),...
    %         a.mapping_p_rt_max_Energy(:),...
    %         a.mapping_p_rt_smoothed_normalized_trion(:),...
    %         a.mapping_m_rt_max(:),...
    %         a.mapping_m_rt_max_Energy(:),...
    %         a.mapping_m_rt_smoothed_normalized_trion(:),...
    %         a.mapping_sigm_rt_smoothed_normalized_Width(:),...
    %         a.mapping_sigp_rt_smoothed_normalized_Width(:)...
    %     );
    
    pre2 = predict(Md,hi);
    [bx, by]=size(a.mapping_m_rt_max);
    pre2_map = reshape(pre2,bx,by).*area;
    maxintensity=max([pre2_map(:);a.mapping_p_lt_max(:)])
    f1=figure(1);imagesc(pre2_map)
    colorbar;
    % f.CurrentAxes.CLim=[0 0.25];
    f1.CurrentAxes.CLim=[0 maxintensity];
    title("Prediction Max Inteisty")
    print(strcat(samplename,".predict.png"),"-dpng","-r250");
    %     f1.CurrentAxes.CLim=[0.15 0.35];
    f2=figure(2);imagesc(a.mapping_p_lt_max)
    colorbar;
    f2.CurrentAxes.CLim=[0 maxintensity];
    title("Experiment Max Inteisty")
    print(strcat(samplename,".experiment.png"),"-dpng","-r250");
    drawnow;
    % temp=input("1");
end
toc