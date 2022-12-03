
USE MFI
GO
--create table t_dprtexp add pack_ck bit,pack_dprtexp_exp datetime,miss_id int 
--update t_dprtexp set pack_ck=0,pack_dprtexp_exp=dprtexp_exp

--
--Insert
alter proc [dbo].[ins_t_dprtexp](@com_id char(2),@br_id char(2),@m_yr_id char(2),@titm_id int,@bd_id int,@wh_id int,@dprtexp_exp datetime,@dprtexp_qty float,@dprtexp_rmk varchar(250),@mprtexp_id int,@aud_frmnam varchar(100),@usr_id int,@aud_ip char(100),@aud_des varchar(1000),@dprtexp_id_out int output)
as
declare
@dprtexp_id int,
@stk_dat datetime,
@stk_des varchar(100),
@dprtexp_rat float,
@mprtexp_rat float,
@cur_id int
begin
	set @dprtexp_rat=0

			set @bd_id=(select bd_id from t_itm where titm_id=@titm_id)
			
	set @stk_dat=(select mprtexp_dat from t_mprtexp where mprtexp_id=@mprtexp_id)
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	set @mprtexp_rat =1
	set @dprtexp_id=(select max(dprtexp_id)+1 from t_dprtexp)
		if @dprtexp_id is null
			begin
				set @dprtexp_id=1
			end
		if (@bd_id=0)
			begin
				set @bd_id=null
			end
		if (@wh_id=0)
			begin
				set @wh_id=null
			end
	--Rate
		set @dprtexp_rat=(select case when sum(stk_qty)=0 then 0 else round(AVG(isnull(stk_trat,0)),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and stk_frm in ('t_itm','GRN') and itm_id=@titm_id and stk_dat<=@stk_dat and  t_id not in (select t_id from m_stk where stk_frm not in ('stk_prtexp') and itm_id=@titm_id and stk_dat=@stk_dat))

	insert into t_dprtexp(dprtexp_id,titm_id,dprtexp_exp,dprtexp_qty,dprtexp_rat,dprtexp_trat,dprtexp_rmk,mprtexp_id,bd_id,wh_id)
			values(@dprtexp_id,@titm_id,@dprtexp_exp,@dprtexp_qty,@dprtexp_rat,@dprtexp_rat,@dprtexp_rmk,@mprtexp_id,@bd_id,@wh_id)

	set @stk_des='Expiry Printed # '+rtrim(cast(@mprtexp_id as varchar(1000)))+ ' Expiry Date '+convert(varchar(12),@dprtexp_exp,106)
	--Stock
			--Received	
			insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,titm_maf,cur_id,stk_currat,stk_bat) 
				values(@mprtexp_id,@titm_id,@dprtexp_qty,0,@dprtexp_rat,'S','R','stk_prtexp',@stk_des,@stk_dat,@wh_id,@bd_id,@m_yr_id,@dprtexp_exp,null,@cur_id,1,null)
			--Issue
			insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,titm_maf,cur_id,stk_currat,stk_bat) 
				values(@mprtexp_id,@titm_id,-@dprtexp_qty,0,@dprtexp_rat,'S','I','stk_prtexp',@stk_des,@stk_dat,@wh_id,@bd_id,@m_yr_id,null,null,@cur_id,1,null)
	

end
GO

--exec  del_t_dprtexp 1

--Delete
alter proc [dbo].[del_t_dprtexp](@mprtexp_id int,@titm_id int)
as
declare
@mso_id int
begin


	delete from m_stk where stk_frm ='stk_prtexp' and itm_id=@titm_id and t_id=@mprtexp_id
	
	delete t_dprtexp where mprtexp_id=@mprtexp_id and titm_id=@titm_id

end

