USE MFI
go
--select * from t_dgp
--alter table t_dgp add chlbk_no int,dgp_rat float
--alter table t_mgp add mvch_id char(12)
--update m_dpt set dpt_typ='S' where dpt_id=18

--alter table t_dgp add constraint FK_Dgp_CHLBKNO foreign key (chlbk_no) references m_chlbk (chlbk_no)
--alter table t_dgp add dgp_bat varchar(250)
--update t_dgp set dgp_bat=gp_bat
--alter table t_dgp drop column gp_bat


--Insert
alter proc ins_t_dgp(@com_id char(2),@br_id char(3),@m_yr_id char(2),@dgp_qty float,@dgp_bat varchar(250),@mgp_id int,@titm_id int,@nat_id int,@chlbk_no int,@row_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@dgp_id int,
@bd_id int,
@batch varchar(250),
@stk_des varchar(250),
@mgp_dat datetime,
@dgp_rat float,
@wh_id int,
@dgp_exp datetime,
@dgp_maf datetime,
@cur_id int,
@mso_id int
begin
	set @mgp_dat=(select mgp_dat from t_mgp where mgp_id=@mgp_id)
	set @m_yr_id=(select m_yr_id from t_mgp where mgp_id=@mgp_id)
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	set @dgp_id=(select max(dgp_id)+1 from t_dgp)
	set @bd_id=(select distinct bd_id from m_stk where stk_bat=@dgp_bat and itm_id=@titm_id)
		if @dgp_id is null
			begin
				set @dgp_id=1
			end
	
	if (@dgp_bat ='0')
		begin
			set @dgp_bat=null
		end
	
	insert into t_dgp(dgp_id,dgp_qty,dgp_bat,chlbk_no,mgp_id,titm_id,bd_id,nat_id)
			values(@dgp_id,@dgp_qty,@dgp_bat,@chlbk_no,@mgp_id,@titm_id,@bd_id,@nat_id)
			
	--Stock
				if (@dgp_bat is not null)
					begin
						set @batch=' Batch # '+ @dgp_bat
						set @dgp_rat=(select round(avg(isnull(stk_rat,0)),4) from m_stk where stk_qty<>0 and m_yr_id=@m_yr_id and stk_bat=@dgp_bat and stk_frm in ('TransFG','t_itm'))						
						set @wh_id=(select top 1 wh_id from m_stk where m_yr_id=@m_yr_id and stk_bat=@dgp_bat and stk_frm in ('TransFG','t_itm'))
						set @dgp_exp=(select titm_exp from m_stk where m_yr_id=@m_yr_id and stk_bat=@dgp_bat and stk_frm in ('TransFG','t_itm'))
						set @dgp_maf=(select titm_maf from m_stk where m_yr_id =@m_yr_id and stk_bat=@dgp_bat and stk_frm in ('TransFG','t_itm'))
						set @mso_id=(select mso_id from m_stk where m_yr_id =@m_yr_id and stk_bat=@dgp_bat and stk_frm in ('TransFG','t_itm'))
					end
				else 
					begin
						set @dgp_rat=(select round(avg(isnull(stk_rat,0)),4) from m_stk where stk_qty<>0 and m_yr_id=@m_yr_id and itm_id=@titm_id and stk_frm in ('GRN','t_itm'))				
						set @wh_id=(select distinct wh_id from m_stk inner join t_itm on m_stk.itm_id=t_itm.titm_id inner join m_itm on t_itm.itm_id=m_itm.itm_id where m_yr_id=@m_yr_id and m_stk.itm_id=@titm_id and stk_frm in ('GRN','t_itm'))				
						set @dgp_exp=null
						set @dgp_maf=null
						set @batch=''
						set @mso_id =null
					end
					
				set @stk_des='GatePass # '+ rtrim(cast(@mgp_id as varchar(100))) +'  Challan #'+rtrim(cast(@chlbk_no as varchar(100))) +@batch
				insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_bat,mso_id,titm_maf) values(@mgp_id,@titm_id,-@dgp_qty,0,@dgp_rat,'S','I','stk_gatepass',@stk_des,@mgp_dat,@wh_id,@bd_id,@m_yr_id,@dgp_exp,@cur_id,1,@dgp_bat,@mso_id,@dgp_maf)
				update t_dgp set dgp_rat=@dgp_rat where dgp_id=@dgp_id
				
				--Challan No
				update m_chlbk set chlbk_act=0 where chlbk_no=@chlbk_no
				--GL
				if (@row_id=1)
					begin
						exec sp_voucher_gp @com_id,@br_id,@m_yr_id,@mgp_id,@usr_id,@aud_ip,@aud_des
					end
end

go	
--select * from m_stk where stk_frm='stk_gatepass'


--Delete
alter proc del_t_dgp(@mgp_id int)
as
begin
	update m_chlbk set chlbk_act=1 where chlbk_no in (select chlbk_no from t_dgp where mgp_id=@mgp_id)
	delete from m_stk where t_id=@mgp_id and stk_frm='stk_gatepass'
	delete from t_dgp where mgp_id=@mgp_id

end

		


