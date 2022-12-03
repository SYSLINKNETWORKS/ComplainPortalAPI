use zsons
go
create view v_bi_so
as
select 
mso_dat,mso_amt,mdc_dat,mdc_no,mso_no,mso_act
from t_mso
inner join t_mdc on
t_mso.mso_id=t_mdc.mdc_id
where mso_act = 0



