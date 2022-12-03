--select * from t_minv

--ALTER table t_minv add bk_id char(2)
--alter table t_minv add constraint FK_TMINV_BKID foreign key (bk_id) references gl_m_bk(bk_id)


--Insert
alter proc ins_t_minv(@com_id char(2),@br_id char(3),@m_yr_id char(2),@minv_dat datetime,@minv_typ char(1),@bk_id char(2),@dc_no varchar(100),@minv_rat float,@cur_id int,@cus_id int,@minv_rmk varchar(250),@minv_amt float,@minv_camt float,@minv_refamt float,@minv_disper float,@minv_disamt float,@minv_freamt float,@minv_namt float,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@minv_id_out int output)
as
declare
@minv_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @minv_id=(select max(minv_id)+1 from t_minv)
		if @minv_id is null
			begin
				set @minv_id=1
			end
	

	insert into t_minv(minv_id,minv_dat,minv_typ,bk_id,cus_id,minv_st,minv_rmk,minv_rat,cur_id,minv_amt,minv_camt,minv_refamt,minv_disper,minv_disamt,minv_freamt,minv_namt,m_yr_id,mdc_id)
			values(@minv_id,@minv_dat,@minv_typ,@bk_id,@cus_id,0,@minv_rmk,@minv_rat,@cur_id,@minv_amt,@minv_camt,@minv_refamt,@minv_disper,@minv_disamt,@minv_freamt,@minv_namt,@m_yr_id,@dc_no)

	set @minv_id_out=@minv_id


	--Audit
		set @aud_des='ID # '+rtrim(cast(@minv_id as char(1000)))  + ' ' + @aud_des
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip


end

GO
--Update
alter proc upd_t_minv(@com_id char(2),@br_id char(3),@m_yr_id char(2),@minv_id int,@minv_typ char(1),@bk_id char(2),@dc_no varchar(100),@cur_id int,@minv_rat float,@minv_rmk varchar(250),@minv_amt float,@minv_camt float,@minv_refamt float,@minv_disper float,@minv_disamt float,@minv_freamt float,@minv_namt float,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Update'
	
	update t_minv set minv_typ=@minv_typ,minv_rmk=@minv_rmk,minv_rat=@minv_rat,bk_id=@bk_id,cur_id=@cur_id,minv_amt=@minv_amt,minv_camt=@minv_camt,minv_refamt=@minv_refamt,minv_disper=@minv_disper,minv_disamt=@minv_disamt,minv_freamt=@minv_freamt,minv_namt=@minv_namt,mdc_id=@dc_no
		where minv_id=@minv_id


	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end

go

--Delete
alter proc del_t_minv(@com_id char(2),@br_id char(3),@m_yr_id char(2),@minv_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@mvch_id char(12),
@aud_act char(10)
begin
	set @aud_act='Delete'

	--Delete Voucher
	set @mvch_id=(select mvch_id from t_minv where minv_id=@minv_id)
	exec del_t_vch @com_id,@br_id,@mvch_id,'05',@m_yr_id,'C',0,@aud_frmnam,@aud_des,@usr_id,@aud_ip	

	--dc Status
	update t_mdc set mdc_act=0 where mdc_id in (select mdc_id from t_dinv_dc where minv_id=@minv_id)

	--Delete Record
	exec del_t_dinv_dc @minv_id
	exec del_t_dinv @minv_id
	delete from t_minv where minv_id=@minv_id	

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
