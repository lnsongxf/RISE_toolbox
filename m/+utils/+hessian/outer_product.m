function [H,H2,grad]=outer_product(Objective,xparam,varargin)
% Computes the hessian using the outer product of the gradient 
%
% ::
%
%    H = outer_product(Objective,params);
%    H = outer_product(Objective,params,varargin);
%
% Args:
%
%    - **Objective** [char|function handle]: function to differentiate
%
%    - **params** [vector]: point at which the differentiation is taken
%
%    - **varargin** : optional/further arguments of the objective function
%
% Returns:
%    :
%
%    - **H** [matrix]: Hessian matrix
%
%    - **H2** [matrix]: Hessian matrix scaled by the number of elements in
%       the underlying gradient
%
%    - **grad** [vector]: gradient vector
%
% Note:
%    Objective is assumed to have at least two output arguments the
%    first one will not be used. The second one is the different increments of
%    the likelihood 
%
% See also:
%
%    - utils.hessian.finite_differences
%

if ischar(Objective)
    
    Objective=str2func(Objective);
    
end

[grad,grad2] = finite_difference_double_gradient(Objective,xparam,varargin{:});

H=grad2'*grad2;

H2=H/size(grad2,1);

function [grad1,grad2] = finite_difference_double_gradient(Objective,xparam,varargin)

tol      = eps.^(1/6);

npar = size(xparam,1);

h = tol.*max(abs(xparam),1);

xh1=xparam+h;

xh0=xparam-h;

h=xh1-xh0;

grad1=nan(npar,1);

for p=1:npar
    
    xx = xparam;
    
    xx(p) = xh1(p); [f1,Incr1]=Objective(xx,varargin{:});
    
    xx(p) = xh0(p); [f0,Incr0]=Objective(xx,varargin{:});
    
    grad1(p) = (f1-f0)/h(p);
    
    if p==1
        
        N=length(Incr1);
        
        grad2=nan(N,npar);
        
    end
    
    grad2(:,p) = (Incr1-Incr0)/h(p);
    
end

