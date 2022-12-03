USE ZSONS
GO

create view v_bi_pr
as
select 
t_mpr.mpr_id,mpr_dat,mso_no,dpt_nam,t_dpr.titm_id,titm_nam,dpr_qty,isnull(dpo_qty,0) as [dpo_qty],dpr_qty-isnull(dpo_qty,0) as [bal_qty],sca_nam
from t_mpr 
--Join with Detail Requisition
inner join t_dpr 
on t_mpr.mpr_id=t_dpr.mpr_id
--Join with Item Detail View
inner join v_titm 
on t_dpr.titm_id=v_titm.titm_id
--Left join with Department
left join m_dpt
on t_mpr.dpt_id=m_dpt.dpt_id
--Left join with PO PR QTY
left join v_bi_pr_po
on t_mpr.mpr_id=v_bi_pr_po.mpr_id
and t_dpr.titm_id=v_bi_pr_po.titm_id
--Left join with SO
left join t_mso 
on t_mpr.com_id=t_mso.com_id
and t_mpr.mso_id=t_mso.mso_id
where mpr_act=0 and dpr_st=0

go
alter view v_bi_pr_po
as
select mpr_id,titm_id,sum(dpo_qty) as [dpo_qty] from t_mpo
inner join t_dpo
on t_mpo.mpo_id=t_dpo.mpo_id
group by mpr_id,titm_id



