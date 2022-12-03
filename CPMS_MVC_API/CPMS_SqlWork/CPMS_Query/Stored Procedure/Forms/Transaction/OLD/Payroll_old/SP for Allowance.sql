USE MFI
GO
--exec ins_m_all '[Select]',0,0,'S','01','01','03','',1,'Allowance','','192.168.0.99'
--exec ins_m_all 'Food Deduction Full',1000,0,'S','01','01','03','',1,'Allowance','','192.168.0.99'
--exec ins_m_all 'Food Deduction Half',500,0,'S','01','01','03','',1,'Allowance','','192.168.0.99'
--exec ins_m_all 'Oven Allowance',400,0,'S','01','01','03','',1,'Allowance','','192.168.0.99'
--exec ins_m_all 'Telephone Allowance',1000,0,'U','01','01','03','',1,'Allowance','','192.168.0.99'
--select * from m_all



--Insert
alter proc [dbo].[ins_m_all](@all_nam varchar(100),@all_amt float,@all_fix bit,@all_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@all_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@all_id			int,
@aud_act			char(20)
begin
	set @all_id =(select max(all_id) from m_all)+1
	set @aud_act='Insert'

	if (@all_id is null)
		begin	
			set @all_id=1
		end

	insert into m_all (all_id,all_nam,all_amt,all_fix,all_typ)
	values
	(@all_id,@all_nam,@all_amt,@all_fix,@all_typ)

	set @all_id_out=@all_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update

alter proc [dbo].[upd_m_all](@all_id int,@all_nam varchar(100),@all_amt float,@all_fix bit,@all_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'
	update m_all 
			set all_nam=@all_nam,all_amt=@all_amt ,all_fix=@all_fix,all_typ=@all_typ
			where all_id=@all_id 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO


--exec [upd_m_all] "1",'07/01/2010','06/30/2011',1,2,14,100,'U','01','01','03',1,'alltuity','','192.168'

--Delete
alter proc [dbo].[del_m_all](@com_id char(2),@br_id char(3),@all_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_all  
			where all_id=@all_id
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--select * from m_all
