USE MFI
GO


--alter table t_mret add miss_id int, mret_nob float
--update t_mret set mret_nob=0
--alter table t_mret add constraint FK_MRET_MISSID foreign key (miss_id) references t_miss(miss_id)


--Insert
alter proc [dbo].[ins_t_mret](@com_id char(2),@br_id char(3),@mret_dat datetime,@miss_id int,@mret_nob float,@miss_nobbal float,@titm_id int,@cus_id int,@bd_id int,@mret_act bit,@mret_ckso bit,@mso_id int,@mret_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mret_id_out int output)
as
declare
@mret_id int,
@mso_batact bit,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @mret_id=(select max(mret_id)+1 from t_mret)
		if @mret_id is null
			begin
				set @mret_id=1
			end
			if (@mret_ckso=0)
				begin
					set @cus_id=null
					set @bd_id=null
				end
	insert into t_mret(mret_id,mret_dat,miss_id,mret_nob,titm_id,mret_act,mret_ckso,mso_id,mret_typ,cus_id,bd_id )
			values(@mret_id,@mret_dat,@miss_id,@mret_nob,@titm_id,@mret_act,@mret_ckso,@mso_id,@mret_typ,@cus_id,@bd_id)
		set @mret_id_out=@mret_id
		
		--Status of RM Transfer
		if (@miss_nobbal=0)
			begin
				update t_miss set miss_act=1 where miss_id=@miss_id
			end			
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update
alter proc [dbo].[upd_t_mret](@com_id char(2),@br_id char(3),@mret_id int,@mret_dat datetime,@miss_id int,@mret_nob float,@miss_nobbal float,@titm_id int,@cus_id int,@bd_id int,@mret_act bit,@mret_ckso bit,@mso_id int,@mret_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@mso_batact bit,
@aud_act char(10)

begin
	set @aud_act='Update'
				if (@mret_ckso=0)
				begin
					set @cus_id=null
					set @bd_id=null
				end
	--Status of RM Transfer
	update t_miss set miss_act=0 where miss_id =(select miss_id from t_mret where mret_id=@mret_id)

	update t_mret set mret_dat=@mret_dat,miss_id=@miss_id,mret_nob=@mret_nob,titm_id=@titm_id,mret_act=@mret_act,mret_ckso=@mret_ckso,mso_id=@mso_id,cus_id=@cus_id,bd_id=@bd_id,mret_typ=@mret_typ where mret_id=@mret_id
	
	--Status of RM Transfer
		if (@miss_nobbal=0)
			begin
				update t_miss set miss_act=1 where miss_id=@miss_id
			end		
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--exec del_t_mret 1

--Delete
alter proc [dbo].[del_t_mret](@com_id char(2),@br_id char(3),@mret_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mvch_id char(20),
@m_yr_id char(2)
begin

	set @mvch_id=(select mvch_id from t_mret where mret_id=@mret_id)
	set @m_yr_id=(select distinct  m_yr_id from t_dret where mret_id=@mret_id)
	set @aud_act='Delete'

	--Status of RM Transfer
	update t_miss set miss_act=0 where miss_id =(select miss_id from t_mret where mret_id=@mret_id)
	--Voucher
	exec del_t_vch @com_id ,@br_id,@mvch_id,'05',@m_yr_id,'C',0,@aud_frmnam,@aud_des ,@usr_id,@aud_ip 
	--Detail Delete
	exec del_t_dret @mret_id
	--Master Delete
	delete t_mret where mret_id=@mret_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
		




