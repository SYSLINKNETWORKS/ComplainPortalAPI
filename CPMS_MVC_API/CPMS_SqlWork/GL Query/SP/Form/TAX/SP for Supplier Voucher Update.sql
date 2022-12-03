USE ZSONS
GO
--alter table t_mpb add mpb_tax bit default 0
--update t_mpb set mpb_tax=0
--exec sp_upd_msupvch '01','01',1

alter proc sp_upd_msupvch(@com_id char(2),@br_id char(3),@mpb_id int)
as
begin
	update t_mpb set mpb_tax=1 where com_id=@com_id and mpb_id=@mpb_id
--	select * from t_mpb
--Purchase Bill Cursor Open
declare @m_yr_id char(2),@mpb_dat datetime,@mpb_typ char(1),@grn_no varchar(100),@mpb_rat float,@cur_id int,@sup_id int,@mpb_rmk varchar(250),
		@sup_bill varchar(25),@mpb_amt float,@mpb_disper float,@mpb_disamt float,@mpb_desamt float,@mpb_othamt float,@mpb_namt float,
		@mpb_fre float,@mpb_con char(1),@mpb_can bit,@mpb_id_new int,
		@dpb_qty float,@dpb_acc float,@dpb_nqty float,@dpb_rat float,@dpb_amt float,@dpb_disper float,@dpb_disamt float,@dpb_othamt float,
		@dpb_namt float,@titm_id int,@mgrn_id int,@row_id int

	--declare  mpb1  cursor for			
	--	select m_yr_id,mpb_dat,mpb_typ,mgrn_id,mpb_rat,cur_id,sup_id,mpb_rmk,sup_bill,mpb_amt ,mpb_disper,mpb_disamt ,mpb_desamt,mpb_othamt,mpb_namt,mpb_fre,mpb_con,mpb_can from t_mpb where mpb_id=@mpb_id
	--	OPEN mpb1
	--		FETCH NEXT FROM mpb1
	--		INTO @m_yr_id,@mpb_dat,@mpb_typ,@mgrn_id,@mpb_rat,@cur_id,@sup_id,@mpb_rmk,@sup_bill,@mpb_amt ,@mpb_disper,@mpb_disamt ,@mpb_desamt,@mpb_othamt,@mpb_namt,@mpb_fre,@mpb_con,@mpb_can
	--			WHILE @@FETCH_STATUS = 0
	--			BEGIN
	--				exec zsons_tax.dbo.ins_t_mpb @com_id,@br_id,@m_yr_id ,@mpb_dat,@mpb_typ ,@grn_no ,@mpb_rat,@cur_id ,@sup_id ,@mpb_rmk,@sup_bill ,@mpb_amt,@mpb_disper,@mpb_disamt,@mpb_desamt,@mpb_othamt,@mpb_namt,@mpb_fre,@mpb_con,@mpb_can,'','','','',@mpb_id_new output
	--					--Purchase Bill Detail Cursor
	--					declare  dpb1  cursor for			
	--						select dpb_qty ,dpb_acc,dpb_nqty,dpb_rat,dpb_amt,dpb_disper ,dpb_disamt ,dpb_othamt,dpb_namt ,mpb_id,titm_id ,m_yr_id from t_dpb where mpb_id=@mpb_id
	--						OPEN dpb1
	--							FETCH NEXT FROM dpb1
	--							INTO @dpb_qty ,@dpb_acc,@dpb_nqty,@dpb_rat,@dpb_amt,@dpb_disper ,@dpb_disamt ,@dpb_othamt,@dpb_namt ,@mpb_id,@titm_id ,@m_yr_id
	--								WHILE @@FETCH_STATUS = 0
	--								BEGIN
	--										exec zsons_tax.dbo.ins_t_dpb @com_id,@br_id,@dpb_qty,@dpb_acc,@dpb_nqty,@dpb_rat ,@dpb_amt,@dpb_disper,@dpb_disamt ,@dpb_othamt,@dpb_namt ,@mpb_id_new,@titm_id ,@m_yr_id ,@row_id ,'','','','' 
							
	--									FETCH NEXT FROM dpb1
	--									INTO @dpb_qty ,@dpb_acc,@dpb_nqty,@dpb_rat,@dpb_amt,@dpb_disper ,@dpb_disamt ,@dpb_othamt,@dpb_namt ,@mpb_id,@titm_id ,@m_yr_id											
											
	--						end
	--						CLOSE dpb1
	--						DEALLOCATE dpb1
	--					--Purchase Bill Detail Cursor Close


				
	--				FETCH NEXT FROM mpb1
	--		INTO @m_yr_id,@mpb_dat,@mpb_typ,@mgrn_id,@mpb_rat,@cur_id,@sup_id,@mpb_rmk,@sup_bill,@mpb_amt ,@mpb_disper,@mpb_disamt ,@mpb_desamt,@mpb_othamt,@mpb_namt,@mpb_fre,@mpb_con,@mpb_can
						
						
	--	end
	--	CLOSE mpb1
	--	DEALLOCATE mpb1

	--	--Purchase Bill Master Courcor Closed
end

GO

go
alter proc sp_del_msupvch(@com_id char(2),@br_id char(3),@sup_id int)
as
begin
	update t_mpb set mpb_tax=0 where com_id=@com_id and sup_id=@sup_id
end

GO