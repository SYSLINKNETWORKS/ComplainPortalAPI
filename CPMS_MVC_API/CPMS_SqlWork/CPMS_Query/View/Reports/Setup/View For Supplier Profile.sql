use zsons
go

alter view v_rpt_suppro
as
select  
sup_id,sup_nam,sup_cp,sup_add,sup_pho,sup_mob,sup_fax,sup_eml,sup_web,sup_ntn,sup_stn,sup_act,sup_creday,sup_amtltd,sup_typ,acc_no,com_id,br_id,sup_app,
m_sup.supcat_id,supcat_nam,
m_sup.cur_id,cur_nam,cur_snm
from m_sup
left join m_cur on m_sup.cur_id=m_cur.cur_id
left join m_supcat on m_sup.supcat_id=m_supcat.supcat_id




