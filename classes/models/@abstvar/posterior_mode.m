function dd=posterior_mode(self)
% Return the posterior mode from the BVAR estimation
%
% ::
%
%    dd = posterior_mode(self)
%
% Args:
%    self (var object): var object
%
% Returns:
%    :
%
%    - **dd** (struct): posterior mode of the parameters
%

dd=[self.estim_.links.estimList(:),num2cell(self.estim_.estim_param)];

dd=cell2struct(dd(:,2),dd(:,1),1);

end
