USE [MFI]
GO

ALTER view [dbo].[v_rpt_acc_obal]
as
	select 
		t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,t_mvch.mvch_dt,t_dvch.acc_id,acc_nam,t_mvch.cur_id,cur_snm,sum(dvch_dr_famt-dvch_cr_famt) as [acc_fobal] ,sum(dvch_dr_amt-dvch_cr_amt) as [acc_obal] 
	from t_mvch
	--Join with Voucher Detail
	inner join t_dvch
	on t_mvch.com_id=t_dvch.com_id
	and t_mvch.br_id=t_dvch.br_id
	and t_mvch.yr_id=t_dvch.yr_id
	and t_mvch.mvch_id=t_dvch.mvch_id
	and t_mvch.typ_id=t_dvch.typ_id
	--Join with COF
	inner join gl_m_acc
	on t_dvch.acc_id=gl_m_acc.acc_id
	--Left Join with Currency
	left join m_cur 
	on t_mvch.cur_id=m_cur.cur_id
	where t_mvch.typ_id='06' 
	group by t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,t_mvch.mvch_dt,t_dvch.acc_id,acc_nam,t_mvch.cur_id,cur_snm

GO


