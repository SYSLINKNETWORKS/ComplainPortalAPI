USE meiji_rusk
GO

--drop table tbl_dat
--create table tbl_dat 
--(
--tbldat_dat datetime,
--tbldat_hol bit,
--tbldat_rmk varchar(250),
--tbldat_nodays int
--)

--exec sp_tbl_dat '2025'

create proc sp_tbl_dat (@year int)
as
DECLARE @numofdays INT,@lastdayofmonth int,@gdate datetime,@cdate datetime,@rmk varchar(100),@holi bit,@ddate datetime,@numofmonth int
set @numofmonth =1
WHILE (@numofmonth <=12)
BEGIN
	set @ddate =casT(rtrim(cast(@numofmonth as CHAR(100)))+'/'+rtrim(cast(1 as CHAR(100)))+'/'+rtrim(cast(@year as CHAR(100))) as datetime)
	set @lastdayofmonth= DAY(DATEADD(DD,-1,DATEADD(MM,DATEDIFF(MM,-1,@ddate),0)))
	SET @numofdays = 1
	WHILE (@numofdays <=@lastdayofmonth)
	BEGIN
		set @gdate =casT(rtrim(cast(@numofmonth as CHAR(100)))+'/'+rtrim(cast(@numofdays as CHAR(100)))+'/'+rtrim(cast(@year as CHAR(100))) as datetime)
		set @cdate=(select tbldat_dat from tbl_dat where tbldat_dat=@gdate)
		if (@cdate is null)
			begin
				set @rmk=''
				set @holi=0
				if (DATEname(dw,@gdate)='Sunday')
					begin
						set @rmk='Sunday'
						set @holi=1
					end
				insert into tbl_dat values(@gdate,@holi,@rmk,@lastdayofmonth)
			end
		SET @numofdays = @numofdays + 1
	END
set @numofmonth =@numofmonth +1
end
