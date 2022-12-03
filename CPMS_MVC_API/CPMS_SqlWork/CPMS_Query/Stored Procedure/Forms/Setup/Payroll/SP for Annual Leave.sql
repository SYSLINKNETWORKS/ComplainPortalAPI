USE zsons
GO


--Insert
create  proc [dbo].[ins_m_empanl](@com_id char(2),@br_id char(3),@empanl_name varchar (100),@empanl_al varchar (100),@empanl_sl varchar (100),@empanl_cl varchar (100),@empanl_dat datetime,@empanl_ck_al bit,@empanl_ck_sl bit,@empanl_ck_cl bit,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100),@empanl_id_out int output)
as
declare
@aud_act char(10),
@empanl_id	        int

begin
	set @aud_act='Insert'
	set @empanl_id =(select max(empanl_id) from m_empanl)+1
	--set @aud_act='Insert'

	if (@empanl_id is null)
		begin	
			set @empanl_id=1
		end

	insert into m_empanl (empanl_id,empanl_name,empanl_al,empanl_sl,empanl_cl,empanl_dat,empanl_ck_al,empanl_ck_sl,empanl_ck_cl)
	values
				     (@empanl_id,@empanl_name,@empanl_al,@empanl_sl,@empanl_cl,@empanl_dat,@empanl_ck_al,@empanl_ck_sl,@empanl_ck_cl)

  set @empanl_id_out=@empanl_id
  
  --Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip


end
GO

--Update

create  proc [dbo].[upd_m_empanl](@com_id char(2),@br_id char(3),@empanl_id int ,@empanl_name varchar (100),@empanl_al varchar (100),@empanl_sl varchar (100),@empanl_cl varchar (100),@empanl_dat datetime,@empanl_ck_al bit,@empanl_ck_sl bit,@empanl_ck_cl bit,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'
	update m_empanl
			set empanl_name=@empanl_name,empanl_al=@empanl_al,empanl_sl=@empanl_sl,empanl_cl=@empanl_cl,empanl_dat=@empanl_dat,empanl_ck_al=@empanl_ck_al,empanl_ck_sl=@empanl_ck_sl,empanl_ck_cl=@empanl_ck_cl
			where empanl_id=@empanl_id 
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--Delete
create  proc [dbo].[del_m_empanl](@com_id char(2),@br_id char(3),@empanl_id int,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_empanl 
			where empanl_id=@empanl_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

