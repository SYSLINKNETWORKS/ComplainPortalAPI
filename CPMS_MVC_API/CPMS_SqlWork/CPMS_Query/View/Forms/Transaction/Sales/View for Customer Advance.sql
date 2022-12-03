USE ZSONS 
GO
alter view v_cusadv
as
	select t_cusadv.cus_id,t_dcusadv.minv_id,sum(dcusadv_amt) as [cusadv_amt],mso_id from t_cusadv inner join t_dcusadv on t_cusadv.cusadv_id=t_dcusadv.cusadv_id 
	where dcusadv_amt<>0 and cusadv_can=0
	group by t_cusadv.cus_id,t_dcusadv.minv_id,mso_id
