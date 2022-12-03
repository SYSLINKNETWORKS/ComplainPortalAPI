USE MFI
GO
--Insert
alter proc [dbo].[ins_m_dbat](@dbat_qty float,@titm_id int,@mbat_id int,@dbat_id_out int output)
as
declare
@dbat_id int
begin
	set @dbat_id=(select max(dbat_id)+1 from m_dbat)
		if @dbat_id is null
			begin
				set @dbat_id=1
			end
	insert into m_dbat(dbat_id,dbat_qty,titm_id,mbat_id )
			values(@dbat_id,@dbat_qty,@titm_id,@mbat_id)
		set @dbat_id_out=@dbat_id

end
GO


--Delete
alter proc [dbo].[del_m_dbat](@mbat_id int)
as
begin
	delete m_dbat where mbat_id=@mbat_id
end
		

