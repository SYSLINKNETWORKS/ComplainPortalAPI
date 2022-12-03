USE MFI
GO

--select * from m_dsccat

--Insert
alter proc [dbo].[ins_m_dsccat](@dsccat_rat float,@dsccat_sca int,@sccat_id int,@mscexp_id int)
as
declare
@dsccat_id int
begin
	set @dsccat_id=(select max(dsccat_id)+1 from m_dsccat)
		if @dsccat_id is null
			begin
				set @dsccat_id=1
			end
	insert into m_dsccat(dsccat_id,dsccat_rat,dsccat_sca,sccat_id,mscexp_id )
			values(@dsccat_id,@dsccat_rat,@dsccat_sca,@sccat_id,@mscexp_id)

end
GO



