USE MEIJI
GO
--delete from m_chlbk

--select * from m_chlbk
--alter table m_chlbk add dpt_id char(2)

--exec sp_ins_chlbk '01','01',3001,25,'U'
--exec sp_del_chlbk '01' ,'01',3001

alter proc [dbo].[sp_ins_chlbk](@com_id char(2),@br_id char(2),@dpt_id char(2),@chlbk_str_no int,@chlbk_lev int,@chlbk_typ char(1))
as
declare
@chlbk_no int,
@chlbk_lev_no int
begin
	set @chlbk_no=@chlbk_str_no
	--Inserting record in chlbk Book Leaves
	set @chlbk_lev_no=cast(@chlbk_no as int)+@chlbk_lev
	while cast(@chlbk_no as int) < @chlbk_lev_no
		begin
				insert into m_chlbk
				(com_id,br_id,chlbk_str_no,chlbk_lev,chlbk_no,chlbk_typ,dpt_id,chlbk_act,chlbk_rmk)
				values
				(@com_id,@br_id,@chlbk_str_no,@chlbk_lev,@chlbk_no,@chlbk_typ,@dpt_id,1,'')
			set @chlbk_no= @chlbk_no+1
		end
end

GO

alter proc [dbo].[sp_upd_chlbk](@com_id char(2),@br_id char(3),@dpt_id char(2),@chlbk_no int,@chlbk_act bit,@chlbk_rmk varchar(250))
as
begin 
	update m_chlbk set chlbk_rmk=@chlbk_rmk,chlbk_act=@chlbk_act where chlbk_no=@chlbk_no and dpt_id=@dpt_id
		
end
GO


alter proc [dbo].[sp_del_chlbk] (@com_id char(2) ,@br_id char(3),@chlbk_str_no int)
as
declare
@bk_count int
begin

				delete from m_chlbk where chlbk_str_no=@chlbk_str_no 
end	

GO
