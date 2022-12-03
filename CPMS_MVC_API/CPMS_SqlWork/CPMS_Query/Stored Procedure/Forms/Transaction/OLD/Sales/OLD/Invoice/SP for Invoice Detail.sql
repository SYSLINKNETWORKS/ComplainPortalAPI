
--exec ins_t_dinv '01','01',90,222.22,20000,2800000,4,1,'01',1,'','',1,''
--select * from t_dinv
--select * from t_dinv
--select * from m_stk
--update m_stk set stk_rat=0 where stk_frm='DC'
--Insert
alter proc ins_t_dinv(@com_id char(2),@br_id char(3),@dinv_qty float,@dinv_rat float,@dinv_amt float,@dinv_tamt float,@minv_id int,@titm_id int,@m_yr_id char(2),@row_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@dinv_id int,
@mdc_id int
begin
	set @dinv_id=(select max(dinv_id)+1 from t_dinv)

		if @dinv_id is null
			begin	
				set @dinv_id=1
			end
	insert into t_dinv(dinv_id,dinv_qty,dinv_rat,dinv_amt,dinv_tamt,minv_id,titm_id,m_yr_id)
			values(@dinv_id,@dinv_qty,@dinv_rat,@dinv_amt,@dinv_tamt,@minv_id,@titm_id,@m_yr_id)

	

	----Voucher
	--if (@row_id =1)
	--	begin	
	--		exec sp_voucher_inv @com_id,@br_id,@m_yr_id,@minv_id,@usr_id,@aud_ip 
	--	end
end
		
go

--Delete
alter proc del_t_dinv(@minv_id int)
as
begin
	exec del_t_dinv_dc @minv_id
	delete from t_dinv where minv_id=@minv_id
end
