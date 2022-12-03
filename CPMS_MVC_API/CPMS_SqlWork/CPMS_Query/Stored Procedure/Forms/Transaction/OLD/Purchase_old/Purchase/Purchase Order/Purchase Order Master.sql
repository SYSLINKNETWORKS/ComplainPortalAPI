
use phm
GO
--alter table t_mpo add mpo_ddat datetime
--update t_mpo set mpo_ddat=mpo_dat
--alter table t_mpo drop column ins_usr_id,ins_dat,upd_usr_id,upd_dat
--alter table t_mpo add com_id char(2),br_id char(3)
--alter table t_mpo add constraint FK_mpo_COMID foreign key (com_id) references m_com(com_id)
--alter table t_mpo add constraint FK_mpo_BRID foreign key (br_id) references m_br(br_id)
--update t_mpo set com_id='01',br_id='01'
--alter table t_mpo add lc_nam varchar(250)
--alter table t_mpo add mpo_purtyp char(2) 
--alter table t_mpo add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)

--Insert
alter proc ins_t_mpo(@com_id char(2),@br_id char(3),@mpo_dat datetime,@mpo_ddat datetime,@mpo_typ char(1),@mpo_rat float,@mpo_amt float,@m_yr_id char(2),@mpo_act bit,@mpo_rmk varchar(250),@mpr_id int,@cur_id int,@sup_id int,@lc_nam varchar(250),@mpo_purtyp char(2),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mpo_id_out int output)
as
declare
@mpo_id int,
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	set @mpo_id=(select max(mpo_id)+1 from t_mpo)
		if @mpo_id is null
			begin
				set @mpo_id=1
			end
			
		--LC Insert
	--exec ins_m_lc @lc_nam ,'P',@lc_id_out =@lc_id output
		
	insert into t_mpo(com_id,br_id,mpo_id,mpo_dat,mpo_ddat,mpo_typ,m_yr_id ,mpo_rat,mpr_id,mpo_amt,sup_id,cur_id,mpo_act,mpo_rmk,lc_nam,mpo_purtyp,log_act,log_dat,usr_id,log_ip)
			values(@com_id,@br_id,@mpo_id,@mpo_dat,@mpo_ddat,@mpo_typ,@m_yr_id,@mpo_rat,@mpr_id,@mpo_amt,@sup_id,@cur_id,@mpo_act,@mpo_rmk,@lc_nam ,@mpo_purtyp,@log_act,@log_dat,@usr_id,@log_ip)
	set @mpo_id_out=@mpo_id
	
	set @log_newval= 'ID=' + cast(@mpo_id as varchar) + '-' + cast(@log_newval as varchar(max))

--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
go
--Update
alter proc upd_t_mpo(@m_yr_id char(2),@mpo_id int,@mpo_dat datetime,@mpo_ddat datetime,@mpo_rat float,@mpo_amt float,@mpo_rmk varchar(250),@sup_id int,@cur_id int,@mpo_act bit,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@lc_nam varchar(250),@mpo_purtyp char(2))
as
declare
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	update t_mpo set mpo_dat=@mpo_dat,mpo_ddat=@mpo_ddat,mpo_rat=@mpo_rat,mpo_amt=@mpo_amt,sup_id=@sup_id,cur_id=@cur_id,mpo_act=@mpo_act,mpo_rmk=@mpo_rmk,lc_nam=@lc_nam,mpo_purtyp=@mpo_purtyp,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where mpo_id=@mpo_id

--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
go

--Delete
alter proc del_t_mpo(@mpo_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	exec del_t_dpo_pat @mpo_id
	exec del_t_dpo @mpo_id
	
	update t_mpo set log_act=@log_act where mpo_id=@mpo_id 
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		
--select * from rm_det
