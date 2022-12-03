USE MFI
GO

--select * from m_dscpk

--Insert
alter proc [dbo].[ins_m_dscpk](@dscpk_rat float,@itmsubmas_id int,@mscfg_id int)
as
declare
@dscpk_id int
begin
	set @dscpk_id=(select max(dscpk_id)+1 from m_dscpk)
		if @dscpk_id is null
			begin
				set @dscpk_id=1
			end
	insert into m_dscpk(dscpk_rat,dscpk_id,itmsubmas_id,mscfg_id )
			values(@dscpk_rat,@dscpk_id,@itmsubmas_id,@mscfg_id)

end
GO



