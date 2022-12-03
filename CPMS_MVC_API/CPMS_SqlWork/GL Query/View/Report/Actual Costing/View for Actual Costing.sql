USE MFI
GO
--Items
alter view v_rpt_actcost_item
as
select 
t_itm.titm_id,titm_nam,inner_titm_qty,m_sca.sca_nam,master_titm_qty,inn.sca_nam as [inner_sca_nam],mas.sca_nam as [master_sca_nam],sum(dfg_batqty) as [dfg_batqty],sum(dfg_rec) as [dfg_rec],round( sum(dfg_rec)/sum(dfg_batqty),4)  as [avgbatchqty],t_miss.mbat_id,mbat_nam,t_dfg.mso_id,mso_no,t_dfg.miss_id_fg,miss_dat
from t_itm
--Join with Finish Goods Transfer Note Detail
inner join t_dfg
on t_itm.titm_id=t_dfg.titm_id
--Join with Finish Goods Transfer Note Master
inner join t_mfg
on t_dfg.mfg_id=t_mfg.mfg_id
--Join with Sale Order
inner join t_mso
on t_dfg.mso_id=t_mso.mso_id
--Left Join with RM Issue Master
left join t_miss 
on t_dfg.miss_id_fg=t_miss.miss_id
--left Join with Recipe
left join m_mbat
on t_miss.mbat_id=m_mbat.mbat_id
--left Join with Scale
left join m_sca
on t_itm.sca_id=m_sca.sca_id
--Left join  with inner scale
left join m_sca inn
on t_itm.inner_sca_id=inn.sca_id
--Left join with master scale
left join m_sca mas
on t_itm.master_sca_id=mas.sca_id
--Where
--where t_itm.titm_id=630
--Group By
group by t_itm.titm_id,titm_nam,inner_titm_qty,m_sca.sca_nam,master_titm_qty,inn.sca_nam,mas.sca_nam,t_miss.mbat_id,mbat_nam,t_dfg.mso_id,mso_no,miss_id_fg,miss_dat
--select * from t_dfg where titm_id=630

GO

--Raw Material
alter view v_rpt_actcost_rm
as
select 
v_rpt_actcost_item.titm_id,v_rpt_actcost_item.titm_nam,v_rpt_actcost_item.inner_titm_qty,sca_nam,v_rpt_actcost_item.master_titm_qty,inner_sca_nam,master_sca_nam,
v_rpt_actcost_item.mbat_id,rm.titm_id as [RMID],rm.titm_nam AS [RMANME]
,sum(diss_qty) as [diss_qty],(select avg(stk_trat) from m_stk where stk_frm in ('t_itm','GRN') and itm_id=rm.titm_id and stk_dat<=v_rpt_actcost_item.miss_dat) as [Rate]
from v_rpt_actcost_item
--Join with Raw Material Issue (MISS)
inner join t_miss
on v_rpt_actcost_item.titm_id=t_miss.titm_id
and v_rpt_actcost_item.mbat_id=t_miss.mbat_id
and v_rpt_actcost_item.miss_id_fg=t_miss.miss_id
--Join with Raw Material ISSUE (DISS)
inner join t_diss
on t_miss.miss_id=t_diss.miss_id
--Join with Item Detail Raw Material
inner join t_itm rm
on t_diss.titm_id=rm.titm_id
----Group by
group by
v_rpt_actcost_item.titm_id,v_rpt_actcost_item.titm_nam,v_rpt_actcost_item.inner_titm_qty,sca_nam,v_rpt_actcost_item.master_titm_qty,inner_sca_nam,master_sca_nam,v_rpt_actcost_item.mbat_id
,rm.titm_id,rm.titm_nam,v_rpt_actcost_item.miss_dat
go
--Packing
alter view v_rpt_actcost_pk
as
select  
v_rpt_actcost_item.titm_id,avgbatchqty as [avgbatchqty],v_rpt_actcost_item.mbat_id,m_itmsub.itmsubmas_id,itmsubmas_nam,
(select avg(stk_trat) from m_stk where stk_frm in ('t_itm','GRN') and itm_id=pk.titm_id and stk_dat<=v_rpt_actcost_item.miss_dat) as [Rate],
case when itmsubmas_masact=1 then avgbatchqty/v_rpt_actcost_item.master_titm_qty else avgbatchqty end as [qty]
from v_rpt_actcost_item
--Join with Finish Goods Detail
inner join t_dfg
on v_rpt_actcost_item.titm_id=t_dfg.titm_id
and v_rpt_actcost_item.mso_id=t_dfg.mso_id
--Join with Packing Material Issue (Master)
inner join t_miss misspk
on t_dfg.miss_id=misspk.miss_id
--Join with Packing Masterial Issue (Detail
inner join t_diss disspk
on misspk.miss_id=disspk.miss_id
--Join with Packing Masterial
inner join t_itm pk
on disspk.titm_id=pk.titm_id
--Join with Sub Category Packing
inner join m_itmsub
on pk.itmsub_id=m_itmsub.itmsub_id
--Join with Master Sub-Category Packing
inner join m_itmsubmas
on m_itmsub.itmsubmas_id=m_itmsubmas.itmsubmas_id
