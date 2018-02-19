% This Source Code Form is subject to the terms of the Mozilla Public
% License, v. 2.0. If a copy of the MPL was not distributed with this
% file, You can obtain one at http://mozilla.org/MPL/2.0/. */
%
%------ Copyright (C) 2018 University of Strathclyde and Authors ------
%--------------- e-mail: smart@strath.ac.uk ---------------------------
%------------------- Authors: SMART developers team -------------------
function update = rbf_update(x, X, threshold)

% Check the condition for updating the RBF surrogate and output:
%    - the logical 1 if the condition is true
%    - the logical 0 if the condition is false.
%
% The condition is the following: if the distance distmin between the 
% current point and its closest neighbour is bigger than the minimun 
% distance between design sites, then update the surrogate with the 
% current point.
% This is necessary for radial basis functions as they don't provide an
% estimation of the mean squared error of the estimated response.
%
% Inputs:
%    - x: the current point
%    - X: the design sites
% Outputs:
%    - update: logical 1 (true) or 0 (false)
%
% Simone Alicino, 2012

nk = size(X,1);
dist = ones(1,nk);
for k = 1:nk
    dist(k) = norm(x - X(k,:));
end
distmin = min(dist);
update = (distmin > threshold);

end
