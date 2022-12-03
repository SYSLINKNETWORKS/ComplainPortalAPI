USE ZSons
GO

--Insert
alter proc [dbo].[ins_m_taxrat](@taxrat_dat datetime,@taxrat_typ char(1),@taxrat_nam char(1),@taxrat_id_out int output)
as
declare
@taxrat_id int
begin
	set @taxrat_id=(select max(taxrat_id)+1 from m_taxrat)
		if @taxrat_id is null
			begin
				set @taxrat_id=1
			end
	insert into m_taxrat(taxrat_id,taxrat_dat,taxrat_typ,taxrat_nam)
			values(@taxrat_id,@taxrat_dat,@taxrat_typ,@taxrat_nam)

		set @taxrat_id_out=@taxrat_id

end
GO
--Update
alter proc [dbo].[upd_m_taxrat](@taxrat_id int,@taxrat_dat datetime,@taxrat_typ char(1),@taxrat_nam char(1))
as
begin
	update m_taxrat set taxrat_dat=@taxrat_dat,taxrat_typ=@taxrat_typ,taxrat_nam=@taxrat_nam where taxrat_id=@taxrat_id
end
GO


--Delete
alter proc [dbo].[del_m_taxrat](@taxrat_id int)
as
begin
	exec del_m_dtaxrat @taxrat_id
	delete m_taxrat where taxrat_id=@taxrat_id 
end
	