USE MEIJI
GO
--select * from m_batqty
--alter table m_batqty add batqty_mqty float,msca_id int,sca_id int
--update m_batqty set batqty_mqty=batqty_qty,msca_id=2,sca_id=2
--alter table m_batqty add batqty_mqty float,batqty_ck bit
--update m_batqty set batqty_mqty=batqty_qty,batqty_ck=0

--alter table m_batqty add batqty_minwei float
--alter table m_batqty add batqty_maxwei float
--alter table m_batqty add batqty_minwal float
--alter table m_batqty add batqty_maxwal float
--alter table m_batqty add batqty_minod float
--alter table m_batqty add batqty_maxod float

--Insert
alter proc [dbo].[ins_m_batqty](@com_id char(2),@br_id char(3),@batqty_dat datetime,@batqty_mqty float,@batqty_ck bit,@batqty_qty float,@batqty_typ char(1),@titm_id int,@itmqty_id int,@batqty_minwei float,@batqty_maxwei float,@batqty_minwal float,@batqty_maxwal float,@batqty_minod float,@batqty_maxod float,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100),@batqty_id_out int output)
as
declare
@aud_act char(10),
@batqty_id int
begin
	set @aud_act='Insert'
	set @batqty_id=(select max(batqty_id)+1 from m_batqty)
		if @batqty_id is null
			begin
				set @batqty_id=1
			end
		if (@itmqty_id =0)	
			begin
				set @itmqty_id =null
			end
	insert into m_batqty(batqty_id,batqty_dat,batqty_mqty,batqty_ck,batqty_qty,batqty_typ,titm_id,itmqty_id,batqty_minwei,batqty_maxwei,batqty_minwal,batqty_maxwal,batqty_minod,batqty_maxod )
			values(@batqty_id,@batqty_dat,@batqty_mqty,@batqty_ck,@batqty_qty,@batqty_typ,@titm_id,@itmqty_id,@batqty_minwei,@batqty_maxwei,@batqty_minwal,@batqty_maxwal,@batqty_minod,@batqty_maxod)

		set @batqty_id_out=@batqty_id
		
		  --Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip


end
GO

--Update
alter proc [dbo].[upd_m_batqty](@com_id char(2),@br_id char(3),@batqty_id int,@batqty_dat datetime,@batqty_mqty float,@batqty_ck bit,@batqty_qty float,@batqty_typ char(1),@titm_id int,@itmqty_id int,@batqty_minwei float,@batqty_maxwei float,@batqty_minwal float,@batqty_maxwal float,@batqty_minod float,@batqty_maxod float,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Update'
		if (@itmqty_id =0)	
			begin
				set @itmqty_id =null
			end

	update m_batqty set batqty_dat=@batqty_dat,batqty_mqty=@batqty_mqty,batqty_ck=@batqty_ck,batqty_qty=@batqty_qty,batqty_typ=@batqty_typ,titm_id=@titm_id,itmqty_id=@itmqty_id,batqty_minwei=@batqty_minwei,batqty_maxwei=@batqty_maxwei,batqty_minwal=@batqty_minwal,batqty_maxwal=@batqty_maxwal,batqty_minod=@batqty_minod,batqty_maxod=@batqty_maxod where batqty_id=@batqty_id
	
	  --Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
GO


--Delete
alter proc [dbo].[del_m_batqty](@com_id char(2),@br_id char(3),@titm_id int,@batqty_dat_old datetime,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'
	delete m_batqty where titm_id=@titm_id and batqty_dat=@batqty_dat_old
	  --Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		

