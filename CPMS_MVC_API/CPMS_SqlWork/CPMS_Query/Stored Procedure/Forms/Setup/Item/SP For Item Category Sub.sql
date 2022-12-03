
USE MFI
GO
--alter table m_itmsub add dpt_id char(2)
--alter table m_itmsub add constraint FK_ITMSUB_DPTID foreign key (dpt_id) references m_dpt(dpt_id)

--Insert
alter proc [dbo].[ins_m_itmsub](@itmsub_nam varchar(250),@itmsub_typ char(1),@itmsubmas_id int,@dpt_id char(2),@itmsub_act bit,@itmsub_id_out int output)
as
declare
@itmsub_id int
begin
	set @itmsub_id=(select max(itmsub_id)+1 from m_itmsub)
		if @itmsub_id is null
			begin
				set @itmsub_id=1
			end
			if (@itmsubmas_id=0)
				begin
					set @itmsubmas_id=null
				end
			if (@dpt_id =0)
				begin
					set @dpt_id=null
				end
	insert into m_itmsub(itmsub_id,itmsub_nam,itmsub_act,itmsubmas_id,dpt_id,itmsub_typ )
			values(@itmsub_id,@itmsub_nam,@itmsub_act,@itmsubmas_id,@dpt_id,@itmsub_typ)
		set @itmsub_id_out=@itmsub_id
end
GO

--Update
alter proc [dbo].[upd_m_itmsub](@itmsub_id int,@itmsub_nam varchar(250),@itmsubmas_id int,@dpt_id char(2),@itmsub_act bit,@itmsub_typ char(1))
as
begin
			if (@itmsubmas_id=0)
				begin
					set @itmsubmas_id=null
				end
			if (@dpt_id=0)
				begin
					set @dpt_id=null
				end
	update m_itmsub set itmsub_nam=@itmsub_nam,itmsub_typ=@itmsub_typ,itmsubmas_id=@itmsubmas_id,dpt_id=@dpt_id,itmsub_act=@itmsub_act where itmsub_id=@itmsub_id
end
GO


--Delete
alter proc [dbo].[del_m_itmsub](@itmsub_id int)
as
begin
	delete m_itmsub where itmsub_id=@itmsub_id
end
		

