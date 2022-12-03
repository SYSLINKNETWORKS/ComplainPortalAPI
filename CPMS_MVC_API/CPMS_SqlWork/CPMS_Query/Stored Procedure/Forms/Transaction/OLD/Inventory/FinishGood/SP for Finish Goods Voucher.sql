USE MFI
GO
--select * from t_mfg where mfg_id=1
--select * from t_mvch where typ_id='05' and mvch_id='040-20120702'

--alter table t_mfg add mvch_id chaR(12)
--alter table m_sys add fg_acc char(20)
--update m_sys set fg_acc='05001010'
--exec sp_voucher_fg '01','01','01',9,1,'',''

--Voucher for Finish Goods Transfer
alter proc sp_voucher_fg (@com_id char(2),@br_id char(3),@m_yr_id char(2),@mfg_id int,@usr_id int,@aud_ip varchar(250),@aud_des varchar(1000))
as
declare
@mfg_dat datetime,
@mfg_namt float,
@mfg_rmk varchar(250),
@itm_id int,
@itm_amt float,
@acc_id varchar(20),
@row_id int,
@mvch_id char(20),
@nar varchar(1000),
@cur_id int,
@mfg_rat float,
@dfg_id int,
@dfg_rec float,
@mfg_typ char(1),
@rm_amt float,
@pk_amt float,
@dfg_petti_kg float,
@dfg_petti_amt float
begin
--GL Voucher
		--print 'Voucher row_id'
		set @row_id=0
		set @mfg_typ=(select mfg_typ from t_mfg where mfg_id=@mfg_id)
		--print 'Voucher Currency'
		set @cur_id=(select cur_id from m_cur where cur_typ='S')
		set @mfg_rat=1
		--print 'Voucher ID'
		set @mvch_id=(select mvch_id from t_mfg where mfg_id=@mfg_id)
		--print 'Voucher FG Date'
		set @mfg_dat=(select mfg_dat from t_mfg where mfg_id=@mfg_id)
		set @mfg_namt=(select sum(dfg_rec*dfg_rat) from t_dfg where mfg_id=@mfg_id)
		set @dfg_petti_amt =(select sum(dfg_pettikg*dfg_petti_rat) from t_dfg where mfg_id=@mfg_id)
		if (@mvch_id is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@mfg_dat,@mfg_dat,'','01','05',@m_yr_id,'Y','C',@mfg_rmk,'S',0,@mfg_dat,0,0,@cur_id,@mfg_rat,'Voucher of Finish Goods Transfer',@aud_des,@usr_id,@aud_ip,'',@mvch_id_out=@mvch_id output
				update t_mfg set mvch_id=@mvch_id where mfg_id=@mfg_id
			end
		else
			begin
				set @mvch_id=(select mvch_id from t_mvch where typ_id='05' and mvch_id=@mvch_id)
				if (@mvch_id is null)
					begin
						--Master Voucher
						exec ins_t_mvch @com_id,@br_id,@mfg_dat,@mfg_dat,'','01','05',@m_yr_id,'Y','C',@mfg_rmk,'S',0,@mfg_dat,0,0,@cur_id,@mfg_rat,'Voucher of Finish Goods Transfer',@aud_des,@usr_id,@aud_ip,'',@mvch_id_out=@mvch_id output
						update t_mfg set mvch_id=@mvch_id where mfg_id=@mfg_id						
					end
				else
					begin
						set @mfg_dat=(select mvch_dt from t_mvch where typ_id='05' and mvch_id=@mvch_id and com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id)
						update t_mvch set mvch_ref=@mfg_rmk,mvch_rat=@mfg_rat,cur_id=@cur_id where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
						delete from t_dvch where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
					end
			end
--Detail Voucher
					set @nar='Finish Goods Transfer # ' + cast(@mfg_id as char(100))  
--Debit Account
					set @row_id=@row_id+1
					set @acc_id=(select fg_acc from m_sys)
					--if (@mfg_typ='E')
					--begin
					--		set @mfg_namt=(select round(sum(dgrn_rat*(dfg_iss+dfg_was)),4) from t_dfg inner join t_dgrn on t_dfg.mgrn_id=t_dgrn.mgrn_id and t_dfg.titm_id_fg=t_dgrn.titm_id where mfg_id=@mfg_id)
					--		set @mfg_namt=@mfg_namt+isnull((select round(sum(dfg_rat_pk_semi*dfg_rec),4) from t_dfg where mfg_id=@mfg_id),0)
					--end
					--else
					--	begin
							set @mfg_namt=(select round(sum(dfg_rat*dfg_rec),4) from t_dfg where mfg_id=@mfg_id)+@dfg_petti_amt
						--end
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@mfg_dat,@row_id,@acc_id,@nar,@mfg_namt,0,'05',@m_yr_id
--exec sp_voucher_fg '01','01','01',1043,'','',''
	--Semi Finish
	if (@mfg_typ='E')
		begin
					--Packing Calculation
					set @row_id=@row_id+1
					set @acc_id=(select cacc_id from m_itm where itm_id=5)
					set @mfg_namt=(select round(sum(isnull(dfg_rat_pk_semi,0)*dfg_rec),4) from t_dfg where mfg_id=@mfg_id)
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@mfg_dat,@row_id,@acc_id,@nar,0,@mfg_namt,'05',@m_yr_id					
					--Material Calculation
					set @row_id=@row_id+1
					set @acc_id=(select cacc_id from m_itm where itm_id=8)
					--set @mfg_namt=(select round(sum(isnull(dfg_rat,0)*dfg_iss),4) from t_dfg where mfg_id=@mfg_id)
					set @mfg_namt=(select avg(stk_trat) from m_stk where itm_id in (select titm_id_fg from t_dfg where mfg_id=@mfg_id) and stk_frm in ('t_itm','GRN') and stk_qty<>0 and stk_dat<=@mfg_dat)					
						set @mfg_namt=@mfg_namt*(select sum(dfg_iss) from t_dfg where mfg_id=@mfg_id)
						exec ins_t_dvch @com_id,@br_id,@mvch_id,@mfg_dat,@row_id,@acc_id,@nar,0,@mfg_namt,'05',@m_yr_id					
		end
	--Petti
	else if (@mfg_typ='M')
		begin	
					print @mfg_typ
					set @row_id=@row_id+1
					set @acc_id=(select wacc_id from m_itm where itm_id=3)
					set @mfg_namt=(select round(sum(dfg_rat*dfg_rec),4) from t_dfg where mfg_id=@mfg_id)
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@mfg_dat,@row_id,@acc_id,@nar,0,@mfg_namt,'05',@m_yr_id
		end
		--Other than Semi Finish
	else 
		begin
			declare @miss_id int
				declare  fgamt  cursor for			
					select itm_id,dfg_id,dfg_rec from t_dfg inner join t_itm on t_dfg.titm_id=t_itm.titm_id where mfg_id=@mfg_id
					OPEN fgamt
						FETCH NEXT FROM fgamt
						INTO @itm_id,@dfg_id,@dfg_rec
							WHILE @@FETCH_STATUS = 0
							BEGIN
								--Credit RM
										set @row_id=@row_id+1
										set @acc_id=(select wacc_id from m_itm where itm_id=3)
										set @rm_amt=(SELECT  round((round(sum(diss_namt)/miss_nob,4)*dfg_batqty),4) from t_miss inner join t_diss on t_miss.miss_id=t_diss.miss_id inner join t_dfg on t_miss.miss_id=t_dfg.miss_id_fg where dfg_id=@dfg_id group by miss_nob,dfg_batqty)
										set @rm_amt=@rm_amt+isnull((select sum(dfg_pettikg*dfg_petti_rat) from t_dfg where dfg_id=@dfg_id),0)	
										exec ins_t_dvch @com_id,@br_id,@mvch_id,@mfg_dat,@row_id,@acc_id,@nar,0,@rm_amt,'05',@m_yr_id
								--Credit PK
								set @row_id=@row_id+1
								set @acc_id=(select wacc_id from m_itm where itm_id=5)
								set @pk_amt=isnull((SELECT round(sum(diss_namt),4)  from t_miss inner join t_diss on t_miss.miss_id=t_diss.miss_id inner join t_dfg on t_miss.miss_id=t_dfg.miss_id where dfg_id=@dfg_id),0)
								exec ins_t_dvch @com_id,@br_id,@mvch_id,@mfg_dat,@row_id,@acc_id,@nar,0,@pk_amt,'05',@m_yr_id
							
								FETCH NEXT FROM fgamt
								INTO @itm_id,@dfg_id,@dfg_rec
									
									
					end
					CLOSE fgamt
					DEALLOCATE fgamt
				end
			

end		

--select * from t_mfg where mfg_id=1045
--select * from t_dfg where mfg_id=1045
--select * from t_diss where miss_id=57
--select * from t_diss where miss_id=9979
