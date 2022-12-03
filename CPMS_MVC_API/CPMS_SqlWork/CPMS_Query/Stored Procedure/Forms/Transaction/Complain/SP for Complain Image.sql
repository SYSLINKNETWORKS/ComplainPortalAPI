use CPMS
go

--alter table t_dcomp_img add imgarc_img image, imgarc_img_byt nvarchar(max), imgarc_noimg bit default 0

--,@imgarc_img image
--Insert
alter proc ins_t_dcomp_img(@dcomp_img_file varchar(max),@mcomp_id int,@imgarc_img_byt nvarchar(max),@imgarc_noimg bit,@dcomp_img_id_out int output)
as
declare
@dcomp_img_id int

begin
	
	set @dcomp_img_id=(select max(dcomp_img_id)+1 from t_dcomp_img)
		if @dcomp_img_id is null
			begin
				set @dcomp_img_id=1
			end
	insert into t_dcomp_img(dcomp_img_id,dcomp_img_file,mcomp_id,imgarc_img,imgarc_img_byt,imgarc_noimg)
			values(@dcomp_img_id,@dcomp_img_file,@mcomp_id,null,@imgarc_img_byt,@imgarc_noimg)
			
	set @dcomp_img_id_out=@dcomp_img_id
		
end
go	

--Delete
alter proc del_t_dcomp_img(@dcomp_img_id int)
as
begin	

	--Delete Detail Record
	delete from t_dcomp_img where dcomp_img_id=@dcomp_img_id
		
end
