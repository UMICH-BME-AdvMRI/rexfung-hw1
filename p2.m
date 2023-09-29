%% BME 599.020 HW 1 Problem 2 Balanced and Spoiled SSFP
% Based on: http://mrsrl.stanford.edu/~brian/bloch/

%% Part a) Frequency response of bSSFP
T1 = 600;	% ms.
T2 = 100;	% ms.
TEs = [2.5, 5, 10];	% ms.
TRs = [5, 10, 20];	% ms.
flip = pi/3;

df = -100:100; 	%Hz

Sig = zeros(length(df),length(TEs));

for n=1:length(TEs)
    for k=1:length(df)
		[Msig,Mss] = sssignal(flip,T1,T2,TEs(n),TRs(n),df(k));
		Sig(k,n) = Mss(1) + 1i*Mss(2);
    end
end

% ===== Plot the Frequency Response ======

subplot(2,1,1);
plot(df,abs(Sig),'LineWidth',2);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
legend('TE = 2.5, TR = 5', 'TE = 5, TR = 10', 'TE = 10, TR = 20');


subplot(2,1,2);
plot(df,angle(Sig),'LineWidth',2);
xlabel('Frequency (Hz)');
ylabel('Phase (radians)');
axis([min(df) max(df) -pi pi]);
grid on;
legend('TE = 2.5, TR = 5', 'TE = 5, TR = 10', 'TE = 10, TR = 20');

%% Part b) Adding gradient spoiler to make FLASH sequence

df = 0;		% Hz off-resonance.
T1 = 1000;	% ms.
T2 = 100;	% ms.
TE = 5;		% ms.
TR = 10;    % ms.
flip = pi/18;	% radians.

%% part i
dephaseCycles = 2;
[Msig,Mss] = gresignal(flip,T1,T2,TE,TR,df,dephaseCycles,0);

%% part ii
dephaseCycles = [1,2,4,8];
Msig = zeros(4,1); Mss = zeros(4,3);
for n = 1:length(dephaseCycles)
    [Msig(n,:),Mss(n,:)] = gresignal(flip,T1,T2,TE,TR,df,dephaseCycles(n),0);
end

figure;
subplot(2,1,1);
scatter(dephaseCycles,abs(Msig),'x','LineWidth',2)
xlabel('Number of dephase cycles'); ylabel('Transverse signal magnitude');

subplot(2,1,2);
scatter(dephaseCycles,angle(Msig),'x','LineWidth',2)
xlabel('Number of dephase cycles'); ylabel('Transverse signal phase');
%% part iii
% rfPhases = (0:pi/1000:pi)';
% Msig = zeros(length(rfPhases),1); Mss = zeros(length(rfPhases),3);
% 
% for n = 1:length(rfPhases)
%     [Msig(n,:),Mss(n,:)] = gresignal(flip,T1,T2,TE,TR,df,2,rfPhases(n));
% end
% 
% figure;
% subplot(2,1,1);
% plot(rfPhases,abs(Msig),'LineWidth',2)
% xlabel('RF phase'); ylabel('Transverse signal magnitude');
% 
% subplot(2,1,2);
% plot(rfPhases,angle(Msig),'LineWidth',2)
% xlabel('RF phase'); ylabel('Transverse signal phase');
incs = (0:1/180:1)*pi;
Nex = 200;
Nf = 100;

Msig = zeros(length(incs),1);
Mss = zeros(length(incs),3,Nf);

for m = 1:length(incs)
    [Msig(m,:),Mss(m,:,:)] = spgrsignal(flip,T1,T2,TE,TR,df,Nex,incs(m));
end

% ===== Plot the Results ======
figure;
subplot(2,1,1);
plot(incs*180/pi,abs(Msig));
xlabel('RF phase increment (degrees)');
ylabel('Magnitude');
grid on;

subplot(2,1,2);
plot(incs*180/pi,angle(Msig));
xlabel('RF phase increment (degrees)');
ylabel('Phase');
grid on;