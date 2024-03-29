clc;
clear

filename = ["H:\文件\论文2\Data\Result\FitR.xlsx"];%EitR.xlsx--EOS
data = importdata(filename);
data1 = data.data.L;
data1(:,[2,3]) = data1(:,[3,2]);
data2 = data.data.PLY;
data2(:,[2,3]) = data2(:,[3,2]);
data3 = data.data.S;
data3(:,[2,3]) = data3(:,[3,2]);
data4 = data.data.Ex;
data4(:,[2,3]) = data4(:,[3,2]);
data5 = data.data.Logic;
data5(:,[2,3]) = data5(:,[3,2]);

title1 = {"EOS","ALAN","T_a"};
title2 = {"Linear","Polyn","S","Exp","Log"};
A = zeros(length(data1(:,1)),5);
C = zeros(3,5);
edges = [0:0.01:1];
color = [
    [0.2 0.70 0.30]
    [0.8 0.2 0.1]
    [0.35 0.20 0.58]
    ];
figure(1)
for i = 1:3
    A(:,1) = data1(:,i);
    A(:,2) = data2(:,i);
    A(:,3) = data3(:,i);
    A(:,4) = data4(:,i);
    A(:,5) = data5(:,i);
    for j = 1:5   
        subplot(3,5,(i-1)*5+j);
        B(:) = A(:,j);
    h1 = histogram(B,edges,'Normalization','probability');
    h1.FaceColor = color(i,:);
    b = round(nanmean(B),2);
    y1 = h1.Parent.YLim;
    set(gca,'FontName','Arial','FontSize',18,'LineWidth',1.5,'FontWeight','bold');
    str = ["R^2 = " + b];
    text(0.1,y1(1,2)*0.8,str,'FontName','Arial','FontSize',18,'LineWidth',1.5,'FontWeight','bold');
    ylabel(title1(i),'FontName','Arial','FontSize',18,'LineWidth',1.5,'FontWeight','bold');
    title(title2(j),'FontName','Arial','FontSize',18,'LineWidth',1.5,'FontWeight','bold');
        xlabel('R^2','FontName','Arial','FontSize',18,'LineWidth',1.5,'FontWeight','bold');
%         axis tight;

    hold on
    end
C(i,:) = nanmean(A,1);
end


function [z1,z2] = aver(x,y)
 l = length(x);
 wb = x(2)-x(1);
 L = [1:1:l];
 c = 0;
 for i = 1:l
     if abs(c-0.5)<0.02
         break;
     else
         c = y(i)*wb + c;
     end
 end
 z1 = x(i);
 z2 = y(i);
 end
