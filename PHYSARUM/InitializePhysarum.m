function [InitializedInputs, ListNodes] = InitializePhysarum()
% This is the main file of the physarum solver. 
% It contains the logic for the algorithm and the solver parameters.
%
% Inputs:
% * 
%
% Outputs: 
% * Inputs         : Structure containing the PhysarumSolver inputs
%
% Author: Aram Vroom - 2016
% Email:  aram.vroom@strath.ac.uk

disp('Initializing Physarum...')

%Retrieve the user settings
PhysarumSettings



%Solver Parameters:
InitializedInputs = struct('LowThrust',                UserInputs.LowThrust,  ... %Set to 1 for low-thrust, 0 for high-thrust
                'LinearDilationCoefficient',          UserInputs.LinearDilationCoefficient,  ... %Linear dilation coefficient 'm'
                'EvaporationCoefficient',             UserInputs.EvaporationCoefficient,  ... %Evaporation coefficient 'rho'
                'GrowthFactor',                       UserInputs.GrowthFactor,  ... %Growth factor 'GF'
                'NumberOfAgents',                     UserInputs.NumberOfAgents,  ... %Number of virtual agents 'N_agents'
                'RamificationProbability',            UserInputs.RamificationProbability, ... %Probability of ramification 'p_ram'
                'RamificationWeight',                 UserInputs.RamificationWeight,  ... %Weight on ramification 'lambda'
                'MaximumRadiusRatio',                 UserInputs.MaximumRadiusRatio,  ... %Maximum radius of the veins
                'MinimumRadiusRatio',                 UserInputs.MinimumRadiusRatio,  ... %Minimum radius of the veins
                'StartingRadius',                     UserInputs.StartingRadius,  ... %The starting radius of the veins
                'RamificationAmount',                 UserInputs.RamificationAmount,  ... %The number of nodes initially generated for the ramification
                'PossibleDecisions',                  {PossibleDecisions},  ... %The list of possible targets
                'MaxConsecutiveRes',                  {MaxConsecutiveRes},  ... %Maximum number of consecutive resonance orbits to each target
                'MaxVisits',                          {MaxVisits},  ... %Maximum number of visits to each target
                'RootChar',                           UserInputs.RootChar,   ... %Characteristic of the root
                'Generations',                        UserInputs.Generations, ... %The number of generations
                'Viscosity',                          UserInputs.Viscosity, ... %The viscocity of the "fluid" 
                'DeterminingCharacteristic',          UserInputs.DeterminingCharacteristic, ... %The index of the determining characteristic in the 'characteristics' field
                'MinCommonNodesThres',                UserInputs.MinCommonNodesThres,  ... %The minimum number of nodes two decision sequences should have in common for a restart to occur
                'IfZeroLength',                       UserInputs.IfZeroLength, ... %Value assigned to the length if it's zero (to prevent flux = inf)
                'CostFunction',                       UserInputs.CostFunction,  ...
                'NodeAttributes',                     UserInputs.NodeAttributes, ...
                'ProjectDirectory',                   UserInputs.ProjectDirectory, ...
                'AttributeIDIndex',                   UserInputs.AttributeIDIndex, ... %Index of the attributes that determine the unique ID
                'IDBoundaries',                       UserInputs.IDBoundaries, ... %Boundaries for the attributes that determine the unique ID. Separate by ;
                'IDStepSize',                         UserInputs.IDStepSize ... %Stepsize for the attributes that determine the unique ID. Separate by ;
            );      
        
%Include Project Directory
addpath(InitializedInputs.ProjectDirectory);

%%%Error Checking%%%

%Display error if the vectors with number of possible decisions, max. number of consecutive
%resonance orbits & the max. number of visists is not equal
if ~(length(InitializedInputs.MaxConsecutiveRes)==length(InitializedInputs.PossibleDecisions))
    error('Check size of PossibleDecisions, MaxConsecutiveRes and MaxVisits')
end

%Check if the number of boundaries and stepsizes correspond
if ~(length(InitializedInputs.IDBoundaries)==length(InitializedInputs.IDStepSize))
    error('Check size of IDBoundaries and IDStepSize')
end

%%%Create a list of all the possible nodes%%%

%To do so, first create a list of all the possible characteristics
for i = 1:length(InitializedInputs.IDStepSize)
    possiblecharacteristics{i} = InitializedInputs.IDBoundaries(i,1):InitializedInputs.IDStepSize(i):InitializedInputs.IDBoundaries(i,2);
end
possiblecharacteristics = combvec(possiblecharacteristics{:})';

%Combine the possiblecharacteristics array into 1 string per row
for i = 1:length(possiblecharacteristics)
    temp = possiblecharacteristics(i,:);
    posscharrstr{i} = strrep(num2str(temp(:)'),' ','_');
end

%Replace any double __ by _, so that all the unique IDs are structured the
%same
while ~isempty(cell2mat(strfind(posscharrstr,'__')))
    posscharrstr = strrep(posscharrstr,'__','_');
end

%Create list of nodes that can be selected by looping over all the
%charactistics & decisions. Add double _ in between decision and
%characteristic to be able to identify the difference later.
for i = 1:(length(posscharrstr))
    for j = 1:length(PossibleDecisions)
        possdeccharvec(i,j) = strcat(PossibleDecisions(j),'__',posscharrstr{i});
    end
end
possdeccharvec = reshape(possdeccharvec, [1, numel(possdeccharvec)]);

%Add nodes that can be selected to the Inputs structure
InitializedInputs.PossibleListNodes = possdeccharvec;


%Create the list of nodes
ListNodes = CreateListNodes(InitializedInputs);

disp('Initialization Complete.')

end

