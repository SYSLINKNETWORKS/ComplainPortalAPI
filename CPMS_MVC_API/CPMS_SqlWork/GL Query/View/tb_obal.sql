
USE zsons
GO
----View for Trial Balance Opening
ALTER view [dbo].[tb_obal]
as
	select 
		t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,t_mvch.cur_id,cur_snm,'' as [typ_id], '' as [typ_nam],'' as [typ_snm],'' as [mvch_id],t_mvch.mvch_dt as [mvch_dt],'' as [mvch_cb], '' as [mvch_ref],'' as [mvch_chq],'' as [mvch_chqdat],cast(0 as bit) as [mvch_chqst],cast(0 as bit) as [mvch_po],'' as [dvch_nar], sum(dvch_dr_famt) as [dvch_dr_famt], sum(dvch_cr_famt) as [dvch_cr_famt],sum(dvch_dr_famt) - sum(dvch_cr_famt) as [Fbalance],sum(dvch_dr_amt) as [dvch_dr_amt],sum(dvch_cr_Amt) as [dvch_cr_amt],sum(dvch_dr_amt-dvch_cr_amt) as [balance],t_dvch.acc_no,gl_m_acc.acc_id,acc_nam,'O' as [Tag],
		mvch_tax
		from t_mvch
		--Join with Detail Voucher
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		--Join with Type ID
		inner join gl_vch_typ
		on t_mvch.typ_id=gl_vch_typ.typ_id
		--Join with account
		inner join gl_m_acc
		on t_dvch.com_id=gl_m_acc.com_id 
		and t_dvch.acc_no=gl_m_acc.acc_no
		--Left Join with Currency
		left join m_cur
		on t_mvch.cur_id=m_cur.cur_id
		where mvch_app='Y'
		and t_mvch.typ_id='06'
		--Group by
		group by t_mvch.com_id,t_mvch.br_id,t_dvch.acc_no,gl_m_acc.acc_id,acc_nam,t_mvch.mvch_dt,t_mvch.yr_id,t_mvch.cur_id,cur_snm,mvch_tax
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

