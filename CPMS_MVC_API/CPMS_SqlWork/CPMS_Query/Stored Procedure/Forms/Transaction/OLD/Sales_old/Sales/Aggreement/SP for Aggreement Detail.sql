USE ZSONS
go
--select * from t_dagg


--alter table t_dagg add stdcat_id int
--alter table t_dagg add constraint FK_TDAGG_STDCATID foreign key (stdcat_id) references m_stdcat(stdcat_id)

--Insert
alter proc ins_t_dagg(@dagg_perval float,@dagg_per1 float,@dagg_per2 float,@dagg_per3 float,@dagg_per4 float,@bd_id int,@itmsub_id int,@stdcat_id int,@magg_id int)
as
declare
@dagg_id int
begin
	set @dagg_id=(select max(dagg_id)+1 from t_dagg)
		if @dagg_id is null
			begin
				set @dagg_id=1
			end
	insert into t_dagg(dagg_id,dagg_perval,dagg_per1,dagg_per2,dagg_per3,dagg_per4,bd_id,itmsub_id,stdcat_id,magg_id)
			values(@dagg_id,@dagg_perval,@dagg_per1,@dagg_per2,@dagg_per3,@dagg_per4,@bd_id,@itmsub_id,@stdcat_id,@magg_id)
end

go	


--Delete
alter proc del_t_dagg(@magg_id int)
as
begin
	delete from t_dagg where magg_id=@magg_id

end

		


