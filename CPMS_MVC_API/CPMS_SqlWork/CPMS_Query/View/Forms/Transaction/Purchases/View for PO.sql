use PHM
go
alter view [dbo].[v_po]
as
select t_mpo.mpo_id,mpr_id,titm_id,dpo_exp,case when sum(dpo_appqty)>0 then sum(dpo_appqty) else SUM(dpo_qty) end as [dpo_appqty] from t_mpo inner join t_dpo on t_mpo.mpo_id=t_dpo.mpo_id group by t_mpo.mpo_id,mpr_id,titm_id,dpo_exp

