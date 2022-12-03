USE NATHI
GO

--exec sp_voucher_del_openingvch '01','01','01','','',1,''

--Opening Voucher Delete
alter proc sp_voucher_del_openingvch (@com_id char(2),@br_id char(3),@m_yr_id char(2),@mvch_tax bit,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
begin
		delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no in (select mvch_no from t_mvch where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and typ_id='06' and mvch_tax=@mvch_tax) 
		delete from t_mvch where com_id=@com_id and br_id=@br_id and typ_id='06' and yr_id=@m_yr_id and mvch_tax=@mvch_tax 
end

go

--exec sp_voucher_openingvch '01','02','01',3364,'01003001',2,1,0,33623884.161,0,'','',1,''

--Openvoucher Insert
alter proc sp_voucher_openingvch (@com_id char(2),@br_id char(3),@m_yr_id char(2),@acc_no int,@acc_id varchar(20),@cur_id int,@acc_rat float,@mvch_tax bit,@dvch_dr_famt float,@dvch_cr_famt float,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mvch_no int,
@mvch_dat datetime,
@typ_id char(2),
@dvch_row int
begin
	set @aud_act='Insert'
	set @typ_id='06'
	set @mvch_dat=(select yr_str_dt from gl_m_yr where yr_id=@m_yr_id )
	set @dvch_row=(select max(dvch_row) from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no where t_mvch.com_id=@com_id and t_mvch.br_id=@br_id and yr_id=@m_yr_iD and mvch_tax=@mvch_tax)+1
	
	if @dvch_row is null
		begin
			set @dvch_row=1
		end


			--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@mvch_dat,@mvch_dat,'Opening Voucher','01',@typ_id,'Y','C','','S',0,@mvch_dat,0,0,@cur_id,@acc_rat,0,@mvch_tax,@aud_frmnam,@aud_des,@usr_id,@aud_ip,'','',@mvch_no_out =@mvch_no output
			--Detail Voucher
				exec ins_t_dvch @com_id,@br_id,@mvch_no,@dvch_row,@acc_no,'Opening Voucher',@dvch_dr_famt,@dvch_cr_famt
--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end		

