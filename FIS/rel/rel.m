% To remove the warning messages for using old syntax
% warning('off','fuzzy:general:warnDeprecation_Newfis') 
% warning('off','fuzzy:general:warnDeprecation_Addvar')
% warning('off','fuzzy:general:warnDeprecation_Addmf')
% warning('off','fuzzy:general:warnDeprecation_Evalfis')

% Clears the Command Window of clutter
clc

% Read in the data for the FIS
filename = ('rel_dummy_data.xlsx');
DummyData = xlsread(filename);

%---------------------------------------------------------------------------------------------------------------------%



                                               % Fuzzy Inference System "rel"

                                               

%---------------------------------------------------------------------------------------------------------------------%

a = newfis('rel');

a=addvar(a, 'input', 'Accuracy (%)', [0 100]);
a=addmf(a, 'input', 1, 'insufficient', 'trimf', [0 0 45]);
a=addmf(a, 'input', 1, 'poor', 'trimf', [30 50 70]);
a=addmf(a, 'input', 1, 'sufficient', 'trimf', [55 100 100])

a=addvar(a, 'output', 'Reliability(F-A)', [0 7]);
a=addmf(a, 'output', 1, 'F', 'gauss2mf', [0.3 0 0.3 1]);
a=addmf(a, 'output', 1, 'E','gaussmf',[0.3 2]);
a=addmf(a, 'output', 1, 'D','gaussmf',[0.3 3]);
a=addmf(a, 'output', 1, 'C','gaussmf',[0.3 4]);
a=addmf(a, 'output', 1, 'B','gaussmf',[0.3 5]);
a=addmf(a, 'output', 1, 'A', 'gauss2mf', [0.3 6 0.3 7]);

a=addvar(a,'input', 'Gut(%)', [0 100]);
a=addmf(a, 'input', 2,'negative', 'trimf',[0 0 50]);
a=addmf(a, 'input', 2,'neutral', 'trimf',[35 50 65]);
a=addmf(a, 'input', 2,'positive', 'trimf',[50 100 100]);

a=addvar(a, 'input', 'Objectivity(%)', [0 100]);
a=addmf(a, 'input', 3, 'weak', 'trimf', [0 0 30]);
a=addmf(a, 'input', 3, 'medium', 'trimf', [20 50 80]);
a=addmf(a, 'input', 3, 'strong', 'trimf', [70 100 100]);

%---------------------------------------------------------------------------------------------------------------------%
 % RULES

 rule1 = [3 0 3 6 1 1];
 rule2 = [2 -3 2 3 1 1];
 rule3 = [2 -1 2 4 1 1];
 rule4 = [2 -3 1 2 1 1];
 rule5 = [3 0 2 5 1 1];
 rule6 = [3 0 1 4 1 1];
 rule7 = [2 -1 3 4 1 1];
 rule8 = [2 -3 3 3 1 1];
 rule9 = [2 3 1 3 1 1];
 rule10 = [1 -3 0 1 1 1];
 rule11 = [1 3 -3 1 1 1];
 rule12 = [1 3 2 2 1 1];
 rule13 = [1 3 3 3 1 1];

 %rule base
ruleListA = [rule1; rule2; rule3; rule4; rule5;
    rule6; rule7; rule8; rule9; rule10;
    rule11; rule12; rule13;];

% Add the rules to the FIS
a = addrule(a,ruleListA);

% Print the rules to the workspace
rule = showrule(a)

%defuzzification methods
a.defuzzMethod = 'centroid';
%a.defuzzMethod = 'bisector';
%a.defuzzMethod = 'mom';
%a.defuzzMethod = 'som';
%a.defuzzMethod = 'lom';

for i=1:size(DummyData,1)
        eval_source_reliability = evalfis([DummyData(i, 1), DummyData(i, 2), DummyData(i, 3)], a); 
        xlswrite('cred_dummy_data.xlsx', eval_source_reliability, 1, sprintf('B%d',i+1));
end

figure(1)
subplot(4,1,1), plotmf(a, 'input', 1)
subplot(4,1,2), plotmf(a, 'input', 2)
subplot(4,1,3), plotmf(a, 'input', 3)
subplot(4,1,4), plotmf(a, 'output', 1)
