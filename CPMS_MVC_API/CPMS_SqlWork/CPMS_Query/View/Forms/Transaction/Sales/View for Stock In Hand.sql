USE MFI
GO

create view v_stk
as 
	select itm_id as [titm_id],bd_id,titm_exp,sum(stk_qty) as [stk_qty] from m_stk
	group by itm_id,bd_id,titm_exp
