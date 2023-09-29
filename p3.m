%% BME 599.020 HW 1 Problem 3 Slice selection
% Based on: http://mrsrl.stanford.edu/~brian/bloch/
clear; close all; clc;

%% part 2
close all;

gammaBar = 42.58; % MHz/T
T1 = 1000; % ms
T2 = 100; % ms
G = 18.8 * 1e-3 * 1e4 * 1e-2; % [mT/m] => [T/m] => [G/m] => [G/cm]

t = 0:5e-6:2e-3; % s
z = -20:.1:20; % mm

% Make sinc pulse with TBW zero crossings
TBW = 8;
myRFpulse = sinc(TBW/2*(1000*t-1));

% Scale RF pulse to get 90 degree flip angle
scaleFactor = 90 / 360 / gammaBar / sum(myRFpulse) * 1e3;
myRFpulse90 = scaleFactor * myRFpulse;

% Simulate slice profile
df = 200;
[Msig90,M90] = sliceprofile([myRFpulse90, 0*myRFpulse90],...
                            [G*ones(size(t)), -0.5*G*ones(size(t))],...
                            [t, t+2e-3],...
                            T1,T2,z,df);

% Plot RF waveform
figure; plot(t*1000,myRFpulse90); title('RF pulse');
xlabel('Time (ms)'); ylabel('B1 strength (uT)');

% Plot gradient waveform
t_grad = -104e-3:1e-3:2104e-3; % ms
t_grad = [t_grad t_grad+2208e-3];
slew = 180; % mT/m/ms
G_mTm = 18.8; % mT/m
ramp = slew*(0:1e-3:104e-3);
grad = [ramp, G_mTm*ones(1,2000-1), -ramp+G_mTm];
grad = [grad -0.5*grad];
figure; plot(t_grad,grad); title('Slice select gradient');
xlabel('Time (ms)'); ylabel('Gradient strength (mT/m)');

% Plot Mx, My, Mz relative to position
figure;
plot(z,M90(1,:),'b-',...
     z,M90(2,:),'r--',...
     z,M90(3,:),'g-.');
title('Magnetization vector components')
legend('M_x','M_y','M_z');
xlabel('z position (mm)');
ylabel('Magnetization');
axis([min(z) max(z) -1 1]);
grid on;

% Plot Mxy relative to position
figure;
subplot(2,1,1);
plot(z,abs(Msig90));
xlabel('Position (mm)');
ylabel('Magnitude');
grid on;

subplot(2,1,2);
plot(z,angle(Msig90));
xlabel('Position (mm)');
ylabel('Phase');
grid on;
sgtitle('Transverse signal M_{xy}')

%% part 3: alpha = 30
close all;

% Make sinc pulse with TBW zero crossings
TBW = 8;
myRFpulse = sinc(TBW/2*(1000*t-1));

% Scale RF pulse to get alpha degree flip angle
alpha = 30;
scaleFactor = alpha / 360 / gammaBar / sum(myRFpulse) * 1e3;
myRFpulse30 = scaleFactor * myRFpulse;

% Simulate slice profile
[Msig30,M30] = sliceprofile([myRFpulse30, 0*myRFpulse30],...
                            [G*ones(size(t)), -0.5*G*ones(size(t))],...
                            [t, t+2e-3],...
                            T1,T2,z,df);
% Plot RF waveform
figure; plot(t*1000,myRFpulse30); title('RF pulse');
xlabel('Time (ms)'); ylabel('B1 strength (uT)');

% Plot Mx, My, Mz relative to position
figure;
plot(z,M30(1,:),'b-',...
     z,M30(2,:),'r--',...
     z,M30(3,:),'g-.');
title('Magnetization vector components')
legend('M_x','M_y','M_z');
xlabel('z position (mm)');
ylabel('Magnetization');
axis([min(z) max(z) -1 1]);
grid on;

% Plot Mxy relative to position
figure;
subplot(2,1,1);
plot(z,abs(Msig30));
xlabel('Position (mm)');
ylabel('Magnitude');
grid on;

subplot(2,1,2);
plot(z,angle(Msig30));
xlabel('Position (mm)');
ylabel('Phase');
grid on;
sgtitle('Transverse signal M_{xy}')

%% part 3: alpha = 10
close all;

% Make sinc pulse with TBW zero crossings
TBW = 8;
myRFpulse = sinc(TBW/2*(1000*t-1));

% Scale RF pulse to get alpha degree flip angle
alpha = 10;
scaleFactor = alpha / 360 / gammaBar / sum(myRFpulse) * 1e3;
myRFpulse10 = scaleFactor * myRFpulse;

% Simulate slice profile
[Msig10,M10] = sliceprofile([myRFpulse10, 0*myRFpulse10],...
                            [G*ones(size(t)), -0.5*G*ones(size(t))],...
                            [t, t+2e-3],...
                            T1,T2,z,df);
% Plot RF waveform
figure; plot(t*1000,myRFpulse10); title('RF pulse');
xlabel('Time (ms)'); ylabel('B1 strength (uT)');

% Plot Mx, My, Mz relative to position
figure;
plot(z,M10(1,:),'b-',...
     z,M10(2,:),'r--',...
     z,M10(3,:),'g-.');
title('Magnetization vector components')
legend('M_x','M_y','M_z');
xlabel('z position (mm)');
ylabel('Magnetization');
axis([min(z) max(z) -1 1]);
grid on;

% Plot Mxy relative to position
figure;
subplot(2,1,1);
plot(z,abs(Msig10));
xlabel('Position (mm)');
ylabel('Magnitude');
grid on;

subplot(2,1,2);
plot(z,angle(Msig10));
xlabel('Position (mm)');
ylabel('Phase');
grid on;
sgtitle('Transverse signal M_{xy}')

%% part 3: compare 90 and 10 degree slice profiles
close all;

figure;
subplot(2,1,1);
plot(z,abs(Msig90),z,abs(Msig10));
legend('90 degrees','10 degrees')
xlabel('Position (mm)');
ylabel('Magnitude');
grid on;

subplot(2,1,2);
plot(z,angle(Msig90),z,angle(Msig10));
legend('90 degrees','10 degrees')
xlabel('Position (mm)');
ylabel('Phase');
grid on;
sgtitle('Transverse signal M_{xy} for different flip angles')

%% part 3: compare simulated and Fourier Transformed slice profiles
close all;

figure;
subplot(2,1,1);
plot(z,abs(Msig90),z,abs(fftshift(fft(myRFpulse90))));
title('90 degrees')
legend('Simulation','Fourier transform')
xlabel('Position (mm)');
ylabel('Magnitude');
grid on;

subplot(2,1,2);
plot(z,abs(Msig10),z,abs(fftshift(fft(myRFpulse10))));
title('10 degrees')
legend('90 degrees','10 degrees')
xlabel('Position (mm)');
ylabel('Magnitude');
grid on;
sgtitle('Simulated vs FT slice profile for 90 and 10 degrees, T2 = 100 ms')

%% part 3: changing T2 to 2 ms
T2 = 2; % ms
[Msig90,M90] = sliceprofile([myRFpulse90, 0*myRFpulse90],...
                            [G*ones(size(t)), -0.5*G*ones(size(t))],...
                            [t, t+2e-3],...
                            T1,T2,z,df);
[Msig10,M10] = sliceprofile([myRFpulse10, 0*myRFpulse10],...
                            [G*ones(size(t)), -0.5*G*ones(size(t))],...
                            [t, t+2e-3],...
                            T1,T2,z,df);
close all;

figure;
subplot(2,1,1);
plot(z,abs(Msig90),z,abs(fftshift(fft(myRFpulse90))));
title('90 degrees')
legend('Simulation','Fourier transform')
xlabel('Position (mm)');
ylabel('Magnitude');
grid on;

subplot(2,1,2);
plot(z,abs(Msig10),z,abs(fftshift(fft(myRFpulse10))));
title('10 degrees')
legend('Simulation','Fourier transform')
xlabel('Position (mm)');
ylabel('Magnitude');
grid on;
sgtitle('Simulated vs FT slice profile for 90 and 10 degrees, T2 = 2 ms')

%% part 4: remove the rephasing gradient
close all;

gammaBar = 42.58; % MHz/T
T1 = 1000; % ms
T2 = 100; % ms
G = 18.8 * 1e-3 * 1e4 * 1e-2; % [mT/m] => [T/m] => [G/m] => [G/cm]

t = 0:5e-6:2e-3; % s
z = -20:.1:20; % mm

% Make sinc pulse with TBW zero crossings
TBW = 8;
myRFpulse = sinc(TBW/2*(1000*t-1));

% Scale RF pulse to get 90 degree flip angle
scaleFactor = 90 / 360 / gammaBar / sum(myRFpulse) * 1e3;
myRFpulse90 = scaleFactor * myRFpulse;

% Simulate slice profile
df = 200;
[Msig90,M90] = sliceprofile(myRFpulse90,...
                            G*ones(size(t)),...
                            t,...
                            T1,T2,z,df);

% Plot Mx, My, Mz relative to position
figure;
plot(z,M90(1,:),'b-',...
     z,M90(2,:),'r--',...
     z,M90(3,:),'g-.');
title('Magnetization vector components without rephasing gradient')
legend('M_x','M_y','M_z');
xlabel('z position (mm)');
ylabel('Magnetization');
axis([min(z) max(z) -1 1]);
grid on;

% Plot Mxy relative to position
figure;
subplot(2,1,1);
plot(z,abs(Msig90));
xlabel('Position (mm)');
ylabel('Magnitude');
grid on;

subplot(2,1,2);
plot(z,angle(Msig90));
xlabel('Position (mm)');
ylabel('Phase');
grid on;
sgtitle('Transverse signal M_{xy} without rephasing gradient')

%% part 5: Simultaneous Multi-Slice excitation
close all;

gammaBar = 42.58; % MHz/T
T1 = 1000; % ms
T2 = 100; % ms
G = 18.8 * 1e-3 * 1e4 * 1e-2; % [mT/m] => [T/m] => [G/m] => [G/cm]

t = 0:5e-6:2e-3; % s
z = -60:.1:60; % mm

% Make sinc pulse with TBW zero crossings
TBW = 8;
myRFpulse = sinc(TBW/2*(1000*t-1));

% Scale RF pulse to get 90 degree flip angle
scaleFactor = 90 / 360 / gammaBar / sum(myRFpulse) * 1e3;
myRFpulse90 = scaleFactor * myRFpulse;

% Add modulated RF pulses
slice_centers = [-50 -25 25 50]; % mm
Hz_centers = (gammaBar*1e6) * (18.8*1e-3) * (slice_centers*1e-3); % [MHz/T]*[mT/m]*[mm]
carriers = cos(2*pi*Hz_centers'*t);
for n = 1:length(slice_centers)
    myRFpulse90 = myRFpulse90 + myRFpulse90.*carriers(n,:);
end

% Simulate slice profile
df = 0;
[Msig90,M90] = sliceprofile([myRFpulse90, 0*myRFpulse90],...
                            [G*ones(size(t)), -0.5*G*ones(size(t))],...
                            [t, t+2e-3],...
                            T1,T2,z,df);

% Plot RF waveform
figure; plot(t*1000,myRFpulse90); title('RF pulse');
xlabel('Time (ms)'); ylabel('B1 strength (uT)');

% Plot gradient waveform
t_grad = -104e-3:1e-3:2104e-3; % ms
t_grad = [t_grad t_grad+2208e-3];
slew = 180; % mT/m/ms
G_mTm = 18.8; % mT/m
ramp = slew*(0:1e-3:104e-3);
grad = [ramp, G_mTm*ones(1,2000-1), -ramp+G_mTm];
grad = [grad -0.5*grad];
figure; plot(t_grad,grad); title('Slice select gradient');
xlabel('Time (ms)'); ylabel('Gradient strength (mT/m)');

% Plot Mx, My, Mz relative to position
figure;
plot(z,M90(1,:),'b-',...
     z,M90(2,:),'r--',...
     z,M90(3,:),'g-.');
title('Magnetization vector components')
legend('M_x','M_y','M_z');
xlabel('z position (mm)');
ylabel('Magnetization');
axis([min(z) max(z) -1 1]);
grid on;

% Plot Mxy relative to position
figure;
subplot(2,1,1);
plot(z,abs(Msig90));
xlabel('Position (mm)');
ylabel('Magnitude');
grid on;

subplot(2,1,2);
plot(z,angle(Msig90));
xlabel('Position (mm)');
ylabel('Phase');
grid on;
sgtitle('Transverse signal M_{xy} for SMS excitation')