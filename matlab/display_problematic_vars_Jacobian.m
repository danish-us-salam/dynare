function []=display_problematic_vars_Jacobian(problemrow,problemcol,M_,x,type,caller_string)
% []=display_problematic_vars_Jacobian(problemrow,problemcol,M_,ys,caller_string)
% print the equation numbers and variables associated with problematic entries 
% of the Jacobian 
%
% INPUTS
%   problemrow      [vector] rows associated with problematic entries
%   problemcol      [vector] columns associated with problematic entries
%   M_              [matlab structure] Definition of the model.           
%   x               [vector] point at which the Jacobian was evaluated
%   type            [string] 'static' or 'dynamic' depending on the type of
%                               Jacobian
%   caller_string   [string] contains name of calling function for printing 
%    
% OUTPUTS
%   none.
%  

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

if nargin<6
    caller_string='';
end
if strcmp(type,'dynamic')
    for ii=1:length(problemrow)
        [var_row,var_index]=find(M_.lead_lag_incidence==problemcol(ii));
        if var_row==2
            type_string='';
        elseif var_row==1
            type_string='lag of';
        elseif var_row==3;
            type_string='lead of';
        end
        if var_index<=M_.orig_endo_nbr
            fprintf('Derivative of Equation %d with respect to %s Variable %s  (initial value of %s: %g) \n',problemrow(ii),type_string,deblank(M_.endo_names(var_index,:)),deblank(M_.endo_names(var_index,:)),x(var_index))
        else %auxiliary vars
            orig_var_index=M_.aux_vars(1,var_index-M_.orig_endo_nbr).orig_index;
            fprintf('Derivative of Equation %d with respect to %s Variable %s  (initial value of %s: %g) \n',problemrow(ii),type_string,deblank(M_.endo_names(orig_var_index,:)),deblank(M_.endo_names(orig_var_index,:)),x(orig_var_index))            
        end    
    end
    fprintf('\n%s  The problem most often occurs, because a variable with\n',caller_string)
    fprintf('%s  exponent smaller than 1 has been initialized to 0. Taking the derivative\n',caller_string)
    fprintf('%s  and evaluating it at the steady state then results in a division by 0.\n',caller_string)
elseif strcmp(type,'static')
    for ii=1:length(problemrow)
        if problemcol(ii)<=M_.orig_endo_nbr
            fprintf('Derivative of Equation %d with respect to Variable %s  (initial value of %s: %g) \n',problemrow(ii),deblank(M_.endo_names(problemcol(ii),:)),deblank(M_.endo_names(problemcol(ii),:)),x(problemcol(ii)))
        else %auxiliary vars
            orig_var_index=M_.aux_vars(1,problemcol(ii)-M_.orig_endo_nbr).orig_index;
            fprintf('Derivative of Equation %d with respect to Variable %s  (initial value of %s: %g) \n',problemrow(ii),deblank(M_.endo_names(orig_var_index,:)),deblank(M_.endo_names(orig_var_index,:)),x(problemcol(ii)))            
        end
    end
    fprintf('\n%s  The problem most often occurs, because a variable with\n',caller_string)
    fprintf('%s exponent smaller than 1 has been initialized to 0. Taking the derivative\n',caller_string)
    fprintf('%s and evaluating it at the steady state then results in a division by 0.\n',caller_string)
else
    error('Unknown Type')    
end