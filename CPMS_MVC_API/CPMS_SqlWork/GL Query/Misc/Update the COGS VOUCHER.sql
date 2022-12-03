--declare 
--@miss_id int,
--@titm_id int,
--@miss_dat datetime,
--@diss_rat float
--declare  diss  cursor for
--	select t_miss.miss_id,t_diss.titm_id,miss_dat from t_miss inner join t_diss on t_miss.miss_id=t_diss.miss_id where miss_dat between '07/01/2012' and '06/30/2013'
--	OPEN diss
--		FETCH NEXT FROM diss
--				INTO @miss_id,@titm_id,@miss_dat
--			WHILE @@FETCH_STATUS = 0
--			BEGIN
--				set @diss_rat=(select case when sum(stk_qty)=0 then 0 else sum(stk_qty*stk_trat)/sum(stk_qty) end from m_Stk where stk_frm in ('t_itm','GRN') and itm_id=@titm_id and stk_dat<=@miss_dat)
								
--				update m_stk set stk_rat=@diss_rat where stk_frm='TransRM' and itm_id=@titm_id and stk_dat=@miss_dat and t_id=@miss_id
--				update t_diss set diss_rat=@diss_rat where  titm_id=@titm_id and miss_id=@miss_id
--				FETCH NEXT FROM diss
--				INTO @miss_id,@titm_id,@miss_dat
--	end
--	CLOSE diss
--	DEALLOCATE diss
--	GO
declare 
@miss_id int
declare  missvch  cursor for
	select miss_id from t_miss  --where miss_id=25
	OPEN missvch
		FETCH NEXT FROM missvch
				INTO @miss_id
			WHILE @@FETCH_STATUS = 0
			BEGIN
								
					exec sp_voucher_iss '01','01','01',@miss_id,1,'',''
				FETCH NEXT FROM missvch
				INTO @miss_id
	end
	CLOSE missvch
	DEALLOCATE missvch
	