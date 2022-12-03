USE ZSONS
GO
----Insert User cuspermission
--alter table m_cusper add cusper_tax bit
--update m_cusper set cusper_tax=0


create proc [dbo].[ins_m_cusper] (@com_id int,@br_id int,@cusper_view bit,@cusper_new bit,@cusper_upd bit, @cusper_del bit,@cusper_print bit,@cusper_tax bit,@men_id int,@cus_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id_aud int,@aud_ip char(100))
as
declare
@cusper_id int,
--@cusper_dt1 datetime,
--@cusper_dt2 datetime,
@aud_act char(10)
begin
	set @aud_act='Insert'
	--set @cusper_dt1=(select cusper_dt1 from new_usr where usr_id=@usr_id)
	--set @cusper_dt2=(select cusper_dt2 from new_usr where usr_id=@usr_id)

	set @cusper_id =(select max(cusper_id) from m_cusper) +1
	if @cusper_id is null
		begin
			set @cusper_id=1	
		end
		insert into m_cusper (cusper_id,cusper_view,cusper_new,cusper_upd,cusper_del,cusper_print,cusper_tax,men_id,cus_id)
		values (@cusper_id,@cusper_view,@cusper_new,@cusper_upd,@cusper_del,@cusper_print,@cusper_tax,@men_id,@cus_id)

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id_aud,@aud_act,@aud_ip
end
GO

----Update User cuspermission
create proc [dbo].[upd_m_cusper] (@com_id int,@br_id int, @cusper_view bit,@cusper_new bit,@cusper_upd bit, @cusper_del bit,@cusper_print bit,@cusper_tax bit,@men_id int,@cus_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id_aud int,@aud_ip char(100))
as
declare
@cusper_id int,
--@cusper_dt1 datetime,
--@cusper_dt2 datetime,
@men_id_old int,
@aud_act char(10)
begin 
	set @aud_act='Update'

	--set @cusper_dt1=(select cusper_dt1 from new_usr where usr_id=@usr_id)
	--set @cusper_dt2=(select cusper_dt2 from new_usr where usr_id=@usr_id)

	set @men_id_old=(select distinct men_id from m_cusper where cus_id=@cus_id and men_id=@men_id)

		if @men_id_old is null
		begin
		set @cusper_id =(select max(cusper_id) from m_cusper) +1
			if @cusper_id is null
				begin
					set @cusper_id=1	
				end

			insert into m_cusper (cusper_id,cusper_view,cusper_new,cusper_upd,cusper_del,cusper_print,cusper_tax,men_id,cus_id)
			values (@cusper_id,@cusper_view,@cusper_new,@cusper_upd,@cusper_del,@cusper_print,@cusper_tax,@men_id,@cus_id)
		end
	else
		begin
			update m_cusper set cusper_new = @cusper_new,cusper_view = @cusper_view,cusper_upd = @cusper_upd,cusper_del = @cusper_del,cusper_print = @cusper_print,cusper_tax=@cusper_tax 
			where cus_id = @cus_id and men_id=@men_id
		end

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id_aud,@aud_act,@aud_ip
end
GO


--Delete the User cuspermission
create proc [dbo].[del_m_cusper] (@com_id int,@br_id int,@cus_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id_aud int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'
	delete from m_cusper where cus_id = @cus_id
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id_aud,@aud_act,@aud_ip
end
GO


