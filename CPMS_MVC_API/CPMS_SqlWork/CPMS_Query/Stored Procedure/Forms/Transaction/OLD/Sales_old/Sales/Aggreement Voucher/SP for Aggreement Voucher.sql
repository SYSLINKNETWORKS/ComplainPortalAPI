USE ZSons
GO
--exec sp_voucher_aggvch 6
--alter table t_maggvch add mvch_taxno int
--select * from t_maggvch
--alter table t_maggvch add mvch_no int
--alter table t_maggvch add maggvch_appdat datetime

--Delete
alter proc del_t_aggvch (@maggvch_id int)
as
declare
@com_id char(2),
@br_id char(3),
@m_yr_id char(2),
@mvch_no int
begin
	set @com_id=(select com_id from t_maggvch where maggvch_id=@maggvch_id)
	set @br_id=(select br_id from t_maggvch where maggvch_id=@maggvch_id)
	set @m_yr_id=(select m_yr_id from t_maggvch where maggvch_id=@maggvch_id)
	set @mvch_no=(select mvch_no from t_maggvch where maggvch_id=@maggvch_id)
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''

	update t_maggvch set maggvch_close=0,mvch_no=null where maggvch_id=@maggvch_id
end
go

--Insert
alter proc ins_t_aggvch (@com_id char(2),@br_id char(3),@m_yr_id char(2),@maggvch_id int,@maggvch_dat datetime,@maggvch_rmk varchar(250),@cus_id int,@daggvch_dis float,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@maggvch_no int,
@row_id int,
@acc_no int,
@cus_nam varchar(250),
@mvch_no int,
@cur_id int,
@nar varchar(1000),
@aud_act char(10)
begin
--GL Voucher
		set @aud_act ='Insert'
		set @row_id=0
		set @maggvch_no=(select maggvch_no from t_maggvch where maggvch_id=@maggvch_id)
		set @cus_nam=(select cus_nam from m_cus where cus_id=@cus_id)
		set @cur_id=(select cur_id from m_cur where cur_typ='S')

		set @mvch_no=(select mvch_no from t_maggvch where maggvch_id=@maggvch_id)
		if (@mvch_no is null)
			begin
				--Master Voucher			
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@maggvch_dat ,@maggvch_dat ,'','01','05','Y','C' ,@maggvch_rmk,'S','',@maggvch_dat,0,0,@cur_id,1,0,0,'','','','','','',@mvch_no_out=@mvch_no output
				update t_maggvch set mvch_no=@mvch_no,maggvch_close=1,maggvch_appdat=@maggvch_dat where maggvch_id=@maggvch_id
			end
		else
			begin
				update t_mvch set mvch_ref=@maggvch_rmk,mvch_rat=1,cur_id=@cur_id,mvch_can=0,mvch_tax=0 where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
			end
								
--Detail Voucher
		
						--Discount
						set @nar='Aggreement Voucher # ' + rtrim(cast(@maggvch_no as char(100))) +' Customer Name : ' +@cus_nam 
						set @row_id=@row_id+1
						set @acc_no=(select dis_acc from m_sys)
						exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,@daggvch_dis,0
	
						--Credit
						set @nar='Aggreement Voucher # ' + rtrim(cast(@maggvch_no as char(100))) 
						set @row_id=@row_id+1
						set @acc_no=(select acc_no from m_cus where cus_id=@cus_id)
						exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,0,@daggvch_dis
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end		
