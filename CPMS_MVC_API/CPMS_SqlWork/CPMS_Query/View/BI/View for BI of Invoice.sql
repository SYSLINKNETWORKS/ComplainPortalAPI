

use zsons
go
create view v_bi_inv
as
select 
minv_id,minv_dat,minv_amt,minv_act,t_mdc.mdc_id,mdc_dat
from t_minv
inner join t_mdc on
t_minv.minv_id=t_mdc.mdc_id



