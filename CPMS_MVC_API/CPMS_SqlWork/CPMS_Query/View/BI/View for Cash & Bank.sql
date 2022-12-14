
USE ZSONS
GO
--select * from v_bi_cb 

ALTER view [dbo].[v_bi_cb]
as
----Bank Opening
--	select 
--		com_id,br_id,yr_id,v_rpt_acc_obal.acc_id as [ID],v_rpt_acc_obal.acc_nam as [Name],mvch_dt as [Date],acc_fobal as [FBalance],acc_obal as [Balance],cur_id,cur_snm,'OB' as [Tag] 
--		from v_rpt_acc_obal
--		inner join gl_m_acc
--		on v_rpt_acc_obal.acc_id=gl_m_acc.acc_id
--		where gl_m_acc.acc_cid=(select bk_acc_id from m_sys)
--union
--Bank Transactional
	select 
			t_mvch.com_id,t_mvch.br_id,t_mvch.yR_id,acc_id as [ID],acc_nam as [Name],t_mvch.mvch_dt as [Date],sum(dvch_dr_famt-dvch_cr_famt) as [FBalance],sum(dvch_dr_amt-dvch_cr_amt) as [Balance],t_mvch.cur_id,cur_snm,'TB' as [Tag]
		from t_mvch
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		inner join gl_m_acc
		on t_dvch.acc_no=gl_m_acc.acc_no
		left join m_cur
		on t_mvch.cur_id=m_cur.cur_id
		where gl_m_acc.acc_cno=(select bk_acc_id from m_sys)
		--and t_mvch.typ_id <>'06'
		and mvch_app='Y'
		and mvch_can=0
		and mvch_del=0
		group by t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,acc_id,acc_nam,t_mvch.mvch_dt,t_mvch.cur_id,cur_snm
--union
----Cash Opening
--	select 
--		com_id,br_id,yr_id,v_rpt_acc_obal.acc_id as [ID],v_rpt_acc_obal.acc_nam as [Name],mvch_dt as [Date],acc_fobal as [FBalance],acc_obal as [Balance],cur_id,cur_snm,'OB' as [Tag] 
--		from v_rpt_acc_obal
--		inner join gl_m_acc
--		on v_rpt_acc_obal.acc_id=gl_m_acc.acc_id
--		where gl_m_acc.acc_cid=(select cashmaster_acc from m_sys)
union ALL
--Cash Transactional
		select 
			t_mvch.com_id,t_mvch.br_id,t_mvch.yR_id,acc_id,acc_nam,t_mvch.mvch_dt,sum(dvch_dr_famt-dvch_cr_famt) as [Balance],sum(dvch_dr_amt-dvch_cr_amt) as [Balance],t_mvch.cur_id,cur_snm,'TB' as [Tag]
				from t_mvch
		inner join t_dvch
		on t_mvch.com_id=t_dvch.com_id
		and t_mvch.br_id=t_dvch.br_id
		and t_mvch.mvch_no=t_dvch.mvch_no
		inner join gl_m_acc
		on t_dvch.acc_no=gl_m_acc.acc_no
		left join m_cur
		on t_mvch.cur_id=m_cur.cur_id
		where gl_m_acc.acc_cno=(select cashmaster_acc from m_sys)
		--and t_mvch.typ_id<>'06'
		and mvch_app ='Y'
		and mvch_can=0
		and mvch_del=0
		group by t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,acc_id,acc_nam,t_mvch.mvch_dt,t_mvch.cur_id,cur_snm


--select * from m_sys
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

