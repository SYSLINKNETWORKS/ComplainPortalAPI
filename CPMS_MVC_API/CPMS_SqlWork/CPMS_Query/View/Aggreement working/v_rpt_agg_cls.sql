USE ZSons
GO

alter view v_rpt_agg_cls
as
select 
	t_magg.magg_id,magg_no,magg_dat,t_magg.cus_id,cus_nam,magg_datfrm,magg_datto,magg_rmk,magg_amt,magg_ckamt,
	t_dagg.bd_id,bd_nam,t_dagg.stdcat_id,rtrim(stdcatmas_nam)+'-'+rtrim(stdcat_nam) as [stdcat_nam],t_dagg.itmsub_id,RTRIM(itmsubmas_nam)+ ' '+RTRIM(itmsub_nam) as [itmsub_nam],
	case magg_ckamt when 0 then magg_amt*(dagg_perval/100) else dagg_perval end as [Target],	
	dagg_perval,
	case magg_ckamt when 0 then magg_amt*(dagg_perval/100) else dagg_perval end as [dagg_amt],
	dagg_per1,
	case magg_ckamt when 0 then (magg_amt*(dagg_perval/100))*(0.91) else dagg_perval*(0.91) end [dagg_amt1],
	dagg_per2,
	case magg_ckamt when 0 then (magg_amt*(dagg_perval/100))*(0.81) else dagg_perval*(0.81) end [dagg_amt2],
	dagg_per3,
	case magg_ckamt when 0 then (magg_amt*(dagg_perval/100))*(0.71) else dagg_perval*(0.71) end [dagg_amt3],
	dagg_per4,
	case magg_ckamt when 0 then (magg_amt*(dagg_perval/100))*(0.70) else dagg_perval*(0.70) end [dagg_amt4]
	from t_magg
	inner join t_dagg 
	on t_magg.magg_id=t_dagg.magg_id	
	inner join m_cus
	on t_magg.cus_id=m_cus.cus_id
	inner join m_bd
	on t_dagg.bd_id=m_bd.bd_id
	inner join m_itmsub 
	on t_dagg.itmsub_id=m_itmsub.itmsub_id
	inner join m_itmsubmas
	on m_itmsub.itmsubmas_id=m_itmsubmas.itmsubmas_id
	left join m_stdcat
	on t_dagg.stdcat_id=m_stdcat.stdcat_id
	left join m_stdcatmas
	on m_stdcat.stdcatmas_id=m_stdcatmas.stdcatmas_id

--where t_magg.magg_id=1