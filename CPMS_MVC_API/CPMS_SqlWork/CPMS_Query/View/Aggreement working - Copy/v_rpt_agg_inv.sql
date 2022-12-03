use ZSons
go

create view v_rpt_agg_inv
as
select 
	cus_id,t_minv.minv_id,minv_dat,bd_id,itmsub_id,sum(dinv_namt) as [dinv_namt]
	from t_minv
	inner join t_dinv
	on t_minv.minv_id=t_dinv.minv_id
	inner join v_titm
	on t_dinv.titm_id=v_titm.titm_id
	where minv_can=0 and minv_disamt=0
	group by cus_id,t_minv.minv_id,minv_dat,bd_id,itmsub_id
	