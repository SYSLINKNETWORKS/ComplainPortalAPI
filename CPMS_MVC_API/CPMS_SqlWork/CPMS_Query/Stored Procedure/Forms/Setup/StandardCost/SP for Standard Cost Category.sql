USE MFI
GO


--Insert
create proc [dbo].[ins_m_sccat](@sccat_nam varchar(250),@sccat_act bit,@sccat_typ char(1),@sccat_id_out int output)
as
declare
@sccat_id int
begin
	set @sccat_id=(select max(sccat_id)+1 from m_sccat)
		if @sccat_id is null
			begin
				set @sccat_id=1
			end
	insert into m_sccat(sccat_id,sccat_nam,sccat_act,sccat_typ )
			values(@sccat_id,@sccat_nam,@sccat_act,@sccat_typ)
		set @sccat_id_out=@sccat_id

end
GO

--Update
create proc [dbo].[upd_m_sccat](@sccat_id int,@sccat_nam varchar(250),@sccat_act bit,@sccat_typ char(1))
as
begin
	update m_sccat set sccat_nam=@sccat_nam,sccat_act=@sccat_act,sccat_typ=@sccat_typ where sccat_id=@sccat_id
end
GO


--Delete
create proc [dbo].[del_m_sccat](@sccat_id int)
as
begin
	delete m_sccat where sccat_id=@sccat_id
end
		

