
USE meiji_rusk
GO

--alter table t_adv add acc_id char(20),mvch_typ char(2)
--exec sp_voucher_adv '01','01','01',4,'04','B','B',62703304,62703304,1,'',''
--select * from t_adv
--SELECT * from t_dvch where mvch_id='002-20121226' and typ_id='04'

--select * from m_empcat

--update m_empcat set sal_accid =(select acc_no from gl_m_acc where acc_id=sal_accid)
--update m_empcat set bou_accid =(select acc_no from gl_m_acc where acc_id=bou_accid)
--update m_empcat set eid_accid =(select acc_no from gl_m_acc where acc_id=eid_accid)
--update m_empcat set sal_accid=581,bou_accid=582,eid_accid=583 where mempcat_id=1
--update m_empcat set sal_accid=441,bou_accid=442,eid_accid=443 where mempcat_id=2




--Voucher for Advance
alter proc sp_voucher_adv (@adv_id int)
as
declare
@com_id char(2),
@br_id char(3),
@m_yr_id char(2),
@aud_act char(10),
@adv_dat datetime,
@adv_amt float,
@cur_id int,
@acc_no int,
@sal_accid int,
@emppro_id int,
@emppro_nam char(250),
@mvch_typ char(2),
@mvch_nar varchar(250),
@row_id int,
@month varchar(100),
@adv_cb char(1),
@adv_chq int,
@mvch_no int,
@adv_chqdat datetime
begin
--GL Voucher
			set @aud_act='Insert'
			set @com_id=(select com_id from t_adv where adv_id=@adv_id)
			set @br_id=(select br_id from t_adv where adv_id=@adv_id)
			set @m_yr_id=(select m_yr_id from t_adv where adv_id=@adv_id)
			set @adv_cb=(select adv_cb from t_adv where adv_id=@adv_id)
			set @adv_chq=(select adv_chq from t_adv where adv_id=@adv_id)
			set @adv_chqdat=(select adv_dat from t_adv where adv_id=@adv_id)
			set @mvch_no=(select mvch_no from t_adv where adv_id=@adv_id)
			set @adv_dat=(select adv_dat from t_adv where adv_id=@adv_id)
			set @adv_amt=(select adv_amt from t_adv where adv_id=@adv_id)
			set @cur_id=(select cur_id from m_cur where cur_typ='S')
			set @acc_no=(select acc_no from t_adv where adv_id=@adv_id)
			set @emppro_id=(select emppro_id from t_adv where adv_id=@adv_id)
			set @emppro_nam =(select emppro_nam from m_emppro where emppro_id=@emppro_id)			
			set @month=(select datename(month,@adv_dat))
			
			
			set @row_id=0
			--Voucher Type
			if @adv_cb='C' 
				begin
					set @mvch_typ='02'
				end
			else if @adv_cb='B'
				begin
					set @mvch_typ='04'
					--update gl_bk_chq  set chq_act='Y' where chq_no=@adv_chq

				end	

		
		if (@mvch_no is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@adv_chqdat ,@adv_dat ,@emppro_nam,'01',@mvch_typ,'Y',@adv_cb ,'','S',@adv_chq,@adv_chqdat,0,0,@cur_id,1,0,0,'','','','','','',@mvch_no_out=@mvch_no output
				--Update the voucher number and type
				update t_adv set mvch_no=@mvch_no where adv_id=@adv_id 
			end
		else
			begin
				exec upd_t_mvch @com_id ,@br_id ,@m_yr_id ,@mvch_no ,@adv_chqdat ,@mvch_typ,'Y',@emppro_nam,'01',@adv_cb,'',@adv_chq,@adv_chqdat,0,0,@cur_id,1,'S',0,0,'','','',''
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
			end		
		--Detail Voucher
		set @mvch_nar='Paid advance# '+rtrim(cast(@adv_id as char(1000)))+' to '+rtrim(@emppro_nam) +' for the month of ' +@month
		
		--Debit
		set @row_id=@row_id+1
		set @sal_accid=(select sal_accid from m_emppro inner join m_empcat on m_emppro.emppro_cat=m_empcat.mempcat_id where emppro_id=@emppro_id)
		exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@sal_accid,@mvch_nar,@adv_amt,0
		
		--Cash/ Bank
		set @row_id=@row_id+1
		set @acc_no=(select acc_no from t_adv where adv_id=@adv_id)
		exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@mvch_nar,0,@adv_amt

		

end		

