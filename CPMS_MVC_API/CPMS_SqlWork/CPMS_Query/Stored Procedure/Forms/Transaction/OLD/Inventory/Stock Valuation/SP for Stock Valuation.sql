USE MFI
GO
--SELECT dfg_batqty,miss_id_fg from t_mfg inner join t_dfg on t_mfg.mfg_id=t_dfg.mfg_id where mfg_typ='U'

--		set @diss_rat=isnull((select case when sum(stk_qty)=0 then 0 else round(sum(stk_qty*stk_trat)/sum(stk_qty),4) end from m_Stk where stk_frm in ('t_itm','GRN') and itm_id=@titm_id and stk_dat<=@stk_dat and m_yr_id=@m_yr_id),0) 
--exec sp_miss_rat '01','07/31/2012'
--select * from t_miss where miss_dat ='07/24/2012' --and miss_typ='U'
--miss_id in (4645,4648)
--select * from t_dso where mso_id=15
--select * from t_diss where diss_rat=0
--select * from m_stk where t_id=4648-- and itm_id=246
--select * from t_miss inner join t_diss on t_miss.miss_id=t_diss.miss_id where t_miss.miss_id=10071
--select * from t_itm where itmsub_id is null
--select * from t_dfg where miss_id=10071
--select miss_nob,sum(diss_namt) from t_miss inner join t_diss on t_miss.miss_id=t_diss.miss_id where t_miss.miss_id=165 group by miss_nob
--select sum(diss_namt) from t_miss inner join t_diss on t_miss.miss_id=t_diss.miss_id where t_miss.miss_id=10071
--SELECT DATEADD(mm, DATEDIFF(mm,0,getdate()), 0)

alter proc sp_miss_rat(@m_yr_id char(2),@dt2 datetime)
as
declare @dt1 datetime,@diss_rat float,@miss_id int,@miss_dat datetime,@titm_id int,@mstkadjmon_id int,@mstkadjmon_dat datetime,@dstkadjmon_rat float,@mprtexp_id int,@mprtexp_dat datetime,@dprtexp_rat float,
@mfg_id int,@dfg_id int,@mfg_typ char(1),@dfg_rat float,@miss_id_rm int,@miss_id_pack int,@titm_id_fg int,@dfg_rec float,@mfg_dat datetime,@dfg_bat char(250),
@mdc_id int,@ddc_bat varchar(250),@mdc_dat datetime,@ddc_rat float,@mso_id int,@mso_id_stk int,@mso_dat datetime,@dso_bat varchar(250),@dso_rat float,
@mstkadj_id int,@dstkadj_bat varchar(250),@dstkadj_rat float,@dfg_rat_pk_semi float,@dfg_iss float
begin
set @dt1=(SELECT DATEADD(mm, DATEDIFF(mm,0,@dt2), 0))--(select yr_str_dt from gl_m_yr where yr_id=@m_yr_id)
set @titm_id=2
print 'Issue'
--set @str_cond=' and t_itm.titm_id=2'
	declare  diss_rat1  cursor for			
		select t_miss.miss_id,miss_dat,t_diss.titm_id from t_miss inner join t_diss on t_miss.miss_id=t_diss.miss_id inner join t_itm on t_diss.titm_id=t_itm.titm_id
		where diss_qty<>0  and miss_dat between @dt1 and @dt2 and t_miss.m_yr_id=@m_yr_id --and t_itm.titm_id=@titm_id
		OPEN diss_rat1
			FETCH NEXT FROM diss_rat1
			INTO @miss_id,@miss_dat,@titm_id
				WHILE @@FETCH_STATUS = 0
				BEGIN
				set @diss_rat=isnull((select case when sum(stk_qty)=0 then 0 else ROUND(avg(isnull(stk_trat,0)),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and stk_frm in ('t_itm','GRN') and itm_id=@titm_id and stk_dat<=@miss_dat and m_yr_id=@m_yr_id),0) 
				update t_diss set diss_rat=@diss_rat where miss_id=@miss_id and titm_id=@titm_id
				update m_stk set stk_rat=@diss_rat where t_id=@miss_id and stk_frm='TransRM' and itm_id=@titm_id
				print @miss_id				
					FETCH NEXT FROM diss_rat1
					INTO @miss_id,@miss_dat,@titm_id											
		end
		CLOSE diss_rat1
		DEALLOCATE diss_rat1
--	RM Issue Voucher
		declare  diss_vch  cursor for			
			select distinct t_miss.miss_id from t_miss inner join t_diss on t_miss.miss_id=t_diss.miss_id
			where miss_dat between @dt1 and @dt2 and t_miss.m_yr_id=@m_yr_id --and t_itm.titm_id=@titm_id		
			OPEN diss_vch
				FETCH NEXT FROM diss_vch
				INTO @miss_id
					WHILE @@FETCH_STATUS = 0
					BEGIN
					print @miss_id
						exec sp_voucher_iss '01','01',@m_yr_id,@miss_id,'','',''
						FETCH NEXT FROM diss_vch
						INTO @miss_id											
			end
			CLOSE diss_vch
			DEALLOCATE diss_vch
--Raw Adjustment
print 'Raw Ajustment'
	declare  diss_rat1  cursor for			
		select t_mstkadjmon.mstkadjmon_id,mstkadjmon_dat,t_dstkadjmon.titm_id from t_mstkadjmon inner join t_dstkadjmon on t_mstkadjmon.mstkadjmon_id=t_dstkadjmon.mstkadjmon_id 
		inner join t_itm on t_dstkadjmon.titm_id=t_itm.titm_id
		where mstkadjmon_dat between @dt1 and @dt2 --and t_itm.titm_id=@titm_id
		OPEN diss_rat1
			FETCH NEXT FROM diss_rat1
				INTO @mstkadjmon_id,@mstkadjmon_dat,@titm_id											
				WHILE @@FETCH_STATUS = 0
				BEGIN
				set @dstkadjmon_rat=isnull((select case when sum(stk_qty)=0 then 0 else ROUND(avg(isnull(stk_trat,0)),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and stk_frm in ('t_itm','GRN') and itm_id=@titm_id and stk_dat<=@mstkadjmon_dat and m_yr_id=@m_yr_id),0) 
				update t_dstkadjmon set dstkadjmon_rat=@dstkadjmon_rat where mstkadjmon_id=@mstkadjmon_id and titm_id=@titm_id
				update m_stk set stk_rat=@dstkadjmon_rat where t_id=@mstkadjmon_id and stk_frm='stk_adjmon' and itm_id=@titm_id
				print @miss_id				
					FETCH NEXT FROM diss_rat1
					INTO @mstkadjmon_id,@mstkadjmon_dat,@titm_id											
		end
		CLOSE diss_rat1
		DEALLOCATE diss_rat1

--Adjusment Voucher
print 'Raw Adjustment Voucher'
		declare  adj_vch1  cursor for			
			select t_mstkadjmon.mstkadjmon_id from t_mstkadjmon 
			where mstkadjmon_dat between @dt1 and @dt2 
			OPEN adj_vch1
				FETCH NEXT FROM adj_vch1
				INTO @mstkadjmon_id
					WHILE @@FETCH_STATUS = 0
					BEGIN
						exec sp_voucher_stkadjmon '01','01',@m_yr_id,@mstkadjmon_id,'','','',''
						FETCH NEXT FROM adj_vch1
						INTO @mstkadjmon_id											
			end
			CLOSE adj_vch1
			DEALLOCATE adj_vch1
--Print Expiry
print 'Print Expiry'
	declare  diss_prt1  cursor for			
		select t_mprtexp.mprtexp_id,mprtexp_dat,t_dprtexp.titm_id from t_mprtexp inner join t_dprtexp on t_mprtexp.mprtexp_id=t_dprtexp.mprtexp_id 
		inner join t_itm on t_dprtexp.titm_id=t_itm.titm_id
		where mprtexp_dat between @dt1 and @dt2 --and t_itm.titm_id=@titm_id

		OPEN diss_prt1
			FETCH NEXT FROM diss_prt1
				INTO @mprtexp_id,@mprtexp_dat,@titm_id											
				WHILE @@FETCH_STATUS = 0
				BEGIN
				set @dprtexp_rat=isnull((select case when sum(stk_qty)=0 then 0 else ROUND(avg(isnull(stk_trat,0)),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and stk_frm in ('t_itm','GRN') and itm_id=@titm_id and stk_dat<=@mprtexp_dat and m_yr_id=@m_yr_id),0) 
				update t_dprtexp set dprtexp_rat=@dprtexp_rat where mprtexp_id=@mprtexp_id and titm_id=@titm_id
				update m_stk set stk_rat=@dprtexp_rat where t_id=@mprtexp_id and stk_frm='stk_prtexp' and itm_id=@titm_id and m_yr_id=@m_yr_id
				print @miss_id				
					FETCH NEXT FROM diss_prt1
					INTO @mprtexp_id,@mprtexp_dat,@titm_id											
		end
		CLOSE diss_prt1
		DEALLOCATE diss_prt1
--Finish Goods Rates
print 'Finish Goods'
				declare  dfg_1  cursor for			
		select t_mfg.mfg_id,mfg_dat,dfg_id,t_dfg.titm_id,dfg_rec,mfg_typ,dfg_bat,titm_id_fg from t_mfg inner join t_dfg on t_mfg.mfg_id=t_dfg.mfg_id
			where mfg_dat between @dt1 and @dt2 --and t_dfg.titm_id=100 and t_mfg.mfg_id=40
			OPEN dfg_1
				FETCH NEXT FROM dfg_1
				INTO @mfg_id,@mfg_dat,@dfg_id,@titm_id,@dfg_rec,@mfg_typ,@dfg_bat,@titm_id_fg
					WHILE @@FETCH_STATUS = 0
					BEGIN
--Rates
		set @miss_id_rm=(select miss_id_fg from t_dfg where dfg_id=@dfg_id)
		set @miss_id_pack=(select miss_id from t_dfg where dfg_id=@dfg_id)
		set @dfg_rat=0
		set @dfg_rat_pk_semi=0
		
		--Semi Finish
		if (@mfg_typ='E')
			begin
				--set @dfg_rat_pk_semi=(SELECT  round(sum(diss_rat),4)  from t_diss where miss_id=@miss_id_pack)
				--set @dfg_rat=(select avg(stk_trat) from m_stk where itm_id=@titm_id_fg and stk_frm in ('t_itm','GRN') and stk_qty<>0 and stk_dat<=@mfg_dat)
				set @dfg_rat_pk_semi=(SELECT  round(sum(diss_namt),4)  from t_diss where miss_id=@miss_id_pack)
				set @dfg_rat=(select ROUND(avg(isnull(stk_trat,0)),4) from m_stk where stk_qty<>0 and m_yr_id=@m_yr_id and itm_id=@titm_id_fg and stk_frm in ('t_itm','GRN') and stk_qty<>0 and stk_dat<=@mfg_dat)
				set @dfg_iss=(select dfg_iss from t_dfg where dfg_id=@dfg_id)
				set @dfg_rat=@dfg_rat*@dfg_iss
				set @dfg_rat=@dfg_rat+@dfg_rat_pk_semi
				set @dfg_rat=round(@dfg_rat/@dfg_rec,4)
				set @dfg_rat_pk_semi=round(@dfg_rat_pk_semi/@dfg_rec,4)
			end
		--Semi Finish Petti in KG
		else if (@mfg_typ='M')
			begin
				set @dfg_rat=@dfg_rat+(SELECT  round((sum(diss_namt)/miss_nob)/mbat_siz,4)  from t_miss inner join t_diss on t_miss.miss_id=t_diss.miss_id inner join m_mbat on t_miss.mbat_id=m_mbat.mbat_id where t_miss.miss_id=@miss_id_rm group by mbat_siz,miss_nob)
			end
		--Others
		else
			begin
			
				set @dfg_rat=isnull((SELECT case when miss_nob>0 then (round(sum(diss_namt)/miss_nob,4)*dfg_batqty) else 0 end from t_miss inner join t_diss on t_miss.miss_id=t_diss.miss_id inner join t_dfg on t_miss.miss_id=t_dfg.miss_id_fg where dfg_id=@dfg_id  group by miss_nob,dfg_batqty),0)
				set @dfg_rat=@dfg_rat+isnull((SELECT round(sum(diss_namt),4)  from t_miss inner join t_diss on t_miss.miss_id=t_diss.miss_id inner join t_dfg on t_miss.miss_id=t_dfg.miss_id where dfg_id=@dfg_id),0)
				set @dfg_rat=round(@dfg_rat/@dfg_rec,4)
			end
		update t_dfg set dfg_rat=@dfg_rat,dfg_rat_pk_semi=@dfg_rat_pk_semi where dfg_id=@dfg_id
		update m_stk set stk_rat=@dfg_rat+@dfg_rat_pk_semi where t_id=@mfg_id and itm_id=@titm_id and stk_bat=@dfg_bat and stk_frm='TransFG' and m_yr_id=@m_yr_id
		
		
		
					FETCH NEXT FROM dfg_1
					INTO @mfg_id,@mfg_dat,@dfg_id,@titm_id,@dfg_rec,@mfg_typ,@dfg_bat,@titm_id_fg
		end
		CLOSE dfg_1
		DEALLOCATE dfg_1

--Finish Goods Voucher
print 'Finish Goods Voucher'
		declare  mfg_vch  cursor for			
			select mfg_id from t_mfg
			where mfg_dat between @dt1 and @dt2 
			OPEN mfg_vch
				FETCH NEXT FROM mfg_vch
				INTO @mfg_id
					WHILE @@FETCH_STATUS = 0
					BEGIN
					print @mfg_id
					exec sp_voucher_fg '01','01',@m_yr_id ,@mfg_id,'','',''
					FETCH NEXT FROM mfg_vch
					INTO @mfg_id
		end
		CLOSE mfg_vch
		DEALLOCATE mfg_vch
		
--Transfer Finish Goods Through SO
print 'Transfer Finish Goods through SO'
		declare  mso_1  cursor for			
			select t_mso.mso_id,mso_id_stk,titm_id,dso_bat from t_mso inner join t_dso on t_mso.mso_id=t_dso.mso_id where mso_id_stk is not null
			and mso_dat between @dt1 and @dt2 
			OPEN mso_1
				FETCH NEXT FROM mso_1
				INTO @mso_id,@mso_id_stk,@titm_id,@dso_bat
					WHILE @@FETCH_STATUS = 0
					BEGIN					
					set @dso_rat=(select case when sum(stk_qty)=0 then 0 else ROUND(avg(isnull(stk_trat,0)),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and itm_id=@titm_id and stk_frm in ('t_itm','TransFG') and mso_id=@mso_id_stk and m_yr_id=@m_yr_id)
					update m_stk set stk_rat=@dso_rat where t_id=@mso_id and mso_id_stk=@mso_id_stk and itm_id=@titm_id and stk_bat=@dso_bat and stk_frm='SO' and m_yr_id=@m_yr_id
					update m_stk set stk_rat=@dso_rat where t_id=@mso_id and itm_id=@titm_id and stk_bat=@dso_bat and stk_frm='SO' and m_yr_id=@m_yr_id

					FETCH NEXT FROM mso_1
					INTO @mso_id,@mso_id_stk,@titm_id,@dso_bat
		end
		CLOSE mso_1
		DEALLOCATE mso_1


--DC RATE
print 'DC'
		declare  ddc_1  cursor for			
			select t_mdc.mdc_id,mso_id,mdc_dat,titm_id,bat_no from t_mdc inner join t_ddc on t_mdc.mdc_id=t_ddc.mdc_id
			where mdc_dat between @dt1 and @dt2 
			OPEN ddc_1
				FETCH NEXT FROM ddc_1
				INTO @mdc_id,@mso_id,@mdc_dat,@titm_id,@ddc_bat
					WHILE @@FETCH_STATUS = 0
					BEGIN					
					set @ddc_rat=(select case when sum(stk_qty)=0 then 0 else ROUND(avg(isnull(stk_trat,0)),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and itm_id=@titm_id and stk_dat<=@mdc_dat and stk_frm in ('t_itm','TransFG') and mso_id=@mso_id and m_yr_id=@m_yr_id)
					update m_stk set stk_rat=@ddc_rat where t_id=@mdc_id and itm_id=@titm_id and stk_bat=@ddc_bat and stk_frm='DC' and m_yr_id=@m_yr_id

					FETCH NEXT FROM ddc_1
					INTO @mdc_id,@mso_id,@mdc_dat,@titm_id,@ddc_bat
		end
		CLOSE ddc_1
		DEALLOCATE ddc_1
--Finish Goods Adjustment
print 'Finish Goods Ajustment'
		declare  mstkadj_1  cursor for			
			select t_mstkadj.mstkadj_id,mso_id,titm_id,dstkadj_bat from t_mstkadj inner join t_dstkadj on t_mstkadj.mstkadj_id=t_dstkadj.mstkadj_id
			where mstkadj_dat between @dt1 and @dt2 
			OPEN mstkadj_1
				FETCH NEXT FROM mstkadj_1
				INTO @mstkadj_id,@mso_id,@titm_id,@dstkadj_bat
					WHILE @@FETCH_STATUS = 0
					BEGIN					
					set @dstkadj_rat=(select case when sum(stk_qty)=0 then 0 else ROUND(avg(isnull(stk_trat,0)),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and stk_frm in ('t_itm','TransFG') and  itm_id=@titm_id and stk_bat=@dstkadj_bat and mso_id=@mso_id and m_yr_id=@m_yr_id)
					update m_stk set stk_rat=@dstkadj_rat where t_id=@mstkadj_id and itm_id=@titm_id and stk_bat=@dstkadj_bat and stk_frm='stk_adj' and m_yr_id=@m_yr_id

					FETCH NEXT FROM mstkadj_1
					INTO @mstkadj_id,@mso_id,@titm_id,@dstkadj_bat
		end
		CLOSE mstkadj_1
		DEALLOCATE mstkadj_1
end
