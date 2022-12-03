USE PHM
GO
create view [dbo].[v_qc]
as
select t_mqc.mqc_id,mgrn_id,titm_id,dqc_exp,case when SUM(dqc_appqty)>0 then sum(dqc_appqty) else sum(dqc_qty) end as [dqc_appqty],sum(dqc_acc) as [dqc_acc],sum(dqc_nqty) as [dqc_nqty] 
from t_mqc 
inner join t_dqc on t_mqc.mqc_id=t_dqc.mqc_id group by t_mqc.mqc_id,mgrn_id,titm_id,dqc_exp
GO
