USE ZSONS
GO

--alter table t_minv add minv_tax bit default 0
--update t_minv set minv_tax=0

create proc sp_upd_mcusvch(@com_id char(2),@br_id char(3),@minv_no int)
as
begin
	update t_minv set minv_tax=1 where com_id=@com_id and minv_no=@minv_no
end

GO

go
create proc sp_del_mcusvch(@com_id char(2),@br_id char(3),@cus_id int)
as
begin
	update t_minv set minv_tax=0 where com_id=@com_id and cus_id=@cus_id
end

GO