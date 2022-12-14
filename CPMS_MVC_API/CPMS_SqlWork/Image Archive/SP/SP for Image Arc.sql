USE ZSONS
GO

--alter table m_sys add ftp_archive varchar(1000)
--update m_sys set ftp_archive='arch'
--select * from t_miarc

--Insert

alter proc [dbo].[ins_t_miarc](@com_id char(2),@br_id char(3),@m_yR_id char(2),@miarc_dat datetime,@miarc_typ char(1),@men_id int,@miarc_data1 varchar(1000),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@miarc_id_out int output)
as
declare
@aud_act char(10),
@miarc_id int
begin	
	set @aud_act='Insert'
	set @miarc_id=(select max(miarc_id)+1 from t_miarc)
		if @miarc_id is null
			begin
				set @miarc_id=1
			end				
		----Insert
	insert into t_miarc(com_id,br_id,m_yr_id,miarc_id,miarc_dat,miarc_typ,men_id,miarc_data1)
			values(@com_id,@br_id,@m_yr_id,@miarc_id,@miarc_dat,@miarc_typ,@men_id,@miarc_data1)
	set @miarc_id_out=@miarc_id			
				
--Audit
	set @aud_des='ID # '+rtrim(cast(@miarc_id as char(1000)))+' '+@aud_des 
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip				
end
GO

--Update
alter proc [dbo].[upd_t_miarc](@com_id char(2),@br_id char(3),@m_yr_id char(2),@miarc_id int,@miarc_dat datetime,@miarc_typ char(1),@men_id int,@miarc_data1 varchar(1000),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin		
	set @aud_act='Update'		
	update t_miarc set miarc_id=@miarc_id,miarc_dat=@miarc_dat,miarc_typ=@miarc_typ,men_id=@men_id,miarc_data1=@miarc_data1
	where com_id=@com_id and br_id=@br_id and miarc_id=@miarc_id 

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
go
--Delete
alter proc [dbo].[del_t_miarc](@com_id char(2),@br_id char(3),@m_yr_id char(2),@miarc_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin	
	set @aud_act='Delete'
	exec del_t_diarc @com_id ,@br_id ,@miarc_id 
	delete t_miarc where com_id=@com_id and br_id=@br_id and miarc_id=@miarc_id 
		
	--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end

GO


