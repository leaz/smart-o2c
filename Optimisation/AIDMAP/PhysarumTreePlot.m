function [] = PhysarumTreePlot(ListNodes)
%% PhysarumTreeplot: This function plots the tree generated by the AIDMAP algorithm
% 
%% Inputs:
% * ListNodes   : Structure containing all the nodes to be plotted
% 
%% Outputs: 
% * 
% 
%% Author: Aram Vroom (2016)
% Email:  aram.vroom@strath.ac.uk

% Retrieve the node names
nodenames = fieldnames(ListNodes);

% Sanity check
if (length(fieldnames(ListNodes))==1)
    disp('No chains have been found');
    return
end

% Loop over all the nodes
for i = 2:length(nodenames)
    
    % Find each node's parent
    treeplotnodes(i) = strmatch(char(ListNodes.(char(nodenames(i))).parent), nodenames, 'exact');
end

% Plot the tree
figure
treeplot(treeplotnodes);

% Find the x & y locations of each node
[x, y] = treelayout(treeplotnodes);
x = x';
y = y';

% Obtain the current axis size
ax = axis;

% Set the node_ID as label for each node
text(x(:, 1), y(:, 1), nodenames, 'FontSize', 5/(ax(4)-ax(3)), 'VerticalAlignment', 'bottom', ...
    'HorizontalAlignment', 'right', 'Interpreter', 'none');

% Remove labels & axis ticks
set(gca, 'XTick', [])
set(gca, 'YTick', [])
set(gca, 'xcolor', 'w', 'ycolor', 'w', 'xtick', [], 'ytick', []);
xlabel('')
ylabel('')

end

