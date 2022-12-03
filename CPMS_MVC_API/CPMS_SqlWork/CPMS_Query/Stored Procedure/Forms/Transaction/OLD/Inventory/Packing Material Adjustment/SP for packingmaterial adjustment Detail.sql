
USE MFI
GO
--alter table t_dpkadj add pack_ck bit,pack_dpkadj_exp datetime,miss_id int 
--update t_dpkadj set pack_ck=0,pack_dpkadj_exp=dpkadj_exp
--select * from m_stk where stk_frm='stk_pkadj'
--
--Insert
alter proc [dbo].[ins_t_dpkadj](@com_id char(2),@br_id char(2),@m_yr_id char(2),@titm_id int,@bd_id int,@wh_id int,@dpkadj_ckexp bit,@dpkadj_exp datetime,@dpkadj_rqty float,@dpkadj_iqty float,@dpkadj_rmk varchar(250),@mpkadj_id int,@aud_frmnam varchar(100),@usr_id int,@aud_ip char(100),@aud_des varchar(1000),@dpkadj_id_out int output)
as
declare
@dpkadj_id int,
@stk_dat datetime,
@stk_des varchar(100),
@dpkadj_rat float,
@mpkadj_rat float,
@cur_id int
begin
	set @dpkadj_rat=0

			set @bd_id=(select bd_id from t_itm where titm_id=@titm_id)
			
	set @stk_dat=(select mpkadj_dat from t_mpkadj where mpkadj_id=@mpkadj_id)
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	set @mpkadj_rat =1
	set @dpkadj_id=(select max(dpkadj_id)+1 from t_dpkadj)
		if @dpkadj_id is null
			begin
				set @dpkadj_id=1
			end
		if (@bd_id=0)
			begin
				set @bd_id=null
			end
		if (@wh_id=0)
			begin
				set @wh_id=null
			end
			if (@dpkadj_ckexp=0)
				begin
					set @dpkadj_exp=null
				end
				
				
	--Rate
		set @dpkadj_rat=(select case when sum(stk_qty)=0 then 0 else round(AVG(isnull(stk_trat,0)),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and stk_frm in ('t_itm','GRN') and itm_id=@titm_id and stk_dat<=@stk_dat and  t_id not in (select t_id from m_stk where stk_frm not in ('stk_pkadj') and itm_id=@titm_id and stk_dat=@stk_dat))

	insert into t_dpkadj(dpkadj_id,titm_id,dpkadj_exp,dpkadj_rqty,dpkadj_iqty,dpkadj_rat,dpkadj_trat,dpkadj_rmk,mpkadj_id,bd_id,wh_id)
			values(@dpkadj_id,@titm_id,@dpkadj_exp,@dpkadj_rqty,@dpkadj_iqty,@dpkadj_rat,@dpkadj_rat,@dpkadj_rmk,@mpkadj_id,@bd_id,@wh_id)

	set @stk_des='Packing Material Adjustment # '+rtrim(cast(@mpkadj_id as varchar(1000)))
	--Stock
			--Received	
			if (@dpkadj_rqty>0)
				begin
					insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,titm_maf,cur_id,stk_currat,stk_bat) 
						values(@mpkadj_id,@titm_id,@dpkadj_rqty,0,@dpkadj_rat,'S','R','stk_pkadj',@stk_des,@stk_dat,@wh_id,@bd_id,@m_yr_id,@dpkadj_exp,null,@cur_id,1,null)
				end
			--Issue
			if (@dpkadj_iqty>0)
				begin
					insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,titm_maf,cur_id,stk_currat,stk_bat) 
						values(@mpkadj_id,@titm_id,-@dpkadj_iqty,0,@dpkadj_rat,'S','I','stk_pkadj',@stk_des,@stk_dat,@wh_id,@bd_id,@m_yr_id,null,null,@cur_id,1,null)
	
				end

end
GO

--exec  del_t_dpkadj 1

--Delete
alter proc [dbo].[del_t_dpkadj](@mpkadj_id int,@titm_id int)
as
declare
@mso_id int
begin


	delete from m_stk where stk_frm ='stk_pkadj' and itm_id=@titm_id and t_id=@mpkadj_id
	
	delete t_dpkadj where mpkadj_id=@mpkadj_id and titm_id=@titm_id

end

