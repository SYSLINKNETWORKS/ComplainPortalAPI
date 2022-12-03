USE ZSons
GO
--View for Total Amount Received from Customer
ALTER view v_dg_drec
as
	select t_mrec.mrec_id,mrec_rat,minv_id,sum(drec_namt)as [drec_namt],sum(drec_epl) as [drec_epl] from 
	t_mrec 
	inner join t_drec
	on t_mrec.mrec_id=t_drec.mrec_id
	group by t_mrec.mrec_id,mrec_rat,minv_id

