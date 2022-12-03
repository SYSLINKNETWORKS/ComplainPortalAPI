USE PAGEY
GO



--Insert
alter proc ins_m_prom(@com_id char(2),@br_id char(3),@prom_dat datetime,@prom_frmdat datetime,@prom_todat datetime,@prom_typ char(1),@prom_act bit,@procat_id int,@titm_id int,@titm_id_free int,@prom_minqty float,@prom_bqty float,@prom_minamt float,@prom_dis float,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@prom_id_out int output)
as
declare
@prom_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @prom_id=(select max(prom_id)+1 from m_prom)
		if @prom_id is null
			begin
				set @prom_id=1
			end
	insert into m_prom(com_id,br_id,prom_id,prom_dat,prom_frmdat,prom_todat,prom_typ,prom_act,procat_id,titm_id,titm_id_free,prom_minqty,prom_bqty,prom_minamt,prom_dis)
					values (@com_id,@br_id,@prom_id,@prom_dat,@prom_frmdat,@prom_todat,@prom_typ,@prom_act,@procat_id,@titm_id,@titm_id_free,@prom_minqty,@prom_bqty,@prom_minamt,@prom_dis)

	set @prom_id_out=@prom_id
	
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
go		

--Update
alter proc upd_m_prom(@com_id char(2),@br_id char(3),@prom_id int,@prom_dat datetime,@prom_frmdat datetime,@prom_todat datetime,@prom_typ char(1),@prom_act bit,@procat_id int,@titm_id int,@titm_id_free int,@prom_minqty float,@prom_bqty float,@prom_minamt float,@prom_dis float,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Update'
	update m_prom set prom_dat=@prom_dat,prom_frmdat=@prom_frmdat,prom_todat=@prom_todat,prom_typ=@prom_typ,prom_act=@prom_act,procat_id=@procat_id,titm_id=@titm_id,titm_id_free=@titm_id_free,prom_minqty=@prom_minqty,prom_bqty=@prom_bqty,prom_minamt=@prom_minamt,prom_dis=@prom_dis
	where prom_id=@prom_id 
	
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
		
go
--Delete
alter proc del_m_prom(@com_id char(2),@br_id char(3),@prom_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'
	delete m_prom where prom_id=@prom_id
	
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
		