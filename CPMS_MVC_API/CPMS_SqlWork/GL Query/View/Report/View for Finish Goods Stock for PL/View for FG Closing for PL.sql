USE ZSons
GO
--alter table m_stk add stk_foh float
--update m_stk set stk_foh=0
--update m_stk set stk_foh=13.2882 where itm_id in (select titm_id from t_itm inner join m_itm on t_itm.itm_id=m_itm.itm_id where itm_cat='F') and m_yr_id='01'

ALTER view v_stock_fg_closing
as
		--Finish Goods Closing
		select m_yr_id,stk_dat,round((sum(isnull(stk_qty,0)*isnull((stk_trat+stk_tratdiff+stk_foh),0))),4) as [amount],stk_tax
		from m_stk
		where itm_id in (select titm_id from t_itm inner join m_itm on t_itm.itm_id=m_itm.itm_id where itm_cat in ('F')) and stk_frm in ('DC','TransFG','SO','stk_adj') 
		group by m_yr_id,stk_dat,stk_tax
		union all
		select  m_yr_id,stk_dat, round((sum(isnull(stk_qty,0)*isnull((stk_trat+stk_tratdiff),0))),4) as [amount],stk_tax
		from m_stk
		where itm_id in (select titm_id from t_itm inner join m_itm on t_itm.itm_id=m_itm.itm_id where itm_cat in ('F')) and stk_frm in ('t_itm') 
		group by m_yr_id,stk_dat,stk_tax		