function A = mpower(B,C) % --*-- Unitary tests --*--

%@info:
%! @deftypefn {Function File} {@var{A} =} mpower (@var{B},@var{C})
%! @anchor{@dseries/mpower}
%! @sp 1
%! Overloads the mpower method for the Dynare time series class (@ref{dseries}).
%! @sp 2
%! @strong{Inputs}
%! @sp 1
%! @table @ @var
%! @item B
%! Dynare time series object instantiated by @ref{dseries}, with T observations and N variables.
%! @item C
%! Real scalar or a dseries object with T observations and N variables.
%! @end table
%! @sp 1
%! @strong{Outputs}
%! @sp 1
%! @table @ @var
%! @item A
%! dseries object with T observations and N variables.
%! @end deftypefn
%@eod:

% Copyright (C) 2013 Dynare Team
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

if isdseries(B) && isnumeric(C) && isreal(C) && isscalar(C)
    A = dseries();
    A.freq = B.freq;
    A.init = B.init;
    A.dates = B.dates;
    A.nobs = B.nobs;
    A.vobs = B.vobs;
    A.name = cell(A.vobs,1);
    A.tex = cell(A.vobs,1);
    for i=1:A.vobs
        A.name(i) = {['power(' B.name{i} ',' num2str(C) ')']};
        A.tex(i) = {[B.tex{i} '^' num2str(C) ]};
    end
    A.data = B.data.^C;
    return
end

if isdseries(B) && isdseries(C)
    if isequal(B.nobs,C.nobs) && isequal(B.vobs,C.vobs) && isequal(B.freq,C.freq)
        A = dseries();
        A.freq = B.freq;
        A.init = B.init;
        A.dates = B.dates;
        A.nobs = B.nobs;
        A.vobs = B.vobs;
        A.name = cell(A.vobs,1);
        A.tex = cell(A.vobs,1);
        for i=1:A.vobs
            A.name(i) = {['power(' B.name{i} ',' C.name{i} ')']};
            A.tex(i) = {[B.tex{i} '^{' C.tex{i} '}']};
        end
        A.data = B.data.^C.data;
    else
        error('dseries::mpower: If both input arguments are dseries objects, they must have the same numbers of variables and observations and common frequency!')
    end
    return
end

error(['dseries::mpower: Wrong calling sequence!'])

%@test:1
%$ % Define a datasets.
%$ A = rand(10,2); B = randn(10,2);
%$
%$ % Define names
%$ A_name = {'A1';'A2'}; B_name = {'B1';'B2'};
%$
%$
%$ % Instantiate a time series object.
%$ try
%$    ts1 = dseries(A,[],A_name,[]);
%$    ts2 = dseries(B,[],B_name,[]);
%$    ts3 = ts1^ts2;
%$    t = 1;
%$ catch
%$    t = 0;
%$ end
%$
%$ if t(1)
%$    t(2) = dyn_assert(ts3.vobs,2);
%$    t(3) = dyn_assert(ts3.nobs,10);
%$    t(4) = dyn_assert(ts3.data,A.^B,1e-15);
%$    t(5) = dyn_assert(ts3.name,{'power(A1,B1)';'power(A2,B2)'});
%$    t(6) = dyn_assert(ts3.tex,{'A1^{B1}';'A2^{B2}'});
%$ end
%$ T = all(t);
%@eof:1

%@test:2
%$ % Define a datasets.
%$ A = rand(10,2);
%$
%$ % Define names
%$ A_name = {'A1';'A2'};
%$
%$
%$ % Instantiate a time series object.
%$ try
%$    ts1 = dseries(A,[],A_name,[]);
%$    ts3 = ts1^2;
%$    t = 1;
%$ catch
%$    t = 0;
%$ end
%$
%$ if t(1)
%$    t(2) = dyn_assert(ts3.vobs,2);
%$    t(3) = dyn_assert(ts3.nobs,10);
%$    t(4) = dyn_assert(ts3.data,A.^2,1e-15);
%$    t(5) = dyn_assert(ts3.name,{'power(A1,2)';'power(A2,2)'});
%$    t(6) = dyn_assert(ts3.tex,{'A1^2';'A2^2'});
%$ end
%$ T = all(t);
%@eof:2