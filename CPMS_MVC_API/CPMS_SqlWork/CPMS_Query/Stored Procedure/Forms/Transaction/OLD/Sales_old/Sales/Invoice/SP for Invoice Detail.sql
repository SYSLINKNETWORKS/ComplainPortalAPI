USE phm
GO
--alter table t_dinv add mdc_id int
--alter table t_dinv add constraint FK_Dinv_MDCID foreign key (mdc_id) references t_mdc (mdc_id)

--alter table t_dinv add dinv_stdsiz float,sca_id int
--alter table t_dinv add constraint FK_dinv_SCAID foreign key (sca_id) references m_Sca(sca_id)
--update t_dinv set dinv_stdsiz=(select master_titm_qty from t_itm where t_itm.titm_id=t_dinv.titm_id),sca_id=(select inner_sca_id from t_itm where t_itm.titm_id=t_dinv.titm_id)
--alter table t_dinv add dinv_gstper float,dinv_gstamt float,dinv_fedper float,dinv_fedamt float
--update t_dinv set dinv_gstper=0,dinv_gstamt=0,dinv_fedper=0,dinv_fedamt=0
--alter table t_dinv add dinv_tax bit
--update t_dinv set dinv_tax=0

--update t_dinv set dinv_tax=1 where minv_id in (select minv_id from t_minv where minv_cktax=1)

--alter table t_dinv add dinv_taxqty float,dinv_taxamt float,dinv_taxdisamt float,dinv_taxnamt float
--update t_dinv set dinv_taxqty=0,dinv_taxamt=0,dinv_taxdisamt=0,dinv_taxnamt=0
--update t_dinv set dinv_taxqty=dinv_qty,dinv_taxamt=dinv_amt,dinv_taxdisamt=dinv_disamt,dinv_taxnamt=dinv_namt where dinv_tax=1

--select * from t_ddc where mdc_id=17

--select * from m_stk where stk_frm='DC' and t_id=17

--alter table m_stk add stk_tax bit default 0
--update m_stk set stk_tax=0
--alter table t_mso add mso_cktax bit default 0
--update t_mso set mso_cktax=0

--alter table t_dso add dso_tax bit default 0, dso_taxqty float default 0
--update t_dso set dso_tax=0,dso_taxqty=0

--alter table t_dinv add dinv_taxrat float
--update t_dinv set dinv_taxrat=dinv_rat
--select * from t_dso
--alter table t_dso add dso_taxrat float
--update t_dso set dso_taxrat=dso_rat
--alter table m_stk add stk_taxrat float
--alter table t_dinv add dinv_bqty float
--alter table t_dinv add dinv_schamt float
--alter table t_dinv add free_titm_id int
--alter table t_dinv add dinv_freeqty float

--alter table t_dinv add dinv_bat varchar(100)
--alter table t_dinv add dinv_mandat datetime
--alter table t_dinv add dinv_expdat datetime

--Insert
alter proc ins_t_dinv(@dinv_tax bit,@dinv_qty float,@dinv_taxqty float,@dinv_rat float,@dinv_taxrat float,@dinv_amt float,@dinv_taxamt float,@dinv_disper float,@dinv_disamt float,@dinv_taxdisamt float,@dinv_othamt float,@dinv_gstper float,@dinv_gstamt float,@dinv_fedper float,@dinv_fedamt float,@dinv_namt float,@dinv_taxnamt float,@minv_id int,@titm_id int,@itmqty_id int,@sca_id int,@dinv_stdsiz float,@row_id int,@mdc_id int,@dinv_bqty float,@dinv_schamt float,@free_titm_id int,@dinv_freeqty float,@dinv_bat varchar(100),@dinv_mandat datetime,@dinv_expdat datetime)
as
declare
@dinv_id int,
@qty int,
@dc_qty int,
@inv_qty int,
@ddc_qty float,
@mdc_qty float,
@minv_qty float,
@minv_cktax bit,
@mso_id int
begin

	set @minv_cktax=(select minv_cktax from t_minv where minv_id=@minv_id)
	set @mso_id=(select mso_id from t_mdc where mdc_id=@mdc_id)
	set @dinv_id=(select max(dinv_id)+1 from t_dinv)

		if @dinv_id is null
			begin	
				set @dinv_id=1
			end
		if (@dinv_tax =0)
				begin
					set @dinv_taxdisamt =0
					set @dinv_gstper=0
					set @dinv_gstamt=0
					set @dinv_fedper=0
					set @dinv_fedamt=0
					set @dinv_taxqty=0
					set @dinv_taxamt=0
					set @dinv_taxnamt=0
				end
			else if (@dinv_tax=1)
				begin
					--SO
					update t_mso set mso_cktax=1 where mso_id=@mso_id
					update t_dso set dso_tax=1,dso_taxqty=@dinv_taxqty,dso_taxrat=@dinv_taxrat where mso_id=@mso_id and titm_id=@titm_id and itmqty_id=@itmqty_id and dso_stdsiz=@dinv_stdsiz
					--DC
					update t_mdc set mdc_cktax=1 where mdc_id=@mdc_id
					update t_ddc set ddc_tax=1,ddc_taxqty=@dinv_taxqty where mdc_id=@mdc_id and titm_id=@titm_id and itmqty_id=@itmqty_id and ddc_stdsiz=@dinv_stdsiz
					--Stock
					update m_stk set stk_tax=1,stk_taxqty=-@dinv_taxqty,stk_taxrat=@dinv_taxrat where t_id=@mdc_id and itm_id=@titm_id and itmqty_id=@itmqty_id and stk_stdsiz=@dinv_stdsiz and stk_frm='DC'
				end
			insert into t_dinv(dinv_id,dinv_tax,dinv_qty,dinv_taxqty,dinv_rat,dinv_taxrat,dinv_amt,dinv_taxamt,dinv_disper,dinv_disamt,dinv_taxdisamt,dinv_othamt,dinv_gstper,dinv_gstamt,dinv_fedper,dinv_fedamt,dinv_namt,dinv_taxnamt,minv_id,titm_id,itmqty_id,mdc_id,sca_id,dinv_stdsiz,dinv_bqty,dinv_schamt,free_titm_id,dinv_freeqty,dinv_bat,dinv_mandat,dinv_expdat)
			values(@dinv_id,@dinv_tax,@dinv_qty,@dinv_taxqty,@dinv_rat,@dinv_taxrat,@dinv_amt,@dinv_taxamt,@dinv_disper,@dinv_disamt,@dinv_taxdisamt,@dinv_othamt,@dinv_gstper,@dinv_gstamt,@dinv_fedper,@dinv_fedamt,@dinv_namt,@dinv_taxnamt,@minv_id,@titm_id,@itmqty_id,@mdc_id,@sca_id,@dinv_stdsiz,@dinv_bqty,@dinv_schamt,@free_titm_id,@dinv_freeqty,@dinv_bat,@dinv_mandat,@dinv_expdat)
			


				--Update dc Status
			set @ddc_qty=(select sum(ddc_qty) from t_ddc where mdc_id=@mdc_id and titm_id=@titm_id and itmqty_id=@itmqty_id and ddc_stdsiz=@dinv_stdsiz)
			set @dinv_qty=(select sum(dinv_qty) from t_dinv where minv_id=@minv_id and titm_id=@titm_id and itmqty_id=@itmqty_id and dinv_stdsiz=@dinv_stdsiz)
			if((@ddc_qty-@dinv_qty)=0)
				begin
					update t_ddc set ddc_st=1 where mdc_id=@mdc_id and titm_id=@titm_id and itmqty_id=@itmqty_id and ddc_stdsiz=@dinv_stdsiz
				end
			set @mdc_qty=(select SUM(ddc_qty) from t_ddc where mdc_id=@mdc_id )
			set @minv_qty=(select SUM(dinv_qty) from t_dinv where minv_id=@minv_id )
			if((@mdc_qty-@minv_qty)=0)
				begin
					update t_mdc set mdc_act=1,mdc_typ='S' where mdc_id=@mdc_id
				end

	--Voucher
	if (@row_id =1)
		begin	
			exec sp_voucher_inv @minv_id
		end
end
		
go


--Delete
alter proc del_t_dinv(@minv_id int)
as
declare
@mdc_id int,
@mso_id int
begin

	--set @mdc_id=(select mdc_id from t_minv where minv_id=@minv_id)
	--set @mso_id=(select mso_id from t_mdc where mdc_id=@mdc_id)

	----Tax Start
	----SO
	--update t_mso set mso_cktax=0 where mso_id=@mso_id
	--update t_dso set dso_tax=0,dso_taxqty=0 where mso_id=@mso_id and titm_id in (select titm_id from t_dinv where mdc_id=@mdc_id) and itmqty_id in (select itmqty_id from t_dinv where mdc_id=@mdc_id) and dso_stdsiz in (select dinv_stdsiz from t_dinv where mdc_id=@mdc_id)
	----DC
	--update t_mdc set mdc_cktax=0 where mdc_id=@mdc_id
	--update t_ddc set ddc_tax=0,ddc_taxqty=0 where mdc_id=@mdc_id and titm_id in (select titm_id from t_dinv where mdc_id=@mdc_id) and itmqty_id in (select itmqty_id from t_dinv where mdc_id=@mdc_id) and ddc_stdsiz in (select dinv_stdsiz from t_dinv where mdc_id=@mdc_id)
	----STOCK
	--update m_stk set stk_tax=0,stk_taxqty=0 where t_id=@mdc_id and itm_id in (select titm_id from t_dinv where mdc_id=@mdc_id) and stk_frm='DC'
	----Tax End	
					
	--update t_ddc set ddc_st=1 where mdc_id in (select mdc_id from t_dinv where minv_id=@minv_id) and titm_id in (select titm_id from t_dinv where minv_id=@minv_id) and itmqty_id in (select itmqty_id from t_dinv where minv_id=@minv_id) and ddc_stdsiz in (select dinv_stdsiz from t_dinv where minv_id=@minv_id)
	--update t_mdc set mdc_act=0,mdc_typ='U' where mdc_id in (select mdc_id from t_dinv where minv_id=@minv_id) 
	declare @mvch_dt datetime,@mvch_pto varchar(100),@dpt_id char(2),@typ_id char(2),@mvch_app char(1),@mvch_id char(12),@mvch_oldvoucherno char(12),@yr_id char(2),@mvch_cb char(2)
declare  inv_dc_1  cursor for
	select distinct mso_id,t_dinv.mdc_id from t_dinv inner join t_mdc on t_dinv.mdc_id=t_mdc.mdc_id where minv_id=@minv_id
	OPEN inv_dc_1
		FETCH NEXT FROM inv_dc_1
		INTO @mso_id,@mdc_id
			WHILE @@FETCH_STATUS = 0
			BEGIN			
				--Tax Start
				--SO
				update t_mso set mso_cktax=0 where mso_id= @mso_id
				update t_dso set dso_tax=0,dso_taxqty=0 where mso_id=@mso_id and titm_id in (select titm_id from t_dinv where mdc_id=@mdc_id) and itmqty_id in (select itmqty_id from t_dinv where mdc_id=@mdc_id) and dso_stdsiz in (select dinv_stdsiz from t_dinv where mdc_id=@mdc_id)
				--DC
				update t_mdc set mdc_cktax=0 where mdc_id=@mdc_id
				update t_ddc set ddc_tax=0,ddc_taxqty=0 where mdc_id=@mdc_id and titm_id in (select titm_id from t_dinv where mdc_id=@mdc_id) and itmqty_id in (select itmqty_id from t_dinv where mdc_id=@mdc_id) and ddc_stdsiz in (select dinv_stdsiz from t_dinv where mdc_id=@mdc_id)
				--STOCK
				update m_stk set stk_tax=0,stk_taxqty=0 where t_id=@mdc_id and itm_id in (select titm_id from t_dinv where mdc_id=@mdc_id) and stk_frm='DC'
				--Tax End	
								
				update t_ddc set ddc_st=1 where mdc_id in (select mdc_id from t_dinv where minv_id=@minv_id) and titm_id in (select titm_id from t_dinv where minv_id=@minv_id) and itmqty_id in (select itmqty_id from t_dinv where minv_id=@minv_id) and ddc_stdsiz in (select dinv_stdsiz from t_dinv where minv_id=@minv_id)
				update t_mdc set mdc_act=0,mdc_typ='U' where mdc_id in (select mdc_id from t_dinv where minv_id=@minv_id) 
	
		
			FETCH NEXT FROM inv_dc_1
			INTO @mso_id,@mdc_id
	end
	CLOSE inv_dc_1
	DEALLOCATE inv_dc_1
	exec del_t_dinv_dc @minv_id
	delete from t_dinv where minv_id=@minv_id
end
