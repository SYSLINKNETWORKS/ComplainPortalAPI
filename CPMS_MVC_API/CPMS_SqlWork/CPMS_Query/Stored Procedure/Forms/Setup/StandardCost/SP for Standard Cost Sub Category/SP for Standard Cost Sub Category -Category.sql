USE MFI
GO

--select * from m_dscfg

--Insert
alter proc [dbo].[ins_m_dscfg](@dscfg_rat float,@sccat_id int,@mscfg_id int)
as
declare
@dscfg_id int
begin
	set @dscfg_id=(select max(dscfg_id)+1 from m_dscfg)
		if @dscfg_id is null
			begin
				set @dscfg_id=1
			end
	insert into m_dscfg(dscfg_id,dscfg_rat,sccat_id,mscfg_id )
			values(@dscfg_id,@dscfg_rat,@sccat_id,@mscfg_id)

end
GO


--Delete
alter proc [dbo].[del_m_dscfg](@mscfg_id int)
as
begin
	delete m_dscrm where mscfg_id=@mscfg_id
	delete m_dscpk where mscfg_id=@mscfg_id
	delete m_dscfg_acc where mscfg_id=@mscfg_id
	delete m_dscfg where mscfg_id=@mscfg_id
end
		

