----Function for Control Account of PL

ALTER function [dbo].[funcCPL]()
returns char(20)
as
begin
	Declare
	@CPLacc_id char(20)
		begin	
			set @CPLacc_id=(select acc_id from gl_m_acc where acc_nam ='Equity')
		end 
	return @CPLacc_id
end
GO

