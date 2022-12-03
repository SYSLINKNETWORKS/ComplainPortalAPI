use zsons
go
create view v_bi_grn1
as
select mgrn_sno,t_mpo.mpo_id,mgrn_id,mpo_sno,mpo_dat,mgrn_amt,mgrn_act,mgrn_dat
from t_mgrn 
inner join t_mpo on
t_mgrn.mpo_id=t_mpo.mpo_id
where mgrn_act=0 

