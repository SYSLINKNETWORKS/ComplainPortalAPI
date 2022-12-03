

--alter table t_dfg add dfg_pettikg float,dfg_titm_id_petti int,dfg_petti_rat float


--update t_dfg set dfg_pettikg=0
--select * from m_stk where stk_frm='GRN' and t_id=651
--select * from t_dfg where mfg_id=393

--Insert
alter proc [dbo].[ins_t_dfg](@com_id char(2),@br_id char(2),@dfg_rec float,@dfg_iss float,@dfg_was float,@dfg_unpack float,@dfg_pack float,@miss_bal float,@miss_id_fg int,@dfg_batqty float,@chlbk_no int,@dfg_bat varchar(100),@dfg_ckexp bit,@dfg_exp datetime,@titm_id int,@titm_id_fg int,@dfg_kg float,@mfg_id int,@mso_id int,@wh_id int,@dso_fgact bit,@row_id int,@patti int,@dfg_titm_id_petti int,@dfg_pettikg float,@m_yr_id char(2),@mgrn_id int,@usr_id int,@aud_ip varchar(100),@dfg_id_out int output)
as
declare
@dfg_id int,
@mso_fgact bit,
@cur_id int,
@bd_id int,
@stk_dat datetime,
@dfg_rat float,
@titm_id_master int,
--@dfg_rat_old int,
@rat_dat datetime,
@dso_qty float,
@dfg_qty_tot float,
@stk_des varchar(250),
@cus_nam varchar(250),
@mso_no int,
@mfg_typ char(1),
@titm_nam varchar(250),
@miss_id_rm int,
@miss_id_pack int,
@mfg_dat datetime,
@stk_des_polybag varchar(1000),
@dfg_rat_pk_semi float
begin

	set @dfg_exp=(cast(convert(varchar,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@dfg_exp)+1,0)),101) as datetime))
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	set @bd_id=(select bd_id from t_dso where mso_id=@mso_id and titm_id=@titm_id and dso_typ='U')
	set @stk_dat=(select mfg_dat from t_mfg where mfg_id=@mfg_id)
	set @mfg_dat=(select mfg_dat from t_mfg where mfg_id=@mfg_id)
	
	set @cus_nam=(select cus_nam from t_mso inner join m_cus on t_mso.cus_id=m_cus.cus_id where t_mso.mso_id=@mso_id)
	set @mso_no=(select mso_no from t_mso where mso_id=@mso_id)
	set @titm_id_master=@titm_id
	set @titm_nam=(select titm_nam from t_itm where titm_id=@titm_id)
	set @mfg_typ=(select mfg_typ from t_mfg where mfg_id=@mfg_id)

	if (@titm_id_fg=0)
		begin
			set @titm_id_fg=null
		end
	
	if (@mgrn_id=0)
		begin
			set @mgrn_id=null
		end
--Rate

	set @dfg_id=(select max(dfg_id)+1 from t_dfg)
		if @dfg_id is null
			begin
				set @dfg_id=1
			end
			
			if (@dfg_ckexp=0)
				begin	
					set @dfg_exp=null
				end
				
				if (@miss_id_fg=0)
					begin
						set @miss_id_fg=null
					end
					
				if (@dfg_pettikg =0)
				begin
					set	@dfg_titm_id_petti=null
				end
	insert into t_dfg(dfg_id,miss_id_fg,dfg_batqty,dfg_bat,dfg_iss,dfg_was,dfg_exp,dfg_rat,dfg_rec,dfg_unpack,dfg_pack,titm_id,titm_id_fg,mso_id,mfg_id,wh_id,chlbk_no ,mgrn_id,dfg_titm_id_petti,dfg_pettikg)
		values(@dfg_id,@miss_id_fg,@dfg_batqty,@dfg_bat,@dfg_iss,@dfg_was,@dfg_exp,@dfg_rat,@dfg_rec,@dfg_unpack,@dfg_pack,@titm_id,@titm_id_fg,@mso_id,@mfg_id,@wh_id,@chlbk_no,@mgrn_id,@dfg_titm_id_petti,@dfg_pettikg)

		set @dfg_id_out=@dfg_id
		
		
			
			
		--Update Challan Book
		update m_chlbk set chlbk_act=0,chlbk_typ='S' where chlbk_no=@chlbk_no
		--Setting Status for Detail Finish Goods
		set @dfg_qty_tot=(select sum(dfg_qty) from v_fg where mso_id=@mso_id and titm_id=@titm_id and bd_id=@bd_id)
		set @dso_qty=(select sum(dso_prod) from t_dso where mso_id=@mso_id and titm_id=@titm_id and dso_prod<>0)
		if ((@dso_qty-@dfg_qty_tot)<=0)
			begin
				update t_dso set dso_fgact=1 where mso_id=@mso_id and titm_id=@titm_id
			end
		else
			begin
				update t_dso set dso_fgact=0 where mso_id=@mso_id and titm_id=@titm_id
			end
			
		set @mso_fgact=(select distinct t_dso.dso_fgact from t_mso inner join t_dso on t_mso.mso_id=t_dso.mso_id where t_dso.mso_id=@mso_id and dso_fgact=0)
		if @mso_fgact is null
			begin
				update t_mso set mso_fgact=1 where mso_id=@mso_id
			end
		else
			begin
				update t_mso set mso_fgact=0 where mso_id=@mso_id
			end
		
		--print @miss_bal
		if (@miss_bal<=0)
			begin
			--print @miss_bal
				update t_miss set miss_st=1 where miss_id=@miss_id_fg
			end
		
		if(@patti=0)
		begin
		----print 'Packing Material'
			exec sp_miss_pack @dfg_id ,@m_yr_id ,@usr_id ,@aud_ip
		end
		
		--Rates
		set @miss_id_rm=(select miss_id_fg from t_dfg where dfg_id=@dfg_id)
		set @miss_id_pack=(select miss_id from t_dfg where dfg_id=@dfg_id)
		set @dfg_rat=0
		set @dfg_rat_pk_semi=0
		
		--Semi Finish
		if (@mfg_typ='E')
			begin
				set @dfg_rat_pk_semi=isnull((SELECT  round(sum(diss_namt),4)  from t_diss where miss_id=@miss_id_pack),0)
				set @dfg_rat=isnull((select avg(stk_trat) from m_stk where stk_qty<>0 and m_yr_id=@m_yr_id and itm_id=@titm_id_fg and stk_frm in ('t_itm','GRN') and stk_qty<>0 and stk_dat<=@mfg_dat),0)
				set @dfg_rat=@dfg_rat*@dfg_iss
				set @dfg_rat=@dfg_rat+@dfg_rat_pk_semi
				set @dfg_rat=round(@dfg_rat/@dfg_rec,4)
				set @dfg_rat_pk_semi=round(@dfg_rat_pk_semi/@dfg_rec,4)
			end
		--Semi Finish Petti in KG
		else if (@mfg_typ='M')
			begin
				set @dfg_rat=@dfg_rat+(SELECT  round((sum(diss_namt)/miss_nob)/mbat_siz,4)  from t_miss inner join t_diss on t_miss.miss_id=t_diss.miss_id inner join m_mbat on t_miss.mbat_id=m_mbat.mbat_id where t_miss.miss_id=@miss_id_rm group by mbat_siz,miss_nob)
				set @dfg_rat=@dfg_rat+(SELECT  round((sum(diss_namt)/miss_nob)*dfg_batqty,4)  from t_miss inner join t_diss on t_miss.miss_id=t_diss.miss_id inner join t_dfg on t_miss.miss_id=t_dfg.miss_id_fg where dfg_id=@dfg_id group by miss_nob,dfg_batqty)
				set @dfg_rat=round(@dfg_rat/@dfg_rec,4)
			end
		--Others
		else
			begin
			
				set @dfg_rat=isnull((SELECT case when miss_nob>0 then (round(sum(diss_namt)/miss_nob,4)*dfg_batqty) else 0 end from t_miss inner join t_diss on t_miss.miss_id=t_diss.miss_id inner join t_dfg on t_miss.miss_id=t_dfg.miss_id_fg where dfg_id=@dfg_id group by miss_nob,dfg_batqty),0)
				set @dfg_rat=@dfg_rat+isnull((SELECT round(sum(diss_namt),4)  from t_miss inner join t_diss on t_miss.miss_id=t_diss.miss_id inner join t_dfg on t_miss.miss_id=t_dfg.miss_id where dfg_id=@dfg_id),0)
				set @dfg_rat=round(@dfg_rat/@dfg_rec,4)
			end
		update t_dfg set dfg_rat=@dfg_rat,dfg_rat_pk_semi=@dfg_rat_pk_semi where dfg_id=@dfg_id
		update m_stk set stk_rat=@dfg_rat where t_id=@mfg_id and stk_frm='TransFG' and itm_id=@titm_id
--Stock
		if (@miss_id_fg is not null)
			begin
				set @dfg_rat=(select case when sum(stk_qty)=0 then 0 else ROUND(AVG(isnull(stk_trat,0)),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and itm_id=@titm_id_FG and stk_dat<=@stk_dat and  t_id not in (select t_id from m_stk where stk_frm='TranFG' and itm_id=@titm_id and stk_dat=@stk_dat))
				set @stk_des='FG Trans # '+ rtrim(cast(@mfg_id as varchar(100))) +' Batch # '+ @dfg_bat+' Order # ' + rtrim(cast(@mso_no as varchar(100))) + ' Customer: '+@cus_nam
				insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_bat,mso_id,titm_maf) values(@mfg_id,@titm_id,@dfg_pack,0,@dfg_rat,'S','R','TransFG',@stk_des,@stk_dat,@wh_id,@bd_id,@m_yr_id,@dfg_exp,@cur_id,1,@dfg_bat,@mso_id,@stk_dat)
				if (@dfg_unpack>0)
					begin
						set @bd_id=(select bd_id from m_bd where bd_genact=1)
						set @stk_des_polybag=@stk_des+' [Unpacked]'
						insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_bat,mso_id,titm_maf) values(@mfg_id,@titm_id,@dfg_unpack,0,@dfg_rat,'S','R','TransFG',@stk_des_polybag,@stk_dat,@wh_id,@bd_id,@m_yr_id,@dfg_exp,@cur_id,1,@dfg_bat,@mso_id,@stk_dat)
					end
			end
		--Semi Finish Master Stock
		if (@mfg_typ='E' or @mfg_typ='I')
			begin
				--Semi Finish Goods
				set @dfg_rat=(select case when sum(stk_qty)=0 then 0 else ROUND(avg(ISNULL(stk_trat,0)),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and itm_id=@titm_id_FG and stk_dat<=@stk_dat and  t_id not in (select t_id from m_stk where stk_frm='TransRM' and itm_id=@titm_id and stk_dat=@stk_dat))
				set @stk_des='SEMI FG Trans # '+ rtrim(cast(@mfg_id as varchar(100))) +' for Item '+ @titm_nam+' Batch # '+ @dfg_bat+' Order # ' + rtrim(cast(@mso_no as varchar(100))) + ' Customer: '+@cus_nam
				insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_bat,mso_id,titm_maf) values(@mfg_id,@titm_id_fg,-@dfg_iss,0,@dfg_rat,'S','I','TransRM',@stk_des,@stk_dat,@wh_id,null,@m_yr_id,@dfg_exp,@cur_id,1,@dfg_bat,@mso_id,@stk_dat)
				--Finish Goods
				set @dfg_rat=(select case when sum(stk_qty)=0 then 0 else ROUND(avg(ISNULL(stk_trat,0)),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and itm_id=@titm_id_FG and stk_dat<=@stk_dat and  t_id not in (select t_id from m_stk where stk_frm='TranFG' and itm_id=@titm_id and stk_dat=@stk_dat))
				set @stk_des='FG Trans # '+ rtrim(cast(@mfg_id as varchar(100))) +' Batch # '+ @dfg_bat+' Order # ' + rtrim(cast(@mso_no as varchar(100))) + ' Customer: '+@cus_nam
				insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_bat,mso_id,titm_maf) values(@mfg_id,@titm_id,@dfg_rec,0,@dfg_rat,'S','R','TransFG',@stk_des,@stk_dat,@wh_id,@bd_id,@m_yr_id,@dfg_exp,@cur_id,1,@dfg_bat,@mso_id,@stk_dat)

			end
			--Issue Petti
			if (@dfg_pettikg >0)
				begin
					set @dfg_rat=(select round(AVG(isnull(stk_trat,0)),4) from m_stk where itm_id=@dfg_titm_id_petti and stk_dat<=@mfg_dat and stk_frm='TransFG' and stk_st='R')
					set @titm_nam=(select titm_id from t_itm where titm_id=@dfg_titm_id_petti)
					set @stk_des='FG Trans # '+ rtrim(cast(@mfg_id as varchar(100))) +' for Petti '+ @titm_nam+' Batch # '+ @dfg_bat+' Order # ' + rtrim(cast(@mso_no as varchar(100))) + ' Customer: '+@cus_nam
					insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_bat,mso_id,titm_maf) values(@mfg_id,@dfg_titm_id_petti,-@dfg_pettikg,0,@dfg_rat,'S','I','TransFG',@stk_des,@stk_dat,@wh_id,null,@m_yr_id,null,@cur_id,1,@dfg_bat,@mso_id,@stk_dat)
					update t_dfg set dfg_petti_rat=@dfg_rat where dfg_id=@dfg_id
				end


		----Voucher
		if (@row_id=1)
			begin
				exec sp_voucher_fg @com_id,@br_id,@m_yr_id,@mfg_id ,@usr_id,'',''
			end

end
GO
--select stk_trat from m_stk where itm_id=749 and stk_frm in ('t_itm','GRN') and stk_dat<='01/08/2013'
--select * from t_dfg where mfg_id=1006




--exec  del_t_dfg 13

--Delete
alter proc [dbo].[del_t_dfg](@mfg_id int)
as
declare
@titm_id_fg int,
@mfg_typ char(1)
begin

	set @mfg_typ=(select mfg_typ from t_mfg where mfg_id=@mfg_id)
	set @titm_id_fg=(select distinct titm_id_fg from t_dfg where mfg_id=@mfg_id)
	
	exec sp_miss_pack_del @mfg_id,1,''
 
	update t_miss set miss_st=0 where miss_id in (select distinct miss_id_fg from t_dfg where mfg_id=@mfg_id) and titm_id in (select distinct titm_id from t_dfg where mfg_id=@mfg_id)
	update t_dso set dso_fgact=0 where mso_id in (select distinct mso_id from t_dfg where mfg_id=@mfg_id) and titm_id in (select distinct titm_id from t_dfg where mfg_id=@mfg_id)
	update t_mso set mso_fgact=0 where mso_id in (select distinct mso_id from t_dfg where mfg_id=@mfg_id)
		--Update Challan Book
		update m_chlbk set chlbk_act=1,chlbk_typ='U' where chlbk_no in (select chlbk_no from t_dfg where mfg_id=@mfg_id)	
		delete from m_stk where stk_frm ='TransFG' and t_id=@mfg_id 
	--Semi Finish Goods
		if (@mfg_typ='E' or @mfg_typ='I')
		begin
			delete from m_stk where stk_frm ='TransRM' and t_id=@mfg_id and itm_id=@titm_id_fg 
		end
	delete t_dfg where mfg_id=@mfg_id
end

go
