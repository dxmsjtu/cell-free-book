%% This Matlab script can be used to reproduce Figure 2.8 in the monograph:
% [1] Ozlem Tugfe Demir, Emil Bjornson and Luca Sanguinetti (2021),"Foundations of User-Centric Cell-Free Massive MIMO", 
%Foundations and Trends in Signal Processing: Vol. 14: No. 3-4, pp 162-472. DOI: 10.1561/2000000109
%Empty workspace and close figures 
close all; clear all;%Set the side length of the simulation area
%Set the side length of the simulation area
squareLength = 400;
%Total number of APs
nbrOfAPs = 64;

%Number of realizations of the random AP locations
nbrOfSetups = 10000; % default is 100000;

%Define a function to compute the large-scale fading as function of the horizontal distance  measured in meter. 
%The AP is 10 meter above the UE. (2.17) of [1].
largescaleFading = @(hor_dist) db2pow(-30.5-36.7*log10(sqrt(hor_dist.^2+10^2)));

%Set the standard deviation of the shadow fading
shadowFadingStd = 4;

%Set the distance between the UEs
distancesBetweenUEs = [10 100];

%The UE is in the center of the simulation area
UElocation_k = (squareLength/2)*(1+1i);

%Prepare to save the simulation results
variance = zeros(nbrOfSetups,length(distancesBetweenUEs));
medianVariance = zeros(length(distancesBetweenUEs),1);
lowLimit = zeros(length(distancesBetweenUEs),1);
highLimit = zeros(length(distancesBetweenUEs),1);

%% Go through all random realizations of the AP locations
for m = 1:length(distancesBetweenUEs)    
    UElocation_i = UElocation_k + distancesBetweenUEs(m);
    %Generate shadowing correalation matrix according to the model in  
    shadowFadingCov = shadowFadingStd^2*[1 2^(-distancesBetweenUEs(m)/9); 2^(-distancesBetweenUEs(m)/9) 1];    
    for n = 1:nbrOfSetups               
        %Generate random AP locations with uniform distribution
        APcellfree = squareLength*(rand(nbrOfAPs,1)+1i*rand(nbrOfAPs,1));        
        %Compute distances to the APs
        distances_k = abs(APcellfree - UElocation_k);
        distances_i = abs(APcellfree - UElocation_i);        
        %Compute large-scale fading based on the shadowing correalation in (2.17) and the model in (2.16)        
        shadowFadingRealizations = sqrtm(shadowFadingCov)*randn(2,nbrOfAPs);               
        beta_k = largescaleFading(distances_k) .* 10.^(shadowFadingRealizations(1,:)'/10);
        beta_i = largescaleFading(distances_i) .* 10.^(shadowFadingRealizations(2,:)'/10);
        beta_k_sorted = sort(beta_k,'descend');
        beta_i_sorted = sort(beta_i,'descend');
        
        strongestAPs_k = find(beta_k>=beta_k_sorted(8));
        strongestAPs_i = find(beta_i>=beta_i_sorted(8));        
        %Compute the variance value in (2.31) without the 1/N term
        variance(n,m) = sum(beta_k(strongestAPs_i))/(sum(sqrt(beta_k(strongestAPs_k))))^2;        
    end   
    %Compute the median with respect to the AP locations
    medianVariance(m) = median(variance(:,m));
    
    %Compute an interval that contains 90% of the realizations
    varianceSorted = sort(variance(:,m),'ascend');
    lowLimit(m) = medianVariance(m) - varianceSorted(round(0.05*nbrOfSetups));
    highLimit(m) = varianceSorted(round(0.95*nbrOfSetups)) - medianVariance(m);    
end
%Range of number of AP antennas
Nrange = 1:10;
%% Plot simulation results
figure;
hold on; box on;fontsize =28; LineWidth =3;
errorbar(Nrange,medianVariance(1)./Nrange,lowLimit(1)./Nrange,highLimit(1)./Nrange,'b--','LineWidth',LineWidth);
errorbar(Nrange,medianVariance(2)./Nrange,lowLimit(2)./Nrange,highLimit(2)./Nrange,'r-.','LineWidth',LineWidth);
plot(Nrange,(1/64)*ones(size(Nrange)),'k:','LineWidth',2);
xlabel('Number of antennas ($N$)','Interpreter','latex');
ylabel('Variance of favorable propagation','Interpreter','latex');
legend({'Cell-free: $\delta_{ki}=10$ m','Cell-free: $\delta_{ki}=100$ m','Reference case'},'Interpreter','latex','Location','NorthEast');
set(gca,'fontsize',fontsize);
ylim([0 0.5]);
Post_plot;