USE MFI
GO
--EXEC sp_rpt_stdcost_pk 100,'07/31/2012'
--select * from m_itmsubmas

alter proc sp_rpt_stdcost_pk(@titm_id_fg int,@dt2 datetime)
as
select 
itmsub_id,
	itmsubmas_nam AS [NAME],dscpk_rat as [dsc_rat],case when itmsubmas_masact=1 then 1 else 0 end as [itmsubmas_mascat]
	from m_mscexp
	inner join m_dscpk
	on m_mscexp.mscexp_id=m_dscpk.mscexp_id
	inner join m_itmsubmas
	on m_dscpk.itmsubmas_id=m_itmsubmas.itmsubmas_id
	where m_dscpk.titm_id=@titm_id_fg
	and mscexp_dat=(select max(mscexp_dat) from m_mscexp inner join m_dscpk on m_mscexp.mscexp_id=m_dscpk.mscexp_id where mscexp_dat<= @dt2 and titm_id =@titm_id_fg)
union all
	select 
	itmsub_id,sccat_nam,isnull(dsccat_rat,0) as [dsc_rat],dsccat_sca
	from m_mscexp
	inner join m_dscfg
	on m_mscexp.mscexp_id=m_dscfg.mscexp_id
	and m_dscfg.titm_id=@titm_id_fg
	inner join m_dsccat
	on m_mscexp.mscexp_id=m_dsccat.mscexp_id
	inner join m_sccat
	on m_dsccat.sccat_id=m_sccat.sccat_id
	where mscexp_dat=(select max(mscexp_dat) from m_mscexp where mscexp_dat<=@dt2)

--select * from m_mscexp
--select * from m_dsccat
