USE MEIJI_RUSK
GO
--View for Total Amount Received from Customer
create view v_inv_drec_opening
as
	select minv_id,sum(drec_namt)as [drec_namt] from 
	t_mrec 
	inner join t_drec
	on t_mrec.mrec_id=t_drec.mrec_id
	group by minv_id

