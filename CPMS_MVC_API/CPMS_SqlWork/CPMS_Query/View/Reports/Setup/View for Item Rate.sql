USE phm
GO
--select * from v_rpt_titm_rat where itm_id=1 and itmsubmas_id=1 and itmsub_id=1
alter view v_rpt_titm_rat
as
select v_titm.titm_id,titm_nam1 as [titm_nam],itm_id,itm_nam,t_itmrat.cuscat_id,cuscat_nam,t_itmrat.cus_id,cus_nam,titmrat_dat,titmrat_wrat,titmrat_rrat from v_titm
inner join t_itmrat
on v_titm.titm_id=t_itmrat.titm_id 
left join m_cus on t_itmrat.cus_id=m_cus.cus_id 
left join m_cuscat on t_itmrat.cuscat_id=m_cuscat.cuscat_id


