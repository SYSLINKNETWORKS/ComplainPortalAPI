USE ZSONS 
GO
alter view v_supadv
as
	select t_supadv.sup_id,t_dsupadv.mpb_id,sum(dsupadv_amt) as [supadv_amt],sum(supadv_tamt) as [supadv_tamt] from t_supadv inner join t_dsupadv on t_supadv.supadv_id=t_dsupadv.supadv_id 
	where dsupadv_amt<>0 and supadv_can=0
	group by t_supadv.sup_id,t_dsupadv.mpb_id
