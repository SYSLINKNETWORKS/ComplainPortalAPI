USE MFI
GO
alter view v_supadv
as
	select sup_id,t_supadv.mpo_id,sum(supadv_amt) as [supadv_amt],sum(supadv_tamt) as [supadv_tamt] from t_supadv inner join t_mpo on t_supadv.mpo_id=t_mpo.mpo_id group by sup_id,t_supadv.mpo_id

