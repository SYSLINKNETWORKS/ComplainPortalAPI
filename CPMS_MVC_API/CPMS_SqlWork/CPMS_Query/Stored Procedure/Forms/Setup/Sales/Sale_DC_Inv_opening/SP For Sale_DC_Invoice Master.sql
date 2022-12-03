USE meiji_rusk
GO

--alter table m_sys add capital_cus_acc int
--update m_sys set capital_cus_acc =(select acc_no from gl_m_acc where acc_id='01001002')
--alter table t_mvch drop constraint CK_MVCH_TYP

--Insert
create proc ins_sp_inv_op(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mso_dat datetime,@mso_rmk varchar(1000),@mso_typ char(1),@mso_amt float,@cus_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@mso_id int,
@mdc_id int,
@minv_id int,
@mso_rat float,
@cur_id int,
@mso_act bit,
@acc_id char(20),
@row_id int,
@acc_no int,
@mvch_no int,
@cus_nam varchar(250),
@nar varchar(1000)
begin
	set @row_id=1
	set @mso_act=1
	set @mso_rat=1
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	set @cus_nam=(select cus_nam from m_cus where cus_id=@cus_id)

	if (@mso_amt >0)
		begin
			--Sale Order		
			exec ins_t_mso @com_id,@br_id,@m_yr_id,@mso_dat,'' ,@mso_amt ,0 ,'' ,0 ,0 ,@mso_amt ,0,@mso_typ ,@cus_id ,'',null,null,null,0,0,'',@usr_id,'',@aud_frmnam ,'','',null,@mso_id_out =@mso_id output
			--DC	
			exec ins_t_mdc @com_id ,@br_id,@m_yr_id ,@mso_dat ,@mso_dat,'','',@mso_typ,@mso_act,0,@mso_id,null, @mso_rmk,0,'','','',null,'',@mso_dat,'',@usr_id,'','','','',null,@mdc_id_out =@mdc_id  output
			----Invoice
			exec ins_t_minv @com_id,@br_id,@m_yr_id,@mso_dat,@mso_dat,@mso_typ,@mso_id,@mso_rat,@cur_id,@cus_id ,@mso_rmk,0,0,0,0,0,@mso_amt,0,0,0,'',0,0,0,@mso_amt,0,'',@usr_id,'','','','',null,null,@minv_id_out=@minv_id output
			----Voucher
			----Master
			exec ins_t_mvch @com_id,@br_id,@m_yr_id,@mso_dat ,@mso_dat ,'','01','06','Y','C' ,'',@mso_typ,0,@mso_dat,0,0,@cur_id,@mso_rat,0,0,'','',@usr_id,'','','',@mvch_no_out=@mvch_no output
			update t_minv set mvch_no=@mvch_no where minv_id=@minv_id
			----Detail
			set @nar='Invoice # ' + rtrim(cast(@minv_id as char(100))) + ' Customer Name : ' +@cus_nam 
			----Debit
			set @row_id=1
			set @acc_no=(select acc_no from m_cus where cus_id=@cus_id)
			exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,@mso_amt,0
			----Credit
			set @row_id=@row_id +1
			set @acc_no=(select capital_cus_acc from m_sys)
			exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,0,@mso_amt
		end
	else if (@mso_amt <0)
		begin
			set @acc_id=(select acc_id from gl_m_acc inner join m_sys on gl_m_acc.acc_no=m_Sys.capital_cus_acc)
			set @mso_amt=-@mso_amt
			exec sp_ins_cusadv @com_id,@br_id,@m_yr_id ,@mso_dat ,0,@mso_amt,0,0,0,0,0,0,0,0,@mso_amt,'O',null,0,@mso_dat,@mso_rmk,@mso_rat,@cus_id,0,0,null,@cur_id,@acc_id ,'',@usr_id,'','','','',null,null
		end
end
go



--exec del_sp_inv_op '01','01','02','O'

--Delete
create proc del_sp_inv_op(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mso_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@mvch_no int,
@minv_id int,
@mdc_id int,
@mso_id int
begin
	
	delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no in (select mvch_no from t_minv where minv_typ=@mso_typ and minv_id not in (select minv_id from t_drec))
	delete from t_mvch where com_id=@com_id and br_id=@br_id and mvch_no in (select mvch_no from t_minv where minv_typ=@mso_typ and minv_id not in (select minv_id from t_drec))

	delete from t_minv where minv_typ=@mso_typ and minv_id not in (select minv_id from t_drec)
	delete from t_mdc where mdc_typ=@mso_typ and mdc_id not in (select t_mdc.mdc_id from t_mdc inner join t_minv on t_mdc.mdc_id=t_minv.minv_id inner join t_drec on t_minv.minv_id=t_drec.minv_id where minv_typ=@mso_typ)
	delete from t_mso where mso_typ=@mso_typ and mso_id not in (select t_mso.mso_id from t_mso inner join t_mdc on t_mso.mso_id=t_mdc.mdc_id inner join t_minv on t_mdc.mdc_id=t_minv.minv_id inner join t_drec on t_minv.minv_id=t_drec.minv_id where minv_typ=@mso_typ )

	
	delete from t_minv where minv_typ=@mso_typ and minv_id not in (select minv_id from t_drec)
	delete from t_mdc where mdc_typ=@mso_typ and mdc_id not in (select t_mdc.mdc_id from t_mdc inner join t_minv on t_mdc.mdc_id=t_minv.minv_id inner join t_drec on t_minv.minv_id=t_drec.minv_id where minv_typ=@mso_typ)
	delete from t_mso where mso_typ=@mso_typ and mso_id not in (select t_mso.mso_id from t_mso inner join t_mdc on t_mso.mso_id=t_mdc.mdc_id inner join t_minv on t_mdc.mdc_id=t_minv.minv_id inner join t_drec on t_minv.minv_id=t_drec.minv_id where minv_typ=@mso_typ )

		
end

