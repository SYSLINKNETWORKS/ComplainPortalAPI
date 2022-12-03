 use nathi
 go
 
 alter view v_rpt_claim
 as                             
 select com_id,br_id,m_yr_id,t_mclaim.mclaim_id,rtrim(mclaim_recfrm) as [receive],mclaim_dat,
	t_dclaim.dclaim_id,t_dclaim.titm_id_rec,titmrec.titm_nam as [titm_rec],dclaim_qtyrec,
	t_dclaim.titm_id_iss,titmiss.titm_nam as [titm_iss],dclaim_qtyiss
 from t_mclaim 
 inner join t_dclaim on t_mclaim.mclaim_id=t_dclaim.mclaim_id 
 inner join v_titm titmrec on t_dclaim.titm_id_rec=titmrec.titm_id 
 inner join v_titm titmiss on t_dclaim.titm_id_iss=titmiss.titm_id 