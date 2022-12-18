% To remove the warning messages for using old syntax
 warning('off','fuzzy:general:warnDeprecation_Newfis') 
 warning('off','fuzzy:general:warnDeprecation_Addvar')
 warning('off','fuzzy:general:warnDeprecation_Addmf')
 warning('off','fuzzy:general:warnDeprecation_Evalfis')

% Clears the Command Window of clutter
clc

% Read in the data for the FIS
filename = ('../rel_test_data.xlsx');
DummyData = xlsread(filename);

%---------------------------------------------------------------------------------------------------------------------%

                                               % Fuzzy Inference System "rel"

%---------------------------------------------------------------------------------------------------------------------%

a = newfis('rel');

a=addvar(a, 'input', 'Accuracy(%)', [0 100]);
a=addmf(a, 'input', 1, 'low', 'gbellmf',[23.5502645502645 6.36 16]);
a=addmf(a, 'input', 1, 'medium', 'gbellmf',[10 2.5 50]);
a=addmf(a, 'input', 1, 'high', 'gbellmf',[24 6 84])

a=addvar(a, 'input', 'Objectivity(%)', [0 100]);
a=addmf(a, 'input', 2, 'weak', 'gbellmf',[17.44 3.406 17.44]);
a=addmf(a, 'input', 2, 'medium','gbellmf',[20 10 55]);
a=addmf(a, 'input', 2, 'strong', 'gbellmf',[14 3.5 94]);

a=addvar(a, 'output', 'Reliability(A-F)', [0 7]);
a=addmf(a, 'output', 1, 'F', 'gbellmf',[0.824074074074074 3.12 0]);
a=addmf(a, 'output', 1, 'E', 'gbellmf',[0.5 2.5 2]);
a=addmf(a, 'output', 1, 'D', 'gbellmf',[0.5 2.5 3]);
a=addmf(a, 'output', 1, 'C', 'gbellmf',[0.5 2.5 4]);
a=addmf(a, 'output', 1, 'B', 'gbellmf',[0.5 2.5 5]);
a=addmf(a, 'output', 1, 'A', 'gbellmf',[0.67 4.24 6.70444444444444]);

%---------------------------------------------------------------------------------------------------------------------%
 % RULES

 rule1 = [3 3 6 1 1];
 rule2 = [3 2 5 1 1];
 rule3 = [3 1 4 1 1];
 rule4 = [2 3 5 1 1];
 rule5 = [2 2 4 1 1];
 rule6 = [2 1 3 1 1];
 rule7 = [1 3 3 1 1];
 rule8 = [1 2 2 1 1];
 rule9 = [1 1 1 1 1];

 %rule base
ruleListA = [rule1; rule2; rule3; rule4; rule5;
    rule6; rule7; rule8; rule9;];

% Add the rules to the FIS
a = addrule(a,ruleListA);

% Print the rules to the workspace
rule = showrule(a)

% defuzzification methods
d_Methods = ["centroid", "bisector", "mom", "som", "lom"]

% excel output columns
xls_output_cols = ["A%d", "B%d", "C%d", "D%d", "E%d"]

% run all defuzzification methods at once
for i=1:5
    a.defuzzMethod = d_Methods(i);
    for j=1:size(DummyData,1)
         eval_source_reliability = evalfis([DummyData(j, 1), DummyData(j, 2)], a); 
         xlswrite('rel_gbellmf_output.xlsx', eval_source_reliability, 1, sprintf(xls_output_cols(i), j+1));
         fprintf( ...
             '%d) In(1): %.2f, In(2) %.2f, => Out: %.2f \n\n', ...
             j, ...
             DummyData(j, 1), ...
             DummyData(j, 2), ...
             eval_source_reliability);  
    end
end

 figure(1)
 subplot(4,1,1), plotmf(a, 'input', 1)
 subplot(4,1,2), plotmf(a, 'input', 2)
 subplot(4,1,4), plotmf(a, 'output', 1)
