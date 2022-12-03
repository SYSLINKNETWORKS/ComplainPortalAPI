USE MEIJI_RUSK
GO



--Insert
alter proc ins_t_mpur(@com_id char(2),@br_id char(3),@m_yr_id char(2),@pur_dat datetime,@pur_typ char(1),@dpt_id char(2),@mso_id int, 
@pur_act bit,
@pur_rat float,@pur_amt float,@pur_tamt float,@pur_rmk varchar(1000),@sup_id int,@cur_id int,
@pur_nw float,@sca_id int,@sup_dc varchar(100),@sup_dcdat datetime,@pur_idold varchar(1000),
@wh_id int,@pur_kepz varchar(100),@emppro_macid int,@pur_auth bit,@pur_credays float,@ind_id int,
@usr_id int,@lc_nam varchar(250),@pur_purtyp char(2),@pur_disper float,@pur_disamt float,@pur_freamt float,@pur_frecon char(1),@pur_othamt float,@pur_desamt float,
@pur_id_out int output
)
as
declare
@mpr_id int,
@mpo_id int,
@mgrn_id int,
@mqc_id int,
@mpb_id int
begin
		
		if(@sca_id=0)
		begin
		set @sca_id=null
		end
		if(@emppro_macid=0)
		begin
		set @emppro_macid=null
		end

	--Requisition
	exec ins_t_mpr @pur_dat,@pur_typ,@pur_act,@dpt_id,@mso_id,@m_yr_id,@pur_dat,@pur_rmk,'A',@usr_id,'','','','',@emppro_macid,1,@pur_auth,2,@mpr_id_out=@mpr_id output

	--Purcahse Order
	exec ins_t_mpo @com_id,@br_id,@pur_dat,@pur_dat,@pur_credays,@pur_typ,@pur_rat,@pur_amt,@m_yr_id,@pur_act,@pur_rmk,@mpr_id,@cur_id,@sup_id,@lc_nam,@pur_purtyp,@ind_id,1,@pur_auth,'A',@usr_id,'','','','',@mpo_id_out=@mpo_id output

	--GRN
	exec ins_t_mgrn @com_id,@br_id,@m_yr_id,@pur_dat,@pur_typ,@pur_nw,@sca_id,@pur_act,@sup_dc,@sup_dcdat,@pur_kepz,@pur_rmk,@pur_rat,@pur_amt,1,@pur_auth,@mpo_id,@wh_id,@pur_idold,'A',@usr_id,'','','','',@mgrn_id_out=@mgrn_id output
	
	--QC
	exec ins_t_mqc @com_id,@br_id,@m_yr_id,@pur_dat,@pur_typ,@pur_nw,@sca_id,@pur_act,1,1,@sup_dc,@sup_dcdat,@pur_kepz,@pur_rmk,@pur_rat,@pur_amt,@mgrn_id,@wh_id,@pur_idold,@emppro_macid,'A',@usr_id,'','','','',@mqc_id_out=@mqc_id output
	
	
	--Bill
	exec ins_t_mpb @com_id,@br_id,@m_yr_id,@pur_dat,@pur_typ,@mgrn_id,@pur_rat,@cur_id,@sup_id,@pur_rmk,@sup_dc,@sup_dcdat,0,0,0,0,@pur_amt,0,@pur_disper,@pur_disamt,0,0,0,0,@pur_desamt,@pur_othamt,@pur_tamt,0,@pur_freamt,'',0,@pur_auth,@pur_frecon,'A',@usr_id,'','','','','',@mpb_id_out=@mpb_id output	
	--exec ins_t_mpb @com_id,@br_id,@m_yr_id,@pur_dat,@pur_typ ,mgrn_id,@pur_rat ,@cur_id ,@sup_id ,@pur_rmk ,'',@pur_dat,0,0,0,0,@pur_amt,0,@pur_disper,@pur_disamt,0,0,0,0,@pur_desamt,@pur_othamt,@pur_tamt,0,@pur_freamt,'',0,1,@pur_auth,'A',@usr_id,'','','','','',@mpb_id_out=@mpb_id output 
	
	set @pur_id_out =@mpb_id
end
go


--Update
alter proc upd_t_mpur(@com_id char(2),@br_id char(3),@m_yr_id char(2),@pur_id int,@pur_dat datetime,@pur_typ char(1),@dpt_id char(2),@mso_id int, 
@pur_act bit,
@pur_rat float,@pur_amt float,@pur_tamt float,@pur_rmk varchar(1000),@sup_id int,@cur_id int,
@pur_nw float,@sca_id int,@sup_dc varchar(100),@sup_dcdat datetime,@pur_idold varchar(1000),
@wh_id int,@pur_kepz varchar(100),@emppro_macid int,@pur_auth bit,@pur_credays float,@ind_id int,
@usr_id int,@lc_nam varchar(250),@pur_purtyp char(2),@pur_disper float,@pur_disamt float,@pur_freamt float,@pur_frecon char(1),@pur_othamt float,@pur_desamt float)
as
declare
@mpr_id int,
@mpo_id int,
@mgrn_id int,
@mqc_id int
begin
   set @mqc_id=(select mqc_id from t_mqc where mgrn_id=@pur_id)
	set @mgrn_id=(select mgrn_id from t_mpb where mpb_id=@pur_id)
	set @mpo_id=(select mpo_id from t_mgrn where mgrn_id=@mgrn_id )
	set @mpr_id=(select mpr_id from t_mpo where mpo_id=@mpo_id )
	
   if(@sca_id=0)
		begin
		set @sca_id=null
		end
		if(@emppro_macid=0)
		begin
		set @emppro_macid=null
		end
	--Requisition
	Exec upd_t_mpr @mpr_id,@dpt_id,@pur_dat,@pur_act,@mso_id,@pur_typ,@m_yr_id,@pur_dat,@pur_rmk,'A',@usr_id,'','','','',@emppro_macid,1,@pur_auth,2
   
	--Purchase Order
	Exec upd_t_mpo @m_yr_id,@mpo_id,@pur_dat,@pur_dat,@pur_credays,@pur_rat,@pur_amt,@pur_rmk,@sup_id,@cur_id,@pur_act,'A',@usr_id,'','','','',@lc_nam,@pur_purtyp,@ind_id,1,@pur_auth

	--GRN
	Exec upd_t_mgrn @m_yr_id,@pur_act,@mgrn_id,@pur_dat,@sup_dc,@sup_dcdat,@pur_kepz,@pur_rmk,@pur_rat,@pur_amt,@wh_id,@pur_nw,@sca_id,1,@pur_auth,'A',@usr_id,'','','',''
	
	--QC
	Exec upd_t_mqc @m_yr_id,@pur_act,@mqc_id,@pur_dat,@sup_dc,@sup_dcdat,@pur_kepz,@pur_rmk,@pur_rat,@pur_amt,@wh_id,@pur_nw,@sca_id,'A',@usr_id,'','','','',@emppro_macid,1,@pur_auth
	
	--Bill 
	Exec upd_t_mpb @com_id,@br_id,@m_yr_id,@pur_id,@pur_typ,@mqc_id,@cur_id,@pur_rat,@pur_rmk,@sup_dc,@sup_dcdat,0,0,0,0,@pur_amt,0,@pur_disper,@pur_disamt,0,0,0,0,@pur_desamt,@pur_othamt,@pur_tamt,0,@pur_freamt,'',0,@pur_auth,@pur_frecon,'A',@usr_id,'','','','',''
end

go

--Delete
alter proc del_t_mpur(@com_id char(2),@br_id char(3),@m_yr_id char(2),@pur_id int,@usr_id int)
as
declare
@mpr_id int,
@mpo_id int,
@mgrn_id int,
@mqc_id int
begin
    set @mqc_id=(select mqc_id from t_mqc where mgrn_id=@pur_id)
	set @mgrn_id=(select mgrn_id from t_mpb where mpb_id=@pur_id)
	set @mpo_id=(select mpo_id from t_mgrn where mgrn_id=@mgrn_id )
	set @mpr_id=(select mpr_id from t_mpo where mpo_id=@mpo_id )

	--Requisition
	exec del_t_mpr @mpr_id,'D',@usr_id,'','','',''

	--Purchase Order
	exec del_t_mpo @mpo_id,'D',@usr_id,'','','',''

	--GRN
	exec del_t_mgrn @mgrn_id,'D',@usr_id,'','','',''
	
	--QC
	exec del_t_mqc @mqc_id,'D',@usr_id,'','','',''	
	
	--BILL
	exec del_t_mpb @com_id,@br_id,@m_yr_id,@pur_id,'D',@usr_id,'','','',''
end


