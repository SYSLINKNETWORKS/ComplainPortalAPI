USE ZSONS
go
--select * from t_daggvch


--alter table t_daggvch add stdcat_id int
--alter table t_daggvch add constraint FK_TDAGGVCH_STDCATID foreign key (stdcat_id) references m_stdcat(stdcat_id)
--Insert
alter proc ins_t_daggvch(@daggvch_sal float,@daggvch_ret float,@daggvch_dis float,@daggvch_disamt float,@daggvch_add float,@daggvch_ded float,@bd_id int,@itmsub_id int,@stdcat_id int,@maggvch_id int)
as
declare
@daggvch_id int
begin
	set @daggvch_id=(select max(daggvch_id)+1 from t_daggvch)
		if @daggvch_id is null
			begin
				set @daggvch_id=1
			end
	insert into t_daggvch(daggvch_id,daggvch_sal,daggvch_ret,daggvch_dis,daggvch_disamt,daggvch_add,daggvch_ded,bd_id,itmsub_id,stdcat_id,maggvch_id)
			values(@daggvch_id,@daggvch_sal,@daggvch_ret,@daggvch_dis,@daggvch_disamt,@daggvch_add,@daggvch_ded,@bd_id,@itmsub_id,@stdcat_id,@maggvch_id)
end

go	


--Delete
alter proc del_t_daggvch(@maggvch_id int)
as
begin
	delete from t_daggvch where maggvch_id=@maggvch_id

end

		


