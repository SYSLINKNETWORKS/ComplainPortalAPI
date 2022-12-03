USE MFI
GO

alter view v_semifinish_item_qty
as
select mgrn_id,titm_id_fg,isnull(dfg_iss,0) as [dfg_iss],dfg_rec*round(cast(itmqty_nam as float)/1000,4) as [dfg_rec] from t_mfg inner join t_dfg on t_mfg.mfg_id=t_dfg.mfg_id  inner join t_itm on t_dfg.titm_id=t_itm.titm_id inner join t_itmqty on t_itmqty.itmqty_id=t_itmqty.itmqty_id and t_itm.titm_id=t_itmqty.titm_id inner join m_itmqty on t_itmqty.itmqty_id=m_itmqty.itmqty_id


--update t_dfg set mgrn_id=651 where mfg_id=393
