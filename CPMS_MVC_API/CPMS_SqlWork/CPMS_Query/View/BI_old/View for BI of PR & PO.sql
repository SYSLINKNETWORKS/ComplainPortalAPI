
--View for BI PR & PO
CREATE view v_bi_pr_po
as
select mpr_id,titm_id,sum(dpo_qty) as [dpo_qty] from t_mpo inner join t_dpo on t_mpo.mpo_id=t_dpo.mpo_id group by mpr_id,titm_id
