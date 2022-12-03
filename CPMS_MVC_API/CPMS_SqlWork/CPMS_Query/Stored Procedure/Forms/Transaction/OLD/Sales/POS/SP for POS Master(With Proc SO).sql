use NTHA
go

alter proc ins_t_mpos(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mso_id int,@mpso_no int,@mso_dat datetime,@wh_id int,@mso_rmk varchar(250),@mso_amt float,@mso_disper float,@mso_disamt float,@mso_freamt float,@mso_othamt float,@mso_namt float,@mso_act bit,@mso_auth bit,@mso_soapp bit,@mso_can bit,@mso_typ char(1),@cus_id int,@emppro_macid int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mso_id_out int output)
as
begin

exec ins_t_mso @com_id ,@br_id ,@m_yr_id ,@mpso_no ,@mso_dat ,'','' ,@wh_id ,'' ,'', '' ,'' ,'' ,@mso_rmk ,@mso_amt ,@mso_disper ,@mso_disamt ,@mso_freamt ,@mso_othamt ,@mso_namt ,@mso_act ,@mso_auth ,@mso_soapp ,@mso_can ,0 ,'' ,'' ,'' ,'S' ,@cus_id ,0 ,0 ,@emppro_macid ,@log_act ,@usr_id ,@log_ip ,@log_frmnam ,@log_oldval ,@log_newval ,'',@mso_id_out =@mso_id output

end
go

alter proc upd_t_mpos(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mso_id int,@mso_no int,@mpso_no int,@mso_dat datetime,@wh_id int,@mso_rmk varchar(250),@mso_amt float,@mso_disper float,@mso_disamt float,@mso_freamt float,@mso_othamt float,@mso_namt float,@mso_act bit,@mso_auth bit,@mso_soapp bit,@mso_can bit,@mso_typ char(1),@cus_id int,@emppro_macid int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
begin

exec upd_t_mso @m_yr_id ,@mso_id ,@mso_no,@mpso_no,@mso_dat,'','',@wh_id,'','','','','',@mso_rmk,@mso_amt ,@mso_disper ,@mso_disamt,@mso_freamt ,@mso_othamt ,@mso_namt ,@mso_act ,@mso_auth ,@mso_soapp ,@mso_can,0,'','','','S',@cus_id,@emppro_macid,@log_act ,@usr_id ,@log_ip ,@log_frmnam ,@log_oldval ,@log_newval

end
go

alter proc del_t_mpos(@mso_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
begin

exec del_t_mso @mso_id,@log_act ,@usr_id ,@log_ip ,@log_frmnam ,@log_oldval ,@log_newval

end
go