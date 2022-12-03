USE ZSONS
GO
--select * from t_dpo_pat

--Insert
create proc ins_t_dpo_pat(@mpo_id int,@pat_id int)
as
declare
@dpo_pat_id int
begin
	set @dpo_pat_id=(select max(dpo_pat_id)+1 from t_dpo_pat)
		if @dpo_pat_id is null
			begin
				set @dpo_pat_id=1
			end
	insert into t_dpo_pat(dpo_pat_id,mpo_id,pat_id)
			values(@dpo_pat_id,@mpo_id,@pat_id)

end

go
--Delete
create proc del_t_dpo_pat(@mpo_id int)
as
begin
	delete from t_dpo_pat where mpo_id=@mpo_id
end




		
--SELECT * from t_mgrn
