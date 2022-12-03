USE ZSONS
go

alter view v_aggvch
as
select 
minv_dat,dinv_namt,0 as [dcn_namt],emppro_macid,t_minv.cus_id,bd_id,bd_nam,
itmsub_id,rtrim(itmsubmas_nam)+ '-' +rtrim(itmsub_nam) as [itmsub_nam],
stdcat_id,rtrim(stdcatmas_nam)+ '-' +rtrim(stdcat_nam) as [stdcat_nam]
from t_minv
inner join t_dinv 
on t_minv.minv_id=t_dinv.minv_id
inner join t_mdc 
on t_dinv.mdc_id=t_mdc.mdc_id
inner join t_mso 
on t_mdc.mso_id=t_mso.mso_id
inner join v_titm
on t_dinv.titm_id=v_titm.titm_id 
left join m_emppro
on t_mso.emppro_id=m_emppro.emppro_id
where minv_can=0 and minv_disamt=0 
union all
select 
mcn_dat,0 as [dinv_namt],dcn_namt,emppro_macid,t_mcn.cus_id,bd_id,bd_nam,
itmsub_id,rtrim(itmsubmas_nam)+ '-' +rtrim(itmsub_nam) as [itmsub_nam],
stdcat_id,rtrim(stdcatmas_nam)+ '-' +rtrim(stdcat_nam) as [stdcat_nam]
from t_mcn
inner join t_dcn 
on t_mcn.mcn_id=t_dcn.mcn_id
inner join t_minv
on t_mcn.minv_id=t_minv.minv_id
inner join t_dinv
on t_minv.minv_id=t_dinv.minv_id
and t_dcn.titm_id=t_dinv.titm_id
and t_dcn.itmqty_id=t_dinv.itmqty_id
inner join t_mdc 
on t_dinv.mdc_id=t_mdc.mdc_id
inner join t_mso 
on t_mdc.mso_id=t_mso.mso_id
inner join v_titm
on t_dcn.titm_id=v_titm.titm_id 
left join m_emppro
on t_mso.emppro_id=m_emppro.emppro_id
where mcn_can=0 and mcn_disamt=0 
