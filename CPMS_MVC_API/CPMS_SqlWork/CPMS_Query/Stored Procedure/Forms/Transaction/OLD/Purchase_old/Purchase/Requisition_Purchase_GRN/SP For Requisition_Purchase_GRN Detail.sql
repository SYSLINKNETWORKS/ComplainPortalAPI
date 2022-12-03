USE PAGEY
GO

--Insert
alter proc ins_t_dpur(@pur_id int,@dpur_stdsiz float,@dpur_qty float,@dpur_mandat bit,@dpur_man datetime,@ck_dat bit,@dpur_exp datetime,@titm_id int,@itmqty_id int,@sca_id int,
@dpur_rat float,@dpur_amt float,@dpur_rmk varchar(250),@m_yr_id char(2),@titm_img bit,@dpur_acc float,@dpur_nqty float,@dpur_bat varchar(100)
)
as
declare
@mpr_id int,
@mpo_id int
begin

    set @mpo_id=(select mpo_id from t_mgrn where mgrn_id=@pur_id )
	set @mpr_id=(select mpr_id from t_mpo where mpo_id=@mpo_id )

	--Detail Requisition
	exec ins_t_dpr @dpur_stdsiz,@dpur_qty,@dpur_mandat,@dpur_man,@ck_dat,@dpur_exp,@mpr_id,@titm_id,@itmqty_id,@sca_id

	--Detail Purcahse Order
	exec ins_t_dpo @dpur_mandat,@dpur_man,@ck_dat,@dpur_exp,@dpur_stdsiz,@dpur_qty,@dpur_rat,@dpur_amt,@dpur_rmk,@titm_id,@itmqty_id,@sca_id,@titm_img,@mpo_id,@m_yr_id

	--Detail GRN
	exec ins_t_dgrn @dpur_mandat,@dpur_man,@ck_dat,@dpur_exp,@dpur_stdsiz,@dpur_qty,@dpur_acc,@dpur_nqty,@dpur_rat,@dpur_amt,@pur_id,@mpo_id,@titm_id,@itmqty_id,@sca_id,@m_yr_id,@dpur_bat 
																													

end

go
--Delete
alter  proc del_t_dpur(@pur_id int)
as
declare
@mpr_id int,
@mpo_id int
begin
    set @mpo_id=(select mpo_id from t_mgrn where mgrn_id=@pur_id )
	set @mpr_id=(select mpr_id from t_mpo where mpo_id=@mpo_id )

		--Detail Requisition
		exec del_t_dpr @mpr_id 

		--Detail Purcahse Order
		exec del_t_dpo @mpo_id 

		--Detail GRN
		exec del_t_dgrn @pur_id 
end
