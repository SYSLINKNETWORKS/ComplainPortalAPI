USE ZSons
go
--select acc_id from v_rpt_bkchq where tag='S' and acc_id='03002001001'
--select * from t_dvch where acc_no=598

--select * from gl_m_acc where acc_id='03002001001'


ALTER view v_rpt_bkchq
as
select t_mvch.com_id,t_mvch.br_id,t_mvch.mvch_chq,mvch_chqdat,acc_id,acc_nam,dvch_dr_amt as [amount],
(select glmacc.acc_id from t_dvch tdvch inner join gl_m_acc glmacc on tdvch.com_id=glmacc.com_id and tdvch.acc_no=glmacc.acc_no where tdvch.com_id=t_dvch.com_id and tdvch.br_id=t_dvch.br_id and tdvch.mvch_no=t_dvch.mvch_no and tdvch.dvch_cr_amt<>0) as [acc_id_party],
(select glmacc.acc_nam from t_dvch tdvch inner join gl_m_acc glmacc on tdvch.com_id=glmacc.com_id and tdvch.acc_no=glmacc.acc_no where tdvch.com_id=t_dvch.com_id and tdvch.br_id=t_dvch.br_id and tdvch.mvch_no=t_dvch.mvch_no and tdvch.dvch_cr_amt<>0) as [acc_nam_party],
'G' as [Tag] 
from t_mvch
inner join t_dvch
on t_mvch.com_id=t_dvch.com_id
and t_mvch.br_id=t_Dvch.br_id
and t_mvch.mvch_no=t_dvch.mvch_no
inner join gl_m_acc
on t_mvch.com_id=gl_m_acc.com_id
and t_dvch.acc_no=gl_m_acc.acc_no
where typ_id='03' and t_mvch.mvch_can=0
and t_mvch.mvch_chqst=0
and dvch_dr_amt<>0
union all
select t_mvch.com_id,t_mvch.br_id,t_mvch.mvch_chq,mvch_chqdat,acc_id,acc_nam,dvch_cr_amt as [amount],
(select glmacc.acc_id from t_dvch tdvch inner join gl_m_acc glmacc on tdvch.com_id=glmacc.com_id and tdvch.acc_no=glmacc.acc_no where tdvch.com_id=t_dvch.com_id and tdvch.br_id=t_dvch.br_id and tdvch.mvch_no=t_dvch.mvch_no and tdvch.dvch_dr_amt<>0) as [acc_id_party],
(select glmacc.acc_nam from t_dvch tdvch inner join gl_m_acc glmacc on tdvch.com_id=glmacc.com_id and tdvch.acc_no=glmacc.acc_no where tdvch.com_id=t_dvch.com_id and tdvch.br_id=t_dvch.br_id and tdvch.mvch_no=t_dvch.mvch_no and tdvch.dvch_dr_amt<>0) as [acc_nam_party],
'S' as [Tag] 
from t_mvch
inner join t_dvch
on t_mvch.com_id=t_dvch.com_id
and t_mvch.br_id=t_Dvch.br_id
and t_mvch.mvch_no=t_dvch.mvch_no
inner join gl_m_acc
on t_mvch.com_id=gl_m_acc.com_id
and t_dvch.acc_no=gl_m_acc.acc_no
where typ_id='03' and t_mvch.mvch_can=0
and t_mvch.mvch_chqst=0
and dvch_cr_amt<>0


