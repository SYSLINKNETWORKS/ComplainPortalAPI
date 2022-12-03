USE MFI
GO

--alter table m_stk add stk_actrat float,stk_ratdiff as case when stk_actrat>0 then stk_actrat-stk_rat else 0 end ,stk_tratdiff as case when stk_actrat>0 then (stk_actrat/stk_currat)-stk_rat else 0 end
--alter table m_stk add stk_tratdiff as case when stk_actrat>0 then case when stk_currat>0 then (stk_actrat/stk_currat)-stk_rat else (stk_actrat/1)-stk_rat end else 0 end
-- stk_tratdiff as (stk_actrat/stk_currat)-stk_rat
--alter table m_stk drop column stk_tratdiff 

--update m_stk set stk_actrat=0,stk_tratdiff=0

--Stock ending
alter proc sp_endingstk (@com_id char(2),@br_id char(3),@m_yr_id char(2),@titm_id int,@stk_actrat float,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Update'
	update m_stk set stk_actrat=@stk_actrat where m_yr_id=@m_yr_id and itm_id=@titm_id

--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end		
go

--Delete
alter proc sp_del_endingstk (@com_id char(2),@br_id char(3),@m_yr_id char(2),@itmsub_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'
	if (@itmsub_id=0 )
		begin
			update m_stk set stk_actrat=0 where m_yr_id=@m_yr_id
		end
	else if (@itmsub_id>0)
		begin
			update m_stk set stk_actrat=0 where m_yr_id=@m_yr_id and itm_id in (select titm_id from t_itm where itmsub_id=@itmsub_id) 
		end

--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
		

end		
