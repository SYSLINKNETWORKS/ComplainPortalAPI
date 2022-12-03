USE MFI
GO
CREATE view v_stktransferFG
as
select t_itm.itm_id,itm_nam,m_stk.itm_id as [titm_id],stk_dat,m_stk.wh_id,m_stk.bd_id,titm_exp,isnull(stk_qty,0) as [stk_qty],isnull(stk_rat,0) as [stk_rat],cur_id,isnull(stk_currat,0) as [stk_currat],m_yr_id
from m_stk
inner join t_itm on m_stk.itm_id=t_itm.titm_id
inner join m_itm on t_itm.itm_id=m_itm.itm_id
 where stk_fRM='transferFG'
