function [SW_Distance,Alignment] = Smith_waterman(Sequence1, Sequence2, scorefunction, gappenalty)
% a simple implementation of the Smith-Waterman distance calculation.

if nargin < 4
    gappenalty = 2;
end

if nargin < 3
    % -3 for mismatch, +3 for match
    scorefunction = @(x,y) -3 + 6 * (x==y);
end
SWMatrix = zeros(length(Sequence1)+1,length(Sequence2)+1);
trace = zeros(length(Sequence1),length(Sequence2);
traces = [-1,-1;0,-1;-1,0;0,0];

for i = 1:length(Sequence1)
    for j = 1:length(Sequence2)
        values = [SWMatrix(i,j) + scorefunction(Sequence1(i),Sequence2(j)), SWMatrix(i+1,j)-gappenalty,SWMatrix(i,j+1)-gappenalty, 0];
        SWMatrix(i+1,j+1) = max(values(:));
        tracepos = find(SWMatrix(i+1,j+1) == values);
        % We just select one of them...
        trace(i,j) = tracepos(1);        
    end
end

SW_Distance = max(SWMatrix(:));
[maxposx,maxposy] = find(SWMatrix == SW_Distance);
tracepos = [maxposx(1)-1,maxposy(1)-1]
Seq1 = []; 
Seq2 = [];
Matching = [];
Seq1Char = Sequence1(tracepos(1));
Seq2Char = Sequence2(tracepos(2));
% Need to compute the first change in traces before the loop as this makes
% is not yet relevant for the alignment notation. 
tracechange = traces(trace(tracepos(1),tracepos(2)),:);         
MatchChar = '|';
while trace(tracepos(1),tracepos(2) ~= 4         
    Seq1 = [Seq1, Seq1Char];
    Seq2 = [Seq2, Seq2Char];        
    Matching = [Matching,MatchChar];
    tracepos = tracepos + tracechange;
    tracechange = traces(trace(tracepos(1),tracepos(2)),:);      
    if tracechange(1) ~= 0
        Seq1Char = '-';
    else
        Seq1Char = Sequence1(tracepos(1));
    end
    if tracechange(2) == 0
        Seq2Char = '-';
    else
        Seq2Char = Sequence2(tracepos(2));
    end
    if Seq1Char == Seq2Char        
        MatchChar = '|';
    else
        MatchChar = ' ';
    end    
end
inverted = length(Seq1):-1:1;
Alignment = [Seq1(inverted), '\n',Matching(inverted),'\n',Seq2(inverted)];
fprintf([Alignment, '\n']);

