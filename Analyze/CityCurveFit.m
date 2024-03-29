clc;
clear

load VPNEOS_All7;
load avVPN_LST_SOS;
load avVPN_LST_EOS;
load VPNSOS_All7;
load VPNALAN_All;
load VPNLST_All;
load VPNTmin_All;
load VPNNH_slope_rank;
load VPNCitylist_All;
load VPNallISA;
load VPNCitymatchKC;

VPNTaav_All = (VPNLST_All+VPNTmin_All)./2;



VPNEOS_All7(find(VPNEOS_All7<180)) = NaN;
VPNEOS_All7(find(VPNEOS_All7>365)) = NaN;
VPNSOS_All7(find(VPNSOS_All7<=0)) = NaN;

L1 = length(VPNSOS_All7(:,1,1));

for citynum = 1:L1
    ss1(:,:) = VPNSOS_All7(citynum,:,:);
    ss2(:,:) = VPNEOS_All7(citynum,:,:);
    %     ss(find(ss<0)) = NaN;
    for layer = 1:10
        sslayer1(:) = ss1(:,layer);
        if sum(isnan(sslayer1)) > 3
            ss1(:,layer) = NaN;
        end
        sslayer2(:) = ss2(:,layer);
        if sum(isnan(sslayer2)) > 3
            ss2(:,layer) = NaN;
        end
    end
    av_ss1(:,:) = nanmean(ss1,1);
    if sum(isnan(av_ss1)) > 5
        ss1(:,:) = NaN;
    end
    av_ss2(:,:) = nanmean(ss2,1);
    if sum(isnan(av_ss2)) > 5
        ss2(:,:) = NaN;
    end
    VPNSOS_All7(citynum,:,:) = ss1;
    VPNEOS_All7(citynum,:,:) = ss2;
end

nh_city(:,1) = VPNNH_slope_rank;
gl_city(:,1) = VPNAllcity(:,1);
[m0,n0,N0] = intersect(nh_city,gl_city);
ALAN = VPNALAN_All(N0,:,:);
LST = VPNTaav_All(N0,:,:);
PHENO = VPNSOS_All7(N0,:,:);%(city,year,layer)
Isa = VPNallISA(N0,:);
Len = length(VPNNH_slope_rank);


selectT = zeros(Len,7,40,10);
selectALAN = zeros(Len,7,3,10);
for city = 1:Len    
    for year = 1:7
        start = 365+(year-1)*365+51;
        enddate = 365+(year-1)*365+90;
    selectT(city,year,:,:)  = LST(city,start:enddate,:);
    selectALAN(city,year,:,:) = ALAN(city,(year-1)*12+1:(year-1)*12+3,:);
    end
end

avVPN_Taav_SOS(:,:,:) = nanmean(selectT,3);
avVPN_ALAN_SOS(:,:,:) = nanmean(selectALAN,3);

fitRes = zeros(Len,3,3);

DffitRes = zeros(Len,2,4);



for i = 1: Len
    ph0 = PHENO(i,:,:);Ta0 = avVPN_Taav_SOS(i,:,:);alan0 = avVPN_ALAN_SOS(i,:,:);
    IsaX0 =repmat(VPNallISA(i,:),7,1) ;
    ph1 = reshape(ph0,7,10);alan1 = reshape(alan0,7,10);ta1 = reshape(Ta0,7,10);IsaX1 = reshape(IsaX0,7,10);
    ph2 = nanmean(ph1,1);alan2 = nanmean(alan1,1);
    ta2 =  nanmean(ta1,1);IsaX2 =  nanmean(IsaX1,1);
    All0 = cat(2,ph2',ta2',alan2',IsaX2');
    All1 = All0(all(~isnan(All0),2),:);

    if isempty(All1)
        fitRes(i,:,:) = NaN;
        DffitRes(i,1,:)= NaN;
    else
        for j = 1:3
            X2 = All1(:,4);
            %X1 = X2.*X2;
            Y = All1(:,j);

            temp1 = FitCurve(X2,Y,2);
            fitRes(i,j,:) = temp1;
        end
%         ph3 =  All1(:,1);alan3 = All1(:,2);ta3 = All1(:,3);
%         temp2 = FitCurve(ta3,alan3,ph3);
%         DffitRes(i,1,:) = temp2;
    end

end

KCfitRes = zeros(3,3,4);
idx = [1 3 6 9];
VNPNH_ISA = zeros(Len,7,10);
for i = 1:Len
    VNPNH_ISA(i,:,:) = repmat(VPNallISA(i,:),7,1);
end
for i = 1:3
    a = idx(1);
    b = idx(3+1);
    [m0,n0] = find(VPNCitymatchKC(:,6)>=a &VPNCitymatchKC(:,6)<b);
    citycount = VPNCitymatchKC(m0,1);
    [m1,n1,N1] = intersect(citycount,VPNNH_slope_rank);
    ph0 = PHENO(N1,:,:);Ta0 = avVPN_Taav_SOS(N1,:,:);
    alan0 = avVPN_ALAN_SOS(N1,:,:);IsaX0 = VNPNH_ISA(N1,:,:);
    slNum = length(N1);
    ph1 = reshape(ph0,slNum*7,10);alan1 = reshape(alan0,slNum*7,10);
    ta1 = reshape(Ta0,slNum*7,10);IsaX1 = reshape(IsaX0,slNum*7,10);
    ph2 = nanmean(ph1,1);alan2 = nanmean(alan1,1);
    ta2 =  nanmean(ta1,1);IsaX2 =  nanmean(IsaX1,1);
    All0 = cat(2,ph2',ta2',alan2',IsaX2');
    All1 = All0(all(~isnan(All0),2),:);
        for j = 1:3
            X2 = All1(:,4);
            
            Y = All1(:,j);

            temp3 = FitCurve(X2,Y,4);
            KCfitRes(i,j,:) = temp3;
        end
end




function FitA = FitCurve(X,Y,num)
if num == 1
res = zeros(4,1);
X1 = X.*X;
tb = table(X1,X,Y,'VariableNames',{'X1','X','Y'});
lm = fitlm(tb,'Y~X1+X');
res(1:3,1) = lm.Coefficients.Estimate;
res(4,1) = lm.Rsquared.Ordinary;
end
if num == 2 % y = ln(x)
res = zeros(3,1);
X1 = log(X);
% Y1 = log(Y);
tb = table(X1,Y,'VariableNames',{'X1','Y'});
lm = fitlm(tb,'Y~X1');
res(1:2,1) = lm.Coefficients.Estimate;
res(3,1) = lm.Rsquared.Ordinary;
end

if num == 3 %y= exp(ax)+b
    res = zeros(3,1);
    if numel(find(Y<0)) >= 1
        minY = min(Y);
        Y1 = log(Y-minY);
    else
        Y1 = log(Y);
    end
    Y1 = Y1-Y1(1,1);
    tb = table(X,Y1,'VariableNames',{'X','Y'});
    lm = fitlm(tb,'Y~X');

    res(1:2,1) = lm.Coefficients.Estimate;
    res(3,1) = lm.Rsquared.Ordinary;
end
if num == 4
    res = zeros(4,1);
    x = X;
    y = Y;
        x(isnan(Y)) = [];
    y(isnan(Y)) = [];

    fx=@(b,x)(b(1)./(1+b(2).*exp(-b(3).*x)));
    b=[1 2 2]; %初始迭代值 最大值 生长速率 （根据具体实验来设定，初始值在本方程拟合影响不大）
    for l=1:30 %拟合过程迭代
        b=lsqcurvefit(fx,b,x,y);
        b=nlinfit(x,y,fx,b);
    end
    n=length(y);
    SSy=var(y)*(n-1);
    y1=fx(b,x);
    RSS=(y-y1)'*(y-y1);
    R =(SSy-RSS)/SSy;
%     res(:,1)=fx(b,x);
    res(1:3,1) = b;
    res(4,1) = R;
end
if num == 5
res = zeros(3,1);
X1 = X;
tb = table(X1,Y,'VariableNames',{'X1','Y'});
lm = fitlm(tb,'Y~X1');
res(1:2,1) = lm.Coefficients.Estimate;
res(3,1) = lm.Rsquared.Ordinary;
end
FitA = res;
end
