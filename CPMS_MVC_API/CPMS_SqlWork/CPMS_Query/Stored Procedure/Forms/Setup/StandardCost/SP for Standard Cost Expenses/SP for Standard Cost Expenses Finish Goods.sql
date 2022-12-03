USE MFI
GO

--select * from m_dscfg

--Insert
alter proc [dbo].[ins_m_dscfg](@titm_id int,@mscexp_id int)
as
declare
@dscfg_id int
begin
	set @dscfg_id=(select max(dscfg_id)+1 from m_dscfg)
		if @dscfg_id is null
			begin
				set @dscfg_id=1
			end
	insert into m_dscfg(dscfg_id,titm_id,mscexp_id )
			values(@dscfg_id,@titm_id,@mscexp_id)

end
GO


--Delete
alter proc [dbo].[del_m_dscfg](@mscexp_id int)
as
begin
	delete m_dscpk where mscexp_id=@mscexp_id
	delete m_dscfg_acc where mscexp_id=@mscexp_id
	delete m_dsccat where mscexp_id=@mscexp_id
	delete m_dscfg where mscexp_id=@mscexp_id
end
		

