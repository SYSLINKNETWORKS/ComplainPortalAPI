USE MFI
GO


--Insert
alter proc [dbo].[ins_m_dscpk](@dscpk_rat float,@itmsubmas_id int,@titm_id int,@mscexp_id int)
as
declare
@dscpk_id int
begin
	set @dscpk_id=(select max(dscpk_id)+1 from m_dscpk)
		if @dscpk_id is null
			begin
				set @dscpk_id=1
			end
	insert into m_dscpk(dscpk_id,dscpk_rat,mscexp_id,itmsubmas_id,titm_id )
			values(@dscpk_id,@dscpk_rat,@mscexp_id,@itmsubmas_id,@titm_id)

end
GO


		

