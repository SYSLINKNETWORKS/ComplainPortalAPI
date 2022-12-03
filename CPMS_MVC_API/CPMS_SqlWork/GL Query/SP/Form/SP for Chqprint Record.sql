create proc sp_chqprt(@chqprt_pay varchar(1000),@chqprt_payee bit,@chq_no float,@bk_id char(2),@chqprt_typ char(1))
as
declare
@chqprt_id int,
@ck_chq_no float,
@chqprt_dat datetime
begin
		set @chqprt_id=(select max(chqprt_id) from t_chqprt)+1
		set @ck_chq_no=(select chq_no from t_chqprt where chq_no=@chq_no)
		set @chqprt_dat=current_timestamp
		if @ck_chq_no is not null
			begin
				delete from t_chqprt where chq_no=@ck_chq_no
			end
		
			if @chqprt_id is null
				begin			
					set @chqprt_id =1
				end
		insert into t_chqprt (chqprt_id,chqprt_dat,chqprt_pay,chqprt_payee,bk_id,chq_no,chqprt_typ)
			values (@chqprt_id,@chqprt_dat,@chqprt_pay,@chqprt_payee,@bk_id,@chq_no,@chqprt_typ)
end
--exec sp_chqprt 'Cash',1,198908,'01','U'
