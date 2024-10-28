clc;
clear

% load VPNNH_slope_rank;
% load VPNNH_Citylist;
load SOSCityparCorTaav_DT.mat;
load EOSCityparCorTaav_DT.mat;

citylist = [60310];
parCorr = zeros(2,length(citylist),2);
parCorr(1,:,:) = SOSCityparCor(:,1,:);
parCorr(2,:,:) = EOSCityparCor(:,1,:);
parCorrP(1,:,:) = SOSCityparCor(:,2,:);
parCorrP(2,:,:) = EOSCityparCor(:,2,:);

% for pheno = 1:2
%     for var = 1:2
%         corrnum(:) = parCorr(pheno,:,var);
%         corrp(:) = parCorrP(pheno,:,var);
%         
%         corrnum(find(corrp > 0.05)) = NaN;
%         parCorr(pheno,:,var) = corrnum(:);
% 
%     end
% end

indxNum = zeros(length(citylist),2);
for i = 1:length(citylist)
    kk(:,:) = parCorr(:,i,:);
    for j = 1:2
        if kk(j,1)*kk(j,2) < 0
            [m1,n1] = max(abs(kk(j,:)));
            indxNum(i,j) = n1;
        else
            [m1,n1] = max(kk(j,:));
            indxNum(i,j) = n1;
        end
    end
end

Corsd = zeros(2,2);
for i = 1:2
    for j = 1:2
        k(:,1) = parCorr(i,:,j);
        k(all(isnan(k),2),:) = [];
        Corsd(i,j) = std(k);
        clear k;
    end
end


edges = [-1:0.02:1];
str1 = {'SOS','EOS'};
str2 = string(str1);
avResP = zeros(2,3);
figure(1)
clf
for pheno = 1:2
    subplot(1,2,pheno);   
    parT1(:,:) = parCorr(pheno,:,1);
    parT1p(:,:) = parCorr(pheno,:,2);

    parT1(isnan(parT1)) = [];
    avResP(pheno,1) = round(nanmean(parT1),2);

    h1 = histogram(parT1,edges,'Normalization','probability');
    h1.FaceColor = [0.86 0.43 0.34];
    h1.LineWidth = 0.8;
    h1.FaceAlpha = 0.7;
    h1.EdgeColor = [0.86 0.43 0.34];

    hold on
    parAlan(:,:) = parCorr(pheno,:,2);
    parAlan(isnan(parAlan)) = [];
    avResP(pheno,2) = round(nanmean(parAlan),2);
    
    h2 = histogram(parAlan,edges,'Normalization','probability');
    h2.FaceColor = [0.47 0.44 0.70];
    h2.FaceAlpha = 0.7;
    h2.LineWidth = 0.8;
    h2.EdgeColor = [0.47 0.44 0.70];
    hold on
   y1 = h2.Parent.YLim;

% hold on
%     parInter(:,:) = parCorr(pheno,:,3);
%     parInter(isnan(parInter)) = [];
%     avResP(pheno,3) = round(nanmean(parInter),2);
% 
%     h2 = histogram(parInter,edges,'Normalization','probability');
%     h2.FaceColor = [0.47 0.74 0.70];
%     h2.FaceAlpha = 0.7;
%     h2.LineWidth = 0.8;
%     h2.EdgeColor = [0.47 0.74 0.70];
%     hold on
%    y1 = h2.Parent.YLim;
line([avResP(pheno,2),avResP(pheno,2)],[0 0.08],'color',[0.47 0.44 0.70],'linestyle','--','LineWidth',3);
acst2 = [num2str(round(avResP(pheno,2),2))+" ± " + num2str(round(Corsd(pheno,2),2))];
text(avResP(pheno,2)+avResP(pheno,2)*0.1,y1(1,2)-0.015,acst2,'FontName','Arial','FontSize',30,'Color',[0.47 0.44 0.70],'FontWeight','bold');
    line([avResP(pheno,1),avResP(pheno,1)],[0 0.08],'color',[0.86 0.43 0.34],'linestyle','--','LineWidth',3);
    acst1 = [num2str(round(avResP(pheno,1),2))+" ± " + num2str(round(Corsd(pheno,1),2))];
text(avResP(pheno,1)-avResP(pheno,1)*0.1,y1(1,2)-0.005,acst1,'FontName','Arial','FontSize',30,'Color',[0.86 0.43 0.34],'FontWeight','bold');
    line([avResP(pheno,3),avResP(pheno,3)],[0 0.08],'color',[0.47 0.74 0.70],'linestyle','--','LineWidth',3);
%     acst3 = [num2str(round(avResP(pheno,3),2))+" ± " + num2str(round(Corsd(pheno,3),2))];
% text(avResP(pheno,3)-avResP(pheno,3)*0.1,y1(1,2)-0.005,acst3,'FontName','Arial','FontSize',30,'Color',[0.47 0.74 0.70],'FontWeight','bold');

    set(gca,'XTick',(-4:2:4),'FontName','Arial','FontSize',30,'LineWidth',1.5,'FontWeight','bold');
    xlabel('R','FontName','Arial','FontSize',30,'LineWidth',1.5,'FontWeight','bold');
    ylabel('Frequency','FontName','Arial','FontSize',30,'LineWidth',1.5,'FontWeight','bold');
    title(str2(pheno),'FontName','Arial','FontSize',30,'LineWidth',1.5,'FontWeight','bold');
               set(gca,'YTick',(0:0.02:0.08));

        set(gca,'YTickLabels',(0:0.02:0.08),'FontName','Arial','FontSize',30,'LineWidth',1.5,'FontWeight','bold');

    clear parT1 parAlan parInter;
end
legend({'Ta','Ta_a_v', 'ALAN','ALAN_a_v'},'FontName','Times New Roman','FontSize',18,'LineWidth',1.5,'FontWeight','bold');
%   legend({'R_T_a', 'R_A_L_A_N','R_T_a_×_A_L_A_N'},'FontName','Arial','FontSize',20,'LineWidth',1.5,'FontWeight','bold',"Box","off");
