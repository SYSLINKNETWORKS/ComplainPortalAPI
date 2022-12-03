USE MFI
GO

alter view v_stk_so_qty_upd
as
	select mso_id,stk_dat,stk_qty,itm_id,bd_id,wh_id,stk_bat,titm_maf,titm_exp from m_stk
	where stk_frm in ('t_itm','TransFG','stk_adj')
union all
	select mso_id,stk_dat,-stk_qty as [stk_qty],itm_id,bd_id,isnull(wh_id,1) as [wh_id],stk_bat,titm_maf,titm_exp from m_stk 
	where stk_frm='SO'  and stk_qty<>0

