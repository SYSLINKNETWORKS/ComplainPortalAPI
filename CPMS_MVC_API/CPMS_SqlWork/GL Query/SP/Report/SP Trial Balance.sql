USE ZSONS
GO

--Trial Balance
alter proc [dbo].[sp_gl_tb] (@dt1 datetime,@yr_id char(2))
as
	select 
		gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_tax,rpt_t_vch.acc_id,gl_m_acc.acc_nam,gl_m_acc.acc_cid,controlaccount.acc_nam as [acc_des],rpt_t_vch.cur_id,cur_snm,
		sum(dvch_dr_famt) as [dvch_dr_famt],sum(dvch_cr_famt) as [dvch_cr_famt],
		sum(dvch_dr_amt) as [dvch_dr_amt],sum(dvch_cr_amt) as [dvch_cr_amt],'O' as [Tag]
			from rpt_t_vch
			--Join with Chart of Account
			inner join gl_m_acc
			on rpt_t_vch.acc_id=gl_m_acc.acc_id
			--left Join for control account
			left join gl_m_acc controlaccount
			on gl_m_acc.acc_cid=controlaccount.acc_id
			--Left Join with Currency
			left join m_cur 
			on rpt_t_vch.cur_id=m_cur.cur_id
			--Where
			where 
			gl_m_acc.acc_dm='D' 
			and 
			mvch_dt <=@dt1
			and yr_id=@yr_id
			and typ_id='06'
			--Group by
			group by gl_m_acc.com_id,gl_m_acc.br_id,mvch_tax,rpt_t_vch.acc_id,gl_m_acc.acc_nam,yr_id,gl_m_acc.acc_cid,controlaccount.acc_nam,rpt_t_vch.cur_id,cur_snm
union all
	select 
		gl_m_acc.com_id,gl_m_acc.br_id,yr_id,mvch_tax,rpt_t_vch.acc_id,gl_m_acc.acc_nam,gl_m_acc.acc_cid,controlaccount.acc_nam as [acc_des],rpt_t_vch.cur_id,cur_snm,
		sum(dvch_dr_famt) as [dvch_dr_famt],sum(dvch_cr_famt) as [dvch_cr_famt],
		sum(dvch_dr_amt) as [dvch_dr_amt],sum(dvch_cr_amt) as [dvch_cr_amt],'T' as [Tag]
			from rpt_t_vch
			--Join with Chart of Account
			inner join gl_m_acc
			on rpt_t_vch.acc_id=gl_m_acc.acc_id
			--left Join for control account
			left join gl_m_acc controlaccount
			on gl_m_acc.acc_cid=controlaccount.acc_id
			--Left Join
			left join m_cur
			on rpt_t_vch.cur_id=m_cur.cur_id
			--Where
			where 
			gl_m_acc.acc_dm='D' 
			and 
			mvch_dt <=@dt1
			and yr_id=@yr_id
			and typ_id<>'06'
			--Group by
			group by gl_m_acc.com_id,gl_m_acc.br_id,mvch_tax,rpt_t_vch.acc_id,gl_m_acc.acc_nam,yr_id,gl_m_acc.acc_cid,controlaccount.acc_nam,rpt_t_vch.cur_id,cur_snm
--select * from rpt_t_vch
--exec sp_gl_tb '08/20/2009','02'
GO


--select acc_obal from gl_br_acc inner join gl_m_acc on  gl_br_acc.acc_id=gl_m_acc.acc_id where acc_dm='M' and acc_obal<>0
--select * from t_dvch inner join gl_m_acc on t_dvch.acc_id=gl_m_acc.acc_id where acc_dm='M'

--05002004001         
--
--select * from tbl_aud1 order by aud_dat
--
--where aud_dat='12/09/2011'
--
--update t_dvch set acc_id='05002004004' where acc_id='05002004001'
--
--
--select * from t_con
--where con_amt <>0
--update t_reg set mvch_id_transport=null where mvch_id_transport <> ''
--
--select * from t_reg
--where mvch_id_transport <> ''
--
--'019-20111209'
--'013-20111209'
--'012-20111209'
--'017-20111209'
--'016-20111209'
--
--delete t_mvch where typ_id='05' and mvch_id='013-20111209'
--delete t_dvch where typ_id='05' and mvch_id='013-20111209'
--
--delete t_mvch where typ_id='05' and mvch_id='012-20111209'
--delete t_dvch where typ_id='05' and mvch_id='012-20111209'
--
--delete t_mvch where typ_id='05' and mvch_id='019-20111209'
--delete t_dvch where typ_id='05' and mvch_id='019-20111209'
--
--delete t_mvch where typ_id='05' and mvch_id='016-20111209'
--delete t_dvch where typ_id='05' and mvch_id='016-20111209'
--
--delete t_mvch where typ_id='05' and mvch_id='017-20111209'
--delete t_dvch where typ_id='05' and mvch_id='017-20111209'
