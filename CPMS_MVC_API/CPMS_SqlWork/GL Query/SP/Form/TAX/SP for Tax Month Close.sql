USE ZSONS
Go

--Insert
create proc [dbo].[sp_taxmon_close](@com_id char(2),@br_id char(3),@taxclose_dat1 datetime,@taxclose_dat2 datetime,@taxclose_act bit,@taxclose_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@taxclose_id int,
@aud_act char(10)
begin
	
	set @aud_act='Update'
	delete from m_taxclose where taxclose_dat1=@taxclose_dat1 and taxclose_dat2=@taxclose_dat2
	
	
	if (@taxclose_act=1)
		begin
			set @aud_act='Insert'
			set @taxclose_id=(select max(taxclose_id)+1 from m_taxclose)
				if @taxclose_id is null
					begin
						set @taxclose_id=1
					end


			insert into m_taxclose(taxclose_id,taxclose_dat1,taxclose_dat2,taxclose_act,taxclose_typ)
					values(@taxclose_id,@taxclose_dat1,@taxclose_dat2,@taxclose_act,@taxclose_typ)


		end
			--Audit
			exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
	
end
GO
