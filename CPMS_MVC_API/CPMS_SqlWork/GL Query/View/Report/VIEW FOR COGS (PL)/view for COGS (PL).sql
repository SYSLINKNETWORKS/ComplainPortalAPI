USE ZSONS
GO

ALTER view v_cogs_pl
as
	
--	Opening Stock
	select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,round(SUM(dvch_dr_amt-dvch_cr_amt),4) as [amt],mvch_tax 
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id =t_dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.com_id =gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no 
	where left(gl_m_acc.acc_cid,len('03002004')) ='03002004' and acc_id not in ('03002004001') 
	group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,mvch_tax 
	union all
	--Add Purchases
	select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,round(SUM(dvch_dr_amt),4) as [amt],mvch_tax 
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id =t_dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.com_id =gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no 
	where left(acc_cid,len('05001')) in ('05001') and acc_id not in ((select pur_ret_acc from m_sys),(select fg_acc from m_sys)) and gl_m_acc.acc_cid not in ((select wip_acc from m_sys),(select wip_ret_acc from m_sys))
	group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,mvch_tax 
	UNION ALL
	--Add Other Purchases
	select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,round(SUM(dvch_dr_amt),4) as [amt],mvch_tax 
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id =t_dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.com_id =gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no 
	where left(acc_cid,len('05005')) in ('05005') and gl_m_acc.acc_cid not in ((select wip_acc from m_sys),(select wip_ret_acc from m_sys)) and acc_id not in (select acc_purdis from m_sys)
	group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,mvch_tax 
	Union all
	--Purchase Discount
	select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,(round(SUM(dvch_dr_amt-dvch_cr_amt),4)) as [amt],mvch_tax 
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id =t_dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.com_id =gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no 
	where left(acc_cid,len('05005')) in ('05005') and acc_id in (select acc_purdis from m_sys)
	group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,mvch_tax 
	UNION ALL
	--Purchase Return
	select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,round(SUM(dvch_dr_amt-dvch_cr_amt),4) as [amt],mvch_tax 
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id =t_dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.com_id =gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no 
	where left(acc_cid,len('05001')) in ('05001') and acc_id in((select pur_ret_acc from m_sys))
	group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,mvch_tax 
	UNION ALL
--Ending Stock
	select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,round(-SUM(dvch_dr_amt-dvch_cr_amt),4) as [amt],mvch_tax 
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id =t_dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.com_id =gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no 
	where left(gl_m_acc.acc_cid,len('03002004')) ='03002004' and acc_id not in ('03002004001') 
	group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,mvch_tax 
	union all
	select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,round(-SUM(dvch_dr_amt-dvch_cr_amt),4) as [amt],mvch_tax 
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id =t_dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.com_id =gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no 
	where left(acc_cid,len('05001')) in ('05001') and acc_id not in ((select pur_ret_acc from m_sys),(select fg_acc from m_sys)) and gl_m_acc.acc_cid not in ((select wip_acc from m_sys),(select wip_ret_acc from m_sys))
	group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,mvch_tax 
	UNION ALL
--CLosing other Purchases
	select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,round(-SUM(dvch_dr_amt-dvch_cr_amt),4) as [amt],mvch_tax 
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id =t_dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.com_id =gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no 
	where left(gl_m_acc.acc_cid,len('05005')) ='05005' and acc_id not in (select acc_purdis from m_sys) 
	group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,mvch_tax 	
	UNION ALL	
--WIP CLOSING
	select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,round(-SUM(dvch_dr_amt-dvch_cr_amt),4) as [amt],mvch_tax 
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id =t_dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.com_id =gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no 
	where left(gl_m_acc.acc_cid,len('05001008')) ='05001008' 
	group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,mvch_tax 
	union all
--Direct Labour
	select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,isnull(round(SUM(dvch_dr_amt-dvch_cr_amt),4),0) as [amt],mvch_tax 
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id =t_dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.com_id =gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no 
	where left(acc_cid,len('05006'))='05006'
	group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,mvch_tax 
	union all
--FACTORY OVERHEAD
	select gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,isnull(round(SUM(dvch_dr_amt-dvch_cr_amt),4),0) as [amt],mvch_tax  
	from t_mvch
	inner join t_dvch
	on t_mvch.com_id =t_dvch.com_id 
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no 
	inner join gl_m_acc
	on t_dvch.com_id =gl_m_acc.com_id 
	and t_dvch.acc_no=gl_m_acc.acc_no 
	where left(acc_cid,len('05007'))='05007'
	group by gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_dt,mvch_tax 
