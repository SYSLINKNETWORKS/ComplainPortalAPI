USE zsons
GO

alter view v_rpt_titm_det
as
select 
v_titm.itm_id,itm_nam,itmsubmas_id,v_titm.itmsub_id,itmsub_nam1 as [itmsub_nam],stdcat_nam1 as [stdcat_nam],v_titm.bd_id,bd_nam,v_titm.titm_id,v_titm.titm_nam1 as [titm_nam],
v_titm.inner_titm_qty,sca_nam,
v_titm.master_titm_qty,inner_sca_nam,v_titm.master_sca_nam,
scale_id,scale,
--gmaster_sca_id ,gmas.sca_nam as [gmaster_sca_nam],
v_titm.titm_mlvl,v_titm.titm_rlvl,v_titm.titm_act,v_titm.titm_bar,
t_itm.scr_id,t_itm_scrap.titm_nam as [scrap_nam],
t_itm.was_id,t_itm_wastage.titm_nam as [wastage_nam],
t_itm.ck_bth as [Petti],t_itm.ck_fill as [Petti_Packing],v_titm.titm_ratchange
 from v_titm 
 --Item Detail
inner join t_itm 
on v_titm.titm_id=t_itm.titm_id
--Left join for scrap
left join t_itm t_itm_scrap
on t_itm.scr_id=t_itm_scrap.titm_id
--Left join for Wastage
left join t_itm t_itm_wastage
on t_itm.scr_id=t_itm_wastage.titm_id
--where v_titm.titm_id in (1,5)
--select * from v_titm where titm_id=5
--select * from t_itm where titm_id=1


