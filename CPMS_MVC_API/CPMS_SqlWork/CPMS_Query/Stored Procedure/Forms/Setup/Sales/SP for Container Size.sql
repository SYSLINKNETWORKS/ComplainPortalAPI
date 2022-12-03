USE MFI
GO

--drop table m_consiz


--Insert
create  proc [dbo].[ins_m_consiz]( @consiz_siz varchar(100),@consiz_gwei float,@consiz_nwei float,@consiz_act bit,@consiz_typ char(1),@consiz_id_out int output)
as
declare
@consiz_id int
begin
	set @consiz_id=(select max(consiz_id)+1 from m_consiz)
		if @consiz_id is null
			begin
				set @consiz_id=1
			end
	insert into m_consiz(consiz_id,consiz_siz,consiz_gwei,consiz_nwei,consiz_typ,consiz_act)
			values(@consiz_id,@consiz_siz,@consiz_gwei,@consiz_nwei,@consiz_typ,@consiz_act)
		set @consiz_id_out=@consiz_id

end
GO

--Update
create proc [dbo].[upd_m_consiz](@consiz_id int ,@consiz_siz varchar(100),@consiz_gwei varchar(100),@consiz_nwei varchar(100),@consiz_act bit,@consiz_typ char(1))
as
begin
	update m_consiz set consiz_siz=@consiz_siz,consiz_gwei=@consiz_gwei,consiz_nwei=@consiz_nwei,consiz_act=@consiz_act,consiz_typ=@consiz_typ where consiz_id=@consiz_id
end
GO


--Delete
create proc [dbo].[del_m_consiz](@consiz_id int)
as
begin
	delete m_consiz where consiz_id=@consiz_id
end
		

