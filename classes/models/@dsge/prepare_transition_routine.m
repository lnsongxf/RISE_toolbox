function Qfunc=prepare_transition_routine(obj)
% INTERNAL FUNCTION
%

if obj.is_endogenous_switching_model
    
    M=obj.parameter_values;
    
    % transition matrix should be invariant. And so, hopefully, the first
    % argument to Q{2} could be the updated data in any state.
    % order of the input arguments is y,x,ss,param,def,s0,s1 
    % remaining arguments of Q{2} after the first one
    %-------------------------------------------------
    defs=cell2mat(obj.solution.definitions);
    
    Vargs={[],cell2mat(obj.solution.ss),M,defs,[],[]};
    
    % account for log vars
    is_log_var=obj.log_vars;
    
    Qfunc=memoizer(obj.routines.transition_matrix,is_log_var,Vargs{:});
    
else
    
    Qfunc=prepare_transition_routine@generic(obj);
    
end

end

function Qfunc=memoizer(routine,is_log_var,varargin)

Qfunc=@engine;

    function [Q,retcode]=engine(y)
        % re-exponentiate the logvars before computing the transition probs
        %------------------------------------------------------------------
        if any(is_log_var)
            
            y(is_log_var,:)=exp(y(is_log_var,:));
            
        end
        
        [Qall,retcode]=utils.code.evaluate_transition_matrices(routine,y,...
            varargin{:});
        
        Q=Qall.Q;
        
    end

end
