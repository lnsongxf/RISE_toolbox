function d=double(self)
% INTERNAL FUNCTION: Returns the underlying data of the time series
%
% ::
%
%    data = value(db);
%
% Args:
%    db (ts object): time series object
%
% Returns:
%    :
%    - data (double): vector/matrix/tensor form of the data underlying the time series
%

d=self.data;
end