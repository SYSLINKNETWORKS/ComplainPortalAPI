----Function for PL
ALTER function [dbo].[funcPL]()
returns char(20)
as
begin
	Declare
	@PLacc_id char(20)
		begin	
			set @PLacc_id=(select '0'+cast(max(acc_id)+1 as char(20)) as [acc_id] from gl_m_acc where acc_cid =(select acc_id from gl_m_acc where acc_nam ='Equity'))
		end 
	return @PLacc_id
end
GO

