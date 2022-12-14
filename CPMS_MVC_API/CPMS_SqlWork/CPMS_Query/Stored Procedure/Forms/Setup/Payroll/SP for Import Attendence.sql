Use ZSONS
GO

--alter table checkinout add check_app bit

--update CHECKINOUT set check_app=1 where check_typ ='S'
--update CHECKINOUT set check_app=0 where check_typ ='U'
--alter table checkinout add inoutcat_id int
--alter table checkinout add constraint FK_CHECKINOUT_INOUTCATID foreign key (inoutcat_id) references m_inoutcat(inoutcat_id)


--Insert
alter proc [dbo].[ins_dpath](@userid int,@checktime datetime,@check_typ char(1))
as
declare
@date int
begin

		set @date=(select count(checktime) from checkinout where checktime=@checktime and userid=@userid)
	
	if(@date=0)
	begin


	insert into	checkinout(userid,checktime,ckinout_st,check_typ,check_app,inoutcat_id)
		values (@userid,@checktime,1,@check_typ,1,null)

	end
end

go

alter proc [dbo].[del_dpath](@date datetime)
as
begin

	delete from checkinout where checktime>@date and check_typ='S'
end

