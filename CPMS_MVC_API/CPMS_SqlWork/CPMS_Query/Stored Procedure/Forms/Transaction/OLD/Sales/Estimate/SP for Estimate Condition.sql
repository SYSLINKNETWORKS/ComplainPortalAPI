

USE ZSONS
go

--Insert
create proc ins_t_dpso_pat(@pat_id int,@mpso_id int)
as
begin
	insert into t_dpso_pat(pat_id,mpso_id)
				values(@pat_id,@mpso_id)		
end




go	

--Delete
create proc del_t_dpso_pat(@mpso_id int)
as
begin
	delete from t_dpso_pat where mpso_id=@mpso_id
end
