USE ZSONS
GO
----View for Transactional Voucher
ALTER view [dbo].[rpt_t_vch]
as
select 
		t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,mvch_tax,t_mvch.typ_id,t_mvch.mvch_dt,t_mvch.cur_id,
		case when (sum(isnull(dvch_dr_famt,0)) - sum(isnull(dvch_cr_famt,0))>0) then sum(isnull(dvch_dr_famt,0)) - sum(isnull(dvch_cr_famt,0)) else 0  end as [dvch_dr_famt], 
		case when (sum(isnull(dvch_dr_famt,0)) - sum(isnull(dvch_cr_famt,0))<0) then sum(isnull(dvch_dr_famt,0)) - sum(isnull(dvch_cr_famt,0)) else 0 end  as [dvch_cr_famt],
		case when (sum(isnull(dvch_dr_amt,0)) - sum(isnull(dvch_cr_amt,0))>0) then sum(isnull(dvch_dr_amt,0)) - sum(isnull(dvch_cr_amt,0)) else 0  end as [dvch_dr_amt], 
		case when (sum(isnull(dvch_dr_amt,0)) - sum(isnull(dvch_cr_amt,0))<0) then sum(isnull(dvch_dr_amt,0)) - sum(isnull(dvch_cr_amt,0)) else 0 end  as [dvch_cr_amt],
		t_dvch.acc_no,acc_id	
		from t_mvch
		--Join with Detail table
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		--Join with Account
		inner join gl_m_acc
		on t_dvch.com_id=gl_m_acc.com_id
		and t_dvch.acc_no=gl_m_acc.acc_no
		--where clause
		where mvch_app='Y'
		--Group By Clause
		group by t_mvch.com_id,t_mvch.br_id,mvch_tax,t_mvch.mvch_dt,t_dvch.acc_no,acc_id,t_mvch.typ_id,t_mvch.yr_id,t_mvch.cur_id
GO

