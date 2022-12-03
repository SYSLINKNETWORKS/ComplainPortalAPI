use ZSons
go

alter view v_rpt_agg_cn
as
	select minv_id,bd_id,itmsub_id,stdcat_id,SUM(dcn_namt) as [dcn_namt]
	from t_mcn
	inner join t_dcn 
	on t_mcn.mcn_id=t_dcn.mcn_id
	inner join v_titm
	on t_dcn.titm_id=v_titm.titm_id
	group by minv_id,bd_id,itmsub_id,stdcat_id

go
--Credit Note
alter view v_rpt_agg_inv
as
select 
	cus_id,t_minv.minv_id,minv_dat,v_titm.bd_id,v_titm.itmsub_id,v_titm.stdcat_id,sum(dinv_namt)-ISNULL(dcn_namt,0) as [dinv_namt]
	from t_minv
	inner join t_dinv
	on t_minv.minv_id=t_dinv.minv_id
	inner join v_titm
	on t_dinv.titm_id=v_titm.titm_id
	left join v_rpt_agg_cn
	on t_minv.minv_id=v_rpt_agg_cn.minv_id and v_titm.bd_id=v_rpt_agg_cn.bd_id and v_titm.itmsub_id=v_rpt_agg_cn.itmsub_id	
	where minv_can=0 and minv_disamt=0
	group by cus_id,t_minv.minv_id,minv_dat,v_titm.bd_id,v_titm.itmsub_id,v_titm.stdcat_id,dcn_namt

----Invoice
--alter view v_rpt_agg_inv
--as
--select 
--	cus_id,t_minv.minv_id,minv_dat,bd_id,itmsub_id,sum(dinv_namt) as [dinv_namt]
--	from t_minv
--	inner join t_dinv
--	on t_minv.minv_id=t_dinv.minv_id
--	inner join v_titm
--	on t_dinv.titm_id=v_titm.titm_id
--	where minv_can=0 and minv_disamt=0
--	group by cus_id,t_minv.minv_id,minv_dat,bd_id,itmsub_id
	