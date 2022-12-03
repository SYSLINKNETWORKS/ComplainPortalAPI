USE PHM
GO
--alter table m_emp_sub add memp_sub_salman bit
--alter table m_emp_sub add memp_sub_booker bit
--exec ins_m_emp_sub 'Booker','U',0,1,'01','01','01','','','','',''
--select * from m_emp_sub 
--update m_emp_sub set memp_sub_salman=0 
--update m_emp_sub set memp_sub_salman=1 where memp_sub_id=2

--alter table m_emp_sub add memp_sub_wh bit,memp_sub_locpur bit,memp_sub_imppur bit
--update m_emp_sub set memp_sub_wh=0,memp_sub_locpur=0,memp_sub_imppur=0


--Insert
alter  proc [dbo].[ins_m_emp_sub](@memp_sub_nam varchar(250),@memp_sub_typ char(1),@memp_sub_salman bit,@memp_sub_booker bit,@memp_sub_wh bit,@memp_sub_locpur bit,@memp_sub_imppur bit,@com_id char(2),@br_id char(3),@m_yr_id char(3),@memp_sub_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@memp_sub_id			int,
@aud_act			char(20)
begin
	set @memp_sub_id =(select max(memp_sub_id) from m_emp_sub)+1
	set @aud_act='Insert'

	if (@memp_sub_id is null)
		begin	
			set @memp_sub_id=1
		end

	insert into m_emp_sub (memp_sub_id,memp_sub_nam,memp_sub_typ,memp_sub_salman,memp_sub_booker,memp_sub_wh,memp_sub_locpur,memp_sub_imppur)
	values
	(@memp_sub_id,@memp_sub_nam,@memp_sub_typ,@memp_sub_salman,@memp_sub_booker,@memp_sub_wh,@memp_sub_locpur,@memp_sub_imppur)

	set @memp_sub_id_out=@memp_sub_id


--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update

alter proc [dbo].[upd_m_emp_sub](@memp_sub_id int,@memp_sub_nam varchar(250),@memp_sub_typ char(1),@memp_sub_salman bit,@memp_sub_booker bit,@memp_sub_wh bit,@memp_sub_locpur bit,@memp_sub_imppur bit,@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'
	update m_emp_sub 
			set memp_sub_nam=@memp_sub_nam,memp_sub_typ=@memp_sub_typ,memp_sub_salman=@memp_sub_salman,memp_sub_booker=@memp_sub_booker,memp_sub_wh=@memp_sub_wh,memp_sub_locpur=@memp_sub_locpur,memp_sub_imppur=@memp_sub_imppur
			where memp_sub_id=@memp_sub_id 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--Delete
alter proc [dbo].[del_m_emp_sub](@com_id char(2),@br_id char(3),@memp_sub_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_emp_sub  
			where memp_sub_id=@memp_sub_id

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

