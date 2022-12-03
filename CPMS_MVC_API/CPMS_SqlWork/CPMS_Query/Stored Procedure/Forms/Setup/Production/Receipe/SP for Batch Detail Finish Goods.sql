USE MEIJI
GO
--Insert
alter proc [dbo].[ins_m_dbat_fg](@titm_id int,@mbat_id int,@dbat_fg_id_out int output)
as
declare
@dbat_fg_id int
begin
	set @dbat_fg_id=(select max(dbat_fg_id)+1 from m_dbat_fg)
		if @dbat_fg_id is null
			begin
				set @dbat_fg_id=1
			end
	insert into m_dbat_fg(dbat_fg_id,titm_id,mbat_id )
			values(@dbat_fg_id,@titm_id,@mbat_id)
		set @dbat_fg_id_out=@dbat_fg_id

end
GO


--Delete
alter proc [dbo].[del_m_dbat_fg](@mbat_id int)
as
begin
	delete m_dbat_fg where mbat_id=@mbat_id
end
		

