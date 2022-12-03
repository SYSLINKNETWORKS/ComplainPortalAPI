USE PAGEY
GO

--Expense Transaction Detail



--Insert
create proc ins_t_dexp(@exp_id int,@dexp_amt int,@mexp_id int)
as
declare
@dexp_id int
begin
	set @dexp_id=(select max(dexp_id)+1 from t_dexp)
		if @dexp_id is null
			begin
				set @dexp_id=1
			end
	insert into t_dexp(dexp_id,exp_id,dexp_amt,mexp_id)
					values (@dexp_id,@exp_id,@dexp_amt,@mexp_id)

	set @dexp_id=@dexp_id
end
go		

--Delete
create proc del_t_dexp(@mexp_id int)
as
begin
	delete t_dexp where mexp_id=@mexp_id
end
		

