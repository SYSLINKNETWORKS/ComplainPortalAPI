use zsons
go
create view v_bi_pdc
as
select  
mdc_id,mdc_dat,mdc_deptime,mso_id,mdc_act
from t_mdc
where mdc_act=0