--alter table m_per add per_dt1 datetime,per_dt2 datetime
--update m_per set per_dt1='07/01/2012',per_dt2='08/31/2012'
----Insert User Permission

ALTER proc [dbo].[ins_m_per] (@com_id char(1),@br_id char(2),@per_view char(1),@per_new char(1),@per_upd char(1), @per_del char(1),@per_print char(1),@men_id int,@usr_id char(2),@per_dt1 datetime,@per_dt2 datetime,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id1 int,@aud_ip char(100))
as
declare
 @per_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @per_id =(select max(per_id) from m_per) +1
	if @per_id is null
		begin
			set @per_id=1	
		end
		insert into m_per (per_id,per_view,per_new,per_upd,per_del,per_print,men_id,usr_id,per_dt1,per_dt2)
		values (@per_id,@per_view,@per_new,@per_upd,@per_del,@per_print,@men_id,@usr_id,@per_dt1,@per_dt2)

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id1,@aud_act,@aud_ip
end
GO

----Update User Permission
ALTER proc [dbo].[upd_m_per] (@com_id char(2),@br_id char(3), @per_view char(1),@per_new char(1),@per_upd char(1), @per_del char(1),@per_print char(1),@men_id int,@usr_id char(2),@per_dt1 datetime,@per_dt2 datetime,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id1 int,@aud_ip char(100))
as
declare
@per_id int,
@men_id_old int,
@aud_act char(10)
begin 
	set @aud_act='Update'
	set @men_id_old=(select men_id from m_per where usr_id=@usr_id and men_id=@men_id)

		if @men_id_old is null
		begin
		set @per_id =(select max(per_id) from m_per) +1
			if @per_id is null
				begin
					set @per_id=1	
				end

			insert into m_per (per_id,per_view,per_new,per_upd,per_del,per_print,men_id,usr_id,per_dt1,per_dt2)
			values (@per_id,@per_view,@per_new,@per_upd,@per_del,@per_print,@men_id,@usr_id,@per_dt1,@per_dt2)
		end
	else
		begin
			update m_per set per_new = @per_new,per_view = @per_view,per_upd = @per_upd,per_del = @per_del,per_print = @per_print,per_dt1=@per_dt1,per_dt2=@per_dt2
			where usr_id = @usr_id and men_id=@men_id
		end

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id1,@aud_act,@aud_ip
end
GO


--Delete the User Permission
ALTER proc [dbo].[del_m_per] (@com_id char(2),@br_id char(3),@usr_id char(2),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id1 int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'
	delete from m_per where usr_id = @usr_id
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id1,@aud_act,@aud_ip
end
GO


