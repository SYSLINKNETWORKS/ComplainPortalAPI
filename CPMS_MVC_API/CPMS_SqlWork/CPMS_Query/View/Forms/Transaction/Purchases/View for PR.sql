
use PHM
go
alter  view [dbo].[v_pr]
as
select mpr_id,titm_id,case when sum(dpr_appqty)>0 then sum(dpr_appqty) else SUM(dpr_qty) end as [dpr_appqty] from t_dpr group by mpr_id,titm_id
GO
