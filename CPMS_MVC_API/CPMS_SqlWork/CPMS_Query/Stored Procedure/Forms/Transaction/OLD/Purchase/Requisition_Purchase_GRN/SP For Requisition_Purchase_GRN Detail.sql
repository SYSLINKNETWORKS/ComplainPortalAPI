USE MEIJI_RUSK
GO

--Insert
alter proc ins_t_dpur(@com_id char(2),@br_id char(3),@pur_id int,@dpur_stdsiz float,@dpur_qty float,@dpur_mandat bit,@dpur_man datetime,@ck_dat bit,@dpur_exp datetime,@titm_id int,@itmqty_id int,@sca_id int,
@dpur_rat float,@dpur_amt float,@dpur_namt float,@dpur_rmk varchar(250),@m_yr_id char(2),@titm_img bit,@dpur_acc float,@dpur_nqty float,@dpur_bat varchar(100),@dpur_appqty float,@dpur_disper float,@dpur_disamt float,@dpur_oth float,
@coun_id int,@man_id int,@row_id int,@dpur_dat datetime,@usr_id int)
as
declare
@mpr_id int,
@mpo_id int,
@mgrn_id int,
@mqc_id int,
@mpb_id int
begin

    set @mqc_id=(select mqc_id from t_mqc where mgrn_id=@pur_id)
	set @mgrn_id=(select mgrn_id from t_mpb where mpb_id=@pur_id)
	set @mpo_id=(select mpo_id from t_mgrn where mgrn_id=@mgrn_id )
	set @mpr_id=(select mpr_id from t_mpo where mpo_id=@mpo_id )
    
    if(@sca_id=0)
    begin 
    set @sca_id=null
    end
    if(@coun_id=0)
    begin 
    set @coun_id=null
    end
    if(@man_id=0)
    begin 
    set @man_id=null
    end

	--Detail Requisition
	exec ins_t_dpr @dpur_stdsiz,@dpur_qty,@dpur_mandat,@dpur_man,@ck_dat,@dpur_exp,@mpr_id,@titm_id,@itmqty_id,@sca_id,@dpur_appqty
	--Detail Purcahse Order
	
	exec ins_t_dpo @dpur_mandat,@dpur_man,@ck_dat,@dpur_exp,@dpur_stdsiz,@dpur_qty,@dpur_rat,@dpur_amt,@dpur_rmk,@titm_id,@itmqty_id,@sca_id,@titm_img,@mpo_id,@m_yr_id,@dpur_appqty
	--Detail GRN
	exec ins_t_dgrn @dpur_mandat,@dpur_man,@ck_dat,@dpur_exp,@dpur_stdsiz,@dpur_qty,@dpur_acc,@dpur_nqty,@mgrn_id,@mpo_id,@titm_id,@itmqty_id,@sca_id,@m_yr_id,@dpur_bat,@coun_id,@man_id,@dpur_appqty,@dpur_rmk 
	
	--Detail QC
	exec ins_t_dqc @dpur_mandat,@dpur_man,@ck_dat,@dpur_exp,@dpur_stdsiz,@dpur_qty,@dpur_qty,@mqc_id,@mgrn_id,@titm_id,@itmqty_id,@sca_id,@m_yr_id,@dpur_bat,1,@dpur_rmk,@coun_id,@man_id,@dpur_appqty,0,@dpur_dat
	
	--Detail Bill
	exec ins_t_dpb @com_id,@br_id,0,@dpur_stdsiz,@dpur_qty,@dpur_acc,@dpur_nqty,@dpur_rat,@dpur_amt,@dpur_disper,@dpur_disamt,@dpur_oth,0,0,0,0,0,@dpur_namt,@mqc_id,@pur_id,@titm_id,@itmqty_id,@sca_id,@m_yr_id,@row_id,'','',@usr_id,'',@dpur_bat,@dpur_man,@dpur_exp 
	
	--BILL GRN
	exec ins_t_dpb_grn @pur_id,@mqc_id,@m_yr_id 
end

go
--Delete
alter  proc del_t_dpur(@pur_id int)
as
declare
@mpr_id int,
@mpo_id int,
@mgrn_id int,
@mqc_id int,
@mpb_id int
begin
    set @mqc_id=(select mqc_id from t_mqc where mgrn_id=@pur_id)
	set @mgrn_id=(select mgrn_id from t_mpb where mpb_id=@pur_id)
	set @mpo_id=(select mpo_id from t_mgrn where mgrn_id=@mgrn_id )
	set @mpr_id=(select mpr_id from t_mpo where mpo_id=@mpo_id )


		--Detail Requisition
		exec del_t_dpr @mpr_id 

		--Detail Purcahse Order
		exec del_t_dpo @mpo_id 

		--Detail GRN
		exec del_t_dgrn @mgrn_id 
		
		--Detail QC
		exec del_t_dqc @pur_id 
		
		--Detail BIll
		exec del_t_dpb @pur_id 
end
