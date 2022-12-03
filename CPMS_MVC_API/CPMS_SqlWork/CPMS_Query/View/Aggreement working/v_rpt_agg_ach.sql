USE ZSons
GO


alter view v_rpt_agg_ach
as
select 
magg_id,dinv_namt as [dinv_namt],achievement,achievement1,achievement2,achievement3,achievement4,achievement1+achievement2+achievement3+achievement4 as [Net Achivement],
bd_id,itmsub_id,stdcat_id,cus_id
from v_rpt_Agg_inv_cls
