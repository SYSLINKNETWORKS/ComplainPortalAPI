USE PAGEY
GO
--mexpense Transaction 
--Insert
--alter table t_mexp add com_id char(2)
--alter table t_mexp add br_id char(3)
--alter table t_mexp add m_yr_id char(2)
--alter table t_mexp add mexp_dat datetime

alter proc ins_t_mexp(@com_id char(2),@br_id char(3),@m_yr_id char(2),@lc_id int,@mexp_dat datetime,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mexp_id_out int output)
as
declare
@mexp_id int,
@aud_act char(10)
begin
set @aud_act='Insert'
	set @mexp_id=(select max(mexp_id)+1 from t_mexp)
		if @mexp_id is null
			begin
				set @mexp_id=1
			end
	insert into t_mexp(com_id,br_id,m_yr_id,mexp_id,lc_id,mexp_dat)
					values (@com_id,@br_id,@m_yr_id,@mexp_id,@lc_id,@mexp_dat)

	set @mexp_id_out=@mexp_id
	
	--Audit	
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
go		

--Update
alter proc upd_t_mexp(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mexp_id int,@lc_id int,@mexp_dat datetime,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
set @aud_act='Update'
	update t_mexp set lc_id=@lc_id,mexp_dat=@mexp_dat where mexp_id=@mexp_id 
	
	--Audit	
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
		
go
--Delete
alter proc del_t_mexp(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mexp_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
set @aud_act='Delete'
	delete t_mexp where mexp_id=@mexp_id

	exec del_t_dexp @mexp_id
	delete t_dmexp where mexp_id=@mexp_id 
	
	--Audit	
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		

--select * from  t_mexp