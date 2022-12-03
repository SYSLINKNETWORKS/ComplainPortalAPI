USE ZSONS
go
--select sal_ret_acc from m_sys
--select acc_no from gl_m_acc where acc_id=(select sal_ret_acc from m_sys)
--update m_sys set sal_ret_acc=415

--EXEC sp_rpt_pl '01','01','01','07/01/2012','07/03/2012',2
--alter table m_sys add sal_ret_acc char(20)
--update m_sys set sal_ret_acc='04001010'
alter proc sp_rpt_PL(@com_id char(2),@m_yr_id char(2),@dt1 datetime,@dt2 datetime,@cur_id int)
as
declare
@cur_id_local int,
@cur_rat float,
@cur_snm varchar(100)
begin
	set @cur_id_local=(select cur_id from m_cur where cur_id=@cur_id and cur_typ='S')
	if (@cur_id=@cur_id_local)
		begin	
			set @cur_rat=1
		end
	else
		begin
			set @cur_rat =(select isnull(currat_rat,1) from m_currat where currat_dat=(select MAX(currat_dat) from m_currat where cur_id=@cur_id and currat_dat <=@dt2) and cur_id=@cur_id)
		end
		set @cur_snm=(select cur_snm from m_cur where cur_id=@cur_id)
		
		--Sales
		select @cur_snm AS [cur_snm],@cur_rat as [cur_rat],gl_m_acc.acc_cid as [acc_id],'Gross Sales' as [acc_nam],isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt],1 as [KTAG],1 as [GTAG],1 as [MTAG],1 as [STAG],1 as [TAG],1 AS [T],'SALES' as [subrmk],'REVENUE' as [masrmk],0 as [famt1],isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt2],isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0)  as [famt3] ,mvch_tax
		from t_mvch
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		inner join gl_m_acc
		on t_dvch.com_id =gl_m_acc.com_id 
		and t_dvch.acc_no=gl_m_acc.acc_no 
		where left(gl_m_acc.acc_cid,len('04001'))='04001' and t_dvch.acc_no not in  (select sal_ret_acc from m_sys) and gl_m_acc.com_id=@com_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
		group by gl_m_acc.acc_cid,mvch_tax
		union all
		--Sales Return
		select @cur_snm AS [cur_snm],@cur_rat as [cur_rat],gl_m_acc.acc_id,'Less: Sales Return' as [acc_nam],isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt],1 as [KTAG],1 as [GTAG],1 as [MTAG],1 as [STAG],1 as [TAG],1 AS [T],'SALES' as [subrmk],'REVENUE' as [masrmk],0 as [famt1],isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt2],isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt3],mvch_tax
		from gl_m_acc
		left join t_dvch
		on t_dvch.com_id =gl_m_acc.com_id 
		and t_dvch.acc_no=gl_m_acc.acc_no 
		left join t_mvch
		on t_dvch.com_id=t_mvch.com_id
		and t_dvch.br_id=t_mvch.br_id
		and t_dvch.mvch_no=t_mvch.mvch_no
		and gl_m_acc.com_id=@com_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
		where gl_m_acc.acc_no in (select sal_ret_acc from m_sys) 
		group by gl_m_acc.acc_id,mvch_tax	
		union all		
		--Finish Goods Opening
		select @cur_snm AS [cur_snm],@cur_rat as [cur_rat],'03002004001' as [acc_id],'Opening Stock (Finished Goods)' as [acc_nam],round((sum(isnull(stk_qty,0)*isnull((stk_trat+stk_tratdiff),0))/@cur_rat),4) as [famt],1 as [KTAG],1 as [GTAG],1 as [MTAG],2 as [STAG],2 as [TAG],1 AS [T],'COST OF GOODS SOLD' as [subrmk],'REVENUE' as [masrmk],round((sum(isnull(stk_qty,0)*isnull((stk_trat+stk_tratdiff),0))/@cur_rat),4) as [famt1],round((sum(isnull(stk_qty,0)*isnull((stk_trat+stk_tratdiff),0))/@cur_rat),4)  as [famt2],round((sum(isnull(stk_qty,0)*isnull((stk_trat+stk_tratdiff),0))/@cur_rat),4) as [famt3],stk_tax 
		from m_stk
		where itm_id in (select titm_id from t_itm inner join m_itm on t_itm.itm_id=m_itm.itm_id where itm_cat in ('F')) and stk_frm='t_itm' and  m_yr_id=@m_yr_id and stk_dat between @dt1 and @dt2
		group by stk_tax
		union all
		--Cost Of Goods Manufactured
		select @cur_snm AS [cur_snm],@cur_rat as [cur_rat],'01003003' as [acc_id],'COST OF GOODS MANUFACTURED'as [acc_nam],isnull(round((SUM(AMT)/@cur_rat),4),0) as [famt],1 as [KTAG],1 as [GTAG],1 as [MTAG],2 as [STAG],2 as [TAG],1 AS [T],'COST OF GOODS SOLD' as [subrmk],'REVENUE' as [masrmk] ,isnull(round((SUM(AMT)/@cur_rat),4),0) as [famt1],isnull(round((SUM(AMT)/@cur_rat),4),0) as [famt2],isnull(round((SUM(AMT)/@cur_rat),4),0) as [famt3],mvch_tax 
		from v_cogs_pl
		where com_id=@com_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
		group by mvch_tax
		union all
		----Finish Goods Closing
		select @cur_snm AS [cur_snm],@cur_rat as [cur_rat],'03002004001' as [acc_id],'Less: Closing Stock (FINISHED GOODS)'as [acc_nam],  -round((sum(amount)/@cur_rat),4) as [famt],1 as [KTAG],1 as [GTAG],1 as [MTAG],2 as [STAG],2 as [TAG],1 AS [T],'COST OF GOODS SOLD' as [subrmk],'REVENUE' as [masrmk],-round((sum(amount)/@cur_rat),4)  as [famt1],-round((sum(amount)/@cur_rat),4)   as [famt2],-round((sum(amount)/@cur_rat),4)  as [famt3],stk_tax 
		from v_stock_fg_closing
		where m_yr_id=@m_yr_id and stk_dat between @dt1 and @dt2
		group by stk_tax
		union all
		--Operating Expenses
		--Selling and Distribution Expenses
		select @cur_snm AS [cur_snm],@cur_rat as [cur_rat],gl_m_acc.acc_id,acc_nam,isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt],1 as [KTAG],1 as [GTAG],2 as [MTAG],4 as [STAG],6 as [TAG],1 AS [T],'SELLING AND DISTRIBUTION EXPENSES' as [subrmk],'OPERATING EXPENSES' as [masrmk],0 as [famt1],isnull(round(-(SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt2],0 as [famt3] ,mvch_tax
		from t_mvch
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		inner join gl_m_acc
		on t_dvch.com_id =gl_m_acc.com_id 
		and t_dvch.acc_no=gl_m_acc.acc_no 
		where left(gl_m_acc.acc_id,len('05003'))='05003' and gl_m_acc.com_id=@com_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
		group by gl_m_acc.acc_id,acc_nam,mvch_tax
		union all
		--Administrative and General Expenses
		select @cur_snm AS [cur_snm],@cur_rat as [cur_rat],gl_m_acc.acc_id,acc_nam,isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt],1 as [KTAG],1 as [GTAG],2 as [MTAG],5 as [STAG],6 as [TAG],1 AS [T],'ADMINISTRATIVES AND GENERAL EXPENSES' as [subrmk],'OPERATING EXPENSES' as [masrmk] ,0 as [famt1],isnull(round(-(SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt2],0 as [famt3],mvch_tax
		from t_mvch
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id 
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		inner join gl_m_acc
		on t_dvch.com_id=gl_m_acc.com_id 
		and t_dvch.acc_no=gl_m_acc.acc_no
		where left(gl_m_acc.acc_id,len('05002'))='05002' and gl_m_acc.com_id=@com_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
		group by gl_m_acc.acc_id,acc_nam,mvch_tax
		union all
		--Other Income
		select @cur_snm AS [cur_snm],@cur_rat as [cur_rat],gl_m_acc.acc_id,acc_nam,isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt],1 as [KTAG],1 as [GTAG],2 as [MTAG],6 as [STAG],7 as [TAG],2 AS [T],'ADD: OTHER INCOME' as [subrmk],'OPERATING EXPENSES' as [masrmk] ,0 as [famt1],0 as [famt2],isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt3],mvch_tax
		from t_mvch
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id 
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		inner join gl_m_acc
		on t_dvch.com_id=gl_m_acc.com_id 
		and t_dvch.acc_no=gl_m_acc.acc_no
		where left(gl_m_acc.acc_cid,len('04002'))='04002' and gl_m_acc.com_id=@com_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
		group by gl_m_acc.acc_id,acc_nam,mvch_tax
		union all
		--Financial Charges
		select @cur_snm AS [cur_snm],@cur_rat as [cur_rat],gl_m_acc.acc_id,acc_nam,isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt],2 as [KTAG],1 as [GTAG],2 as [MTAG],7 as [STAG],8 as [TAG],2 as [T],'LESS: FINANCIAL EXPENSES' as [subrmk],'OPERATING EXPENSES' as [masrmk] ,0 as [famt1],0 as [famt2],isnull(round((SUM(dvch_dr_amt-dvch_cr_amt)/@cur_rat),4),0) as [famt3],mvch_tax
		from t_mvch
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id 
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		inner join gl_m_acc
		on t_dvch.com_id=gl_m_acc.com_id 
		and t_dvch.acc_no=gl_m_acc.acc_no
		where left(gl_m_acc.acc_cid,len('05004'))='05004' and gl_m_acc.com_id=@com_id and yr_id=@m_yr_id and mvch_dt between @dt1 and @dt2
		group by gl_m_acc.acc_id,acc_nam,mvch_tax
		
		
end

--EXEC sp_rpt_pl '01','01','01','07/01/2012','07/31/2012',2
