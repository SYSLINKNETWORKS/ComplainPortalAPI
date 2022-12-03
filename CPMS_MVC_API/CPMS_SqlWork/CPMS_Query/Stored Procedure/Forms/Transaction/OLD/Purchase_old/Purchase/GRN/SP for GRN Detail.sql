USE phm
go
--alter table t_dgrn add dgrn_man datetime
--alter table m_stk add com_id char(2),br_id char(3)
--alter table m_stk add constraint FK_MSTK_COMID foreign key (com_id) references m_com(com_id)
--alter table m_stk add constraint FK_MSTK_BRID foreign key (br_id) references m_br(br_id)
--update m_stk set com_id='01',br_id='01'
--select * from m_stk where stk_dat='08/04/2014' and itm_id=5

--alter table t_dgrn add itmqty_id int,sca_id int,dgrn_stdsiz float
--ALTER table t_dgrn add constraint FK_Tdgrn_itmqtyid foreign key (itmqty_id) references m_itmqty(itmqty_id)
--ALTER table t_dgrn add constraint FK_Tdgrn_scaid foreign key (sca_id) references m_sca(sca_id)
--alter table t_dgrn add dgrn_bat varchar(100)
--select * from t_dgrn
--alter table t_dgrn add coun_id int,man_id int


alter proc ins_t_dgrn(@ck_mandat bit,@dgrn_man datetime,@ck_dat bit,@dgrn_exp datetime,@dgrn_stdsiz float,@dgrn_qty float,@dgrn_acc float,@dgrn_nqty float,@dgrn_rat float,@dgrn_amt float,@mgrn_id int,@mpo_id int,@titm_id int,@itmqty_id int,@sca_id int,@m_yr_id char(2),@dgrn_bat varchar(100),@coun_id int,@man_id int)
as
declare
@dgrn_id int,
@grn_qty int,
@po_qty int,
--@po_id int,
@qty int,
@stk_dat datetime,
@wh_id int,
@bd_id int,
@mgrn_rat float,
@mgrn_typ char(1),
@dgrn_trat float,
@dgrn_tamt float,
@cur_id int,
@com_id char(2),
@br_id char(3),
@titm_snm varchar(100),
@stk_qty float,
@stk_acc float,
@sca_met float,
@mgrn_act bit,
@itm_cat char(1),
@lot_id int
begin
	set @com_id=(select com_id from t_mgrn where mgrn_id=@mgrn_id)
	set @br_id=(select br_id from t_mgrn where mgrn_id=@mgrn_id)
	set @cur_id=(select cur_id from t_mgrn where mgrn_id=@mgrn_id)
	set @mgrn_rat=(select mgrn_rat from t_mgrn where mgrn_id=@mgrn_id)
	set @dgrn_trat=@dgrn_rat*@mgrn_rat
	set @dgrn_tamt=@dgrn_amt*@mgrn_rat
	set @stk_dat=(select mgrn_dat from t_mgrn where mgrn_id=@mgrn_id)
	set @wh_id=(select wh_id from t_mgrn where mgrn_id=@mgrn_id)
	set @bd_id=(select bd_id from t_itm where titm_id=@titm_id)
	set @sca_met=(select case sca_met when 0 then 1 else sca_met end as [sca_met] from m_sca where sca_id=@sca_id)
	set @itm_cat=(select itm_cat from v_titm where titm_id=@titm_id)
	set @mgrn_typ=(select mgrn_typ from t_mgrn where mgrn_id=@mgrn_id)
	set @lot_id=(select lot_id from t_mgrn where mgrn_id=@mgrn_id)
	

	set @dgrn_id =(select max(dgrn_id)+1 from t_dgrn)
		if @dgrn_id is null
		begin
			set @dgrn_id=1
		end

	if (@ck_mandat=0)
		begin
			set @dgrn_man=null
		end

	if (@ck_dat=0)
		begin
			set @dgrn_exp=null
		end

	if (@itm_cat<>'F')
		begin
			set @itmqty_id =null
			set @dgrn_stdsiz =0
		end
		
	--Expiry Date
    set @dgrn_exp= (SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@dgrn_exp)+1,0)))
	--	--Lot Insert
	--set @lot_nam =rtrim(cast(@mgrn_id as varchar(100)))+'-'+rtrim(isnull(@sup_snm,''))+'-'+rtrim(isnull(@titm_snm,''))
	--exec ins_m_lot @lot_nam ,@mgrn_act,@mgrn_typ,@lot_id_out =@lot_id output

	insert into t_dgrn
		(dgrn_id,dgrn_man,dgrn_exp,dgrn_stdsiz,dgrn_qty,dgrn_acc,dgrn_nqty,dgrn_rat,dgrn_trat,dgrn_amt,dgrn_tamt,mgrn_id,titm_id,itmqty_id,sca_id,m_yr_id,dgrn_bat,coun_id,man_id)
		values
		(@dgrn_id,@dgrn_man,@dgrn_exp,@dgrn_stdsiz,@dgrn_qty,@dgrn_acc,@dgrn_nqty,@dgrn_rat,@dgrn_trat,@dgrn_amt,@dgrn_tamt,@mgrn_id,@titm_id,@itmqty_id,@sca_id,@m_yr_id,@dgrn_bat,@coun_id,@man_id)


    
    
	if (@dgrn_rat=0)
		begin
			set @dgrn_trat=(select case when sum(stk_qty)=0 then 0 else sum(stk_qty*stk_trat)/sum(stk_qty) end from m_Stk where  stk_frm in ('t_itm','GRNQ') and itm_id=@titm_id and stk_dat<=@stk_dat  )
			set @dgrn_rat=@dgrn_trat/@mgrn_rat
			set @dgrn_amt=@dgrn_qty*@dgrn_rat
		end
	--Stock	
	set @stk_qty=round(@dgrn_qty/@sca_met,2)
	set @stk_acc=round(@dgrn_acc/@sca_met,2)
	insert into m_stk(com_id,br_id,t_id,itm_id,itmqty_id,stk_stdsiz,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,lot_id) 
		values(@com_id,@br_id,@mgrn_id,@titm_id,@itmqty_id,@dgrn_stdsiz,@stk_qty,@stk_acc,@dgrn_rat,'S','R','GRNQ',@stk_dat,@wh_id,@bd_id,@m_yr_id,@dgrn_exp,@cur_id,@mgrn_rat,@lot_id)

	set @po_qty=(select sum(dpo_qty) from t_dpo where mpo_id=@mpo_id and titm_id=@titm_id)
	set @grn_qty=(select sum(dgrn_qty) from t_mgrn inner join t_dgrn on t_mgrn.mgrn_id=t_dgrn.mgrn_id where mpo_id=@mpo_id and titm_id=@titm_id)
			if ((@po_qty-@grn_qty)<=0)
				begin
					update 	t_dpo set dpo_st=1 where titm_id=@titm_id and mpo_id=@mpo_id
				end
	--set @po_id=(select distinct dpo_id from t_dpo where mpo_id=@mpo_id and titm_id=@titm_id)
	set @po_qty=(select distinct sum(dpo_qty) from t_dpo where mpo_id=@mpo_id )
	set @grn_qty=(select distinct sum(dgrn_qty) from  t_mgrn inner join t_dgrn on t_mgrn.mgrn_id=t_dgrn.mgrn_id where mpo_id=@mpo_id )
		set @qty= @po_qty-@grn_qty
			--print @qty
			if @qty<=0
				begin		
					update t_mpo set mpo_act=1,mpo_typ='S' where mpo_id=@mpo_id
				end



end

go
--Delete
alter proc del_t_dgrn(@mgrn_id int)
as
declare
@mpo_id int
begin
	set @mgrn_id=(select distinct mgrn_id from t_dgrn where mgrn_id=@mgrn_id)
	set @mpo_id=(select mpo_id from t_mgrn where mgrn_id=@mgrn_id)
	
	update t_dpo set dpo_st=0 where mpo_id=@mpo_id
	update t_mpo set mpo_act=0,mpo_typ='U' where mpo_id=@mpo_id and mpo_typ='S'
	
	--Stock
	delete from m_stk where t_id=@mgrn_id and stk_frm='GRNQ'

	delete from t_dgrn where mgrn_id=@mgrn_id
end

