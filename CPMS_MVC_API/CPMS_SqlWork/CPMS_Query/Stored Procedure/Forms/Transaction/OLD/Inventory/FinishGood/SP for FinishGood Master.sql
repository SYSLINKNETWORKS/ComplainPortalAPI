USE MFI
GO
--alter table t_mfg add m_yr_id char(2)
--alter table t_mfg add constraint FK_MFG_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)

--Insert
alter proc [dbo].[ins_t_mfg](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mfg_dat datetime,@mfg_shtpetti float,@mfg_waspetti float,@mfg_act bit,@mfg_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mfg_id_out int output)
as
declare
@mfg_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @mfg_id=(select max(mfg_id)+1 from t_mfg)
		if @mfg_id is null
			begin
				set @mfg_id=1
			end
			
--			if (@mfg_typ<>'E')
--				begin
--					set @titm_id=null
--				end
				
	insert into t_mfg(m_yr_id,mfg_id,mfg_dat,mfg_shtpetti,mfg_waspetti,mfg_act,mfg_typ )
			values(@m_yr_id,@mfg_id,@mfg_dat,@mfg_shtpetti,@mfg_waspetti,@mfg_act,@mfg_typ)
		set @mfg_id_out=@mfg_id
		
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

	
end
GO

--Update
alter proc [dbo].[upd_t_mfg](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mfg_id int,@mfg_dat datetime,@mfg_shtpetti float,@mfg_waspetti float,@mfg_act bit,@mfg_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Update'
	update t_mfg set mfg_dat=@mfg_dat,mfg_shtpetti=@mfg_shtpetti,mfg_waspetti=@mfg_waspetti,mfg_act=@mfg_act,mfg_typ=@mfg_typ where mfg_id=@mfg_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
GO



--exec del_t_mfg 13

--Delete
alter proc [dbo].[del_t_mfg](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mfg_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mvch_id char(12)

begin
	set @m_yr_id=(select m_yr_id from t_mfg where mfg_id=@mfg_id)
	set @aud_act='Delete'
	set @mvch_id=(select mvch_id from t_mfg where mfg_id=@mfg_id)
	
	--Delete Voucher
	exec del_t_vch @com_id,@br_id,@mvch_id,'05',@m_yr_id,'C',0,@aud_frmnam,@aud_des,@usr_id,@aud_ip
	--Delete Packing
	exec sp_miss_pack_del @mfg_id,1,''
	--Delete Detail FG
	exec del_t_dfg @mfg_id
	--Delete Master FG
	delete t_mfg where mfg_id=@mfg_id
	
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		

