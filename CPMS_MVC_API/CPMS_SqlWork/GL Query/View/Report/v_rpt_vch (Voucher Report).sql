
use meiji_rusk
go
--select * from v_rpt_vch

--update t_mvch set mvch_can =0 where mvch_can is null

--Voucher Report
alter view [dbo].[v_rpt_vch]
as
select 
		t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,t_mvch.mvch_no,t_mvch.typ_id,typ_nam,typ_snm + '-' +t_mvch.mvch_id as [mvch_id],mvch_tdat,t_mvch.mvch_dt,mvch_pto,mvch_rat,t_mvch.cur_id,cur_snm,mvch_cb,mvch_ref,mvch_chq,mvch_chqdat,mvch_chqst,mvch_po,t_dvch.acc_no,gl_m_acc.acc_id,acc_nam,acc_des,dvch_nar,dvch_dr_famt,dvch_cr_famt,dvch_dr_amt,dvch_cr_amt,mvch_app,dvch_row,t_mvch.usr_id,usr_nam,isnull(mvch_can,0) as [mvch_can],mvch_del,mvch_tax
		from t_mvch 
		--Join with Detail voucher
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id 
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		--Join with Type
		inner join gl_vch_typ
		on t_mvch.typ_id=gl_vch_typ.typ_id
		--Join with Account Table
		inner join gl_m_acc
		on t_dvch.com_id=gl_m_acc.com_id
		and t_dvch.acc_no=gl_m_acc.acc_no
		--Left join with Currecy
		left join m_cur 
		on t_mvch.cur_id=m_cur.cur_id
		--Left join with 
		left join new_usr
		on t_mvch.usr_id=new_usr.usr_id
		where t_mvch.typ_id<>'06'
GO


