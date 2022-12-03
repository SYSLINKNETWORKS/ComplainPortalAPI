
use phm
go
--alter table m_stk add stk_famt as stk_qty*stk_rat, stk_amt as stk_qty*(stk_rat*stk_currat)
--alter table t_dso add dso_act bit default 0
--alter table t_dso add dso_stdsiz int,sca_id int
--update t_dso set dso_stdsiz=1 ,sca_id=1
--alter table t_dso add constraint FK_TDSO_SCAID foreign key (sca_id) references m_sca(sca_id)
--update t_dso set dso_stdsiz=(select master_titm_qty from t_itm where t_itm.titm_id=t_dso.titm_id),sca_id=(select inner_sca_id from t_itm where t_itm.titm_id=t_dso.titm_id)
--alter table t_dso add dso_bqty float
--alter table t_dso add dso_schamt float
--alter table t_dso add free_titm_id int
--alter table t_dso add dso_freeqty float
--alter table t_dso add dso_appqty float
--alter table t_dso add dso_titm_id_free int
--alter table t_dso add constraint FK_DSO_TITMIDFREE foreign key (titm_id) references t_itm(titm_id)
--update t_dso set dso_titm_id_free=free_titm_id
--alter table t_dso drop column free_titm_id
--alter table t_dso add dso_schper float
--update t_dso set dso_schper=0


--Insert
alter proc ins_t_dso(@dso_stdsiz float,@dso_qty float,@dso_appqty float,@dso_rat float,@dso_amt float,@dso_disper float,@dso_disamt float,@dso_othamt float,@dso_namt float,@titm_id int,@itmqty_id int,@mso_id int,@sca_id int,@dso_act bit,@dso_bqty float,@dso_schper float,@dso_schamt float,@dso_titm_id_free int,@dso_freeqty float)
as
declare
@dso_id int,
@m_yr_id char(2),
@cur_id int,
@stk_dat datetime,
@stk_rat float,
@stk_dat_old datetime,
@stk_qty float,
@stk_amt float,
@dpso_qty float,
@mpso_id int,
@mpso_qty float,
@mso_qty float
begin
	set @mpso_id=(select mpso_id from t_mso where mso_id=@mso_id)
	set @m_yr_id=(select m_yr_id from t_mso where mso_id=@mso_id)
	set @Cur_id=(select cur_id from m_cur where cur_typ='S')
	set @stk_dat=(select mso_dat from t_mso where mso_id=@mso_id)

	set @dso_id=(select max(dso_id)+1 from t_dso)
		if @dso_id is null
			begin
				set @dso_id=1
			end
	insert into t_dso(dso_id,dso_qty,dso_appqty,dso_rat,dso_amt,dso_disper,dso_disamt,dso_othamt,dso_namt,titm_id,itmqty_id,mso_id,dso_act,dso_stdsiz,sca_id,dso_bqty,dso_schper,dso_schamt,dso_titm_id_free,dso_freeqty)
			values(@dso_id,@dso_qty,@dso_appqty,@dso_rat,@dso_amt,@dso_disper,@dso_disamt,@dso_othamt,@dso_namt,@titm_id,@itmqty_id,@mso_id,@dso_act,@dso_stdsiz,@sca_id,@dso_bqty,@dso_schper,@dso_schamt,@dso_titm_id_free,@dso_freeqty)
	
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
	insert into m_stk(t_id,itm_id,itmqty_id,stk_stdsiz,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,m_yr_id,cur_id,stk_currat,mso_id) 
		values(@mso_id,@titm_id,@itmqty_id,@dso_stdsiz,-@dso_appqty,@stk_rat,'S','I','SO',@stk_dat,@m_yr_id,@cur_id,1,@mso_id)



		--Update Estimate Status
			set @dpso_qty=(select sum(dpso_qty) from t_dpso where mpso_id=@mpso_id and titm_id=@titm_id and itmqty_id=@itmqty_id and dpso_stdsiz=@dso_stdsiz)
			set @dso_appqty=(select sum(dso_appqty) from t_dso where mso_id=@mso_id and titm_id=@titm_id and itmqty_id=@itmqty_id and dso_stdsiz=@dso_stdsiz)
			if((@dpso_qty-@dso_qty)=0)
				begin
					update t_dpso set dpso_act=1 where mpso_id=@mpso_id and titm_id=@titm_id and itmqty_id=@itmqty_id
				end
			set @mpso_qty=isnull((select SUM(dpso_qty) from t_dpso where mpso_id=@mpso_id and dpso_act=0 ),0)
			if(@mpso_qty=0)
				begin
					update t_mpso set mpso_act=1 where mpso_id=@mpso_id
				end				
end




go	

--Delete
alter proc del_t_dso(@mso_id int)
as
declare 
@mpso_id int
begin

	set @mpso_id=(select mpso_id from t_mso where mso_id=@mso_id)
	update t_dpso set dpso_act=0 where mpso_id =@mpso_id and titm_id in (select titm_id from t_dso where mso_id=@mso_id) and itmqty_id in (select itmqty_id from t_dso where mso_id=@mso_id) and dpso_stdsiz in (select dso_stdsiz from t_dso where mso_id=@mso_id)
	update t_mpso set mpso_act=0 where mpso_id=@mpso_id

	--Stock
	delete from m_stk where t_id=@mso_id and stk_frm='SO'
	--Delete Detail Record
	delete from t_dso where mso_id=@mso_id

end
