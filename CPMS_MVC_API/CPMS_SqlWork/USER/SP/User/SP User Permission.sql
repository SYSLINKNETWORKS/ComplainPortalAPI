USE NATHI
GO
----Insert User Permission
--alter table m_per add per_tax bit
--update m_per set per_tax=0

--alter table m_per add per_app bit
--update m_per set per_app=0
--alter table m_per add per_ck bit
--update m_per set per_ck=1

--alter table m_per add per_can bit
--update m_per set per_can =1



alter proc [dbo].[ins_m_per] (@com_id char(2),@br_id char(3),@per_view bit,@per_new bit,@per_upd bit, @per_del bit,@per_print bit,@per_tax bit,@per_can bit,@per_ck bit,@per_app bit,@men_id int,@usr_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id_aud int,@aud_ip char(100))
as
declare
@per_id int,
@per_dt1 datetime,
@per_dt2 datetime,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @per_dt1=(select per_dt1 from new_usr where usr_id=@usr_id)
	set @per_dt2=(select per_dt2 from new_usr where usr_id=@usr_id)

	set @per_id =(select max(per_id) from m_per) +1
	if @per_id is null
		begin
			set @per_id=1	
		end
		insert into m_per (per_id,per_view,per_new,per_upd,per_del,per_print,per_tax,per_can,per_ck,per_app,men_id,usr_id,per_dt1,per_dt2)
		values (@per_id,@per_view,@per_new,@per_upd,@per_del,@per_print,@per_tax,@per_can,@per_ck,@per_app,@men_id,@usr_id,@per_dt1,@per_dt2)

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id_aud,@aud_act,@aud_ip
end
GO


--Delete the User Permission
alter proc [dbo].[del_m_per] (@com_id char(2),@br_id char(3),@usr_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id_aud int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'
	delete from m_per where usr_id = @usr_id
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id_aud,@aud_act,@aud_ip
end
GO


