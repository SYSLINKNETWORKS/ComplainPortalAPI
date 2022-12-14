
--Insert Financial Year
ALTER proc [dbo].[ins_yr](@com_id char(2),@br_id char(2),@yr_str_dt datetime,@yr_end_dt datetime,@yr_active varchar(1),@yr_typ char(1),@yr_id_out char(2) output)
as
declare
@yr_id			varchar(2),
@yr_str_yy		varchar(4),
@yr_str_mn		varchar(2),
@yr_str_dy		varchar(2),
@yr_end_yy		varchar(4),
@yr_end_mn		varchar(2),
@yr_end_dy		varchar(2)
begin	
	set @yr_id		=		(select max(yr_id) from gl_m_yr)
	set @yr_id		=		dbo.autonumber(@yr_id,2)
	set @yr_str_yy	=		year(@yr_str_dt)
	set @yr_end_yy	=		year(@yr_end_dt)
	set @yr_str_mn	=		month(@yr_str_dt)
	set @yr_end_mn	=		month(@yr_end_dt)
	set @yr_str_dy	=		day(@yr_str_dt)
	set @yr_end_dy	=		day(@yr_end_dt)
	insert into gl_m_yr
	(com_id,br_id,yr_id,yr_str_yy,yr_str_mn,yr_str_dy,yr_str_dt,yr_end_yy,yr_end_mn,yr_end_dy,yr_end_dt,yr_ac,yr_typ)
	values
	(@com_id,@br_id,@yr_id,@yr_str_yy,@yr_str_mn,@yr_str_dy,@yr_str_dt,@yr_end_yy,@yr_end_mn,@yr_end_dy,@yr_end_dt,@yr_active,@yr_typ)
	
	set @yr_id_out=@yr_id
	if (@yr_active='Y')
		begin
			update gl_m_yr set yr_ac='N' where yr_id not in (@yr_id)
		end
end
GO

----Update Financial Year

ALTER proc [dbo].[upd_yr](@com_id char(2),@br_id char(2),@yr_id char(2),@yr_str_dt datetime,@yr_end_dt datetime,@yr_active varchar(1),@yr_typ char(1))
as
declare
@yr_str_yy		varchar(4),
@yr_str_mn		varchar(2),
@yr_str_dy		varchar(2),
@yr_end_yy		varchar(4),
@yr_end_mn		varchar(2),
@yr_end_dy		varchar(2)
begin	
	set @yr_str_yy	=		year(@yr_str_dt)
	set @yr_end_yy	=		year(@yr_end_dt)
	set @yr_str_mn	=		month(@yr_str_dt)
	set @yr_end_mn	=		month(@yr_end_dt)
	set @yr_str_dy	=		day(@yr_str_dt)
	set @yr_end_dy	=		day(@yr_end_dt)
	update gl_m_yr set
	yr_str_yy=@yr_str_yy,yr_str_mn=@yr_str_mn,yr_str_dy=@yr_str_dy,yr_str_dt=@yr_str_dt,yr_end_yy=@yr_end_yy,yr_end_mn=@yr_end_mn,yr_end_dy=@yr_end_dy,yr_end_dt=@yr_end_dt,yr_ac=@yr_active,yr_typ=@yr_typ
	where yr_id=@yr_id and com_id=@com_id and br_id=@br_id

	if (@yr_active='Y')
			begin
				update gl_m_yr set yr_ac='N' where yr_id not in (@yr_id)
			end
end
GO


--Delete Financial Year

ALTER proc [dbo].[del_yr](@com_id char(2),@br_id char(3),@yr_id char(2))
as
delete from gl_m_yr where com_id=@com_id and br_id=@br_id and yr_id =@yr_id
GO


