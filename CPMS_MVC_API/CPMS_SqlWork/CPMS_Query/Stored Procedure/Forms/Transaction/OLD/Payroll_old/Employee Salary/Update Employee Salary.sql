USE ZSons
go
--Update
alter proc [dbo].[upd_emp_sal](@emppro_id int,@emp_sal_dat datetime,@emp_sal_addoth float,@emp_sal_dedoth float,@emp_sal_loan float,@emppro_ot float,@emppro_otamt float,@emppro_intax float,@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100),@row_id int)
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'
	set @emppro_ot=@emppro_ot*60
	update emp_sal set emppro_addoth=@emp_sal_addoth,emppro_dedoth=@emp_sal_dedoth,emppro_intax=@emppro_intax,emppro_loan=@emp_sal_loan,emppro_ot=@emppro_ot,emppro_otamt=@emppro_otamt where emp_sal_dat=@emp_sal_dat and emppro_id=@emppro_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
	
end
GO

