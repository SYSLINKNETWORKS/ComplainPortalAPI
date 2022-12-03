USE meiji_rusk
GO

alter proc sp_rpt_acc (@com_id char(2),@br_id char(2),@m_yr_id char(2),@mvch_tax bit)
as
select com_id,br_id,acc_no,acc_id,acc_nam,acc_lvl,acc_dm,0 as [acc_fobal],0 as [acc_obal],gl_m_acc.cur_id,cur_snm from gl_m_acc
left join 
m_cur 
on gl_m_acc.cur_id=m_cur.cur_id
where com_id=@com_id and br_id=@br_id
union all
select t_mvch.com_id,t_mvch.br_id,gl_m_acc.acc_no,gl_m_acc.acc_id,acc_nam,acc_lvl,acc_dm,sum(dvch_dr_famt-dvch_cr_famt) as [acc_fobal],sum(dvch_dr_amt-dvch_cr_amt) as [acc_obal],t_mvch.cur_id,cur_snm 
from t_mvch
inner join t_dvch
on t_mvch.com_id=t_dvch.com_id
and t_mvch.br_id=t_dvch.br_id
and t_mvch.mvch_no=t_dvch.mvch_no
inner join gl_m_acc
on t_dvch.com_id=gl_m_acc.com_id 
and t_dvch.acc_no=gl_m_acc.acc_no
inner join m_cur
on t_mvch.cur_id=m_cur.cur_id
where t_mvch.com_id=@com_id and t_mvch.br_id=@br_id 
and t_mvch.typ_id='06'
and t_mvch.yr_id=@m_yr_id
and t_mvch.mvch_tax=@mvch_tax
group by t_mvch.com_id,t_mvch.br_id,gl_m_acc.acc_no,gl_m_acc.acc_id,acc_nam,acc_lvl,acc_dm,t_mvch.cur_id,cur_snm

--select 
--		'01' as [com_id],'01' as [br_id],(select yr_id from gl_m_yr where yr_ac='Y') as [yr_id],gl_m_acc.acc_id,gl_m_acc.acc_nam,acc_lvl,acc_dm,isnull(v_rpt_acc_obal.acc_fobal,0) as [acc_fobal],isnull(v_rpt_acc_obal.acc_obal,0) as [acc_obal],cur_id,cur_snm
--		from gl_m_acc
--		left join v_rpt_acc_obal
--		on gl_m_acc.acc_id=v_rpt_acc_obal.acc_id
--		and v_rpt_acc_obal.yr_id=(select yr_id from gl_m_yr where yr_ac='Y')
