USE NATHI
go

create view v_so_wei
as
select 
t_mso.mso_id,round(mso_bdisamt/sum(dso_qty),2) as [dso_wbdisamt],round(mso_disamt/sum(dso_qty),2) as [dso_wdisamt]
from 
t_mso
inner join t_dso
on t_mso.mso_id=t_dso.mso_id 
group by t_mso.mso_id,mso_bdisamt,mso_disamt

