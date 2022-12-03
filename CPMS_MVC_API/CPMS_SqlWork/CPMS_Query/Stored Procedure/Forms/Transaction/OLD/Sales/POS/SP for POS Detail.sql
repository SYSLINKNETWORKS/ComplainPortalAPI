USE NTHA
GO
--alter table t_dpos add titm_bar int
--alter table t_dpos add dpos_set float
--alter table t_dpos add dpos_rat float
--alter table t_dpos add dpos_amt float
--alter table t_dpos add itmqty_id int
--alter table t_dpos add constraint FK_dpos_itmqtyID foreign key (itmqty_id) references m_itmqty (itmqty_id)
--alter table m_stk add stk_bat varchar(1000)
--select * from t_mpos where mpos_no=420
--select * from t_dpos where mpos_id=2714
--alter table t_dpos alter column titm_bar varchar(100)


--Insert
alter proc ins_t_dpos(@dpos_qty float,@dpos_rat float,@dpos_amt float,@titm_id int,@mpos_id int,@dis_per float,@dis_amt float)
as
declare
@dpos_id int,
@cur_id int,
@wh_id int,
@mpos_rat float,
@titm_bar varchar(100),
@mpos_ret bit
begin
	  
	set @titm_bar=(select titm_bar from t_itm where titm_id=@titm_id)

	set @mpos_ret=(select mpos_ret from t_mpos where mpos_id=@mpos_id)
	set @wh_id=1
	
	set @mpos_rat = 1--(select cur_rat from t_mpso where mpso_id = @mso_id)
	set @cur_id = (select cur_id from t_mpos where mpos_id = @mpos_id)
	set @dpos_id=(select max(dpos_id)+1 from t_dpos)
	set @wh_id=1
		if @dpos_id is null
			begin
				set @dpos_id=1
			end
	insert into t_dpos(dpos_id,dpos_qty,mpos_id,titm_id,titm_bar,dpos_rat,dpos_amt,dis_per,dis_amt)
			values(@dpos_id,@dpos_qty,@mpos_id,@titm_id,@titm_bar,@dpos_rat,@dpos_amt,@dis_per,@dis_amt)


end

go
--Delete
alter proc del_t_dpos(@mpos_id int)
as
declare
@mso_id int
begin
	delete from t_dpos where mpos_id=@mpos_id
	delete from t_mpos_omop where mpos_id=@mpos_id
end
go
		
alter proc ins_mpos_omop(@mpos_id int,@mop_id int,@amt float)
as
declare
@tmpos_omop_id int
begin
set @tmpos_omop_id=(select max(tmpos_omop_id)+1 from t_mpos_omop)
		if @tmpos_omop_id is null
			begin
				set @tmpos_omop_id=1
			end
insert into t_mpos_omop (tmpos_omop_id,mop_id,amt,mpos_id)values(@tmpos_omop_id,@mop_id,@amt,@mpos_id)
end