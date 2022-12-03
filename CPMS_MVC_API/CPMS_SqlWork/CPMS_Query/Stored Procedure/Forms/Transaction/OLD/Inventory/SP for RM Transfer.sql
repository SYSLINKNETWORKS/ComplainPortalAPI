
alter proc sp_del_transfer_rm(@com_id char(2),@br_id char(3),@m_yr_id char(2),@itm_id int,@stk_dat datetime,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'
	delete from m_Stk where stk_frm='TransferRM' and stk_dat=@stk_dat and m_yr_id=@m_yr_id and itm_id in (select titm_id from t_itm where itm_id=@itm_id)

--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end

go

alter proc sp_ins_transfer_rm(@com_id char(2),@br_id char(3),@m_yr_id char(2),@titm_id int,@stk_qty float,@stk_dat datetime,@wh_id int,@bd_id int,@ck_dat bit,@titm_exp datetime,@cur_id int,@stk_rat float,@stk_currat float,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare 
@trans_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @trans_id=(select max(t_id)+1 from m_Stk where stk_frm='TransferRM')
	if @trans_id is null
		begin		
			set @trans_id=1
		end
	--Expiry Date
	if (@ck_dat=0)
			begin
				set @titm_exp=null
			end
	--Qty
	set @stk_qty=-(select man_qty from t_itm where titm_id=@titm_id)*@stk_qty
	
	--Rate
	if (@stk_rat=0)
		begin
			set @stk_rat=1
		end
	--Brand
	if (@bd_id=0)
		begin
			set @bd_id=null
		end
	--Warehouse
	if (@wh_id=0)
		begin
			set @wh_id=null
		end
	insert into m_stk (t_id,itm_id,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_qtyacc)
	values (@trans_id,@titm_id,@stk_qty,@stk_rat,'S','I','TransferRM',@stk_dat,@wh_id,@bd_id,@m_yr_id,@titm_exp,@cur_id,@stk_currat,0)

--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
--select * from m_stk
