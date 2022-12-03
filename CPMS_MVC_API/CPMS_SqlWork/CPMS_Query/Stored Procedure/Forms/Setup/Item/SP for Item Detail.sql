USE meiji_rusk
GO


--alter table t_itm drop column ger_id int,purcod_id int,man_id int,coun_id int,titm_rat float,titm_rrat float,titm_trat float,titm_drat float
--alter table t_itm add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)
--select * from t_itm

--alter table t_itm drop column purcod_id,titm_rat ,titm_rrat ,titm_trat ,titm_drat
--alter table t_itm add itmgp_id int,titm_cl float,titm_cw float,titm_ch float,titm_space float

--update t_itm set itmgp_id=1,itmsubmas_id=1
--update t_itm set ger_id=1,man_id=1,coun_id=1

--alter table t_itm add titm_dat datetime,titm_renewdat datetime,titm_exp datetime
--alter table t_itm add titm_reg varchar(100)
--alter table t_itm add sca_id_dos int,titm_dosqty float
--alter table t_itm add sca_id_pack int
--update t_itm set sca_id_dos=1,titm_dosqty=0,sca_id_pack=1
--update t_itm set titm_dat=GETDATE(),titm_renewdat=GETDATE(),titm_exp=GETDATE(),titm_reg='0'
--update t_itm set titm_cl=0,titm_cw=0,titm_ch=0,titm_space=0

--alter table t_itm add str_id int
--alter table t_itm add constraint FK_TITMID_STRID foreign key (str_id) references m_str(str_id)
--alter table t_itm add constraint FK_TITMID_scaidpack foreign key (sca_id_pack) references m_sca(sca_id)
--alter table t_itm add constraint FK_TITMID_scaiddos foreign key (sca_id_dos) references m_sca(sca_id)
--alter table t_itm add constraint FK_TITMID_itmgpid foreign key (itmgp_id) references m_itmgp(itmgp_id)
--alter table t_itm add constraint FK_TITMID_itmsubcatid foreign key (itmsub_id) references m_itmsub(itmsub_id)
--alter table t_itm add constraint FK_TITMID_gerid foreign key (ger_id) references m_ger(ger_id)

--alter table t_itm add titm_bartyp char(1)
--alter table t_itm add titm_ckbar bit
--select * from t_itm where com_id is null

--Insert
alter proc ins_t_itm(@com_id char(2),@br_id char(3),@titm_nam varchar(100),@titm_snm varchar(10),@itm_id int,@sca_id int,@titm_ckbar bit,@titm_bar varchar(100),@inner_titm_qty float,@inner_sca_id int,@master_titm_qty float,@master_sca_id int,@man_sca_id int,@man_qty float,@titm_mlvl float,@titm_rlvl float,@titm_act bit,@titm_ckscr bit,@titm_typ char,@titm_idold varchar(1000),@ger_id int,@itmgp_id int,@man_id int,@coun_id int,@bd_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@str_id int,@titm_cl float,@titm_cw float,@titm_ch float,@titm_space float,@titm_dat datetime,@titm_renewdat datetime,@titm_exp datetime,@titm_reg varchar(100),@itmsub_id int,@sca_id_dos int,@sca_id_pack int,@titm_id_out int output)
as
declare
@titm_id int,
@titm_bartyp char(1),
@log_dat datetime
begin
set @log_dat=GETDATE()
		set @titm_id=(select max(titm_id)+1 from t_itm)
		if @titm_id is null
			begin
				set @titm_id=1
			end
	
	if (@inner_sca_id=0)
		begin	
			set @inner_sca_id=null
		end
	if (@master_sca_id=0)
		begin	
			set @master_sca_id=null
		end
	if (@man_sca_id=0)
		begin	
			set @man_sca_id=null
		end
	if (@itmgp_id =0)
		begin
			set @itmgp_id =null
		end
	if (@man_id =0)
		begin
			set @man_id =null
		end
	if (@coun_id =0)
		begin
			set @coun_id =null
		end
	if (@str_id =0)
		begin
			set @str_id =null
		end
	if (@sca_id_dos =0)
		begin
			set @sca_id_dos =null
		end
	if (@sca_id_pack =0)	
		begin
			set @sca_id_pack =null
		end
	if (@titm_ckbar=1)
		begin
			set @titm_bar=rtrim(cast(@titm_id as varchar(1000)))
			set @titm_bartyp='S'			
		end

	--Generic
	if (@ger_id=0)
		begin
			set @ger_id=null
		end

	insert into t_itm(com_id,br_id,titm_id,titm_nam,titm_snm,sca_id,inner_titm_qty,titm_bartyp,inner_sca_id,master_titm_qty,master_sca_id,man_sca_id,man_qty,titm_mlvl,titm_rlvl,itm_id,titm_typ,titm_act,titm_idold,ger_id,itmgp_id,man_id,coun_id,log_act,log_dat,usr_id,log_ip,str_id,titm_cl,titm_cw ,titm_ch ,titm_space ,titm_dat,titm_renewdat,titm_exp,titm_reg,itmsub_id,sca_id_dos,sca_id_pack,titm_ckbar,titm_bar,bd_id)
			values(@com_id,@br_id,@titm_id,@titm_nam,@titm_snm,@sca_id,@inner_titm_qty,@titm_bartyp,@inner_sca_id,@master_titm_qty,@master_sca_id,@man_sca_id,@man_qty,@titm_mlvl,@titm_rlvl,@itm_id,@titm_typ,@titm_act,@titm_idold,@ger_id,@itmgp_id,@man_id,@coun_id,@log_act,@log_dat,@usr_id,@log_ip,@str_id ,@titm_cl ,@titm_cw ,@titm_ch ,@titm_space ,@titm_dat,@titm_renewdat ,@titm_exp,@titm_reg,@itmsub_id,@sca_id_dos,@sca_id_pack,@titm_ckbar,@titm_bar,@bd_id)
		set @titm_id_out=@titm_id
		
		set @log_newval= 'ID=' + cast(@titm_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

	
end
go


--Update
alter proc upd_t_itm(@titm_id int,@titm_nam varchar(100),@titm_snm varchar(10),@sca_id int,@titm_ckbar bit,@titm_bar varchar(100),@inner_titm_qty float,@inner_sca_id int,@master_titm_qty float,@master_sca_id int,@man_sca_id int,@man_qty float,@titm_mlvl float,@titm_rlvl float,@titm_act bit,@itm_id int,@titm_ckscr bit,@titm_typ char,@ger_id int,@itmgp_id int,@man_id int,@coun_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@str_id int,@titm_cl float,@titm_cw float,@titm_ch float,@titm_space float,@titm_dat datetime,@titm_renewdat datetime,@titm_exp datetime,@titm_reg varchar(100),@itmsub_id int,@sca_id_dos int,@sca_id_pack int,@bd_id int)
as
declare
@log_dat datetime,
@titm_bartyp char(1)
begin
set @log_dat=GETDATE()
	set @titm_bartyp='U'
	if (@inner_sca_id=0)
		begin	
			set @inner_sca_id=null
		end
	if (@master_sca_id=0)
		begin	
			set @master_sca_id=null
		end
	if (@man_sca_id=0)
		begin	
			set @man_sca_id=null
		end
		if (@itmgp_id =0)
		begin
			set @itmgp_id =null
		end
	if (@man_id =0)
		begin
			set @man_id =null
		end
	if (@coun_id =0)
		begin
			set @coun_id =null
		end
	if (@str_id=0)
		begin
			set @str_id=null
		end
	if (@sca_id_dos =0)
		begin
			set @sca_id_dos =null
		end
	if (@sca_id_pack =0)	
		begin
			set @sca_id_pack =null
		end

	if (@titm_ckbar=1)
		begin
			set @titm_bar=rtrim(cast(@titm_id as varchar(1000)))
			set @titm_bartyp='S'			
		end
--Generic
	if (@ger_id=0)
		begin
			set @ger_id=null
		end


--Update Record
		update t_itm set titm_nam=@titm_nam,titm_snm=@titm_snm,sca_id=@sca_id,titm_bartyp=@titm_bartyp,inner_titm_qty=@inner_titm_qty,inner_sca_id=@inner_sca_id,master_titm_qty=@master_titm_qty,master_sca_id=@master_sca_id,man_sca_id=@man_sca_id,man_qty=@man_qty,titm_mlvl=@titm_mlvl,titm_rlvl=@titm_rlvl,titm_act=@titm_act,itm_id=@itm_id,titm_typ =@titm_typ,ger_id=@ger_id,itmgp_id=@itmgp_id,man_id=@man_id,coun_id=@coun_id,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip,str_id=@str_id,titm_cl=@titm_cl,titm_cw=@titm_cw,titm_ch=@titm_ch,titm_space=@titm_space,titm_dat=@titm_dat,titm_renewdat=@titm_renewdat,titm_exp=@titm_exp,titm_reg=@titm_reg,itmsub_id=@itmsub_id,sca_id_dos=@sca_id_dos,sca_id_pack=@sca_id_pack,titm_ckbar=@titm_ckbar,titm_bar=@titm_bar,bd_id=@bd_id
		where titm_id=@titm_id
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
go

--Delete
alter proc del_t_itm(@titm_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
	set @log_dat=GETDATE()
	--Stock Opening Delete
	delete from m_stk where itm_id=@titm_id and stk_frm='t_itm'
	----Delete Item from Finish Goods Tagging
	--exec del_t_itmfg @titm_id
	----Delete detail item qty
	--exec del_t_itmqty @titm_id
	--Delete record	
	update t_itm set log_act=@log_act where titm_id=@titm_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		
