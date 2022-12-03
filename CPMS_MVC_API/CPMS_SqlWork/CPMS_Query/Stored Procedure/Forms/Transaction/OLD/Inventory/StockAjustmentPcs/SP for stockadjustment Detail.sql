
USE MFI
GO
--alter table t_dstkadj add pack_ck bit,pack_dstkadj_exp datetime,miss_id int 
--update t_dstkadj set pack_ck=0,pack_dstkadj_exp=dstkadj_exp

--
--Insert
alter proc [dbo].[ins_t_dstkadj](@com_id char(2),@br_id char(2),@m_yr_id char(2),@mso_id int,@titm_id int,@bd_id int,@dstkadj_bat varchar(100),@dstkadj_exp datetime,@dstkadj_maf datetime,@wh_id int,@dstkadj_qty float,@pack_mso_id int,@pack_titm_id int,@pack_ck bit,@pack_bd_id int,@pack_dstkadj_exp datetime,@dstkadj_rmk varchar(250),@mstkadj_id int,@aud_frmnam varchar(100),@usr_id int,@aud_ip char(100),@aud_des varchar(1000),@row_id int,@dstkadj_id_out int output)
as
declare
@dstkadj_id int,
@mso_no int,
@stk_dat datetime,
@stk_des varchar(100),
@dstkadj_rat float,
@cur_id int,
@ck_pc bit,
@inner_titm_qty float,
@pack_inner_titm_qty float,
@pack_dstkadj_qty float,
@cus_nam varchar(1000),
@stk_batqty float,
@stk_rat float
begin
	set @dstkadj_rat=0
	set @pack_dstkadj_qty=@dstkadj_qty
	set @stk_dat=(select mstkadj_dat from t_mstkadj where mstkadj_id=@mstkadj_id)
	set @ck_pc=(select mstkadj_pc from t_mstkadj where mstkadj_id=@mstkadj_id)
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	set @dstkadj_id=(select max(dstkadj_id)+1 from t_dstkadj)
		if @dstkadj_id is null
			begin
				set @dstkadj_id=1
			end

	insert into t_dstkadj(dstkadj_id,mso_id,titm_id,bd_id,dstkadj_bat,dstkadj_exp,dstkadj_maf,wh_id,dstkadj_qty,pack_mso_id,pack_titm_id,pack_ck,pack_bd_id,pack_dstkadj_exp,mstkadj_id,dstkadj_rmk)
			values(@dstkadj_id,@mso_id,@titm_id,@bd_id,@dstkadj_bat,@dstkadj_exp,@dstkadj_maf,@wh_id,@dstkadj_qty,@pack_mso_id,@pack_titm_id,@pack_ck,@pack_bd_id,@pack_dstkadj_exp,@mstkadj_id,@dstkadj_rmk)

--Stock Re-Pack
	set @inner_titm_qty=(select inner_titm_qty from t_itm where titm_id=@titm_id)
	set @pack_inner_titm_qty=(select inner_titm_qty from t_itm where titm_id=@pack_titm_id)
		if (@ck_pc=1)
			begin
				set @dstkadj_qty=@dstkadj_qty/@inner_titm_qty
				set @pack_dstkadj_qty=@pack_dstkadj_qty/@pack_inner_titm_qty
			end
		
		set @stk_rat=(select case when sum(stk_qty)=0 then 0 else round(AVG(isnull(stk_trat,0)),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and stk_frm in ('t_itm','TransFG') and  itm_id=@titm_id and stk_bat=@dstkadj_bat and mso_id=@mso_id and m_yr_id=@m_yr_id)
		--Stock
		set @mso_no=(select mso_no from t_mso where mso_id=@mso_id)
		set @cus_nam=(select cus_nam from m_cus inner join t_mso on m_cus.cus_id=t_mso.cus_id where mso_id=@mso_id)
		set @stk_des='Stock Adjustment # '+ rtrim(cast(@mstkadj_id as varchar(100))) +' Batch # '+ rtrim(cast(@dstkadj_bat as varchar(100)))+' Order # ' + rtrim(cast(@mso_no as varchar(100))) + ' Customer: '+@cus_nam
		insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,titm_maf,cur_id,stk_currat,stk_bat,mso_id) 
			values(@mstkadj_id,@titm_id,-@dstkadj_qty,@stk_rat,@dstkadj_rat,'S','I','stk_adj',@stk_des,@stk_dat,@wh_id,@bd_id,@m_yr_id,@dstkadj_exp,@dstkadj_maf,@cur_id,1,@dstkadj_bat,@mso_id)

		--Stock Pack
		set @mso_no=(select mso_no from t_mso where mso_id=@pack_mso_id)
		set @cus_nam=(select cus_nam from m_cus inner join t_mso on m_cus.cus_id=t_mso.cus_id where mso_id=@pack_mso_id)
		set @stk_des='Stock Adjustment # '+ rtrim(cast(@mstkadj_id as varchar(100))) +' Batch # '+ rtrim(cast(@dstkadj_bat as varchar(100)))+' Order # ' + rtrim(cast(@mso_no as varchar(100))) +' Customer: '+@cus_nam
		--Stock
		insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,titm_maf,cur_id,stk_currat,stk_bat,mso_id) 
			values(@mstkadj_id,@pack_titm_id,@pack_dstkadj_qty,@stk_rat,@dstkadj_rat,'S','R','stk_adj',@stk_des,@stk_dat,@wh_id,@pack_bd_id,@m_yr_id,@pack_dstkadj_exp,@dstkadj_maf,@cur_id,1,@dstkadj_bat,@pack_mso_id)
			
	--Stock Batch Status
		--Update Stock Batch
	set @stk_batqty=(select sum(stk_qty) from m_stk where itm_id=@titm_id and bd_id=@bd_id and stk_bat=@dstkadj_bat and titm_maf=@dstkadj_maf and titm_exp=@dstkadj_exp and mso_id=@mso_id)
	if (@stk_batqty=0)
		begin	
			update m_Stk set stk_batst=1 where itm_id=@titm_id and bd_id=@bd_id and stk_bat=@dstkadj_bat and titm_maf=@dstkadj_maf and titm_exp=@dstkadj_exp
		end

	--Packing Material
	if (@row_id=1)
		begin
			exec sp_stkadj_pack @mstkadj_id,@m_yr_id,@usr_id,@aud_ip
		end			

end
GO


--exec  del_t_dstkadj 1

--Delete
alter proc [dbo].[del_t_dstkadj](@mstkadj_id int)
as
declare
@mso_id int,
@titm_id int,
@bd_id int,
@dstkadj_bat varchar(250),
@dstkadj_maf datetime,
@dstkadj_exp datetime

begin

	exec sp_miss_stkadj_pack_del @mstkadj_id ,1,''
		declare  updbatst  cursor for
				select mso_id,titm_id,bd_id,dstkadj_bat,dstkadj_maf,dstkadj_exp from t_dstkadj where mstkadj_id=@mstkadj_id
				OPEN updbatst
					FETCH NEXT FROM updbatst
					INTO @mso_id,@titm_id,@bd_id,@dstkadj_bat,@dstkadj_maf,@dstkadj_exp
						WHILE @@FETCH_STATUS = 0
						BEGIN
							update m_Stk set stk_batst=0 where mso_id=@mso_id and itm_id=@titm_id and bd_id=@bd_id and stk_bat=@dstkadj_bat and titm_maf=@dstkadj_maf and titm_exp=@dstkadj_exp
							FETCH NEXT FROM updbatst
							INTO @mso_id,@titm_id,@bd_id,@dstkadj_bat,@dstkadj_maf,@dstkadj_exp
						end
						CLOSE updbatst
						DEALLOCATE updbatst
	delete from m_stk where stk_frm ='stk_adj' and t_id=@mstkadj_id 	
	delete t_dstkadj where mstkadj_id=@mstkadj_id

end



