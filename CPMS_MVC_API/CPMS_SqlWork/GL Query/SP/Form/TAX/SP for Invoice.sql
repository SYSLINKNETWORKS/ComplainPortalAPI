USE ZSons
GO


--alter table t_minv add minv_taxid int

--alter table t_mpso add mpso_taxid int
--exec sp_upd_taxaccvch '01',8





alter proc sp_upd_taxaccvch(@com_id char(2),@minv_id int)
as
declare
@minv_taxid int
begin

--Master Invoice
--exec zsons_tax.dbo.ins_t_minv @com_id ,@br_id ,@m_yr_id ,@minv_dat,@minv_typ,@dc_no ,@minv_rat ,@cur_id ,@cus_id ,@minv_rmk ,@minv_cktax,@minv_gstamt ,@minv_fedamt ,@minv_amt ,@minv_disamt ,@minv_freamt ,@minv_othamt ,@minv_namt ,@minv_can ,@aud_frmnam ,@aud_des ,@usr_id,@aud_ip ,@minv_id_out =@minv_taxid output,''


--Master Voucher Cursor Open
declare @br_id char(3),@m_yr_id char(2),@mpso_id int,@mpso_dat datetime,@mpso_ddat datetime,@mpso_rmk varchar(250),@mpso_currat float,@mpso_amt float,@mpso_disper float,@mpso_disamt float,@mpso_freamt float,@mpso_othamt float,@mpso_namt float,@mpso_pamt float,@mpso_act bit,@mpso_app bit,
@mpso_ckdel bit,@mpso_delnam varchar(250),@mpso_delpho varchar(250),@mpso_deladd varchar(250),@emppro_macid int,@mpso_can bit,@mpso_typ char(1),@emppro_id int,@cus_id int,@cur_id int,
@mpso_taxid int
	
	--Estimate Master Data
	declare  estimatemasterdata1  cursor for			
			select distinct t_mpso.br_id,t_mpso.m_yr_id,t_mpso.mpso_id,mpso_dat,mpso_ddat,mpso_rmk,mpso_currat,mpso_amt,mpso_disper,mpso_disamt,mpso_freamt,mpso_othamt,mpso_namt,mpso_act ,mpso_can ,mpso_ckdel ,mpso_delnam ,mpso_delpho ,mpso_deladd ,mpso_typ ,emppro_macid ,t_mpso.cus_id  from
			t_mpso 
			left join m_emppro on t_mpso.emppro_id=m_emppro.emppro_id
			inner join t_mso on t_mpso.com_id=t_mso.com_id and t_mpso.mpso_id=t_mso.mpso_id 
			inner join t_mdc on t_mso.com_id=t_mdc.com_id and t_mso.mso_id=t_mdc.mso_id inner join t_dinv on t_mdc.mdc_id=t_dinv.mdc_id
			 where minv_id=8
		OPEN estimatemasterdata1
			FETCH NEXT FROM estimatemasterdata1
			INTO @br_id,@m_yr_id,@mpso_id,@mpso_dat,@mpso_ddat,@mpso_rmk,@mpso_currat,@mpso_amt,@mpso_disper,@mpso_disamt,@mpso_freamt,@mpso_othamt,@mpso_namt,@mpso_act ,@mpso_can ,@mpso_ckdel ,@mpso_delnam ,@mpso_delpho ,@mpso_deladd ,@mpso_typ ,@emppro_macid ,@cus_id 
				WHILE @@FETCH_STATUS = 0
				BEGIN
					--Estimate
					exec zsons_tax.dbo.ins_t_mpso @com_id ,@br_id ,@m_yr_id ,@mpso_dat ,@mpso_ddat ,@mpso_rmk ,@mpso_amt ,@mpso_disper ,@mpso_disamt ,@mpso_freamt ,@mpso_othamt ,@mpso_namt ,@mpso_act ,@mpso_can ,@mpso_ckdel ,@mpso_delnam ,@mpso_delpho ,@mpso_deladd ,@mpso_typ ,@emppro_macid ,@cus_id ,'' ,'' ,'' ,'','',@mpso_id_out=@mpso_taxid output
					update t_mpso set mpso_taxid =@mpso_taxid where mpso_id=@mpso_id
					----Sale Order
					--exec zsons_tax.dbo.ins_t_mso @com_id ,@br_id ,@m_yr_id ,@mpso_no ,@mso_dat ,@mso_cuspo ,@mso_podat ,@mso_ddat ,@mso_rmk ,@mso_amt ,@mso_disper ,@mso_disamt ,@mso_freamt ,@mso_othamt ,@mso_namt ,@mso_act ,@mso_soapp ,@mso_can ,@mso_ckdel ,@mso_delnam ,@mso_delpho ,@mso_deladd ,@mso_typ ,@emppro_macid ,@cus_id ,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip ,'',@mso_id_out =@mso_taxid output
					--update t_mso set mso_taxid =@mso_taxid where mso_id=@mso_id
					----Delivery Challan
					--exec zsons_tax_dbo.ins_t_mdc @com_id ,@br_id ,@m_yr_id ,@mdc_dat ,@mdc_deptime ,@mdc_vno ,@mdc_drv ,@mdc_typ ,@mdc_act ,@mso_no ,@wh_id , @mdc_rmk ,@mdc_ckdel ,@mdc_delnam ,@mdc_delpho ,@mdc_deladd ,@aud_frmnam ,@aud_des ,@usr_id,@aud_ip ,'', @mdc_id_out =@mdc_taxid output
					--update t_mdc set mdc_taxid =@mdc_taxid where mdc_id=@mdc_id
					----Invoice
					--exec zsons_tax.dbo.ins_t_minv @com_id ,@br_id ,@m_yr_id, @minv_dat,@minv_typ ,@dc_no ,@minv_rat ,@cur_id ,@cus_id ,@minv_rmk ,@minv_cktax ,@minv_gstamt ,@minv_fedamt ,@minv_amt ,@minv_disamt ,@minv_freamt ,@minv_othamt ,@minv_namt ,@minv_can ,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip ,@minv_id_out =@minv_taxid output,''
					--update t_minv set minv_taxid =@minv_taxid where minv_id=@minv_id

				
					FETCH NEXT FROM estimatemasterdata1
			INTO @br_id,@m_yr_id,@mpso_id,@mpso_dat,@mpso_ddat,@mpso_rmk,@mpso_currat,@mpso_amt,@mpso_disper,@mpso_disamt,@mpso_freamt,@mpso_othamt,@mpso_namt
			,@mpso_act ,@mpso_can ,@mpso_ckdel ,@mpso_delnam ,@mpso_delpho ,@mpso_deladd ,@mpso_typ ,@emppro_macid ,@cus_id			
						
		end
		CLOSE estimatemasterdata1
		DEALLOCATE estimatemasterdata1

		--Master Voucher Courcor Closed
end

GO


GO

