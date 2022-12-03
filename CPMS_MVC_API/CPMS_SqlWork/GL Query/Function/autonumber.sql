
----Function for autonumber
create function [dbo].[autonumber](@field varchar(255),@len int)
returns varchar(100)
as
begin
declare
@tacc_id varchar(6),
@c int 
	set @tacc_id=@field
	set @c=0
	if @tacc_id ='' or @tacc_id is null
		begin
			set @tacc_id=0
		end
		begin
			set @tacc_id=@tacc_id +1
			while  @c  < @len
				begin
					if len(@tacc_id)<@len
						begin
							set @tacc_id= '0' + @tacc_id
						end
					set @c= @c +1
				end 		
		end		
	return @tacc_id
end
GO

