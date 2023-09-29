% 
%	function [Msig,Mss] = gresignal(flip,T1,T2,TE,TR,dfreq)
% 
%	Calculate the steady state gradient-spoiled signal at TE for repeated
%	excitations given T1,T2,TR,TE in ms.  dfreq is the resonant
%	frequency in Hz.  flip is in radians. dephaseCycles is the number of
%	cycles of dephasing per voxel. rfPhase is the phase of the RF pulse


function [Msig,Mss] = gresignal(flip,T1,T2,TE,TR,dfreq,dephaseCycles,rfPhase)

    N = 100;
    M = zeros(3,N);
    phi = ((1:N)/N-0.5 ) * 2*pi * dephaseCycles;
    
    
    for k=1:N
	    [M1sig,M1] = gssignal(flip,T1,T2,TE,TR,dfreq,phi(k),rfPhase);
	    M(:,k)=M1;
    end
    
    Mss = mean(M')';
    Msig = Mss(1) + 1i*Mss(2);

end