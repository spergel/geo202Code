%% 
% GEO 202 Project Data
% Joshua Spergel
% Messing around with AQI data
%%
% Load in sample data
san_joanquin = readtable('san_joanquin.csv');
santa_barbara = readtable('santa_barbara.csv');
otay = readtable("otay.csv");
camp_pendleton = readtable("camp_pendleton.csv");
alameda = readtable("alameda.csv");
long_beach = readtable("south_long_beach.csv");
tulare = readtable("tulare.csv");

%% I put everything above in following table
load exportstuff.mat

pm25_san_joanquin=san_joanquin(:,1:2);%north
pm25_santa_barbara=santa_barbara(:,1:2);%south
pm25_otay=otay(:,1:2);%south
pm25_camp_pendleton=camp_pendleton(:,1:2);%south
pm25_alameda=alameda(:,1:2);%north
pm25_tulare=tulare(:,1:2);%south

pm25_san_joanquin.date=datetime(san_joanquin.date,'InputFormat','yyyy/MM/dd');
pm25_alameda.date=datetime(alameda.date,'InputFormat','yyyy/MM/dd');
pm25_santa_barbara.date=datetime(santa_barbara.date,'InputFormat','yyyy/MM/dd');
pm25_otay.date=datetime(otay.date,'InputFormat','yyyy/MM/dd');
pm25_camp_pendleton.date=datetime(camp_pendleton.date,'InputFormat','yyyy/MM/dd');
pm25_tulare.date=datetime(tulare.date,'InputFormat','yyyy/MM/dd');

%EVERYTHING ABOVE IS IN EXPORTSTUFF.MAT
%%
%setting up combined data
combined_dates = intersect(pm25_camp_pendleton.date,pm25_alameda.date);
combined_data  = zeros(length(combined_dates),7);

for i = 1:length(combined_dates) 

    if ~isempty(find(pm25_san_joanquin.date == combined_dates(i)))
        combined_data(i,1)=pm25_san_joanquin.pm25(pm25_san_joanquin.date == combined_dates(i));
    else
        combined_data(i,1) = NaN;
        
    end
    if ~isempty(find(pm25_santa_barbara.date == combined_dates(i)))
        combined_data(i,2)=pm25_santa_barbara.pm25(pm25_santa_barbara.date == combined_dates(i));
    else
        combined_data(i,2) = NaN;
    end
    if ~isempty(find(pm25_alameda.date == combined_dates(i)))
        combined_data(i,3)=pm25_alameda.pm25(pm25_alameda.date == combined_dates(i));
    else
        combined_data(i,3) = NaN;
    end
    if ~isempty(find(pm25_camp_pendleton.date == combined_dates(i)))
        combined_data(i,4)=pm25_camp_pendleton.pm25(pm25_camp_pendleton.date == combined_dates(i));
    else
        combined_data(i,4) = NaN;
    end
    if ~isempty(find(pm25_otay.date == combined_dates(i)))
        combined_data(i,5)=pm25_otay.pm25(pm25_otay.date == combined_dates(i));
    else
        combined_data(i,5) = NaN;
    end
    if ~isempty(find(pm25_tulare.date == combined_dates(i)))
        combined_data(i,6)=pm25_tulare.pm25(pm25_tulare.date == combined_dates(i));
    else
        combined_data(i,6) = NaN;
        
    end
    if ~isempty(find(time == combined_dates(i)))
        combined_data(i,7)=temp(time == combined_dates(i));
    else
        combined_data(i,7) = NaN;
    end
end

%%
%finding the moving means
movmeans  = zeros(length(combined_dates),2);
movmeans(:,1)=(movmean(combined_data(:,2),3) + movmean(combined_data(:,3),3)) / 2;
movmeans(:,2)=(movmean(combined_data(:,1),3) + movmean(combined_data(:,4),3) + movmean(combined_data(:,5),3) + movmean(combined_data(:,6),3)) / 4;
 %%
 %linear regression for North and South
mdl1 = fitlm(movmeans(:,1),combined_data(:,7));
mdl2 = fitlm(movmeans(:,2),combined_data(:,7));

 %%
%Making scatterplots for the air quality and time
plot(combined_dates,movmeans(:,1))
hold on
plot(combined_dates,movmeans(:,2),'r')
title("Air Quality over Time")
ylabel("Air Quality (pm25)")
xlabel("Time")
legend("North", "South")


figure()
scatter(movmean(movmeans(:,1),3), movmean(combined_data(:,7),3))
hold on

scatter(movmean(movmeans(:,2),3), movmean(combined_data(:,7),3), 'r')
title("Air Quality and Temperature")
ylabel("Temperature")
xlabel("Air Quality (pm25)")
legend("North", "South")
%%
%Plotting air quality and temperature in North and South
figure()
plot(mdl1)
title("Air Quality and Temperature(N)")
ylabel("Temperature")
xlabel("Air Quality (pm25)")
figure()
plot(mdl2)
title("Air Quality and Temperature(S)")
ylabel("Temperature")
xlabel("Air Quality (pm25)")
%%
%Modelling the temperature and time
mdl3 = fitlm(datenum(time),temp);
plot(mdl3)
title("Temperature over Time")
ylabel("Temperature")
xlabel("Time")