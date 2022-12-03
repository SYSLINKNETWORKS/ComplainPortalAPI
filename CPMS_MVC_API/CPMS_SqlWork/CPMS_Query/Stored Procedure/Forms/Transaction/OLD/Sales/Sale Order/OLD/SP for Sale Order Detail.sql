
USE ZSONS
go
--alter table m_stk add stk_famt as stk_qty*stk_rat, stk_amt as stk_qty*(stk_rat*stk_currat)
--alter table t_dso add dso_act bit default 0

--Insert
alter proc ins_t_dso(@dso_qty float,@dso_rat float,@dso_amt float,@dso_disper float,@dso_disamt float,@dso_othamt float,@dso_namt float,@titm_id int,@itmqty_id int,@mso_id int,@dso_act bit)
as
declare
@dso_id int,
@m_yr_id char(2),
@cur_id int,
@stk_dat datetime,
@stk_rat float,
@stk_dat_old datetime,
@stk_qty float,
@stk_amt float
begin
	set @m_yr_id=(select m_yr_id from t_mso where mso_id=@mso_id)
	set @Cur_id=(select cur_id from m_cur where cur_typ='S')
	set @stk_dat=(select mso_dat from t_mso where mso_id=@mso_id)

	set @dso_id=(select max(dso_id)+1 from t_dso)
		if @dso_id is null
			begin
				set @dso_id=1
			end
	insert into t_dso(dso_id,dso_qty,dso_rat,dso_amt,dso_disper,dso_disamt,dso_othamt,dso_namt,titm_id,itmqty_id,mso_id,dso_act)
			values(@dso_id,@dso_qty,@dso_rat,@dso_amt,@dso_disper,@dso_disamt,@dso_othamt,@dso_namt,@titm_id,@itmqty_id,@mso_id,@dso_act)
	
		set @stk_dat_old =DATEADD(DAY,-1,@stk_dat)
		set @stk_rat=0

		set @stk_qty=(isnull((select round(sum(stk_qty),4) from m_stk where stk_dat<=@stk_dat_old and itm_id=@titm_id and m_yr_id=@m_yr_id),0))
		set @stk_qty=@stk_qty+(isnull((select round(sum(stk_qty),4) from m_stk where stk_frm in ('t_itm','GRN') and stk_dat=@stk_dat and itm_id=@titm_id and m_yr_id=@m_yr_id),0))
		set @stk_amt=(isnull((select round(sum(stk_amt),4) from m_stk where stk_dat<=@stk_dat_old and itm_id=@titm_id and m_yr_id=@m_yr_id),0))
		set @stk_amt=@stk_amt+(isnull((select round(sum(stk_amt),4) from m_stk where stk_frm in ('t_itm','GRN') and stk_dat=@stk_dat and itm_id=@titm_id and m_yr_id=@m_yr_id),0))
		if (@stk_qty<>0)
			begin
				set @stk_rat=round(@stk_amt/@stk_qty,4)
			end
		else
			begin
				set @stk_rat=0
			end

	--Stock
	insert into m_stk(t_id,itm_id,itmqty_id,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,m_yr_id,cur_id,stk_currat,mso_id) 
		values(@mso_id,@titm_id,@itmqty_id,-@dso_qty,@stk_rat,'S','I','SO',@stk_dat,@m_yr_id,@cur_id,1,@mso_id)
				
end




go	

--Delete
alter proc del_t_dso(@mso_id int)
as
begin
	--Stock
	delete from m_stk where t_id=@mso_id and stk_frm='SO'
	--Delete Detail Record
	delete from t_dso where mso_id=@mso_id

end
