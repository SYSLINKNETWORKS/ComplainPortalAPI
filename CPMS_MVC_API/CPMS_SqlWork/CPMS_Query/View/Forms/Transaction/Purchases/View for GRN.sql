USE PHM
GO
alter view [dbo].[v_grn]
as
select t_mgrn.mgrn_id,mpo_id,titm_id,dgrn_exp,case when SUM(dgrn_appqty)>0 then sum(dgrn_appqty) else sum(dgrn_qty) end as [dgrn_appqty],sum(dgrn_acc) as [dgrn_acc],sum(dgrn_nqty) as [dgrn_nqty] from t_mgrn inner join t_dgrn on t_mgrn.mgrn_id=t_dgrn.mgrn_id group by t_mgrn.mgrn_id,mpo_id,titm_id,dgrn_exp
GO
