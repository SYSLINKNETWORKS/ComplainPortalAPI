USE ZSons
GO

create  view v_rpt_adminexp
as
select	
	t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,mvch_tax,t_mvch.mvch_dt,dvch_nar,dvch_dr_amt,dvch_cr_amt,dvch_dr_amt-dvch_cr_amt as [amount],gl_m_acc.acc_id,gl_m_acc.acc_nam,gl_m_acc.acc_cid,controlaccount.acc_nam as [ControlName]
	from t_mvch
	inner join t_dvch 
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no
	inner join gl_m_acc
	on t_dvch.acc_no=gl_m_acc.acc_no
	inner join gl_m_acc controlaccount
	on gl_m_acc.acc_cid=controlaccount.acc_id
	where mvch_app='Y'
	and mvch_can=0
	--and left(t_dvch.acc_id,5) in ('05002','05003')
	--and left(t_dvch.acc_id,8) not in ('05003004')	
