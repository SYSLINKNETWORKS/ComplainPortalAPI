USE MFI
GO

create view v_stk_gp
as
select itm_id as [titm_id],round(sum(stk_qty),4) as [stk_qty] 
from m_stk 
left join m_bd
on m_stk.bd_id=m_bd.bd_id
group by itm_id
having sum(stk_qty)>0

go

create view v_stk_gp_det
as
select itm_id as [titm_id],bd_nam,stk_bat,round(sum(stk_qty),4) as [stk_qty] 
from m_stk 
left join m_bd
on m_stk.bd_id=m_bd.bd_id
group by itm_id,bd_nam,stk_bat
having sum(stk_qty)>0
