USE meiji_rusk
GO

--alter table t_miss add mvch_no_con int
--alter table m_sys add con_acc_exp int
--update m_sys set con_acc_exp=(select acc_no from gl_m_acc where acc_id='05001012')

--Voucher for Raw Material Contractor
alter proc sp_voucher_iss_con (@com_id char(2),@br_id char(3),@m_yr_id char(2),@miss_id int,@usr_id int,@aud_ip varchar(250),@aud_des varchar(1000))
as
declare
@miss_dat datetime,
@miss_rmk varchar(250),
@con_id int,
@con_nam varchar(250),
@con_amt float,
@acc_no int,
@row_id int,
@mvch_no int,
@nar varchar(1000),
@cur_id int,
@miss_rat float
begin
--GL Voucher
		set @row_id=0
		set @cur_id=(select cur_id from m_cur where cur_typ='S')
		set @miss_rat=1
		set @mvch_no=(select t_miss.mvch_no_con from t_miss inner join t_mvch on t_miss.mvch_no_con=t_mvch.mvch_no and t_mvch.typ_id='05' and t_mvch.com_id=@com_id and t_mvch.br_id=@br_id and t_mvch.yr_id=@m_yr_id where miss_id=@miss_id)
		set @miss_dat=(select miss_dat from t_miss where miss_id=@miss_id)
		set @con_id=(select con_id from t_miss where miss_id=@miss_id and con_id is not null)
		set @con_nam=(select con_nam from m_con where con_id=@con_id)
		set @con_amt=(select miss_nob* conrat_rat from t_miss inner join m_conrat on t_miss.con_id=m_conrat.con_id where miss_id=@miss_id and conrat_dat=(select MAX(conrat_dat) from m_conrat mconrat where m_conrat.con_id=mconrat.con_id and mconrat.conrat_dat <=miss_dat))
		if (@mvch_no is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@miss_dat,@miss_dat,'','01','05','Y','C',@miss_rmk,'S',0,@miss_dat,0,0,@cur_id,@miss_rat,0,0,'',@aud_des,@usr_id,@aud_ip,'','',@mvch_no_out=@mvch_no output
				update t_miss set mvch_no_con=@mvch_no where miss_id=@miss_id
			end
		else
			begin
--				exec upd_t_mvch @com_id,@br_id,@m_yr_id,@mvch_no,@miss_dat,'05','Y','','01','C',@miss_rmk,0,miss_dat,0,0,@cur_id,@miss_rat,'S',0,0,'',@aud_des,@usr_id,@aud_ip
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
			end
--Detail Voucher
					set @nar='Raw Material Transfer # ' + rtrim(cast(@miss_id as char(100))) + ' Contractor : '+RTRIM(@con_nam)
					--Debit Voucher				
					set @row_id=@row_id+1
					set @acc_no=(select con_acc_exp from m_sys)
					exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,@con_amt,0

					--Credit Voucher				
					set @nar='Raw Material Transfer # ' + rtrim(cast(@miss_id as char(100)))  
					set @row_id=@row_id+1
					set @acc_no=(select acc_no from m_con where con_id=@con_id)
					exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,0,@con_amt


				

end		

