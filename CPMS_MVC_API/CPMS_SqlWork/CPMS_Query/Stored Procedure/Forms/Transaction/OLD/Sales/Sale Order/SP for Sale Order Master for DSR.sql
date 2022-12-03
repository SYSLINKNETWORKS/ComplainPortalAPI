USE PAGEY 
GO

--select * from t_msodsr

--exec ins_t_msodsr '01','01','02' ,1,0 ,'U','test' ,'','','','','',''

--Insert
alter proc ins_t_msodsr(@com_id char(2),@br_id char(3),@m_yr_id char(2),@msodsr_act bit,@msodsr_can bit,@msodsr_typ char(1),@msodsr_idold varchar(1000),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@msodsr_no_out int output,@msodsr_id_out int output)
as
declare
@msodsr_id int,
@msodsr_no int,
@aud_act char(10),
@usr_dat datetime
begin
	set @usr_dat =GETDATE()
	set @aud_act='Insert'
	

	set @msodsr_id=(select max(msodsr_id)+1 from t_msodsr )
		if @msodsr_id is null
			begin
				set @msodsr_id=1
			end

	set @msodsr_no=(select max(msodsr_no)+1 from t_msodsr )
		if @msodsr_no is null
			begin
				set @msodsr_no=1
			end



	insert into t_msodsr(com_id,br_id,m_yr_id,msodsr_id,msodsr_no,msodsr_act,msodsr_can,msodsr_typ,ins_usr_id,ins_usr_dat,msodsr_idold)
			values(@com_id,@br_id,@m_yr_id,@msodsr_id,@msodsr_no,@msodsr_act,@msodsr_can,@msodsr_typ,@usr_id,@usr_dat,@msodsr_idold)
	set @msodsr_id_out=@msodsr_id
	set @msodsr_no_out=@msodsr_no

--Audit
	set @aud_des='ID # '+rtrim(cast(@msodsr_id as char(1000)))+' '+@aud_des 
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		
go
--Update
alter proc upd_t_msodsr(@com_id char(2),@br_id char(3),@m_yr_id char(2),@msodsr_id int,@msodsr_no int,@msodsr_act bit,@msodsr_can bit,@msodsr_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@msodsr_no_out int output,@msodsr_id_out int output)
as
declare
@aud_act char(10),
@usr_dat datetime
begin
	set @usr_dat =GETDATE()
	set @aud_act='Update'
	
	
	update t_msodsr set msodsr_no=@msodsr_no,msodsr_act=@msodsr_act,msodsr_can=@msodsr_can,msodsr_typ=@msodsr_typ,upd_usr_id=@usr_id,upd_usr_dat=@usr_dat								
							where msodsr_id=@msodsr_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end

go
--Delete

alter proc del_t_msodsr(@com_id char(2),@br_id char(3),@m_yr_id char(2),@msodsr_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'

	exec del_t_dso_pat @msodsr_id 
	exec del_t_dso @msodsr_id 
	delete t_msodsr where msodsr_id=@msodsr_id 

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		
--select * from rm_det


