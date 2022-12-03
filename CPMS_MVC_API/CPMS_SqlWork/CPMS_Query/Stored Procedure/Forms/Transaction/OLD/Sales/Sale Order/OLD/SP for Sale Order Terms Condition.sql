

USE ZSONS
go

--Insert
create proc ins_t_dso_pat(@pat_id int,@mso_id int)
as
begin
	insert into t_dso_pat(pat_id,mso_id)
				values(@pat_id,@mso_id)		
end




go	

--Delete
create proc del_t_dso_pat(@mso_id int)
as
begin
	delete from t_dso_pat where mso_id=@mso_id
end
