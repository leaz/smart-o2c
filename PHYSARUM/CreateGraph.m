function [Nodes] = CreateGraph()
% This function creates the structure describing the graph.
%
% Inputs:
% * none
%
% Outputs: 
% * Nodes : Empty structure that will contain the Graph's information
%
% Author: Aram Vroom - 2016
% Email:  aram.vroom@strath.ac.uk

%Create the Nodes structure
Nodes = struct('identifier',        [],... % Identifier of each node
               'parent',            [],... % Matrix containing each node's parent
               'links',             [],... % Matrix that holds the nodes' connections to each other
               'radius',            [],... % The radius of each connection
               'pressure_gradient', [],... % The pressure gradient over each connection
               'lengths',           [],... % The length of each connection
               'fluxes',            [],... % Matrix containing each connection's flux
               'probabilities',    [] ... % Matrix containing the probability for each connection
               ); 
 end

