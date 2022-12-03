USE meiji_rusk
GO
--alter table m_dbat add dbat_mpro bit
--alter table m_dbat add dbat_phrc float

--alter table m_dbat add dbat_ckqty bit
--update m_dbat set dbat_ckqty=0


--Insert
alter proc [dbo].[ins_m_dbat](@dbat_qty float,@titm_id int,@mbat_id int,@dbat_mpro bit,@dbat_ckqty bit,@dbat_phrc float,@dbat_id_out int output)
as
declare
@dbat_id int
begin
	set @dbat_id=(select max(dbat_id)+1 from m_dbat)
		if @dbat_id is null
			begin
				set @dbat_id=1
			end
			if @dbat_mpro is null
			begin
			set @dbat_mpro=0
			end
	insert into m_dbat(dbat_id,dbat_qty,titm_id,mbat_id,dbat_mpro,dbat_phrc,dbat_ckqty )
			values(@dbat_id,@dbat_qty,@titm_id,@mbat_id,@dbat_mpro,@dbat_phrc,@dbat_ckqty)
		set @dbat_id_out=@dbat_id

end
GO


--Delete
alter proc [dbo].[del_m_dbat](@mbat_id int)
as
begin
	delete m_dbat where mbat_id=@mbat_id
end

