USE [NATHI]
GO

--alter table t_mitn add com_id char(2),br_id char(3)
--alter table t_mitn add constraint FK_TMITN_COMID foreign key (com_id) references m_com(com_id)
--alter table t_mitn add constraint FK_TMITN_BRID foreign key (br_id) references m_br(br_id)
--UPDATE t_mitn set com_id='01',bR_id='02'
--Insert
ALTER proc [dbo].[ins_t_mitn](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mitn_dat datetime,@mitn_rmk varchar(1000),@mitn_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mitn_no_out int output,@mitn_id_out int output)
as
declare
@mitn_id int,
@mitn_no int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @mitn_id=(select max(mitn_id)+1 from t_mitn )
		if @mitn_id is null
			begin
				set @mitn_id=1
			end
			
			set @mitn_no=(select max(mitn_no)+1 from t_mitn )
		if @mitn_no is null
			begin
				set @mitn_no=1
			end
 
    	
	insert into t_mitn(com_id,br_id,m_yr_id,mitn_id,mitn_no,mitn_dat,mitn_rmk,mitn_typ)
			values(@com_id,@br_id,@m_yr_id,@mitn_id,@mitn_no,@mitn_dat,@mitn_rmk,@mitn_typ)
	
	set @mitn_id_out=@mitn_id
	set @mitn_no_out=@mitn_no		

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end		

GO

--Update
ALTER proc [dbo].[upd_t_mitn](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mitn_id int,@mitn_dat datetime,@mitn_rmk varchar(1000),@mitn_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act ='Update'
	update t_mitn set mitn_dat=@mitn_dat,mitn_rmk=@mitn_rmk,mitn_typ=@mitn_typ   
	where mitn_id=@mitn_id 

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end


GO

--Delete

ALTER proc [dbo].[del_t_mitn](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mitn_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'

	exec del_t_ditn @mitn_id 

	delete t_mitn where mitn_id=@mitn_id 
	
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end

