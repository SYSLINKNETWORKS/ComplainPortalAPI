USE MEIJI
GO
--drop proc ins_m_dbat_cus 
--drop proc del_m_dbat_cus 

--Insert
alter proc [dbo].[ins_m_dbat_cus](@cus_id int,@mbat_id int,@dbat_cus_id_out int output)
as
declare
@dbat_cus_id int
begin
	set @dbat_cus_id=(select max(dbat_cus_id)+1 from m_dbat_cus)
		if @dbat_cus_id is null
			begin
				set @dbat_cus_id=1
			end
	insert into m_dbat_cus(dbat_cus_id,cus_id,mbat_id )
			values(@dbat_cus_id,@cus_id,@mbat_id)
		set @dbat_cus_id_out=@dbat_cus_id

end
GO


--Delete
alter proc [dbo].[del_m_dbat_cus](@mbat_id int)
as
begin
	delete m_dbat_cus where mbat_id=@mbat_id
end
		

