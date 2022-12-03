
USE MFI
GO
--alter table t_dstkadjmon add pack_ck bit,pack_dstkadjmon_exp datetime,miss_id int 
--update t_dstkadjmon set pack_ck=0,pack_dstkadjmon_exp=dstkadjmon_exp

--
--Insert
alter proc [dbo].[ins_t_dstkadjmon](@com_id char(2),@br_id char(2),@m_yr_id char(2),@titm_id int,@bd_id int,@dstkadjmon_bat varchar(100),@dstkadjmon_exp datetime,@dstkadjmon_exp_ck bit,@dstkadjmon_maf datetime,@dstkadjmon_maf_ck bit,@wh_id int,@dstkadjmon_qty float,@dstkadjmon_rmk varchar(250),@mstkadjmon_id int,@aud_frmnam varchar(100),@usr_id int,@aud_ip char(100),@aud_des varchar(1000),@dstkadjmon_id_out int output)
as
declare
@dstkadjmon_id int,
@stk_dat datetime,
@stk_des varchar(100),
@dstkadjmon_rat float,
@mstkadjmon_rat float,
@cur_id int
begin
	set @dstkadjmon_rat=0
	
	if (@dstkadjmon_maf_ck=0)
		begin
			set @dstkadjmon_maf=null
		end
	if (@dstkadjmon_exp_ck=0)
		begin
			set @dstkadjmon_exp=null
		end
		if (@bd_id=0)
		begin
			set @bd_id=null
		end
		if (@wh_id=0)
		begin
			set @wh_id=null
		end
	set @stk_dat=(select mstkadjmon_dat from t_mstkadjmon where mstkadjmon_id=@mstkadjmon_id)
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	set @mstkadjmon_rat =1
	set @dstkadjmon_id=(select max(dstkadjmon_id)+1 from t_dstkadjmon)
		if @dstkadjmon_id is null
			begin
				set @dstkadjmon_id=1
			end
	--Rate
		set @dstkadjmon_rat=(select case when sum(stk_qty)=0 then 0 else round(avg(stk_trat),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and stk_frm in ('t_itm','GRN') and itm_id=@titm_id and stk_dat<=@stk_dat and  t_id not in (select t_id from m_stk where stk_frm not in ('SO') and itm_id=@titm_id and stk_dat=@stk_dat))

	insert into t_dstkadjmon(dstkadjmon_id,titm_id,bd_id,dstkadjmon_bat,dstkadjmon_exp,dstkadjmon_maf,wh_id,dstkadjmon_qty,dstkadjmon_rat,dstkadjmon_trat,dstkadjmon_rmk,mstkadjmon_id)
			values(@dstkadjmon_id,@titm_id,@bd_id,@dstkadjmon_bat,@dstkadjmon_exp,@dstkadjmon_maf,@wh_id,@dstkadjmon_qty,@dstkadjmon_rat,@dstkadjmon_rat,@dstkadjmon_rmk,@mstkadjmon_id)


	
	--Stock
	if (@dstkadjmon_qty>=0)
		begin
			--Received	
			insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,titm_maf,cur_id,stk_currat,stk_bat) 
				values(@mstkadjmon_id,@titm_id,@dstkadjmon_qty,0,@dstkadjmon_rat,'S','R','stk_adjmon',@stk_des,@stk_dat,@wh_id,@bd_id,@m_yr_id,@dstkadjmon_exp,@dstkadjmon_maf,@cur_id,1,@dstkadjmon_bat)
		end
	else
		begin
			--Issue
			insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,titm_maf,cur_id,stk_currat,stk_bat) 
				values(@mstkadjmon_id,@titm_id,@dstkadjmon_qty,0,@dstkadjmon_rat,'S','I','stk_adjmon',@stk_des,@stk_dat,@wh_id,@bd_id,@m_yr_id,@dstkadjmon_exp,@dstkadjmon_maf,@cur_id,1,@dstkadjmon_bat)
		end
	

end
GO


--exec  del_t_dstkadjmon 1

--Delete
alter proc [dbo].[del_t_dstkadjmon](@mstkadjmon_id int,@titm_id int)
as
declare
@mso_id int
begin

	delete from m_stk where stk_frm ='stk_adjmon' and itm_id=@titm_id and t_id=@mstkadjmon_id
	
	delete t_dstkadjmon where mstkadjmon_id=@mstkadjmon_id and titm_id=@titm_id 
	
end



