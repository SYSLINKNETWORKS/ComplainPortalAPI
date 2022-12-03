use rough
go



--alter table t_diss add diss_aqty float,diss_typ char(1)
--update t_diss set diss_aqty=diss_qty,diss_typ='U'
--sp_help t_diss 
--alter table t_diss drop column diss_namt 
--alter table t_diss add  diss_namt as diss_rat*diss_aqty

--
--Insert
alter proc [dbo].[ins_t_diss](@com_id char(2),@br_id char(2),@m_yr_id char(2),@diss_exp varchar(100),@diss_qty float,@diss_aqty float,@titm_id int,@miss_id int,@wh_id int,@diss_typ char,@row_id int,@miss_des varchar(1000),@aud_frmnam varchar(100),@usr_id int,@aud_ip char(100),@aud_des varchar(1000),@diss_id_out int output)
as
declare
@diss_id int,
@stk_dat datetime,
@bd_id int,
@cur_id int,
@diss_rat float,
@diss_rat_old float,
@rat_dat datetime,
@titm_id_master int,
@mso_id int,
@stk_des varchar(250),
@cus_nam varchar(250),
@miss_nob float,
@mso_no int
begin

	if @diss_exp=''
	begin
		set @diss_exp=null
	end
	set @m_yr_id=(select m_yr_id from t_miss where miss_id=@misS_id)
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	set @bd_id=(select bd_id from t_itm where titm_id=@titm_id)
	set @stk_dat=(select miss_dat from t_miss where miss_id=@miss_id)
	set @titm_id_master=(select titm_id from t_miss where miss_id=@miss_id)
	set @diss_rat_old =(select max(isnull(diss_rat,0)) from t_miss inner  join t_diss on t_miss.miss_id=t_diss.miss_id where t_diss.titm_id=@titm_id and miss_dat=(select max(miss_dat) from t_miss where miss_dat<=@stk_dat and titm_id =@titm_id_master) )
	set @rat_dat=(select max(miss_dat) from t_miss where miss_dat<=@stk_dat and titm_id =@titm_id_master)
	set @mso_id=(select mso_id from t_miss where miss_id=@miss_id)
	set @cus_nam=(select cus_nam from t_mso inner join m_cus on t_mso.cus_id=m_cus.cus_id where t_mso.mso_id=@mso_id)
	set @miss_nob=(select isnull(miss_nob,0) from t_miss where miss_id=@miss_id)
	set @mso_no=(select mso_no from t_mso where mso_id=@mso_id)

	
--Rate
		set @diss_rat=isnull((select case when sum(stk_qty)=0 then 0 else ROUND(avg(isnull(stk_trat,0)),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and stk_frm in ('t_itm','GRN') and itm_id=@titm_id and stk_dat<=@stk_dat and m_yr_id=@m_yr_id),0) 
			

	set @diss_id=(select max(diss_id)+1 from t_diss)
		if @diss_id is null
			begin
				set @diss_id=1
			end

	insert into t_diss(diss_id,diss_qty,diss_aqty,titm_id,miss_id,wh_id,diss_exp ,diss_rat,diss_typ,m_yr_id)
			values(@diss_id,@diss_qty,@diss_aqty,@titm_id,@miss_id,@wh_id,@diss_exp,@diss_rat,@diss_typ,@m_yr_id)

		set @diss_id_out=@diss_id
		
		set @stk_des='Production # '+ rtrim(cast(@miss_id as varchar(100))) +' No. of batches '+ rtrim(cast(@miss_nob as varchar(100)))+' Order # ' + rtrim(cast(@mso_no as varchar(100))) + ' Customer: '+@cus_nam  + ' '+ @miss_des
		
		--Stock
		set @diss_qty=@diss_qty/(select case when man_qty=0 then 1 else man_qty end from v_titm where titm_id=@titm_id)
		insert into m_stk(com_id,br_id,t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,mso_id) 
		values(@com_id,@br_id,@miss_id,@titm_id,-@diss_qty,0,@diss_rat,'S','I','TransRM',@stk_des,@stk_dat,@wh_id,@bd_id,@m_yr_id,@diss_exp,@cur_id,1,@mso_id)
		----Voucher
		--if (@row_id=1)
		--	begin
		--		exec sp_voucher_iss @com_id,@br_id,@m_yr_id,@miss_id,@usr_id,@aud_ip,@aud_des			
		--	end

end
GO



--Delete
alter proc [dbo].[del_t_diss](@miss_id int)
as
declare
@mso_id int
begin

	delete from m_stk where stk_frm ='TransRM' and t_id=@miss_id 
	--set @mso_id=(select distinct mso_id from t_miss where miss_id=@miss_id)
	--update t_dso set dso_batact=0 where mso_id=@mso_id and titm_id in (select titm_id from t_miss where miss_id=@miss_id)
	--update t_mso set mso_batact=0 where mso_id=@mso_id
	
	delete t_diss where miss_id=@miss_id

end



