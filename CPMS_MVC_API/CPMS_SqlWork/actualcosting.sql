
--select * from m_Stk where itm_id=32 and stk_Frm='GRN'
declare @dt1 datetime,@dt2 datetime,@m_yr_id char(2)
set @m_yr_id='01'
set @dt1=(select yr_str_dt from gl_m_yr where yr_id=@m_yr_id)
set @dt2=(select yr_end_dt from gl_m_yr where yr_id=@m_yr_id)
select t_miss.mbat_id,SUM(dfg_rec) as [dfg_rec],sum(dfg_batqty) as [dfg_batqty],round(SUM(dfg_rec) /sum(dfg_batqty),4) as [Avg] from t_mfg inner join t_dfg on t_mfg.mfg_id=t_dfg.mfg_id 
inner join t_miss
on t_dfg.miss_id_fg=t_miss.miss_id
inner join m_mbat
on t_miss.mbat_id=m_mbat.mbat_id
where mfg_dat between @dt1 and @dt2 and t_dfg.titm_id=100
and t_miss.mbat_id=2
group by t_miss.mbat_id


select 
m_mbat.mbat_id,m_dbat.titm_id,titm_nam,dbat_qty,ROUND(AVG(dpb_rat),4) as [dpb_rat]
from m_mbat
inner join m_dbat
on m_mbat.mbat_id=m_dbat.mbat_id
inner join t_itm
on m_dbat.titm_id=t_itm.titm_id
left join v_rpt_rat
on m_dbat.titm_id=v_rpt_rat.titm_id
and v_rpt_rat.mpb_dat between @dt1 and @dt2 
where m_mbat.mbat_id=2
group by m_mbat.mbat_id,m_dbat.titm_id,titm_nam,dbat_qty

--create view v_rpt_rat
--as
--select mpb_dat,titm_id,dpb_rat*mpb_rat as [dpb_rat] from t_mpb
--inner join t_dpb
--on t_mpb.mpb_id=t_dpb.mpb_id

