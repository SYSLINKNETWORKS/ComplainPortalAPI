USE MFI
GO

--alter table m_mbat add mbat_std bit default 0
--update m_mbat set mbat_std=0
--update m_mbat set mbat_std=1 where mbat_nam like '%Standard%'
--update m_mbat set itmsub_id=null where itmsub_id=0

--Insert
alter proc [dbo].[ins_m_mbat](@com_id char(2),@br_id char(3),@mbat_dat datetime,@mbat_siz float,@mbat_nam varchar(250),@mbat_std bit,@itmsub_id int,@mbat_act bit,@mbat_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mbat_id_out int output)
as
declare
@mbat_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @mbat_id=(select max(mbat_id)+1 from m_mbat)
		if @mbat_id is null
			begin
				set @mbat_id=1
			end
			if (@itmsub_id=0)
				begin
					set @itmsub_id=null
				end
	insert into m_mbat(mbat_id,mbat_dat,mbat_siz,mbat_nam,mbat_act,mbat_std,mbat_typ,itmsub_id )
			values(@mbat_id,@mbat_dat,@mbat_siz,@mbat_nam,@mbat_act,@mbat_std,@mbat_typ,@itmsub_id)
		set @mbat_id_out=@mbat_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip



end
GO

--Update
alter proc [dbo].[upd_m_mbat](@com_id char(2),@br_id char(3),@mbat_id int,@mbat_dat datetime,@mbat_siz float,@mbat_nam varchar(250),@itmsub_id int,@mbat_act bit,@mbat_std bit,@mbat_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin		
		
	set @aud_act='Update'
			if (@itmsub_id=0)
				begin
					set @itmsub_id=null
				end

	update m_mbat set mbat_dat=@mbat_dat,mbat_siz=@mbat_siz,mbat_nam=@mbat_nam,mbat_act=@mbat_act,mbat_typ=@mbat_typ,itmsub_id=@itmsub_id,mbat_std=@mbat_std where mbat_id=@mbat_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip


end
GO


--Delete
alter proc [dbo].[del_m_mbat](@com_id char(2),@br_id char(3),@mbat_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'
	exec del_m_dbat_fg @mbat_id
	exec del_m_dbat_cus @mbat_id
	exec del_m_dbat @mbat_id
	delete m_mbat where mbat_id=@mbat_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip


end
		

