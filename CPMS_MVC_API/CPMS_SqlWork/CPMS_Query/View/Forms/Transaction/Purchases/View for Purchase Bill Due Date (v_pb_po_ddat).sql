USE PHM
go

alter view v_pb_po_ddat
as
select 
 t_mpb.mpb_id,dateadd(DAY,mpo_credays,mpb_dat) as [mpb_ddat] 
from t_mpb 
inner join t_dpb on t_mpb.mpb_id=t_dpb.mpb_id 
inner join t_mqc on t_dpb.mqc_id=t_mqc.mqc_id
inner join t_mgrn on t_mqc.mgrn_id=t_mgrn.mgrn_id 
inner join t_mpo on t_mgrn.mpo_id=t_mpo.mpo_id
group by t_mpb.mpb_id,mpo_credays,mpb_dat

