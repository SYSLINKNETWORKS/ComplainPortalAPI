USE phm
GO
--select * from t_mdn
--select * from t_ddn
--select * from t_dpb where mpb_id=3

--exec ins_pb_det 40,12,12000,1,1,1,'03'

--alter table t_ddn add mgrn_id int
--alter table t_ddn add constraint FK_DDN_MGRNID foreign key (mgrn_id) references t_mgrn(mgrn_id)
--alter table t_ddn add ddn_gstper float,ddn_gstamt float,ddn_fedper float,ddn_fedamt float,ddn_namt as ddn_amt+ddn_gstamt+ddn_fedamt

--update t_ddn set ddn_gstper=0,ddn_gstamt=0,ddn_fedper=0,ddn_fedamt=0
--ALTER table t_ddn add ddn_disper float,ddn_disamt float,ddn_othamt float
--update t_ddn set ddn_disper=0,ddn_disamt=0,ddn_othamt=0


--Insert
alter proc ins_t_ddn(@com_id char(2),@br_id char(3),@m_yr_id char(2),@ck_dat bit,@ddn_exp datetime,@ddn_qty float,@ddn_acc float,@ddn_nqty float,@ddn_rat float,@ddn_disper float,@ddn_disamt float,@ddn_othamt float,@ddn_amt float,@ddn_gstper float,@ddn_gstamt float,@ddn_fedper float,@ddn_fedamt float,@mdn_id int,@titm_id int,@row_id int,@mgrn_id int,@log_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@log_ip char(100))
as
declare
@ddn_id int,
@mpb_id int,
@stk_dat datetime,
@wh_id int,
@bd_id int,
@cur_id int,
@mdn_rat float,
@ddn_trat float,
@ddn_tamt float,
@dpay_amt float,
@dpb_amt float
begin
	if (@ck_dat=1)
		begin
			set @ddn_exp=null
		end
	set @cur_id=(select cur_id from t_mdn where  mdn_id=@mdn_id)
	set @mdn_rat=(select mdn_rat from t_mdn where mdn_id=@mdn_id)
	set @ddn_trat=@mdn_rat*@ddn_rat
	set @ddn_tamt=@ddn_amt*@mdn_rat
	set @wh_id=(select wh_id from t_mdn where mdn_id=@mdn_id)
	set @bd_id=(select bd_id from t_itm where titm_id=@titm_id)
	set @ddn_id=(select max(ddn_id)+1 from t_ddn)
	set @mpb_id=(select mpb_id from t_mdn where mdn_id=@mdn_id)
		if @ddn_id is null
			begin
				set @ddn_id=1
			end
	insert into t_ddn(ddn_id,ddn_qty,ddn_acc,ddn_nqty,ddn_rat,ddn_trat,ddn_disper,ddn_disamt,ddn_othamt,ddn_amt,ddn_gstper,ddn_gstamt,ddn_fedper,ddn_fedamt,ddn_tamt,mdn_id,titm_id,m_yr_id,mgrn_id)
			values(@ddn_id,@ddn_qty,@ddn_acc,@ddn_nqty,@ddn_rat,@ddn_trat,@ddn_disper,@ddn_disamt,@ddn_othamt,@ddn_amt,@ddn_gstper,@ddn_gstamt,@ddn_fedper,@ddn_fedamt,@ddn_tamt,@mdn_id,@titm_id,@m_yr_id,@mgrn_id)



	--Stock
	set @stk_dat=(select mdn_dat from t_mdn where mdn_id=@mdn_id)
	insert into m_stk(com_id,br_id,t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat) values(@com_id,@br_id,@mdn_id,@titm_id,-@ddn_qty,@ddn_acc,@ddn_rat,'S','I','DebitNote',@stk_dat,@wh_id,@bd_id,@m_yr_id,@ddn_exp,@cur_id,@mdn_rat)



set @dpb_amt=(select isnull(sum(dpb_namt),0) from t_dpb where mpb_id=@mpb_id)
set @dpay_amt=(select isnull(sum(dpay_amt),0) from t_dpay where mpb_id=@mpb_id)
set @dpay_amt=@dpay_amt+(select isnull(sum(ddn_namt),0) from t_mdn inner join t_ddn on t_mdn.mdn_id=t_ddn.mdn_id where mpb_id=@mpb_id)
	if (@dpb_amt=@dpay_amt)
		begin
			update t_dpb set dpb_st=1 where mpb_id=@mpb_id
			update t_mpb set mpb_st=1 where mpb_id=@mpb_id
		end

	--Voucher
	if (@row_id=1)
		begin
			set @aud_des='Voucher against Debit Note # '+rtrim(cast(@mdn_id as char(1000)))
			exec sp_voucher_dn @com_id,@br_id,@m_yr_id,@mdn_id,@usr_id,@log_ip,@aud_des
		end
	
end
		
go

--Delete
alter  proc del_t_ddn(@mdn_id int,@m_yr_id char(2))
as
declare
@mpb_id int
begin

	set @mpb_id=(select mpb_id from t_mdn where mdn_id=@mdn_id)
	delete m_stk  where t_id=@mdn_id and stk_frm='DebitNote' and m_yr_id=@m_yr_id
	update t_dpb set dpb_st=0 where mpb_id=@mpb_id
	update t_mpb set mpb_st=0 where mpb_id=@mpb_id
			
	delete t_ddn where mdn_id=@mdn_id
	
end



go
