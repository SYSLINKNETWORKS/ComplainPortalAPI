USE MFI
GO

--Insert
create proc [dbo].[ins_m_scacc](@scacc_act bit,@scacc_typ char(1),@sccat_id int,@acc_id char(20))
as
declare
@scacc_id int
begin
	set @scacc_id=(select max(scacc_id)+1 from m_scacc)
		if @scacc_id is null
			begin
				set @scacc_id=1
			end
	insert into m_scacc(scacc_id,scacc_act,scacc_typ,sccat_id,acc_id )
			values(@scacc_id,@scacc_act,@scacc_typ,@sccat_id,@acc_id)

end
GO

--Delete
create proc [dbo].[del_m_scacc](@sccat_id int)
as
begin
	delete m_scacc where sccat_id=@sccat_id
end
		

