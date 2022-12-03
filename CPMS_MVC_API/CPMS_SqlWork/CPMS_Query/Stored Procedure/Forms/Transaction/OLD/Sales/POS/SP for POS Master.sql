USE NTHA
GO
--Insert

--alter table t_mpos add upl_act bit,mpos_oldid int
--alter table t_mpos add mrec_id int
--alter table t_mpos add mpos_dis float,mpos_ret bit 
--update t_mpos set mpos_dis=0,mpos_ret=0
--alter table t_mpos add mpos_retcash bit
--update t_mpos set mpos_retcash=0


alter proc ins_t_mpos(@mpos_oldid int,@upl_act bit,@mpos_amt float,@other float,@change_due float,@mpos_hold bit,@mpos_act bit,@com_id int ,@br_id int,@mpos_dat datetime,@mpos_typ char(1),@cus_id int, @mpos_rmrks varchar(1000),@mpos_dis float,@mpos_ret bit,@m_yr_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@cash float,@mpos_retcash bit, @mpos_id_out int output, @mpos_no_out int output)
as
declare
@mpos_id int,
@mpos_no int,
@wh_id int,
@aud_act char(10),
@cur_id int,
@mrec_id int
begin
	set @aud_act='Insert'
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	--set @mpos_act = 0
	set @wh_id=1 
	set @mpos_id=(select max(mpos_id)+1 from t_mpos)
		if @mpos_id is null
			begin
				set @mpos_id=1
			end
	set @mpos_no=(select max(mpos_no)+1 from t_mpos where com_id=@com_id and br_id=@br_id and m_yr_id=@m_yr_id)
		if @mpos_no is null
			begin
				set @mpos_no=1
			end
	if (@mpos_ret=1)
		begin
			set @mpos_amt=0
		end
		
		
		
	insert into t_mpos(mpos_oldid,usr_id,upl_act,other,change_due,mpos_amt,mpos_no,mpos_id,mpos_dat,mpos_typ,cus_id,mpos_act,mpos_rmrks,m_yr_id,com_id,br_id,cur_id,wh_id,cash,mpos_dis,mpos_hold,mpos_ret,mpos_retcash)
			values(@mpos_oldid,@usr_id,@upl_act,@other,@change_due,@mpos_amt,@mpos_no,@mpos_id,@mpos_dat,@mpos_typ,@cus_id,@mpos_act,@mpos_rmrks,@m_yr_id,@com_id,@br_id,@cur_id,@wh_id,@cash,@mpos_dis,@mpos_hold,@mpos_ret,@mpos_retcash)

	set @mpos_id_out=@mpos_id
	set @mpos_no_out=@mpos_no
	
	--Mark Status
	if (@mpos_ret=1 and @mpos_retcash =1)
		begin
			update t_mpos set mpos_act =1 where mpos_id=@mpos_id
		end
		

--Audit
	set @aud_des='ID # '+rtrim(cast (@mpos_id as char(1000)))+' '+@aud_des
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip 

end
		
go


--Update
alter proc upd_t_mpos(@upl_act bit,@mpos_amt float,@other float,@change_due float,@mpos_act bit,@mpos_hold bit,@com_id int, @br_id int,@mpos_id int,@mpos_dat datetime,@mpos_typ char(1),@cus_id int,@mpos_dis float,@mpos_rmrks varchar(1000),@mpos_ret bit,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@m_yr_id int,@cash float,@mpos_retcash float)
as
declare
@aud_act char(10),
@cur_id int,
@mrec_id int,
@acc_id char(20)
begin
	set @aud_act ='Update'
	set @cur_id =(select cur_id from m_cur where cur_typ='S')
	set @mrec_id=(select mrec_id from t_mpos where mpos_id=@mpos_id)
	if (@mpos_ret=1)
		begin
			set @mpos_amt=0
		end
	
	update t_mpos set upl_act=@upl_act,mpos_amt=@mpos_amt,other=@other,change_due=@change_due, mpos_dat=@mpos_dat,cus_id=@cus_id,mpos_act=@mpos_act,mpos_rmrks=@mpos_rmrks,m_yr_id=@m_yr_id,cur_id=@cur_id,cash=@cash,mpos_hold=@mpos_hold,mpos_ret=@mpos_ret,mpos_dis=@mpos_dis,mpos_retcash=@mpos_retcash where mpos_id=@mpos_id
	--Mark Status
	if (@mpos_ret=1 and @mpos_retcash =1)
		begin
			update t_mpos set mpos_act =1 where mpos_id=@mpos_id
		end

	--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip 
end
go

--Delete
alter proc del_t_mpos(@com_id int, @br_id int,@mpos_id int, @aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@m_yr_id int)
as
declare
@aud_act char(10),
@mvch_id int,
@mrec_id int
begin
	set @mvch_id=(select mvch_id from t_mpos where mpos_id=@mpos_id)
	set @mrec_id=(select mrec_id from t_mpos where mpos_id=@mpos_id)
	set @aud_act='Delete'

	--Delete Detail POS
	exec del_t_dpos @mpos_id
	--Delete Master POS
	delete t_mpos where mpos_id=@mpos_id 

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
