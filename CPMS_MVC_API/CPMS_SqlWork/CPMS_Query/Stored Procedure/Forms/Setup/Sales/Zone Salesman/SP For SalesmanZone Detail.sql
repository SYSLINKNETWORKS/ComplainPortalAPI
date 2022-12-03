USE phm
go

--alter table m_dsalzon drop column zone_id
--alter table m_dsalzon add terr_id int
--alter table m_dsalzon add constraint FK_DSALZON_TERRID foreign key (terr_id) references s_terr (terr_id)
--alter table m_dsalzon add log_act char(1)

--Insert
alter proc ins_m_dsalzon(@terr_id int,@msalzon_id int)
as
declare
@dsalzon_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @dsalzon_id=(select max(dsalzon_id)+1 from m_dsalzon)
		if @dsalzon_id is null
			begin
				set @dsalzon_id=1
			end
	insert into m_dsalzon(dsalzon_id,msalzon_id,terr_id)
					values (@dsalzon_id,@msalzon_id,@terr_id)
end
go		

--Delete
alter proc del_m_dsalzon(@msalzon_id int)
as
declare
@log_dat datetime
begin
	set @log_dat=GETDATE()
	update m_dsalzon set log_act='D' where msalzon_id=@msalzon_id

end
		