USE phm
go
--select * from v_titm where titm_id=5
--select * from t_itm where titm_id=5
--update t_itm set inner_sca_id=1
--select * from t_itm
alter view v_titm
as
select t_itm.titm_id,titm_nam,
UPPER(ISNULL(rtrim(titm_nam),''))  as [titm_nam1],
inner_titm_qty,m_sca.sca_snm as [sca_nam],
master_titm_qty,inn.sca_snm as [inner_sca_nam],mas.sca_snm as [master_sca_nam],
titm_prat,titm_rat,titm_trat,titm_rrat,titm_drat,titm_act,t_itm.ger_id,ger_nam,t_itm.man_id,man_nam,
t_itm.itm_id,itm_nam,titm_rlvl,titm_mlvl,itm_cat,
inn.sca_ckcon,case inn.sca_met when 0 then 1 else inn.sca_met end as [sca_met],
case itm_cat when 'F' then inn.sca_id else m_sca.sca_id end as [Scale_ID],
case itm_cat when 'F' then inn.sca_snm else m_sca.sca_snm end as [Scale]
from t_itm 
left join m_itm
on t_itm.itm_id=m_itm.itm_id
left join m_ger 
on t_itm.ger_id=m_ger.ger_id
left join m_man 
on t_itm.man_id=m_man.man_id
left join m_sca
on t_itm.sca_id=m_sca.sca_id
left join m_sca inn
on t_itm.inner_sca_id=inn.sca_id
left join m_sca mas
on t_itm.master_sca_id=mas.sca_id

--where titm_id=1

