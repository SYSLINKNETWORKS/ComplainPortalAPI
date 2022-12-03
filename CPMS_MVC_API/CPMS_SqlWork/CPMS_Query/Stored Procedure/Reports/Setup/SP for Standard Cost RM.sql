USE MFI
GO
--exec sp_rpt_stdcost_rm '08/30/2012'
--drop view v_rpt_stdcost_bat

alter proc sp_rpt_stdcost_rm(@dt1 datetime)
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
and m_mscrm.mscrm_dat=(select max(mscrm_dat) from m_mscrm where mscrm_dat<=@dt1)
left join m_sca 
on rm.man_sca_id=m_sca.sca_id

