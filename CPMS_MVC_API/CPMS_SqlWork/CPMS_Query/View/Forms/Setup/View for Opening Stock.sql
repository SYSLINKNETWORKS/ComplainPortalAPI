
USE NATHI
GO


alter view v_stkop
as
select m_stk.com_id,m_stk.br_id,t_itm.itm_id,itm_nam,m_stk.itm_id as [titm_id],itmqty_id,m_stk.wh_id,m_stk.bd_id,m_stk.stk_bat,m_stk.titm_maf,m_stk.titm_exp,isnull(stk_qty,0) as [stk_qty],isnull(stk_rat,0) as [stk_rat],cur_id,isnull(stk_currat,0) as [stk_currat],m_yr_id
from m_stk
inner join t_itm on m_stk.itm_id=t_itm.titm_id
inner join m_itm on t_itm.itm_id=m_itm.itm_id
 where stk_frm='t_itm' 


--select * from m_stk
--alter table m_stk add stk_frat float
--update m_stk set stk_frat=0
