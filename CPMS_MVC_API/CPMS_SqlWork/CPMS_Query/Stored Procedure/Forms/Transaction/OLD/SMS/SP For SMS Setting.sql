USE zsons
GO




--alter table m_sys add sms_webservice bit,sms_port varchar(100),sms_rat float,sms_bit float,sms_read float,sms_write float
--update m_sys set sms_webservice=0,sms_port='COM12',sms_rat=9600,sms_bit=8,sms_read=300,sms_write=300

--alter table m_sys add sms_webpwd varchar(100)
--update m_sys set sms_webpwd='334466'
--select * from m_sys
--alter table m_sys add sms_webcustomerid varchar(100),sms_webshortcode varchar(100),sms_weblanguage varchar(100)


---Update
alter proc [dbo].[upd_sms_setting](@com_id char(2),@br_id char(2),@sms_webservice bit,@sms_webpwd varchar(100),@sms_webcustomerid varchar(100),@sms_webshortcode varchar(100),@sms_weblanguage varchar(100),@sms_port varchar(100),@sms_rat float,@sms_bit float,@sms_read float,@sms_write float,@aud_frmnam varchar(1024),@aud_des varchar(1024),@usr_id int,@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'

	

	update m_sys set sms_webservice=@sms_webservice,sms_webpwd=@sms_webpwd,sms_port=@sms_port,sms_rat=@sms_rat,sms_bit=@sms_bit,sms_read=@sms_read,sms_write=@sms_write,sms_webcustomerid =@sms_webcustomerid,sms_webshortcode=@sms_webshortcode,sms_weblanguage=@sms_weblanguage


--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

