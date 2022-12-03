use ZSons
GO
--select acc_nam,sum(amount) from v_stock_bl group by acc_nam
--select * from m_itm

alter view v_stock_bl
as
	--Assets With Opening Stock
		select 	t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,t_mvch.mvch_dt,gl_m_acc.acc_id as [acc_id],gl_m_acc.acc_nam as [acc_nam],
		dvch_dr_amt-dvch_cr_amt as [amount],mvch_tax
		from t_mvch
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		inner join gl_m_acc
		on t_dvch.com_id=gl_m_acc.com_id 
		and  t_dvch.acc_no=gl_m_acc.acc_no
		where left(gl_m_acc.acc_id,len('03002004')) in ('03002004')-- and left(gl_m_acc.acc_id,len('03002004001')) not in ('03002004001') 	
	union all
	--Assets with Closing Stock
	select gl_m_acc.com_id,gl_m_acc.br_id,m_yr_id,stk_dat,acc_id,acc_nam,
	stk_qty*(stk_trat+stk_foh) as [amount],stk_tax
	from m_stk
	inner join t_itm
	on m_stk.itm_id=t_itm.titm_id
	inner join m_itm
	on t_itm.itm_id=m_itm.itm_id 
	inner join gl_m_acc
	on m_itm.oacc_id=gl_m_acc.acc_id
	where stk_frm<>'t_itm' and itm_cat='F'--and stk_dat between '07/01/2012' and '07/01/2012' 
	--and itm_id in (select titm_id from t_itm inner join m_itm on t_itm.itm_id=m_itm.itm_id where itm_cat='F')		
	
UNION ALL
		--Assets With Stock
		select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,t_mvch.mvch_dt,open_m_acc.acc_id as [acc_id],open_m_acc.acc_nam as [acc_nam],
		dvch_dr_amt-dvch_cr_amt as [amount],mvch_tax
		from t_mvch
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		inner join gl_m_acc
		on t_dvch.com_id =gl_m_acc.com_id 
		and t_dvch.acc_no=gl_m_acc.acc_no
		inner join m_itm on 
		gl_m_acc.acc_id=m_itm.cacc_id
		inner join gl_m_acc open_m_acc
		on m_itm.oacc_id=open_m_acc.acc_id
		where left(gl_m_acc.acc_id,len('05001')) in ('05001') and left(gl_m_acc.acc_id,len('05001010')) not in ('05001010',(select pur_ret_acc from m_sys)) 
union all
--Assets Work in Process
		select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,t_mvch.mvch_dt,open_m_acc.acc_id as [acc_id],open_m_acc.acc_nam as [acc_nam],
		dvch_dr_amt-dvch_cr_amt as [amount],mvch_tax
		from t_mvch
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		inner join gl_m_acc
		on t_dvch.com_id =gl_m_acc.com_id
		and t_dvch.acc_no=gl_m_acc.acc_no 
		inner join m_itm on 
		gl_m_acc.acc_id=m_itm.wacc_id
		inner join gl_m_acc open_m_acc
		on m_itm.oacc_id=open_m_acc.acc_id
		where left(gl_m_acc.acc_id,len('05001')) in ('05001') and left(gl_m_acc.acc_id,len('05001010')) not in ('05001010',(select pur_ret_acc from m_sys)) 
UNION ALL
		--Assets With Other Stock
		select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,t_mvch.mvch_dt,open_m_acc.acc_id as [acc_id],open_m_acc.acc_nam as [acc_nam],
		dvch_dr_amt-dvch_cr_amt as [amount],mvch_tax
		from t_mvch
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		inner join gl_m_acc
		on t_dvch.com_id =gl_m_acc.com_id 
		and t_dvch.acc_no=gl_m_acc.acc_no 
		inner join m_itm
		on gl_m_acc.acc_id=m_itm.pacc_id
		inner join gl_m_acc open_m_acc
		on m_itm.oacc_id=open_m_acc.acc_id 		
		where left(gl_m_acc.acc_id,len('05005')) in ('05005') and gl_m_acc.acc_id not in (select acc_purdis from m_sys)  

		