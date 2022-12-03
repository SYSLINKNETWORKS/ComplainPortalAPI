USE PHM
GO

alter view v_rpt_titm_dis
as
select 
m_bd_rat.titm_id,titm_nam1 as [titm_nam],m_bd_rat.cuscat_id,cuscat_nam,m_bd_rat.cus_id,cus_nam,bd_rat_dat,bd_disrat,bd_mas_dis 
from m_bd_rat
inner join v_titm
on m_bd_rat.titm_id=v_titm.titm_id
left join m_cus on m_bd_rat.cus_id=m_cus.cus_id 
left join m_cuscat on m_bd_rat.cuscat_id=m_cuscat.cuscat_id

