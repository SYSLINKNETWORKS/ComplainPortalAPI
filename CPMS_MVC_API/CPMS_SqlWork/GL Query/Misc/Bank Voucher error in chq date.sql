USE MFI
GO
--select * from t_mvch where mvch_dt>'06/30/2013'
----Master Voucher
declare @mvch_id_old char(12),@mvch_dat datetime,@mvch_chqdat datetime,@mvch_chq int,@mvch_pto varchar(100),@dpt_id char(2),@typ_id char(2),@mvch_app char(1),@mvch_id char(12),@mvch_oldvoucherno char(12),@yr_id char(2),@mvch_cb char(2),@mvch_ref varchar(1000),@mvch_chqst bit,@cur_id int,@mvch_rat float,@dvch_nar varchar(1000),@dvch_dr_famt float,@dvch_cr_famt float,@acc_id char(20),@dvch_row int
declare  insvoucher  cursor for
		SELECT distinct t_mvch.mvch_id,t_mvch.mvch_dt,mvch_chqdat,mvch_pto,dpt_id,mvch_ref,mvch_chq,mvch_chqst,cur_id,mvch_rat from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.yr_id=t_dvch.yr_id and t_mvch.mvch_id=t_dvch.mvch_id and t_mvch.typ_id=t_dvch.typ_id where mvch_typ='U' and t_mvch.typ_id='04' and t_mvch.mvch_dt<>mvch_chqdat and t_mvch.mvch_chqdat between '07/01/2012' and '06/30/2013'--and mvch_id='001-20120707'
			OPEN insvoucher
				FETCH NEXT FROM insvoucher
				INTO @mvch_id_old,@mvch_dat,@mvch_chqdat,@mvch_pto,@dpt_id,@mvch_ref,@mvch_chq,@mvch_chqst,@cur_id,@mvch_rat
					WHILE @@FETCH_STATUS = 0
					BEGIN
					exec ins_t_mvch '01','01',@mvch_chqdat,@mvch_dat,@mvch_pto,@dpt_id,'04','01',1,'B',@mvch_ref,'U',@mvch_chq,@mvch_chqdat,0,@mvch_chqst,@cur_id,@mvch_rat,'','','','',@mvch_id_old,@mvch_id_out=@mvch_id output
--					print @mvch_id_old
					--Detail
						declare  detailvoucher  cursor for
						select dvch_row,acc_id,dvch_nar,dvch_dr_famt,dvch_cr_famt from t_dvch where typ_id='04' and mvch_id=@mvch_id_old
									OPEN detailvoucher
										FETCH NEXT FROM detailvoucher
										INTO @dvch_row,@acc_id,@dvch_nar,@dvch_dr_famt,@dvch_cr_famt
											WHILE @@FETCH_STATUS = 0
											BEGIN
											exec ins_t_dvch '01','01',@mvch_id,@mvch_chqdat,@dvch_row,@acc_id,@dvch_nar,@dvch_dr_famt,@dvch_cr_famt,'04','01'
												--print @mvch_id
													FETCH NEXT FROM detailvoucher
													INTO @dvch_row,@acc_id,@dvch_nar,@dvch_dr_famt,@dvch_cr_famt
											end
											CLOSE detailvoucher
											DEALLOCATE detailvoucher
						--Delete Voucher
						exec del_t_vch '01','01',@mvch_id_old,'04','01','B',0,'','','',''
	
					FETCH NEXT FROM insvoucher
				INTO @mvch_id_old,@mvch_dat,@mvch_chqdat,@mvch_pto,@dpt_id,@mvch_ref,@mvch_chq,@mvch_chqst,@cur_id,@mvch_rat
			end
			CLOSE insvoucher
			DEALLOCATE insvoucher
			GO
	
	
