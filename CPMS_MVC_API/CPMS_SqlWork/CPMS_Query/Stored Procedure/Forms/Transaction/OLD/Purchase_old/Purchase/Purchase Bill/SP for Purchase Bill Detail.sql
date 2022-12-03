use phm
go

--alter table t_dpb add dpb_othamt float,dpb_tothamt float

--update t_dpb set dpb_othamt=0,dpb_tothamt=0 where dpb_othamt is null

--select * from t_dpb
--alter table t_dpb add dpb_gstper float,dpb_gstamt float,dpb_fedper float,dpb_fedamt float
--update t_dpb set dpb_gstper=0,dpb_gstamt=0,dpb_fedper=0,dpb_fedamt=0
--alter table t_dpb add dpb_eamt float
--update t_dpb set dpb_eamt=dpb_amt-dpb_disamt-dpb_othamt 
--alter table t_dpb add dpb_tax bit
--update t_dpb set dpb_tax=0
--update t_dpb set dpb_tax=1 where mpb_id in (select mpb_id from t_mpb where mpb_cktax=1)

--alter table t_dpb add mgrn_id int
--alter table t_dpb add constraint FK_TDPB_MGRNID foreign key (mgrn_id) references t_mgrn(mgrn_id)

--alter table t_mgrn add mgrn_cktax bit default 0
--update t_mgrn set mgrn_cktax =0

--alter table t_dgrn add dgrn_tax bit default 0
--update t_dgrn set dgrn_tax =0

--alter table t_mpo add mpo_cktax bit default 0
--update t_mpo set mpo_cktax=0

--alter table t_dpo add dpo_tax bit default 0
--update t_dpo set dpo_tax =0

--alter table t_dpb add itmqty_id int,sca_id int,dpb_stdsiz float
--ALTER table t_dpb add constraint FK_Tdpb_itmqtyid foreign key (itmqty_id) references m_itmqty(itmqty_id)
--ALTER table t_dpb add constraint FK_Tdpb_scaid foreign key (sca_id) references m_sca(sca_id)
--alter table t_dpb add dpb_bat varchar(100)
--alter table t_dpb add dpb_mandat datetime
--alter table t_dpb add dpb_expdat datetime

--Insert
alter proc ins_t_dpb(@com_id char(2),@br_id char(3),@dpb_tax bit,@dpb_stdsiz float,@dpb_qty float,@dpb_acc float,@dpb_nqty float,@dpb_rat float,@dpb_amt float,@dpb_disper float,@dpb_disamt float,@dpb_othamt float,@dpb_eamt float,@dpb_gstper float,@dpb_gstamt float,@dpb_fedper float,@dpb_fedamt float,@dpb_namt float,@mgrn_id int,@mpb_id int,@titm_id int,@itmqty_id int,@sca_id int,@m_yr_id char(2),@row_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@dpb_bat varchar(100),@dpb_mandat datetime,@dpb_expdat datetime)
as
declare
@dpb_id int,
@grn_no varchar(100),
@mpb_rat float,
@dpb_tamt float,
@dpb_tdisamt float,
@dpb_tothamt float,
@dpb_ntamt float,
@t_id int,
@mpb_can bit,
@mpb_cktax bit,
@sca_met float,
@itm_cat char(1)
begin

	set @sca_met=(select case sca_met when 0 then 1 else sca_met end as [sca_met] from m_sca where sca_id=@sca_id)
	set @itm_cat=(select itm_cat from v_titm where titm_id=@titm_id)
	if (@sca_id=0)
		begin
			set @sca_id=null
		end
	if (@dpb_stdsiz =0)
		begin
			set @dpb_stdsiz =null
		end
	set @dpb_id=(select max(dpb_id)+1 from t_dpb)
	if (@dpb_id is null)	
		begin
			set @dpb_id=1
		end
		
	set @grn_no=(select mgrn_id from t_mpb where mpb_id=@mpb_id)
	set @mpb_rat=(select mpb_rat from t_mpb where mpb_id=@mpb_id)
	set @dpb_tamt=@dpb_amt*@mpb_rat
	set @dpb_tdisamt=@dpb_disamt*@mpb_rat
	set @dpb_tothamt=@dpb_othamt*@mpb_rat
	set @dpb_ntamt=@dpb_namt*@mpb_rat
	set @mpb_cktax=(select mpb_cktax from t_mpb where mpb_id=@mpb_id)
	if (@dpb_tax=0)
		begin
			set @dpb_gstper=0
			set @dpb_gstamt =0
			set @dpb_fedper=0
			set @dpb_fedamt=0
		end
	else if (@dpb_tax=1)
		begin
			update t_mgrn set mgrn_cktax=1 where mgrn_id=@mgrn_id
			update t_dgrn set dgrn_tax=1 where mgrn_id=@mgrn_id and titm_id=@titm_id
			update t_mpo set mpo_cktax=1 where mpo_id=(select mpo_id from t_mgrn where mgrn_id=@mgrn_id)
			update t_dpo set dpo_tax=1 where mpo_id=(select mpo_id from t_mgrn where mgrn_id=@mgrn_id) and titm_id=@titm_id
		end
		
	if (@itm_cat<>'F')
		begin
			set @itmqty_id =null
			set @dpb_stdsiz =0
		end

			insert into t_dpb(dpb_id,dpb_tax,dpb_stdsiz,dpb_qty,dpb_acc,dpb_nqty,dpb_rat,dpb_amt,dpb_disper,dpb_disamt,dpb_othamt,dpb_eamt,dpb_gstper,dpb_gstamt,dpb_fedper,dpb_fedamt,dpb_namt,dpb_tamt,dpb_tdisamt,dpb_tothamt,dpb_ntamt,mgrn_id,mpb_id,titm_id,itmqty_id,sca_id,m_yr_id,dpb_bat,dpb_mandat,dpb_expdat)
			values(@dpb_id,@dpb_tax,@dpb_stdsiz,@dpb_qty,@dpb_acc,@dpb_nqty,@dpb_rat,@dpb_amt,@dpb_disper,@dpb_disamt,@dpb_othamt,@dpb_eamt,@dpb_gstper,@dpb_gstamt,@dpb_fedper,@dpb_fedamt,@dpb_namt,@dpb_tamt,@dpb_tdisamt,@dpb_tothamt,@dpb_ntamt,@mgrn_id,@mpb_id,@titm_id,@itmqty_id,@sca_id,@m_yr_id,@dpb_bat,@dpb_mandat,@dpb_expdat)



	
	--Voucher
	if (@row_id =1)
		begin	
			set @aud_des='Voucher Against Bill# '+rtrim(cast(@mpb_id as char(1000)))
			exec sp_voucher_pb @com_id,@br_id,@m_yr_id,@mpb_id,@usr_id,@aud_ip,@aud_des 
		end
end
		
go

--Delete
alter proc del_t_dpb(@mpb_id int)
as
begin
	update t_mpo set mpo_cktax =0 where mpo_id in (select t_mgrn.mpo_id from t_mgrn inner join t_mpo on t_mgrn.mpo_id=t_mpo.mpo_id inner join t_dpb on t_mgrn.mgrn_id=t_dpb.mgrn_id where mpb_id=@mpb_id)
	update t_dpo set dpo_tax=0 where mpo_id in (select t_mgrn.mpo_id from t_mgrn inner join t_mpo on t_mgrn.mpo_id=t_mpo.mpo_id inner join t_dpb on t_mgrn.mgrn_id=t_dpb.mgrn_id and t_dpo.titm_id=t_dpb.titm_id where mpb_id=@mpb_id) and titm_id in (select titm_id from t_dpb where mpb_id=@mpb_id)
	
	update t_mgrn set mgrn_cktax =0 where mgrn_id in (select mgrn_id from t_dpb where mpb_id=@mpb_id)
	update t_dgrn set dgrn_tax=0 where mgrn_id in (select mgrn_id from t_dpb where mpb_id=@mpb_id) and titm_id in (select titm_id from t_dpb where mpb_id=@mpb_id)
	exec del_t_dpb_grn @mpb_id
	delete from t_dpb where mpb_id=@mpb_id
end
