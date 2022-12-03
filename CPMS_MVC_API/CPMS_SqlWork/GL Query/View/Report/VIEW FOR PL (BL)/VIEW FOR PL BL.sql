USE ZSONS
GO
alter view v_pl_bl
as
--Sales
		select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,'01003003' as [acc_id],sum(dvch_dr_amt-dvch_cr_amt) as [amount],mvch_tax 
		from t_mvch
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		inner join gl_m_acc
		on t_dvch.com_id =gl_m_acc.com_id 
		and t_dvch.acc_no=gl_m_acc.acc_no 
		where left(gl_m_acc.acc_cid,len('04001'))='04001' and acc_id not in  (select sal_ret_acc from m_sys)
		group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt, gl_m_acc.acc_cid,mvch_tax
		union all
--Sales Return
		select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,'01003003' as [acc_id],sum(dvch_dr_amt-dvch_cr_amt) as [amount] ,mvch_tax
		from gl_m_acc
		left join t_dvch
		on t_dvch.com_id =gl_m_acc.com_id 
		and gl_m_acc.acc_no=t_dvch.acc_no
		left join t_mvch
		on t_dvch.com_id =t_mvch.com_id 
		and t_dvch.br_id =t_mvch.br_id 
		and t_dvch.mvch_no=t_mvch.mvch_no 		
		where gl_m_acc.acc_id in (select sal_ret_acc from m_sys) 
		group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt, gl_m_acc.acc_id,mvch_tax
		union all
--Finish Goods Opening
		select '01' as [com_id],'01' as [br_id],m_yr_id as [yr_id],stk_dat as [mvch_dt],'01003003' as [acc_id],round((isnull(stk_qty,0)*isnull((stk_trat+stk_tratdiff),0)),4) as [amount],stk_tax
		from m_stk
		where itm_id in (select titm_id from t_itm inner join m_itm on t_itm.itm_id=m_itm.itm_id where itm_cat in ('F')) and stk_frm in ('t_itm')
		union all
--Cost Of Goods Manufactured
		select com_id,br_id,yr_id,mvch_dt,'01003003' as [acc_id],AMT as [Amount],mvch_tax 
		from v_cogs_pl
		union all
--Finish Goods Closing
		select '01' as [com_id],'01' as [br_id],m_yr_id as [yr_id],stk_dat as [mvch_dt],'01003003' as [acc_id],case when stk_frm='t_itm' then -round((isnull(stk_qty,0)*isnull((stk_trat+stk_tratdiff),0)),4) else -round((isnull(stk_qty,0)*isnull((stk_trat+stk_tratdiff+13.2882),0)),4) end as [amount],stk_tax
		from m_stk
		where itm_id in (select titm_id from t_itm inner join m_itm on t_itm.itm_id=m_itm.itm_id where itm_cat in ('F')) and stk_frm in ('DC','TransFG','SO','stk_adj','t_itm')
		union all
		--Operating Expenses
		--Selling and Distribution Expenses
		select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,'01003003' as [acc_id],sum(dvch_dr_amt-dvch_cr_amt) as [amount],mvch_tax
		from t_mvch
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		inner join gl_m_acc
		on t_dvch.com_id =gl_m_acc.com_id 
		and t_dvch.acc_no=gl_m_acc.acc_no 
		where left(gl_m_acc.acc_id,len('05003'))='05003' 
		group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt, gl_m_acc.acc_id,acc_nam,mvch_tax
		union all
		--Administrative and General Expenses
		select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,'01003003' as [acc_id],sum(dvch_dr_amt-dvch_cr_amt) as [amount],mvch_tax 
		from t_mvch
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		inner join gl_m_acc
		on t_dvch.com_id =gl_m_acc.com_id 
		and t_dvch.acc_no=gl_m_acc.acc_no 
		where left(gl_m_acc.acc_id,len('05002'))='05002'
		group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt, gl_m_acc.acc_id,acc_nam,mvch_tax
		union all
		--Other Income
		select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,'01003003' as [acc_id],sum(dvch_dr_amt-dvch_cr_amt) as [amount],mvch_tax 
		from t_mvch
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		inner join gl_m_acc
		on t_dvch.com_id =gl_m_acc.com_id 
		and t_dvch.acc_no=gl_m_acc.acc_no 
		where left(gl_m_acc.acc_cid,len('04002'))='04002' 
		group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt, gl_m_acc.acc_id,acc_nam,mvch_tax
		union all
		--Financial Charges
		select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,'01003003' as [acc_id],sum(dvch_dr_amt-dvch_cr_amt) as [amount],mvch_tax 
		from t_mvch
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		inner join gl_m_acc
		on t_dvch.com_id =gl_m_acc.com_id 
		and t_dvch.acc_no=gl_m_acc.acc_no 
		where left(gl_m_acc.acc_cid,len('05004'))='05004' 
		group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt, gl_m_acc.acc_id,acc_nam,mvch_tax 
		