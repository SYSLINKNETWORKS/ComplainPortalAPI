USE MFI
GO


create view v_rpt_stdcost_sum_1
as
select cast(convert(varchar,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,mfg_dat)+1,0)),101)+' 00:00:00' as datetime) as [mfg_dat],m_itmsub.dpt_id,dpt_nam,t_itm.itmsub_id,itmsub_nam,t_dfg.titm_id,titm_nam,t_dso.bd_id,bd_nam,sum(dfg_rec*inner_titm_qty) as [pcs],sum(dfg_rec) as [dfg_rec],sum(round(dfg_rec/master_titm_qty,2)) as [ctn]
from t_mfg 
inner join t_dfg
on t_mfg.mfg_id=t_dfg.mfg_id
inner join t_itm
on t_dfg.titm_id=t_itm.titm_id
inner join t_dso
on t_dfg.titm_id=t_dso.titm_id
and t_dfg.mso_id=t_dso.mso_id
inner join m_bd
on t_dso.bd_id=m_bd.bd_id
left join m_itmsub
on t_itm.itmsub_id=m_itmsub.itmsub_id
left join m_dpt
on m_itmsub.dpt_id=m_dpt.dpt_id
where dso_prod<>0
group by DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,mfg_dat)+1,0)),m_itmsub.dpt_id,dpt_nam,t_itm.itmsub_id,itmsub_nam,t_dfg.titm_id,titm_nam,t_dso.bd_id,bd_nam
go

create view v_rpt_stdcost_sum_2
as
select 
mscexp_dat,m_dscfg.titm_id,m_sccat.sccat_id,sccat_nam, dsccat_rat,case dsccat_sca when 1 then dsccat_rat*inner_titm_qty when 2 then dsccat_rat when 3 then dsccat_rat/inner_titm_qty end as [Rate]
from m_mscexp
inner join m_dscfg
on m_mscexp.mscexp_id=m_dscfg.mscexp_id
inner join m_dsccat
on m_mscexp.mscexp_id=m_dsccat.mscexp_id
inner join m_sccat
on m_dsccat.sccat_id=m_sccat.sccat_id
inner join t_itm
on m_dscfg.titm_id=t_itm.titm_id

go

create view v_rpt_stdcost_sum_3
as
select 
mfg_dat,dpt_id,dpt_nam,itmsub_id,itmsub_nam,v_rpt_stdcost_sum_1.titm_id,titm_nam,bd_id,bd_nam,pcs,dfg_rec,ctn,sccat_id,sccat_nam,rate,dfg_rec*rate as [stdcost],'Rate' as [Rate_heading],'Cost' as [Cost_heading]
from v_rpt_stdcost_sum_1 
inner join v_rpt_stdcost_sum_2 
on v_rpt_stdcost_sum_1.titm_id=v_rpt_stdcost_sum_2.titm_id 
and v_rpt_stdcost_sum_1.mfg_dat=v_rpt_stdcost_sum_2.mscexp_dat 
--where v_rpt_stdcost_sum_1.mfg_dat='07/31/2012'
