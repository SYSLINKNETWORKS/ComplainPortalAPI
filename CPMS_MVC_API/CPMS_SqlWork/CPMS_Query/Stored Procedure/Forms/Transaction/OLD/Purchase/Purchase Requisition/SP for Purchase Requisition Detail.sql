USE phm
go
--alter table t_dpr add dpr_man datetime

--alter table t_dpr add itmqty_id int,sca_id int,dpr_stdsiz float
--ALTER table t_dpr add constraint FK_TDPR_itmqtyid foreign key (itmqty_id) references m_itmqty(itmqty_id)
--ALTER table t_dpr add constraint FK_TDPR_scaid foreign key (sca_id) references m_sca(sca_id)
--alter table t_dpr add dpr_appqty float
--update t_dpr set dpr_appqty=0
--Insert
alter proc ins_t_dpr(@dpr_stdsiz float,@dpr_qty float,@ck_mandat bit,@dpr_man datetime,@ck_dat bit,@dpr_exp datetime,@mpr_id int,@titm_id int,@itmqty_id int,@sca_id int,@dpr_appqty float)
as
declare
@dpr_id int,
@itm_cat char(1)
begin
	set @itm_cat=(select itm_cat from v_titm where titm_id=@titm_id)
	set @dpr_id=(select max(dpr_id)+1 from t_dpr)
		if @dpr_id is null
			begin
				set @dpr_id=1
			end
	--Manufacturing Date
	if (@ck_mandat=0)
		begin
			set @dpr_man=null
		end
	--Expiry Date
	if (@ck_dat=0)
		begin
			set @dpr_exp=null
		end
	if (@itm_cat<>'F')
		begin
			set @itmqty_id =null
			set @dpr_stdsiz =0
		end
	insert into t_dpr(dpr_id,dpr_qty,dpr_stdsiz,dpr_man,dpr_exp,mpr_id,titm_id,itmqty_id,sca_id,dpr_st,dpr_appqty)
			values(@dpr_id,@dpr_qty,@dpr_stdsiz,@dpr_man,@dpr_exp,@mpr_id,@titm_id,@itmqty_id,@sca_id,0,@dpr_appqty)
end

go	


--Delete
alter proc del_t_dpr(@mpr_id int)
as
begin
	delete from t_dpr where mpr_id=@mpr_id

end

		


