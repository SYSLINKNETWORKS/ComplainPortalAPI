USE MFI
GO
alter proc sp_stkadj_pack (@mstkadj_id int,@m_yr_id char(2),@usr_id int,@aud_ip varchar(100))
as

	declare @mso_id int,@titm_id_fg int,@bd_id int,@mfg_dat datetime,@dfg_exp datetime,@dfg_bat varchar(100),@itmqty_id int,@dfg_rec float,@stk_qty float,@stk_tqty float,@master_titm_qty float,@inner_sca_id int,@master_sca_id int,@cus_id int,@miss_id int,@miss_nob float,@miss_ckso bit,@titm_id int,@wh_id int,@dsopk_exp datetime,@dfg_chlbk float,@miss_des varchar(100),@itmsubmas_expact as bit,@pack_exp datetime
	set @stk_tqty=0
--Insert Record of Packing Transfer
	declare  packing  cursor for
			
		select pack_mso_id,pack_titm_id,pack_bd_id,cus_id,mstkadj_dat,pack_dstkadj_exp,dstkadj_bat,'',case mstkadj_pc when 0 then dstkadj_qty else dstkadj_qty/inner_titm_qty end as [dstkadj_qty],0 as [miss_nob],ROUND((dstkadj_qty/master_titm_qty),4) as [master_titm_qty],wh_id,miss_id from t_mstkadj inner join t_dstkadj on t_mstkadj.mstkadj_id=t_dstkadj.mstkadj_id inner join t_itm on t_dstkadj.pack_titm_id=t_itm.titm_id inner join t_mso on t_dstkadj.pack_mso_id=t_mso.mso_id where t_mstkadj.mstkadj_id=@mstkadj_id and pack_ck=1
		OPEN packing
			FETCH NEXT FROM packing
			INTO @mso_id,@titm_id_fg ,@bd_id,@cus_id,@mfg_dat,@dfg_exp,@dfg_bat,@dfg_chlbk,@dfg_rec,@miss_nob,@master_titm_qty,@wh_id,@miss_id
				WHILE @@FETCH_STATUS = 0
				BEGIN

					set @stk_tqty=@dfg_rec

					if (@mso_id =null)
						begin
							set @miss_ckso=0
						end
					else
						begin
							set @miss_ckso=1
						end
						PRINT 'Get Miss ID'
						print @mstkadj_id
						print @titm_id_fg
						print @mso_id
								print 'New MISS'
						set @miss_des='Stock Adjustment # '+rtrim(cast(@mstkadj_id as varchar(1000)))+' Chlbk # '+rtrim(cast(@dfg_chlbk as varchar(1000)))
								exec	ins_t_miss '01','01',@mfg_dat,@miss_nob ,@titm_id_fg,0,0,@cus_id,@bd_id,1,@miss_ckso ,@mso_id,'A',0,'','',@usr_id,@aud_ip,@miss_id_out=@miss_id output																	
								update t_dstkadj set miss_id=@miss_id where mstkadj_id=@mstkadj_id and pack_titm_id=@titm_id_fg and pack_mso_id=@mso_id
								
							--Detail Packing
								declare  DetailIssueInner  cursor for
									SELECT distinct t_dsopk.titm_id,case when itmsubmas_masact=1 then @master_titm_qty else @dfg_rec end,itmsubmas_expact from t_dsopk inner join t_itm on t_dsopk.titm_id=t_itm.titm_id left join m_itmsub on t_itm.itmsub_id=m_itmsub.itmsub_id left join m_itmsubmas on m_itmsub.itmsubmas_id=m_itmsubmas.itmsubmas_id where mso_id=@mso_id and titm_id_fg=@titm_id_fg order by titm_id
									OPEN DetailIssueInner
										FETCH NEXT FROM DetailIssueInner
										INTO @titm_id,@dfg_rec,@itmsubmas_expact
											WHILE @@FETCH_STATUS = 0
											BEGIN
											if (@itmsubmas_expact=1)
												begin
													set @pack_exp=@dfg_exp
												end
											else
												begin
													set @pack_exp=null
												end
													set @stk_tqty=@dfg_rec
													set @wh_id=(select top 1 wh_id from m_stk where itm_id=@titm_id and bd_id=@bd_id and stk_frm in ('t_itm','GRN')  )
													exec ins_t_diss '01','01',@m_yr_id,@pack_exp,@dfg_rec,@dfg_rec,@titm_id,@miss_id,@wh_id,'S',0,@miss_des,'',@usr_id,@aud_ip,'',''
												FETCH NEXT FROM DetailIssueInner
												INTO @titm_id,@dfg_rec,@itmsubmas_expact
											end
									CLOSE DetailIssueInner
									DEALLOCATE DetailIssueInner
						--Issue Voucher
						exec sp_voucher_iss '01','01',@m_yr_id,@miss_id,@usr_id,@aud_ip,''
					FETCH NEXT FROM packing
					INTO @mso_id,@titm_id_fg ,@bd_id,@cus_id,@mfg_dat,@dfg_exp,@dfg_bat,@dfg_chlbk,@dfg_rec,@miss_nob,@master_titm_qty,@wh_id,@miss_id
						
						
		end
		CLOSE packing
		DEALLOCATE packing
		GO
