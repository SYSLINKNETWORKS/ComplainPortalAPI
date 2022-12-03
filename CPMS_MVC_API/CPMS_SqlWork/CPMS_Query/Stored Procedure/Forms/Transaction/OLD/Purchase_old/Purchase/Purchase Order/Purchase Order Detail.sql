USE ZSONS
GO
--alter table t_dpo add dpo_man datetime,dpo_rmk varchar(250)
--update t_dpo set titm_img=0
--alter table t_dpo add itmqty_id int,sca_id int,dpo_stdsiz float
--ALTER table t_dpo add constraint FK_Tdpo_itmqtyid foreign key (itmqty_id) references m_itmqty(itmqty_id)
--ALTER table t_dpo add constraint FK_Tdpo_scaid foreign key (sca_id) references m_sca(sca_id)

--Insert
alter proc ins_t_dpo(@ck_mandat bit,@dpo_man datetime,@ck_dat bit,@dpo_exp datetime,@dpo_stdsiz float,@dpo_qty float,@dpo_rat float,@dpo_amt float,@dpo_rmk varchar(250),@titm_id int,@itmqty_id int,@sca_id int,@titm_img bit ,@mpo_id int,@m_yr_id char(2))
as
declare
@mpr_id int,
@dpo_id int,
@pr_qty float,
@pr_itm_count int,
@po_qty float,
@po_itm_count int,
@qty float,
@rat float,
@dpo_trat float,
@dpo_tamt float,
@itm_cat char(1)
begin
	set @itm_cat=(select itm_cat from v_titm where titm_id=@titm_id)
	set @rat=(select mpo_rat from t_mpo where mpo_id=@mpo_id)
	set @dpo_trat=@dpo_rat*@rat
	set @dpo_tamt=@dpo_amt*@rat
	set @mpr_id=(select mpr_id from t_mpo where mpo_id=@mpo_id)
	set @dpo_id=(select max(dpo_id)+1 from t_dpo)
		if @dpo_id is null
			begin
				set @dpo_id=1
			end
			--Manufacturing
	if (@ck_mandat=0)
		begin
			set @dpo_man=null
		end
		--Expiry
	if (@ck_dat=0)
		begin
			set @dpo_exp=null
		end
	if (@itm_cat<>'F')
		begin
			set @itmqty_id =null
			set @dpo_stdsiz =0
		end

	insert into t_dpo(dpo_id,dpo_man,dpo_exp,dpo_stdsiz,dpo_qty,dpo_rat,dpo_trat,dpo_amt,dpo_tamt,dpo_rmk,mpo_id,titm_id,itmqty_id,sca_id,dpo_st,m_yr_id,titm_img)
			values(@dpo_id,@dpo_man,@dpo_exp,@dpo_stdsiz,@dpo_qty,@dpo_rat,@dpo_trat,@dpo_amt,@dpo_tamt,@dpo_rmk,@mpo_id,@titm_id,@itmqty_id,@sca_id,0,@m_yr_id,@titm_img)

	set @pr_qty=(select sum(dpr_qty) from t_dpr where mpr_id=@mpr_id and titm_id=@titm_id)
	set @po_qty=(select sum(dpo_qty) from t_mpo inner join t_dpo on t_mpo.mpo_id=t_dpo.mpo_id where mpr_id=@mpr_id and titm_id=@titm_id)
			if (@pr_qty-@po_qty)<=0
				begin
					update 	t_dpr set dpr_st=1 where titm_id=@titm_id and mpr_id=@mpr_id
				end
	set @mpr_id=(select distinct mpr_id from t_dpr where mpr_id=@mpr_id and titm_id=@titm_id)
	set @pr_qty=(select distinct sum(dpr_qty) from t_dpr where mpr_id=@mpr_id)
	set @po_qty=(select distinct sum(dpo_qty) from t_dpo where mpo_id in (select mpo_id from t_mpo where mpr_id=@mpr_id))
	set @pr_itm_count=(select count(titm_id) from t_dpr where mpr_id=@mpr_id)
	set @po_itm_count=(select count(titm_id) from t_dpo where mpo_id in (select mpo_id from t_mpo where mpr_id=@mpr_id))
		set @qty= (@pr_qty-@po_qty)
			print @qty
			if (@qty<=0 and @pr_itm_count=@po_itm_count)
				begin		
					update t_mpr set mpr_act=1, mpr_typ='S' where mpr_id=@mpr_id
				end
end

go
--Delete
--exec del_t_dpo 4

alter proc del_t_dpo(@mpo_id int)
as
declare
@mpr_id int
begin
	set @mpr_id=(select mpr_id from t_mpo where mpo_id=@mpo_id)
	update t_dpr set dpr_st=0 where mpr_id=@mpr_id and titm_id in(select titm_id from t_dpo where mpo_id=@mpo_id)
	update t_mpr set mpr_act=0,mpr_typ='U' where mpr_id=@mpr_id
	delete from t_dpo where mpo_id=@mpo_id
end

 



		
--SELECT * from t_mgrn
