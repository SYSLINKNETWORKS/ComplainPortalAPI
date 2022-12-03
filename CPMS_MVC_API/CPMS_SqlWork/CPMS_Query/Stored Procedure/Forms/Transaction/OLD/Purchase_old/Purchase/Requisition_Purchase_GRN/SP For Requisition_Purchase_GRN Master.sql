USE PAGEY 
GO



--Insert
alter proc ins_t_mpur(@com_id char(2),@br_id char(3),@m_yr_id char(2),@pur_dat datetime,@pur_typ char(1),@dpt_id char(2),@mso_id int, 
@pur_act bit,
@pur_rat float,@pur_amt float,@pur_rmk varchar(1000),@sup_id int,@cur_id int,
@pur_nw float,@sca_id int,@sup_dc varchar(100),@sup_dcdat datetime,@pur_idold varchar(1000),
@wh_id int,@pur_kepz varchar(100),
@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@lc_nam varchar(250),@pur_purtyp char(2),
@pur_id_out int output
)
as
declare
@mpr_id int,
@mpo_id int,
@mgrn_id int
begin
	--Requisition
	exec ins_t_mpr @com_id,@br_id,@pur_dat,@pur_typ,@pur_act,@dpt_id,@mso_id,@m_yr_id,@aud_frmnam,@aud_des,@usr_id,@aud_ip,@mpr_id_out=@mpr_id output

	--Purcahse Order
	exec ins_t_mpo @com_id,@br_id,@pur_dat,@pur_dat,@pur_typ,@pur_rat,@pur_amt,@m_yr_id,@pur_act,@pur_rmk,@mpr_id,@cur_id,@sup_id,@lc_nam,@pur_purtyp,@aud_frmnam,@aud_des,@usr_id,@aud_ip,@mpo_id_out=@mpo_id output

	--GRN
	exec ins_t_mgrn @com_id,@br_id,@m_yr_id,@pur_dat,@pur_typ,@pur_nw,@sca_id,@pur_act,@sup_dc,@sup_dcdat,@pur_kepz,@pur_rmk,@pur_rat,@pur_amt,@mpo_id,@wh_id,@pur_idold,@aud_frmnam,@aud_des,@usr_id,@aud_ip,@mgrn_id_out=@mgrn_id output
	
	set @pur_id_out =@mgrn_id
end
go


--Update
alter proc upd_t_mpur(@com_id char(2),@br_id char(3),@m_yr_id char(2),@pur_id int,@pur_dat datetime,@pur_typ char(1),@dpt_id char(2),@mso_id int, 
@pur_act bit,
@pur_rat float,@pur_amt float,@pur_rmk varchar(1000),@sup_id int,@cur_id int,
@pur_nw float,@sca_id int,@sup_dc varchar(100),@sup_dcdat datetime,@pur_idold varchar(1000),
@wh_id int,@pur_kepz varchar(100),
@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@lc_nam varchar(250),@pur_purtyp char(2))
as
declare
@mpr_id int,
@mpo_id int
begin

	set @mpo_id=(select mpo_id from t_mgrn where mgrn_id=@pur_id )
	set @mpr_id=(select mpr_id from t_mpo where mpo_id=@mpo_id )

	--Requisition
	Exec upd_t_mpr @com_id,@br_id,@mpr_id,@dpt_id,@pur_dat,@pur_act,@mso_id,@pur_typ,@m_yr_id,@aud_frmnam,@aud_des,@usr_id,@aud_ip

	--Purchase Order
	Exec upd_t_mpo @com_id,@br_id,@m_yr_id,@mpo_id,@pur_dat,@pur_dat,@pur_rat,@pur_amt,@pur_rmk,@sup_id,@cur_id,@pur_act,@aud_frmnam,@aud_des,@usr_id,@aud_ip,@lc_nam,@pur_purtyp

	--GRN
	Exec upd_t_mgrn @com_id,@br_id,@m_yr_id,@pur_act,@pur_id,@pur_dat,@sup_dc,@sup_dcdat,@pur_kepz,@pur_rmk,@pur_rat,@pur_amt,@wh_id,@pur_nw,@sca_id,@aud_frmnam,@aud_des,@usr_id,@aud_ip
end

go

--Delete
alter proc del_t_mpur(@com_id char(2),@br_id char(3),@m_yr_id char(2),@pur_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@mpr_id int,
@mpo_id int
begin
	set @mpo_id=(select mpo_id from t_mgrn where mgrn_id=@pur_id )
	set @mpr_id=(select mpr_id from t_mpo where mpo_id=@mpo_id )

	--Requisition
	exec del_t_mpr @com_id,@br_id,@m_yr_id,@pur_id,@aud_frmnam,@aud_des,@usr_id,@aud_ip

	--Purchase Order
	exec del_t_mpo @com_id,@br_id,@pur_id,@m_yr_id,@aud_frmnam,@aud_des,@usr_id,@aud_ip

	--GRN
	exec del_t_mgrn @com_id,@br_id,@m_yr_id,@pur_id,@aud_frmnam,@aud_des,@usr_id,@aud_ip
end

