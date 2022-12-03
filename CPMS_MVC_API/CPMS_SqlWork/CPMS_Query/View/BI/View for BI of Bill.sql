use zsons
go
create view v_bi_bill
as
select 
mpb_sno,mpb_id,mpb_dat,mpb_amt,mgrn_id,mpb_st
from t_mpb
where mpb_st=0

