% To remove the warning messages for using old syntax
warning('off','fuzzy:general:warnDeprecation_Newfis') 
warning('off','fuzzy:general:warnDeprecation_Addvar')
warning('off','fuzzy:general:warnDeprecation_Addmf')
warning('off','fuzzy:general:warnDeprecation_Evalfis')

% Clears the Command Window of clutter
clc

% Read in the data for the FIS
filename = ('NATO_STANAG_2511.xlsx');

DummyData = xlsread(filename);

%---------------------------------------------------------------------------------------------------------------------%


                                               % Fuzzy Inference System "cred"

                                              
%---------------------------------------------------------------------------------------------------------------------%
a = newfis('cred');

a=addvar(a, 'input','Validations(0-30)', [0 30]);
a=addmf(a, 'input', 1, 'low', 'trapmf', [0 0 10 15]);
a=addmf(a, 'input', 1, 'medium', 'trimf', [10 15 20]);
a=addmf(a, 'input', 1, 'high', 'trapmf', [15 20 30 30]);

a=addvar(a, 'input', 'Reliability(A-F)', [0 6]);
a=addmf(a, 'input', 2, 'A', 'gauss2mf', [0.3 6 0.3 7]);
a=addmf(a, 'input', 2, 'B', 'gaussmf', [0.3 5]);
a=addmf(a, 'input', 2, 'D', 'gaussmf', [0.3 4]);
a=addmf(a, 'input', 2, 'C', 'gaussmf', [0.3 3]);
a=addmf(a, 'input', 2, 'E', 'gaussmf', [0.3 2]);
a=addmf(a, 'input', 2, 'F', 'gauss2mf', [0.3 0 0.3 1]);

a=addvar(a, 'input', 'Gut(%)', [0 100]);
a=addmf(a, 'input', 3, 'negative', 'trimf', [0 0 50]);
a=addmf(a, 'input', 3, 'neutral', 'trimf', [35 50 65]);
a=addmf(a, 'input', 3, 'positive', 'trimf', [50 100 100]);

a=addvar(a,'output','Credibility(1-6)', [1 6]);
a=addmf(a, 'output', 1, '1', 'gauss2mf', [0.3 0 0.3 1]);
a=addmf(a, 'output', 1, '2', 'gaussmf', [0.3 2]);
a=addmf(a, 'output', 1, '3', 'gaussmf',[0.3 3]);
a=addmf(a, 'output', 1, '4', 'gaussmf',[0.3 4]);
a=addmf(a, 'output', 1, '5', 'gaussmf',[0.3 5]);
a=addmf(a, 'output', 1, '6', 'gauss2mf',[0.3 6 0.3 7]);

%---------------------------------------------------------------------------------------------------------------------%
 % RULES

 rule1 = [-3 1 0 1 0.5 1];
 rule2 = [-3 2 0 2 0.5 1];
 rule3 = [-3 3 0 3 0.5 1];
 rule4 = [-3 4 0 4 0.5 1];
 rule5 = [-3 5 0 5 0.5 1];
 rule6 = [-3 6 0 6 0.5 1];
 rule7 = [3 0 3 1 1 1];
 rule8 = [3 0 2 2 1 1];
 rule9 = [3 0 1 3 1 1];
 rule10 = [1 0 1 6 1 1];
 rule11 = [1 0 2 5 1 1];
 rule12 = [1 0 3 4 1 1];
 rule13 = [3 1 0 1 1 2];

 %rule base
ruleListA = [rule1; rule2; rule3; rule4; rule5;
    rule6; rule7; rule8; rule9; rule10; rule11; rule12; rule13;];

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
        eval_information_credibility = evalfis([DummyData(i, 8), DummyData(i, 6), DummyData(i, 9)], a); 
        xlswrite('NATO_STANAG_2511.xlsx', eval_information_credibility, 1, sprintf("K%d", i+1));
        fprintf( ...
            '%d) In(1): %.2f, In(2) %.2f, In(3) %.2f, => Out: %.2f \n\n', ...
            j, ...
            DummyData(i, 8), ...
            DummyData(i, 6), ...
            DummyData(i, 9), ...
            eval_information_credibility);   
end

figure(1)
subplot(4,1,1), plotmf(a, 'input', 1)
subplot(4,1,2), plotmf(a, 'input', 2)
subplot(4,1,3), plotmf(a, 'input', 3)
subplot(4,1,4), plotmf(a, 'output', 1)





