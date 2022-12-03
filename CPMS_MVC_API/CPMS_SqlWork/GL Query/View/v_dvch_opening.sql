USE meiji_rusk
GO

--select * from v_dvch_opening where acc_no =(select acc_no from m_cus where cus_id=41)


alter view v_dvch_opening
as
select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,
t_mvch.typ_id,mvch_tax,t_mvch.cur_id,t_mvch.mvch_rat,
mvch_typ,
case when sum(dvch_dr_famt-dvch_cr_famt)>0 then sum(dvch_dr_famt-dvch_cr_famt) else 0 end as [dvch_dr_famt],
case when sum(dvch_dr_famt-dvch_cr_famt)<0 then -(sum(dvch_dr_famt-dvch_cr_famt)) else 0 end as [dvch_cr_famt],
case when sum(dvch_dr_amt-dvch_cr_amt)>0 then sum(dvch_dr_amt-dvch_cr_amt) else 0 end as [dvch_dr_amt],
case when sum(dvch_dr_amt-dvch_cr_amt)<0 then -(SUM(dvch_dr_amt-dvch_cr_amt)) else 0 end as [dvch_cr_amt],
t_dvch.acc_no,gl_m_acc.acc_id 
from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_acc on t_dvch.acc_no=gl_m_acc.acc_no where typ_id='06' 
group by t_mvch.com_id,t_mvch.br_id,t_mvch.typ_id,t_mvch.yr_id,t_mvch.cur_id,mvch_tax,t_dvch.acc_no,gl_m_acc.acc_id,t_mvch.mvch_rat,mvch_typ
