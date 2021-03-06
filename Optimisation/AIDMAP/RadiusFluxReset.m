function [ListNodes] = RadiusFluxReset(Inputs, ListNodes)
% This Source Code Form is subject to the terms of the Mozilla Public
% License, v. 2.0. If a copy of the MPL was not distributed with this
% file, You can obtain one at http://mozilla.org/MPL/2.0/. */
%
%-----------Copyright (C) 2018 University of Strathclyde and Authors-----------
%
%
%
%% RadiusFluxReset: This function handles the restarting of the Physarum algorithm by resetting the radii to their default values and updating the fluxes accordingly.
% 
%% Inputs:
% * Inputs          : Structure containing the PhysarumSolver inputs
% * ListNodes       : Structure containing the graph
% 
%% Outputs: 
% * ListNodes       : Structure containing the updated graph
% 
%% Author(s): Aram Vroom (2016)
% Email:  aram.vroom@strath.ac.uk

% Retrieve the node IDs
nodenames = fieldnames(ListNodes);

% Loop over all the nodes
for i = 1:length(nodenames)
    
    % Check if node has a parent (ignores the root)
    if ~isempty(ListNodes.(char(nodenames(i))).parent)  
    
        % Set the vein radii to their default value
        ListNodes.(char(nodenames(i))).radius = Inputs.StartingRadius*ones(1, length(ListNodes.(char(nodenames(i))).radius));
    
        % Recalculate the fluxes using the previously updated radius
        ListNodes.(char(nodenames(i))).flux = CalculateFlux(Inputs, ListNodes.(char(nodenames(i))));
    
    end

end
        

end

