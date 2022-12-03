USE PHM
go
--update t_dqc set dqc_acc=0,dqc_rat=52,dqc_trat=52,dqc_amt=26000,dqc_tamt=26000 where mqc_id=2


--alter table t_dqc add dqc_man datetime
--alter table m_stk add com_id char(2),br_id char(3)
--alter table m_stk add constraint FK_MSTK_COMID foreign key (com_id) references m_com(com_id)
--alter table m_stk add constraint FK_MSTK_BRID foreign key (br_id) references m_br(br_id)
--update m_stk set com_id='01',br_id='01'
--select * from m_stk where stk_dat='08/04/2014' and itm_id=5

--alter table t_dqc add itmqty_id int,sca_id int,dqc_stdsiz float
--ALTER table t_dqc add constraint FK_Tdqc_itmqtyid foreign key (itmqty_id) references m_itmqty(itmqty_id)
--ALTER table t_dqc add constraint FK_Tdqc_scaid foreign key (sca_id) references m_sca(sca_id)
--alter table t_dqc add dqc_bat varchar(100)
--alter table t_dqc add dqc_nqty float
--alter table t_dqc add dqc_acc float
--alter table t_dqc add coun_id int,man_id int
--alter table t_dqc add dqc_appqty float
--alter table t_dqc add dqc_ar int
--alter table t_dqc add dqc_redat datetime
--alter table t_dqc add dqc_res varchar(100)
--select * from t_dqc
--alter table t_dqc add dqc_ckredat bit
--update t_dqc set dqc_ckredat=0

--alter table t_dqc add dqc_samqty float
--update t_dqc set dqc_samqty=0


alter proc ins_t_dqc(@ck_mandat bit,@dqc_man datetime,@ck_dat bit,@dqc_exp datetime,@dqc_stdsiz float,@dqc_qty float,@dqc_samqty float,@mqc_id int,@mgrn_id int,@titm_id int,@itmqty_id int,@sca_id int,@m_yr_id char(2),@dqc_bat varchar(100),@dqc_res varchar(100),@dqc_rmk varchar(1000),@coun_id int,@man_id int,@dqc_appqty float,@ck_redat bit,@dqc_redat datetime)
as
declare
@dqc_id int,
@dqc_rat float,
@dqc_amt float,
@qc_qty int,
@grn_qty int,
@dqc_ar int,
@qty int,
@stk_dat datetime,
@wh_id int,
@bd_id int,
@mqc_rat float,
@mqc_typ char(1),
@dqc_trat float,
@dqc_tamt float,
@cur_id int,
@com_id char(2),
@br_id char(3),
@titm_snm varchar(100),
@stk_qty float,
@stk_acc float,
@sca_met float,
@mqc_act bit,
@itm_cat char(1),
@lot_id int,
@dqc_nqty float
begin
	set @com_id=(select com_id from t_mqc where mqc_id=@mqc_id)
	set @br_id=(select br_id from t_mqc where mqc_id=@mqc_id)
	set @cur_id=(select cur_id from t_mqc where mqc_id=@mqc_id)
	set @mqc_rat=(select mqc_rat from t_mqc where mqc_id=@mqc_id)
	set @dqc_rat=(select dgrn_rat from t_dgrn where mgrn_id=@mgrn_id and titm_id=@titm_id)
	set @dqc_amt=@dqc_rat*@dqc_qty
	set @dqc_nqty=@dqc_qty
	set @dqc_trat=@dqc_rat*@mqc_rat
	set @dqc_tamt=@dqc_amt*@mqc_rat
	set @stk_dat=(select mqc_dat from t_mqc where mqc_id=@mqc_id)
	set @wh_id=(select wh_id from t_mqc where mqc_id=@mqc_id)
	set @bd_id=(select bd_id from t_itm where titm_id=@titm_id)
	set @sca_met=(select case sca_met when 0 then 1 else sca_met end as [sca_met] from m_sca where sca_id=@sca_id)
	set @itm_cat=(select itm_cat from v_titm where titm_id=@titm_id)
	set @mqc_typ=(select mqc_typ from t_mqc where mqc_id=@mqc_id)
	set @lot_id=(select lot_id from t_mqc where mqc_id=@mqc_id)
	

	set @dqc_id =(select max(dqc_id)+1 from t_dqc)
		if @dqc_id is null
		begin
			set @dqc_id=1
		end
		set @dqc_ar =(select max(dqc_ar)+1 from t_dqc)
		if @dqc_ar is null
		begin
			set @dqc_ar=1
		end

	if (@ck_mandat=0)
		begin
			set @dqc_man=null
		end

	if (@ck_dat=0)
		begin
			set @dqc_exp=null
		end
	if (@ck_redat=0)
		begin
			set @dqc_redat=null
		end

	if (@itm_cat<>'F')
		begin
			set @itmqty_id =null
			set @dqc_stdsiz =0
		end
		if (@man_id=0)
		begin
			set @man_id=null
		end
		if (@coun_id=0)
		begin
			set @coun_id=null
		end
		if (@sca_id=0)
		begin
			set @sca_id=null
		end
	--Expiry Date
    set @dqc_exp= (SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@dqc_exp)+1,0)))
	--	--Lot Insert
	--set @lot_nam =rtrim(cast(@mqc_id as varchar(100)))+'-'+rtrim(isnull(@sup_snm,''))+'-'+rtrim(isnull(@titm_snm,''))
	--exec ins_m_lot @lot_nam ,@mqc_act,@mqc_typ,@lot_id_out =@lot_id output

	insert into t_dqc
		(dqc_id,dqc_man,dqc_exp,dqc_stdsiz,dqc_qty,dqc_samqty,dqc_nqty,dqc_rat,dqc_trat,dqc_amt,dqc_tamt,mqc_id,titm_id,itmqty_id,sca_id,m_yr_id,dqc_bat,dqc_res,dqc_rmk,coun_id,man_id,dqc_appqty,dqc_ar,dqc_redat)
		values
		(@dqc_id,@dqc_man,@dqc_exp,@dqc_stdsiz,@dqc_qty,@dqc_samqty,@dqc_nqty,@dqc_rat,@dqc_trat,@dqc_amt,@dqc_tamt,@mqc_id,@titm_id,@itmqty_id,@sca_id,@m_yr_id,@dqc_bat,@dqc_res,@dqc_rmk,@coun_id,@man_id,@dqc_appqty,@dqc_ar,@dqc_redat)


    
    
	if (@dqc_rat=0)
		begin
			set @dqc_trat=(select case when sum(stk_qty)=0 then 0 else sum(stk_qty*stk_trat)/sum(stk_qty) end from m_Stk where  stk_frm in ('t_itm','GRN') and itm_id=@titm_id and stk_dat<=@stk_dat  )
			set @dqc_rat=@dqc_trat/@mqc_rat
			set @dqc_amt=@dqc_appqty*@dqc_rat
		end
	--Stock	
	set @stk_qty=@dqc_appqty
	set @stk_acc=0
	insert into m_stk(com_id,br_id,t_id,itm_id,itmqty_id,stk_stdsiz,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,lot_id) 
		values(@com_id,@br_id,@mqc_id,@titm_id,@itmqty_id,@dqc_stdsiz,@stk_qty,@stk_acc,@dqc_rat,'S','R','GRN',@stk_dat,@wh_id,@bd_id,@m_yr_id,@dqc_exp,@cur_id,@mqc_rat,@lot_id)

	set @grn_qty=(select sum(dgrn_appqty) from t_dgrn where mgrn_id=@mgrn_id and titm_id=@titm_id)
	set @qc_qty=(select sum(dqc_appqty) from t_mqc inner join t_dqc on t_mqc.mqc_id=t_dqc.mqc_id where mgrn_id=@mgrn_id and titm_id=@titm_id)
			if ((@grn_qty-@qc_qty)<=0)
				begin
					update 	t_dgrn set dgrn_st=1 where titm_id=@titm_id and mgrn_id=@mgrn_id
				end
	--set @po_id=(select distinct dpo_id from t_dpo where mpo_id=@mpo_id and titm_id=@titm_id)
	set @grn_qty=(select distinct sum(dgrn_appqty) from t_dgrn where mgrn_id=@mgrn_id )
	set @qc_qty=(select distinct sum(dqc_appqty) from  t_mqc inner join t_dqc on t_mqc.mqc_id=t_dqc.mqc_id where mgrn_id=@mgrn_id )
		set @qty= @grn_qty-@qc_qty
			--print @qty
			--if @qty<=0
			--	begin		
			--		update t_mgrn set mgrn_act=1,mgrn_typ='S' where mgrn_id=@mgrn_id
			--	end



end

go
--Delete
alter proc del_t_dqc(@mqc_id int)
as
declare
@mgrn_id int
begin
	set @mqc_id=(select distinct mqc_id from t_dqc where mqc_id=@mqc_id)
	set @mgrn_id=(select mgrn_id from t_mqc where mqc_id=@mqc_id)
	
	update t_dgrn set dgrn_st=0 where mgrn_id=@mgrn_id
	update t_mgrn set mgrn_act=0,mgrn_typ='U' where mgrn_id=@mgrn_id and mgrn_typ='S'
	
	--Stock
	delete from m_stk where t_id=@mqc_id and stk_frm='GRN'

	delete from t_dqc where mqc_id=@mqc_id
end

