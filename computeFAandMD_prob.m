function [Pmiss,Pfa]=computeFAandMD_prob(Chance,H,M)
% Chance is vector of real present-absent PU
% H is detected present-absent vector from SU
% M is Number of symbol intervals that sensed
FalseAlarm=0;MissDet=0;Pmiss=0;Pfa=0;
for i = 1:M
   if Chance(i) == 0 && H(i) == 1
       FalseAlarm = FalseAlarm+1;
   elseif Chance(i) == 1 && H(i) == 0
       MissDet = MissDet+1;
   end
end
Pmiss = MissDet/M;
Pfa = FalseAlarm/M;
end