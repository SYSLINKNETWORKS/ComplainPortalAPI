USE MFI
GO

--select * from m_mscrm

--Insert
alter proc [dbo].[ins_m_mscrm](@mscrm_dat datetime,@mscrm_rat float,@mscrm_act bit,@mscrm_typ char(1),@titm_id int)
as
declare
@mscrm_id int
begin
	set @mscrm_id=(select MAX(mscrm_id)+1 from m_mscrm)
	if (@mscrm_id is null)
		begin
			set @mscrm_id=1
		end
		
	insert into m_mscrm(mscrm_id,mscrm_dat,mscrm_rat,mscrm_act,mscrm_typ,titm_id)
			values(@mscrm_id,@mscrm_dat,@mscrm_rat,@mscrm_act,@mscrm_typ,@titm_id)

end
GO



--delete
alter proc [dbo].[del_m_mscrm](@mscrm_dat datetime)
as
begin
	delete m_mscrm where mscrm_dat=@mscrm_dat
end
GO
