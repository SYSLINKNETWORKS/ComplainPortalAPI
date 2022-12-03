USE PAGEY
GO
--SELECT * FROM gl_bk_chq
--update gl_bk_chq set chq_act=0 where chq_act='N'
--update gl_bk_chq set chq_act=1 where chq_act='Y'
--alter table gl_bk_chq drop constraint DF__gl_bk_chq__chq_a__0A888742
--alter table gl_bk_chq alter column chq_act bit

----Insert Bank Cheque
ALTER proc [dbo].[ins_chq](@com_id char(2),@br_id char(2),@bk_id char(2),@chq_str_no int,@chq_lev_no int,@chq_no char(100),@chq_lev int,@chq_rmk varchar(255),@chq_typ char(1))
as
declare
@chq_id int
begin

	--Inserting record in Chq Book Leaves
	set @chq_lev=cast(@chq_no as int)+@chq_lev
	while cast(@chq_no as int) < @chq_lev
		begin
				insert into gl_bk_chq 
				(com_id,bk_id,chq_str_no,chq_lev,chq_no,chq_rmk,br_id,chq_typ,chq_act)
				values
				(@com_id,@bk_id,@chq_str_no,@chq_lev_no,@chq_no,@chq_rmk,@br_id,@chq_typ,1)
			set @chq_no= @chq_no+1
		end
end


--exec ins_chq '0101','01',0409141,10,''
--select * from gl_bk_chq
--select * from gl_m_bk
GO


----Update Bank Cheque

ALTER proc [dbo].[upd_chq](@com_id char(2),@br_id char(3),@bk_id char(2),@chq_no int,@chq_act bit,@chq_rmk varchar(255),@chq_rmk_ck char(10))
as
declare
@act int
begin 
	update gl_bk_chq set chq_rmk=@chq_rmk, chq_act=@chq_act where bk_id=@bk_id  and com_id=@com_id and br_id=@br_id and chq_no=@chq_no
		
end
GO

--select * from gl_bk_chq where chq_no=198806

--Delete the Bank Cheque
ALTER proc [dbo].[del_chq] (@bk_id char(2),@com_id char(2) ,@br_id char(3),@chq_str_no int)
as
declare
@bk_count int
begin
	set @bk_count =(select count(*) from gl_bk_chq where com_id=@com_id and br_id=@br_id and bk_id=@bk_id and chq_str_no=@chq_str_no and chq_typ='S')
	if (@bk_count is not null)
		begin
			delete from gl_bk_chq where bk_id =@bk_id and com_id=@com_id and br_id=@br_id and chq_str_no=@chq_str_no
			
		end
	
	
	set @bk_count=(select count(*) from gl_bk_chq where bk_id=@bk_id)
	print @bk_count		
	if @bk_count<1
		begin
			update gl_m_bk set bk_typ='U' where bk_id=@bk_id
		end
end	

--SELECT * from gl_bk_chq where bk_id=05
--select count(*) from gl_bk_chq where bk_id=05
GO

select mvch_chq from t_mvch where typ_id=04
select * from gl_bk_chq where chq_no=62703301
select * from gl_m_bk where bk_id=01
