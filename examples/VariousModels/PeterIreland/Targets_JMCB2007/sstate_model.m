function [y,newp,retcode]=sstate_model(obj,y,p,d,id) %#ok<INUSL>
% sstate_model -- shows the way of writing a RISE steady state file
%
% ::
%
%
%   [y,newp,retcode]=sstate_model(obj,y,p,d,id)
%
% Args:
%
%    - **obj** [rise|dsge]: model object (not always needed)
%
%    - **y** [vector]: endo_nbr x 1 vector of initial steady state
%
%    - **p** [struct]: parameter structure
%
%    - **d** [struct]: definitions
%
%    - **id** [vector]: location of the variables to calculate
%
% Returns:
%    :
%
%      CASE 1: one input argument
%
%    - **y** [cell array]: list of the variables for which the steady state
%    will be calculated within the steady state function
%
%    - **newp** [cell array]: List of the parameters calculated inside the
%    steady state function
%
%    - **retcode** [struct]: possible fields are "imposed", "unique", "loop".
%    The default value for all of those is false.
%      - "imposed": This tells RISE not to check that this is actually solves
%          the steady state. Hence, RISE will attempt to approximate the model
%          around the chosen point
%      - "unique": This tells RISE that the steady state is the same across
%          all regimes. RISE will call the function only once but instead of
%          using just any parameter vector, it will use the ergodic mean of
%          the parameter vector (mean across all regimes).
%      - "loop": This tells RISE that if the user was given the steady state
%          values for some of the variables, he would be able to compute the
%          steady state for the remaining variables. RISE will then exploit
%          this information to optimize over the variables that the user needs
%          for computing the steady state.
%
%      CASE 2: More than one input argument
%
%    - **y** []: endo_nbr x 1 vector of updated steady state
%
%    - **newp** [struct]: structure containing updated parameters if any
%
%    - **retcode** [0|number]: return 0 if there are no problems, else return
%      any number different from 0
%
% Note:
%
%    - If the user knows the steady state, it is always an advantage. If the
%    steady state is computed numerically, we don't know whether it is unique
%    or not. Not that it really matters but... some economists have a strong
%    aversion towards models with multiple equilibria.
%
%    - If the user does not know the solution for all the variables in the
%    steady state, it is a good idea to take a log-linear approximation for
%    the variables that potentially have a nonzero steady state. Hence the
%    user should give that information to RISE.
%
%    - One can potentially improve on the above point by explicit bounds on
%    the variables. But this is not implemented.
%
%    - An alternative that potentially avoids taking a loglinearization is to
%    to reset the values proposed by the optimizer whenever they are in a bad
%    region. It is unclear whether this always works.
%
%    - So be on the safe side, i.e. don't do like me: compute your steady
%    state analytically.
%
% Example:
%
%    See also:

retcode=0;
if nargin==1
    y={'A','THETA','Z','PAISTAR','V','PAI','Y','C','GY','GPAI','GR',...
        'LAMBDA','Q','X','R','RRPAI','E'};

	% list of parameters herein calculated
	%-------------------------------------
	newp={};
	
    % flags on the calculation
    %--------------------------
    retcode=struct('unique',true,'imposed',true);
else
    % no parameter to update
    %-----------------------
    newp=[];
    
    A=1;
    THETA=p.thetass;
    Z=p.zss;
    PAISTAR=1;
    V=1;
    PAI=1;
    Y=(p.thetass-1)/p.thetass*(p.zss-p.beta*p.gam)/(p.zss-p.gam);
    C=Y;
    GY=Z;
    GPAI=1;
    GR=1;
    LAMBDA=p.thetass/(p.thetass-1);
    Q=(p.zss-p.beta*p.gam)/(p.zss-p.gam);
    X=(p.thetass-1)/p.thetass;
    R=p.zss/p.beta;
    RRPAI=p.zss/p.beta;
    E=p.ess;
    
    ys=[A,THETA,Z,PAISTAR,V,PAI,Y,C,GY,GPAI,GR,LAMBDA,Q,X,R,RRPAI,E];
    ys=ys(:);
    % check the validity of the calculations
    %----------------------------------------
    if ~utils.error.valid(ys)
        retcode=1;
    else
        % push the calculations
        %----------------------
        y(id)=ys;
    end
end

end