use NTHA
go

alter proc ins_t_dpos(@dso_stdsiz float,@dso_qty float,@dso_appqty float,@dso_rat float,@dso_amt float,@dso_disper float,@dso_disamt float,@dso_othamt float,@dso_namt float,@titm_id int,@itmqty_id int,@mso_id int,@sca_id int,@dso_act bit,@dso_bqty float,@dso_schper float,@dso_schamt float,@dso_titm_id_free int,@dso_freeqty float,@dso_bat varchar(100),@dso_mandat datetime,@dso_expdat datetime)
as

begin

exec ins_t_dso @dso_stdsiz,@dso_qty,@dso_appqty,@dso_rat,@dso_amt,@dso_disper,@dso_disamt,@dso_othamt,@dso_namt,@titm_id,@itmqty_id,@mso_id,@sca_id,@dso_act,@dso_bqty,@dso_schper,@dso_schamt,@dso_titm_id_free,@dso_freeqty,@dso_bat,@dso_mandat,@dso_expdat

end
go

alter proc del_t_dpos(@dso_stdsiz float,@dso_qty float,@dso_appqty float,@dso_rat float,@dso_amt float,@dso_disper float,@dso_disamt float,@dso_othamt float,@dso_namt float,@titm_id int,@itmqty_id int,@mso_id int,@sca_id int,@dso_act bit,@dso_bqty float,@dso_schper float,@dso_schamt float,@dso_titm_id_free int,@dso_freeqty float,@dso_bat varchar(100),@dso_mandat datetime,@dso_expdat datetime)
as

begin

exec del_t_dso @mso_id

end
go