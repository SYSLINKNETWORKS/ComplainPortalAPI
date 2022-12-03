USE MFI
GO
--select * from v_rpt_stdcost where FGID=88


alter view v_rpt_stdcost
as
select 
m_mscexp.mscexp_id,mscexp_dat,m_mscexp.itmsub_id,itmsub_nam,t_itm.titm_id AS [FGID],t_itm.titm_nam as [FG],t_itm.inner_titm_qty,inn.sca_nam as [Innerscale],t_itm.master_titm_qty,mas.sca_nam as [MasterScale],
batqty_dat,batqty_mqty,batqty_qty,
batqty_mqty/t_itm.master_titm_qty as [CTN]
from m_mscexp
inner join m_itmsub
on m_mscexp.itmsub_id=m_itmsub.itmsub_id
inner join t_itm
on m_itmsub.itmsub_id=t_itm.itmsub_id
left join m_sca inn
on t_itm.inner_sca_id=inn.sca_id
left join m_sca mas
on t_itm.master_sca_id=mas.sca_id
left join v_rpt_stdcost_batsiz
on t_itm.titm_id=v_rpt_stdcost_batsiz.titm_id
and v_rpt_stdcost_batsiz.batqty_dat=(select max(batqty_dat) from v_rpt_stdcost_batsiz where batqty_dat<=mscexp_dat and titm_id=t_itm.titm_id)
--where t_itm.titm_id=88


go

alter view v_rpt_stdcost_batsiz
as
select batqty_dat,titm_id,batqty_mqty,batqty_qty from m_batqty 

go


--RM STANDARD COSTING
alter view v_rpt_stdcost_bat
as
select 
mscrm_dat,t_itm.itmsub_id,m_mbat.mbat_id,mbat_dat,mbat_nam,mbat_siz,m_dbat_fg.titm_id as [FGID],t_itm.titm_nam [FG],m_dbat.titm_id as [RMID],rm.titm_nam as [RM],
sca_nam,dbat_qty,isnull(mscrm_rat,0) as [mscrm_rat],dbat_qty*isnull(mscrm_rat,0) as [amt]
from m_mbat
inner join m_dbat
on m_mbat.mbat_id=m_dbat.mbat_id
inner join m_dbat_fg
on m_mbat.mbat_id=m_dbat_fg.mbat_id
inner join t_itm
on m_dbat_fg.titm_id=t_itm.titm_id
inner join t_itm rm
on m_dbat.titm_id=rm.titm_id
inner join m_itmsub
on t_itm.itmsub_id=m_itmsub.itmsub_id
left join m_mscrm
on m_dbat.titm_id=m_mscrm.titm_id
left join m_sca 
on rm.man_sca_id=m_sca.sca_id

--select 
--m_mscexp.mscexp_id,mscexp_dat,mscrm_dat,t_itm.itmsub_id,m_mbat.mbat_id,mbat_dat,mbat_nam,mbat_siz,m_dbat_fg.titm_id as [FGID],t_itm.titm_nam [FG],m_dbat.titm_id as [RMID],rm.titm_nam as [RM],
--sca_nam,dbat_qty,isnull(mscrm_rat,0) as [mscrm_rat],dbat_qty*isnull(mscrm_rat,0) as [amt]
----*
--from m_mbat
--inner join m_dbat
--on m_mbat.mbat_id=m_dbat.mbat_id
--inner join m_dbat_fg
--on m_mbat.mbat_id=m_dbat_fg.mbat_id
--inner join t_itm
--on m_dbat_fg.titm_id=t_itm.titm_id
--inner join t_itm rm
--on m_dbat.titm_id=rm.titm_id
--inner join m_itmsub
--on t_itm.itmsub_id=m_itmsub.itmsub_id
--inner join m_mscexp
--on t_itm.itmsub_id=m_mscexp.itmsub_id
----left join m_mscrm
----on m_mscexp.mscexp_id=m_mscrm.mscexp_id
----and rm.titm_id=m_mscrm.titm_id
--left join m_mscrm
--on m_dbat.titm_id=m_mscrm.titm_id
--left join m_sca 
--on rm.man_sca_id=m_sca.sca_id



go


--ALTER view v_rpt_stdcost_pk
--as
--select 
--t_itm.itmsub_id,itmsubmas_nam AS [NAME],isnull(sum(mscpk_rat),0) as [dsc_rat]
-- from t_itmfg
-- inner join t_itm
-- on t_itm.titm_id=t_itmfg.titm_id_fg 
-- inner join t_itm rm
-- on t_itmfg.titm_id=rm.titm_id
-- inner join m_itmsub
-- on rm.itmsub_id=m_itmsub.itmsub_id
-- inner join m_itmsubmas
-- on m_itmsub.itmsubmas_id=m_itmsubmas.itmsubmas_id
--left join m_mscpk
--on rm.titm_id=m_mscpk.titm_id
--group by m_itmsub.itmsubmas_id,itmsubmas_nam,t_itm.itmsub_id
----union all
----select 
----itmsub_id,sccat_nam,isnull(dscfg_rat,0) as [dsc_rat]
----from m_mscfg
----inner join m_dscfg
----on m_mscfg.mscfg_id=m_dscfg.mscfg_id
----inner join m_sccat
----on m_dscfg.sccat_id=m_sccat.sccat_id

