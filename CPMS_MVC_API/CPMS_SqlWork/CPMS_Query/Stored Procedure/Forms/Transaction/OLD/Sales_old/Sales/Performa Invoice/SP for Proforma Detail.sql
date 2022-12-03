
use MFI
go
--alter table t_dpso add itmqty_id int
--alter table t_dpso add constraint FK_TDPSO_ITMQTYID foreign key (itmqty_id) references m_itmqty(itmqty_id)

--Insert
alter proc ins_t_dpso(@dpso_qty float,@dpso_rat float,@dpso_amt float,@mpso_id int,@titm_id int,@itmqty_id int,@bd_id int)
as
declare
@dpso_id int
begin
	set @dpso_id=(select max(dpso_id)+1 from t_dpso)
		if @dpso_id is null
			begin
				set @dpso_id=1
			end
	insert into t_dpso(dpso_id,dpso_qty,dpso_rat,dpso_amt,mpso_id,titm_id,itmqty_id,bd_id,dpso_st)
			values(@dpso_id,@dpso_qty,@dpso_rat,@dpso_amt,@mpso_id,@titm_id,@itmqty_id,@bd_id,0)
end

go	


--Delete
alter proc del_t_dpso(@mpso_id int)
as
begin
	delete from t_dpso where mpso_id=@mpso_id

end


