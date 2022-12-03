
USE MFI
GO
--alter table t_dstkadjmonfg add pack_ck bit,pack_dstkadjmonfg_exp datetime,miss_id int 
--alter table t_dstkadjmonfg add dstkadjmonfg_ckbat bit 
--update t_dstkadjmonfg set dstkadjmonfg_ckbat=0

--update t_dstkadjmonfg set pack_ck=0,pack_dstkadjmonfg_exp=dstkadjmonfg_exp
--alter table t_dstkadjmonfg add dstkadjmonfg_rat float,dstkadjmonfg_trat float
--
--select * from t_mstkadjmonfg
--select * from t_dstkadjmonfg
--select * from m_stk where itm_id=651 and stk_bat='3645-1B' and bd_id=4 and mso_id=52 stk_frm='stk_adjmonfg'

--
--Insert
alter proc [dbo].[ins_t_dstkadjmonfg](@mso_ck bit,@mso_id int,@titm_id int,@bd_id int,@wh_id int,@dstkadjmonfg_ckbat bit,@dstkadjmonfg_bat varchar(100),@dstkadjmonfg_exp datetime,@dstkadjmonfg_qty float,@dstkadjmonfg_rmk varchar(250),@mstkadjmonfg_id int)
as
declare
@dstkadjmonfg_id int,
@stk_dat datetime,
@stk_des varchar(100),
@dstkadjmonfg_rat float,
@mstkadjmonfg_rat float,
@cur_id int,
@dstkadjmonfg_maf datetime,
@com_id char(2),
@br_id char(2),
@m_yr_id char(2)
begin
	set @dstkadjmonfg_rat=0
	set @com_id=(select com_id from t_mstkadjmonfg where mstkadjmonfg_id=@mstkadjmonfg_id )
	set @br_id=(select br_id from t_mstkadjmonfg where mstkadjmonfg_id=@mstkadjmonfg_id )
	set @m_yr_id=(select m_yr_id from t_mstkadjmonfg where mstkadjmonfg_id=@mstkadjmonfg_id )
	set @stk_dat=(select mstkadjmonfg_dat from t_mstkadjmonfg where mstkadjmonfg_id=@mstkadjmonfg_id)
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	set @mstkadjmonfg_rat =1
	set @dstkadjmonfg_id=(select max(dstkadjmonfg_id)+1 from t_dstkadjmonfg)
	set	@dstkadjmonfg_maf=(select top 1 titm_maf from m_stk where itm_id=@titm_id and stk_bat=@dstkadjmonfg_bat and mso_id=@mso_id )
		if @dstkadjmonfg_id is null
			begin
				set @dstkadjmonfg_id=1
			end
		if (@mso_ck=1)
			begin
				set @mso_id=-1
			end
		if (@dstkadjmonfg_maf is null)
			begin
				set @dstkadjmonfg_maf=@stk_dat
				set @dstkadjmonfg_rat=(select case when sum(stk_qty)=0 then 0 else ROUND(AVG(isnull(stk_trat,0)),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and stk_frm in ('t_itm','TransFG') and itm_id=@titm_id and stk_dat<=@stk_dat and  t_id not in (select t_id from m_stk where stk_frm not in ('SO') and itm_id=@titm_id and stk_dat=@stk_dat))
			end
		else
			begin
				set @dstkadjmonfg_rat=(select round(avg(isnull(stk_trat,0)),4) from m_Stk where stk_qty<>0 and m_yr_id =@m_yr_id and stk_frm in ('t_itm','TransFG') and itm_id=@titm_id and stk_bat=@dstkadjmonfg_bat)			
			end
	--Rate

	insert into t_dstkadjmonfg(dstkadjmonfg_id,mso_id,titm_id,bd_id,dstkadjmonfg_ckbat,dstkadjmonfg_bat,dstkadjmonfg_exp,dstkadjmonfg_maf,wh_id,dstkadjmonfg_qty,dstkadjmonfg_rat,dstkadjmonfg_trat,dstkadjmonfg_rmk,mstkadjmonfg_id)
			values(@dstkadjmonfg_id,@mso_id,@titm_id,@bd_id,@dstkadjmonfg_ckbat,@dstkadjmonfg_bat,@dstkadjmonfg_exp,@dstkadjmonfg_maf,@wh_id,@dstkadjmonfg_qty,@dstkadjmonfg_rat,@dstkadjmonfg_rat,@dstkadjmonfg_rmk,@mstkadjmonfg_id)

	
	--Stock
	if (@dstkadjmonfg_qty>=0)
		begin
			--Received	
			insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_bat,mso_id,titm_maf) 
				values(@mstkadjmonfg_id,@titm_id,@dstkadjmonfg_qty,0,@dstkadjmonfg_rat,'S','R','stk_adjmonfg',@stk_des,@stk_dat,@wh_id,@bd_id,@m_yr_id,@dstkadjmonfg_exp,@cur_id,1,@dstkadjmonfg_bat,@mso_id,@dstkadjmonfg_maf)
		end
	else
		begin
			--Issue
			insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_bat,mso_id,titm_maf) 
				values(@mstkadjmonfg_id,@titm_id,@dstkadjmonfg_qty,0,@dstkadjmonfg_rat,'S','I','stk_adjmonfg',@stk_des,@stk_dat,@wh_id,@bd_id,@m_yr_id,@dstkadjmonfg_exp,@cur_id,1,@dstkadjmonfg_bat,@mso_id,@dstkadjmonfg_maf)
		end
	
end
GO


--exec  del_t_dstkadjmonfg 1

--Delete
alter proc [dbo].[del_t_dstkadjmonfg](@mstkadjmonfg_id int,@titm_id int)
as
declare
@mso_id int
begin


	delete from m_stk where stk_frm ='stk_adjmonfg' and t_id=@mstkadjmonfg_id and itm_id=@titm_id
	
	delete t_dstkadjmonfg where mstkadjmonfg_id=@mstkadjmonfg_id and titm_id=@titm_id

end


--UPDATE m_stk set wh_id=null where wh_id=0 and stk_frm='stk_adjmon'

