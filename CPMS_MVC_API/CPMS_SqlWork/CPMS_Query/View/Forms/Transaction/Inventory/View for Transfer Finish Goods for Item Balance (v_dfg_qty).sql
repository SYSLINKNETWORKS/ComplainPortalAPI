USE MFI
GO

alter view v_dfg_qty
as
select mso_id,titm_id,sum(dfg_pack) as [dfg_prec] from t_dfg 
group by mso_id,titm_id

