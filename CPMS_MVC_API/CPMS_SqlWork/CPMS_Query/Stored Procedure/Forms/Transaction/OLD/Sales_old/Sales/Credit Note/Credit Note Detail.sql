USE ZSONS
GO

--alter table t_dcn add mdc_id int 
--alter table t_dcn add constraint FK_DCN_MDCID foreign key (mdc_id) references t_mdc(mdc_id)
--alter table t_dcn add dcn_stdsiz float,sca_id int
--alter table t_dcn add constraint FK_dcn_SCAID foreign key (sca_id) references m_Sca(sca_id)
--update t_dcn set dcn_stdsiz=(select master_titm_qty from t_itm where t_itm.titm_id=t_dcn.titm_id),sca_id=(select inner_sca_id from t_itm where t_itm.titm_id=t_dcn.titm_id)
--alter table t_dcn add dcn_gstper float,dcn_gstamt float,dcn_fedper float,dcn_fedamt float

--Insert
alter proc ins_t_dcn(@dcn_qty float,@titm_id int,@itmqty_id int,@dcn_stdsiz float,@dcn_rat float,@dcn_amt float,@dcn_disper float,@dcn_disamt float,@dcn_gstper float,@dcn_gstamt float,@dcn_fedper float,@dcn_fedamt float,@dcn_namt float,@mcn_id int,@mdc_id int,@sca_id int,@row_id int)
as
declare
@com_id char(2),
@br_id char(3),
@m_yR_id char(2),
@dcn_id int,
@inv_qty float,
@cn_qty float,
@qty float,
@stk_dat datetime,
@wh_id int,
@stk_dat_old datetime,
@stk_rat float,
@stk_qty float,
@stk_amt float,
@minv_no int,
@mcn_no int,
@cur_id int,
@cur_rat float,
@cus_nam varchar(250),
@stk_des varchar(250)
begin

	set @mcn_no=(select mcn_no from t_mcn where mcn_id=@mcn_id)
	set @cur_id=(select cur_id from t_mcn where mcn_id=@mcn_id)
	set @cur_rat=(select mcn_currat from t_mcn where mcn_id=@mcn_id)
	set @wh_id=(select wh_id from t_mcn where mcn_id=@mcn_id)	
	set @com_id=(select com_id from t_mcn where mcn_id=@mcn_id)
	set @br_id=(select br_id from t_mcn where mcn_id=@mcn_id)
	set @m_yr_id=(select m_yr_id from t_mcn where mcn_id=@mcn_id)
	set @stk_dat=(select mcn_dat from t_mcn where mcn_id=@mcn_id)
	set @minv_no=(select minv_no from t_minv inner join t_mcn on t_minv.minv_id=t_mcn.minv_id where mcn_id=@mcn_id)
	set @cus_nam=(select cus_nam from t_mcn inner join m_cus on t_mcn.com_id=m_cus.com_id and t_mcn.cus_id=m_cus.cus_id where mcn_id=@mcn_id)
	
	set @dcn_id=(select max(dcn_id)+1 from t_dcn)
		if @dcn_id is null
			begin
				set @dcn_id=1
			end
	insert into t_dcn(dcn_id,dcn_qty,dcn_rat,dcn_amt,dcn_disper,dcn_disamt,dcn_gstper,dcn_gstamt,dcn_fedper,dcn_fedamt,dcn_namt,mcn_id,titm_id,itmqty_id,mdc_id,dcn_stdsiz,sca_id)
			values(@dcn_id,@dcn_qty,@dcn_rat,@dcn_amt,@dcn_disper,@dcn_disamt,@dcn_gstper,@dcn_gstamt,@dcn_fedper,@dcn_fedamt,@dcn_namt,@mcn_id,@titm_id,@itmqty_id,@mdc_id,@dcn_stdsiz,@sca_id)

		set @stk_dat_old =DATEADD(DAY,-1,@stk_dat)
		set @stk_rat=0

		set @stk_qty=(isnull((select round(sum(stk_qty),4) from m_stk where stk_dat<=@stk_dat_old and itm_id=@titm_id and m_yr_id=@m_yr_id),0))
		set @stk_qty=@stk_qty+(isnull((select round(sum(stk_qty),4) from m_stk where stk_frm in ('t_itm','GRN','TransFG') and stk_dat=@stk_dat and itm_id=@titm_id and m_yr_id=@m_yr_id),0))
		set @stk_amt=(isnull((select round(sum(stk_amt),4) from m_stk where stk_dat<=@stk_dat_old and itm_id=@titm_id and m_yr_id=@m_yr_id),0))
		set @stk_amt=@stk_amt+(isnull((select round(sum(stk_amt),4) from m_stk where stk_frm in ('t_itm','GRN','TransFG') and stk_dat=@stk_dat and itm_id=@titm_id and m_yr_id=@m_yr_id),0))
		if (@stk_qty<>0)
			begin
				set @stk_rat=round(@stk_amt/@stk_qty,4)
			end
		else
			begin
				set @stk_rat=0
			end

			--Stock	
			set @stk_des='CN# ' +rtrim(cast(@mcn_no as varchar(100))) + ' Invoice # '+rtrim(cast(@minv_no as varchar(100)))+ ' Customer: ' +@cus_nam	
			insert into m_stk(com_id,br_id,t_id,itm_id,itmqty_id,stk_stdsiz,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,bd_id,m_yr_id,titm_maf,titm_exp,stk_bat,mso_id,cur_id,stk_currat,stk_des) 
				values(@com_id,@br_id,@mcn_id,@titm_id,@itmqty_id,@dcn_stdsiz,@dcn_qty,@stk_rat,'S','R','CN',@stk_dat,@wh_id,null,@m_yr_id,null,null,null,null,@cur_id,@cur_rat,@stk_des)
			
	--Voucher
	if (@row_id>0)
		begin
			exec sp_voucher_cn @mcn_id 
		end

end

go
--Delete
alter proc del_t_dcn(@mcn_id int)
as
begin
	delete from m_stk where t_id=@mcn_id and stk_frm='CN'
	delete from t_dcn where mcn_id=@mcn_id
end
