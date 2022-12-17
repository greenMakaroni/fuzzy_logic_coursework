% To remove the warning messages for using old syntax
 warning('off','fuzzy:general:warnDeprecation_Newfis') 
 warning('off','fuzzy:general:warnDeprecation_Addvar')
 warning('off','fuzzy:general:warnDeprecation_Addmf')
 warning('off','fuzzy:general:warnDeprecation_Evalfis')

% Clears the Command Window of clutter
clc

% Read in the data for the FIS
filename = ('rel_dummy_data.xlsx');
DummyData = xlsread(filename);

%---------------------------------------------------------------------------------------------------------------------%

                                               % Fuzzy Inference System "rel"

%---------------------------------------------------------------------------------------------------------------------%

a = newfis('rel');

a=addvar(a, 'input', 'Accuracy(%)', [0 100]);
a=addmf(a, 'input', 1, 'low', 'trimf', [0 0 45]);
a=addmf(a, 'input', 1, 'medium', 'trimf', [30 50 70]);
a=addmf(a, 'input', 1, 'high', 'trimf', [55 100 100])

a=addvar(a, 'input', 'Objectivity(%)', [0 100]);
a=addmf(a, 'input', 2, 'weak', 'trimf', [0 0 30]);
a=addmf(a, 'input', 2, 'medium', 'trimf', [20 50 80]);
a=addmf(a, 'input', 2, 'strong', 'trimf', [70 100 100]);

a=addvar(a, 'output', 'Reliability(A-F)', [0 7]);
a=addmf(a, 'output', 1, 'F', 'gauss2mf', [0.3 0 0.3 1]);
a=addmf(a, 'output', 1, 'E','gaussmf',[0.3 2]);
a=addmf(a, 'output', 1, 'D','gaussmf',[0.3 3]);
a=addmf(a, 'output', 1, 'C','gaussmf',[0.3 4]);
a=addmf(a, 'output', 1, 'B','gaussmf',[0.3 5]);
a=addmf(a, 'output', 1, 'A', 'gauss2mf', [0.3 6 0.3 7]);

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
xls_output_cols = ["G%d", "H%d", "I%d", "J%d", "K%d"]

% run all defuzzification methods at once
for i=1:5
    a.defuzzMethod = d_Methods(i);
    for j=1:size(DummyData,1)
         eval_source_reliability = evalfis([DummyData(j, 1), DummyData(j, 2)], a); 
         xlswrite('rel_dummy_data.xlsx', eval_source_reliability, 1, sprintf(xls_output_cols(i), j+1));
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
