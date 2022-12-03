USE PHM
GO
--View for Total Amount paid to supplier
alter view v_dg_dpay
as
	select t_mpay.mpay_id,mpb_id,t_dpay.m_yr_id,sum(dpay_namt)as [dpay_amt],sum(dpay_famt) as [dpay_famt],sum(dpay_epl) as [dpay_epl] 
	from t_mpay 
	inner join t_dpay
	on t_mpay.mpay_id=t_dpay.mpay_id
	where dpay_amt<>0 AND mpay_can=0
	group by t_mpay.mpay_id,mpb_id,t_dpay.m_yr_id
	


