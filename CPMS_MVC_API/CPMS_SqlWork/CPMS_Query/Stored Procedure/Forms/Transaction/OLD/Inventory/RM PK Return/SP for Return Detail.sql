USE MFI
GO
--select * from t_dret where mret_id=1
--select * from t_mret

--select * from m_stk where stk_frm='TransRM'
--
--Insert
alter proc [dbo].[ins_t_dret](@com_id char(2),@br_id char(2),@m_yr_id char(2),@dret_exp datetime,@dret_qty float,@titm_id int,@mret_id int,@wh_id int,@row_id int,@aud_frmnam varchar(100),@usr_id int,@aud_ip char(100),@aud_des varchar(1000),@dret_id_out int output)
as
declare
@dret_id int,
@stk_dat datetime,
@bd_id int,
@cur_id int,
@dret_rat float,
@dret_rat_old float,
@rat_dat datetime,
@titm_id_master int,
@stk_des varchar(100),
@mso_no int,
@cus_id int,
@cus_nam varchar(1000),
@miss_id int,
@mso_id int
begin
	set @mso_id=(select mso_id from t_mret where mret_id=@mret_id)
	set @mso_no=(select mso_no from t_mso where mso_id=@mso_id)
	set @Cus_id=(select cus_id from t_mso where mso_id=@mso_id)
	set @cus_nam=(select cus_nam from m_cus where cus_id =@cus_id)
	set @miss_id=(select miss_id from t_mret where mret_id=@mret_id)
	if @dret_exp=''
	begin
		set @dret_exp=null
	end

	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	set @bd_id=(select bd_id from t_itm where titm_id=@titm_id)
	set @stk_dat=(select mret_dat from t_mret where mret_id=@mret_id)
	set @titm_id_master=(select titm_id from t_mret where mret_id=@mret_id)
	--Rate
	set @dret_rat=(select case when sum(stk_qty)=0 then 0 else round(AVG(isnull(stk_trat,0)),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and stk_frm in ('t_itm','GRN') and itm_id=@titm_id and stk_dat<=@stk_dat and m_yr_id=@m_yr_id) 

	set @dret_id=(select max(dret_id)+1 from t_dret)
		if @dret_id is null
			begin
				set @dret_id=1
			end

	insert into t_dret(dret_id,dret_qty,titm_id,wh_id,mret_id,dret_exp,dret_rat,m_yr_id)
			values(@dret_id,@dret_qty,@titm_id,@wh_id,@mret_id,@dret_exp,@dret_rat,@m_yr_id)

		set @dret_id_out=@dret_id
		
		set @stk_des='Return # '+ rtrim(cast(@mret_id as varchar(100))) +'RMID #'+ rtrim(cast(@miss_id as varchar(100))) +' Order # ' + rtrim(cast(@mso_no as varchar(100))) + ' Customer: '+@cus_nam

		--Stock
		insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,mso_id) values(@mret_id,@titm_id,@dret_qty,0,@dret_rat,'S','R','ReturnRM',@stk_des,@stk_dat,@wh_id,@bd_id,@m_yr_id,@dret_exp,@cur_id,1,@mso_id)

		--Voucher
		if (@row_id=1)
			begin
				exec sp_voucher_ret @com_id,@br_id,@m_yr_id,@mret_id,@usr_id,@aud_ip,@aud_des			
			end

end
GO


--exec  del_t_dret 1

--Delete
alter proc [dbo].[del_t_dret](@mret_id int)
as
declare
@mso_id int
begin

	delete from m_stk where stk_frm ='ReturnRM' and t_id=@mret_id 	
	delete t_dret where mret_id=@mret_id

end

