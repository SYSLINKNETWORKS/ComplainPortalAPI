USE ZSONS
GO



alter view v_rpt_chq_print
as
SELECT acc_id,t_mvch.mvch_dt,mvch_chq,sum(dvch_cr_amt) as [Amount] from t_mvch 
	inner join 	t_dvch 
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.mvch_no=t_dvch.mvch_no
	inner join gl_m_acc 
	on t_dvch.com_id=gl_m_acc.com_id
	and t_dvch.acc_no=gl_m_acc.acc_no
	where mvch_cb='B' 
	and t_mvch.typ_id='04' 
	and mvch_can=0
	and left(acc_id,(select len(acc_id) from m_sys inner join gl_m_acc glmacc on m_sys.bk_acc_id=glmacc.acc_no)) in (select acc_id from m_sys inner join gl_m_acc glmacc on m_sys.bk_acc_id=glmacc.acc_no) 
	and mvch_chq<>''
	group by acc_id,t_mvch.mvch_dt,mvch_chq

