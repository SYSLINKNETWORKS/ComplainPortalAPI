
USE MFI
GO
--alter table m_itmsubmas add itmsubmas_expact bit
--update m_itmsubmas set itmsubmas_expact=0

--Insert
alter proc [dbo].[ins_m_itmsubmas](@itmsubmas_nam varchar(250),@itmsubmas_typ char(1),@itmsubmas_soact bit,@itmsubmas_innact bit,@itmsubmas_masact bit,@itmsubmas_expact bit,@itmsubmas_act bit,@itmsubmas_id_out int output)
as
declare
@itmsubmas_id int
begin
	set @itmsubmas_id=(select max(itmsubmas_id)+1 from m_itmsubmas)
		if @itmsubmas_id is null
			begin
				set @itmsubmas_id=1
			end
	insert into m_itmsubmas(itmsubmas_id,itmsubmas_nam,itmsubmas_soact,itmsubmas_innact,itmsubmas_masact,itmsubmas_expact,itmsubmas_act,itmsubmas_typ )
			values(@itmsubmas_id,@itmsubmas_nam,@itmsubmas_soact,@itmsubmas_innact,@itmsubmas_masact,@itmsubmas_expact,@itmsubmas_act,@itmsubmas_typ)
		set @itmsubmas_id_out=@itmsubmas_id
end
GO

--Update
alter proc [dbo].[upd_m_itmsubmas](@itmsubmas_id int,@itmsubmas_nam varchar(250),@itmsubmas_soact bit,@itmsubmas_innact bit,@itmsubmas_masact bit,@itmsubmas_expact bit,@itmsubmas_act bit,@itmsubmas_typ char(1))
as
begin
	update m_itmsubmas set itmsubmas_nam=@itmsubmas_nam,itmsubmas_typ=@itmsubmas_typ,itmsubmas_soact=@itmsubmas_soact,itmsubmas_innact=@itmsubmas_innact,itmsubmas_masact=@itmsubmas_masact,itmsubmas_expact=@itmsubmas_expact,itmsubmas_act=@itmsubmas_act where itmsubmas_id=@itmsubmas_id
end
GO


--Delete
alter proc [dbo].[del_m_itmsubmas](@itmsubmas_id int)
as
begin
	delete m_itmsubmas where itmsubmas_id=@itmsubmas_id
end
		

