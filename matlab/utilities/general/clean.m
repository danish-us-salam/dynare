function clean()

% Copyright (C) 2014 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

a = dir('*.mod');

for i = 1:length(a)
    [junk,basename,extension] = fileparts(a(i).name);
    delete([basename '.m']);
    delete([basename '.log']);
    rmdir(basename,'s');
    if exist([basename '_steadystate.m'])
        movefile([basename '_steadystate.m'],['protect_' basename '_steadystate.m']);
    end
    delete([basename '_*'])
    if exist(['protect_' basename '_steadystate.m'])
        movefile(['protect_' basename '_steadystate.m'],[basename '_steadystate.m']);
    end
end