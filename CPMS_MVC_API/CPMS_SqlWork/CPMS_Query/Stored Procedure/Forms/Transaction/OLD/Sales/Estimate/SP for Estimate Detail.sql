
USE ZSONS
go
--alter table m_stk add stk_famt as stk_qty*stk_rat, stk_amt as stk_qty*(stk_rat*stk_currat)
--alter table t_dso add dso_act bit default 0



--alter table t_dpso add sca_id int,dpso_stdsiz float
--update t_dpso set sca_id=1,dpso_stdsiz=0
--alter table t_dpso add constraint FK_TPDSO_SCAID foreign key (sca_id) references m_sca(sca_id)
--update t_dpso set dpso_stdsiz=(select master_titm_qty from t_itm where t_itm.titm_id=t_dpso.titm_id),sca_id=(select inner_sca_id from t_itm where t_itm.titm_id=t_dpso.titm_id)
--select * from t_itm

--Insert
alter proc ins_t_dpso(@dpso_qty float,@dpso_rat float,@dpso_amt float,@dpso_disper float,@dpso_disamt float,@dpso_othamt float,@dpso_namt float,@dpso_stdsiz float,@sca_id int,@titm_id int,@itmqty_id int,@mpso_id int,@dpso_act bit)
as
declare
@dpso_id int,
@m_yr_id char(2),
@cur_id int,
@stk_dat datetime,
@stk_rat float,
@stk_dat_old datetime,
@stk_qty float,
@stk_amt float
begin
	set @m_yr_id=(select m_yr_id from t_mso where mso_id=@mpso_id)
	set @Cur_id=(select cur_id from m_cur where cur_typ='S')
	set @stk_dat=(select mpso_dat from t_mpso where mpso_id=@mpso_id)

	set @dpso_id=(select max(dpso_id)+1 from t_dpso)
		if @dpso_id is null
			begin
				set @dpso_id=1
			end
	insert into t_dpso(dpso_id,dpso_qty,dpso_rat,dpso_amt,dpso_disper,dpso_disamt,dpso_othamt,dpso_namt,titm_id,itmqty_id,mpso_id,dpso_act,dpso_stdsiz,sca_id)
			values(@dpso_id,@dpso_qty,@dpso_rat,@dpso_amt,@dpso_disper,@dpso_disamt,@dpso_othamt,@dpso_namt,@titm_id,@itmqty_id,@mpso_id,@dpso_act,@dpso_stdsiz,@sca_id)
	
			
					
					
end




go	

--Delete
alter proc del_t_dpso(@mpso_id int)
as
begin
	--Delete Detail Record
	delete from t_dpso where mpso_id=@mpso_id

end
