USE ZSONS 
GO
alter view v_mdn
as
	select sup_id,t_mdn.mpb_id,sum(mdn_amt) as [mdn_amt],sum(mdn_tamt) as [mdn_tamt] from t_mdn inner join t_mpb on t_mdn.mpb_id=t_mpb.mpb_id group by sup_id,t_mdn.mpb_id

