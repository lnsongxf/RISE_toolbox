function display(self)
if numel(self)==1
    if self.NumberOfVariables
        disp(main_frame(self)) % does not display the name of the variable
    end
    index(self);
else
    disp(self)
end
end