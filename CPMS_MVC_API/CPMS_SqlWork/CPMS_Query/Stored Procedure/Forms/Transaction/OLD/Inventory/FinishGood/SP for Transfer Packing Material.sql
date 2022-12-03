USE [MFI]
GO

/****** Object:  StoredProcedure [dbo].[sp_miss_pack]    Script Date: 09/20/2013 16:03:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--select * from t_miss where titm_id=100 and mso_id=1 and miss_typ='G'
--exec sp_miss_pack_del 1092 ,1,''

--exec sp_miss_pack 104,'01',1,''

ALTER proc [dbo].[sp_miss_pack] (@dfg_id int,@m_yr_id char(2),@usr_id int,@aud_ip varchar(100))
as

--exec sp_miss_pack_del @mfg_id ,@usr_id,@aud_ip 
--select * from t_miss where miss_id=11169
	declare @mso_id int,@titm_id_fg int,@bd_id int,@mfg_dat datetime,@dfg_exp datetime,@dfg_bat varchar(100),@itmqty_id int,@dfg_rec float,@stk_qty float,@stk_tqty float,@master_titm_qty float,@inner_sca_id int,@master_sca_id int,@cus_id int,@miss_id int,@miss_nob float,@miss_ckso bit,@titm_id int,@wh_id int,@dsopk_exp datetime,@dfg_chlbk float,@miss_des varchar(100),@pack_exp datetime,@itmsubmas_expact bit,@mfg_id int
	set @stk_tqty=0
--Insert Record of Packing Transfer
	declare  packing  cursor for
		select t_mfg.mfg_id,dfg_id,t_dfg.mso_id,t_dfg.titm_id,t_dso.bd_id,cus_id,mfg_dat,dfg_exp,dfg_bat,chlbk_no,dfg_pack,dfg_batqty,round(dfg_pack/master_titm_qty,4) as [master_titm_qty],t_dfg.wh_id,t_dfg.miss_id from t_mfg inner join t_dfg on t_mfg.mfg_id=t_dfg.mfg_id inner join t_mso on t_dfg.mso_id=t_mso.mso_id inner join t_dso on t_mso.mso_id=t_dso.mso_id and t_dfg.titm_id=t_dso.titm_id inner join t_itm on t_dfg.titm_id=t_itm.titm_id where t_dfg.dfg_id=@dfg_id and dso_prod<>0		
		OPEN packing
			FETCH NEXT FROM packing
			INTO @mfg_id,@dfg_id,@mso_id,@titm_id_fg ,@bd_id,@cus_id,@mfg_dat,@dfg_exp,@dfg_bat,@dfg_chlbk,@dfg_rec,@miss_nob,@master_titm_qty,@wh_id,@miss_id
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
						set @miss_des='FGTN # '+rtrim(cast(@mfg_id as varchar(1000)))+' Chlbk # '+rtrim(cast(@dfg_chlbk as varchar(1000)))						
								if (@miss_id is null)
									begin
										exec ins_t_miss '01','01',@m_yr_id,@mfg_dat,@miss_nob ,@titm_id_fg,0,0,@cus_id,@bd_id,1,@miss_ckso ,@mso_id,'G',0,'','',@usr_id,@aud_ip,@miss_id_out=@miss_id output																									
										update t_dfg set miss_id=@miss_id where dfg_id=@dfg_id and titm_id=@titm_id_fg and mso_id=@mso_id
									print 'MISS BLANK'
									end
								else
									begin
										exec upd_t_miss '01','01',@miss_id,@mfg_dat,@miss_nob,@titm_id_fg,0,0,1,@miss_ckso,@mso_id,@cus_id,@bd_id,'G',0,'','',@usr_id,@aud_ip									
										exec del_t_diss @miss_id
									print @miss_id
									end
						--Detail Issue
							--Inner Packing
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
--													set @stk_tqty=(select case itmsubmas_masact when 1 then round(dso_prod/FG.master_titm_qty,4) else dso_prod end +sum(stk_qty) from m_stk inner join t_dsopk on m_stk.mso_id=t_dsopk.mso_id and m_stk.itm_id=t_dsopk.titm_id inner join t_itm on m_Stk.itm_id=t_itm.titm_id inner join m_itmsub on t_itm.itmsub_id=m_itmsub.itmsub_id inner join m_itmsubmas on m_itmsub.itmsubmas_id=m_itmsubmas.itmsubmas_id inner join t_dso on t_dsopk.mso_id=t_dso.mso_id and t_dsopk.titm_id_fg=t_dso.titm_id inner join t_itm FG on t_dsopk.titm_id_fg=FG.titm_id where m_stk.mso_id=@mso_id and m_stk.itm_id=@titm_id and dso_prod<>0 group by dso_prod,itmsubmas_masact,FG.master_titm_qty)	
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
					INTO @mfg_id,@dfg_id,@mso_id,@titm_id_fg ,@bd_id,@cus_id,@mfg_dat,@dfg_exp,@dfg_bat,@dfg_chlbk,@dfg_rec,@miss_nob,@master_titm_qty,@wh_id,@miss_id
						
						
		end
		CLOSE packing
		DEALLOCATE packing


GO


