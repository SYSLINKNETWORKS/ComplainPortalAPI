USE MFI
GO

alter view v_fg
as
select mso_id,itm_id as [titm_id],bd_id,sum(stk_qty) as [dfg_qty] from m_stk where stk_frm not in ('DC') group by mso_id,itm_id,bd_id
