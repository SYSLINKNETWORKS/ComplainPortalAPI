USE MFI
GO
alter view v_stk_so_qty
as
	select mso_id,stk_dat,sum(stk_qty) as [stk_qty],itm_id,bd_id,wh_id,stk_bat,titm_maf,titm_exp from m_stk
	where stk_frm in ('t_itm','TransFG','stk_adj') and bd_id not in (select bd_id from m_bd where bd_genact=1)
--	and mso_id=20 and itm_id=88
	group by mso_id,stk_dat,itm_id,bd_id,wh_id,stk_bat,titm_maf,titm_exp
--	having 	sum(stk_qty)>0
union all
	select mso_id,stk_dat,case when sum(-stk_qty)<0 then sum(stk_qty) else sum(-stk_qty) end  as [stk_qty],itm_id,bd_id ,isnull(wh_id,1) as [wh_id],stk_bat,titm_maf,titm_exp from m_stk 
	where stk_frm='SO' and stk_qty>0 and bd_id not in (select bd_id from m_bd where bd_genact=1)
--	and mso_id=20 and itm_id=88
	group by mso_id,stk_dat,itm_id,bd_id,wh_id,stk_bat,titm_maf,titm_exp


--select * from m_stk where itm_id=796 and mso_id=5

