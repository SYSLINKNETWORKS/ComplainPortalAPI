USE ZSONS
GO

--Insert
create proc [dbo].[ins_t_diarc](@com_id char(2),@br_id char(3),@diarc_filepath varchar(1000),@diarc_filename varchar(250),@diarc_extension varchar(100),@miarc_id int,@diarc_col1 varchar(1000))
as
declare
@diarc_id int
begin
	set @diarc_id=(select max(diarc_id)+1 from t_diarc)
		if @diarc_id is null
			begin
				set @diarc_id=1
			end
	insert into t_diarc(com_id,br_id,diarc_id,diarc_filepath,diarc_filename,diarc_extension,miarc_id,diarc_col1)
					values (@com_id,@br_id,@diarc_id,@diarc_filepath,@diarc_filename,@diarc_extension,@miarc_id,@diarc_col1)

end
GO

--Delete
create proc [dbo].[del_t_diarc](@com_id char(2),@br_id char(3),@miarc_id int)
as
begin
	delete t_diarc where com_id=@com_id and br_id=@br_id and miarc_id=@miarc_id
end
GO
