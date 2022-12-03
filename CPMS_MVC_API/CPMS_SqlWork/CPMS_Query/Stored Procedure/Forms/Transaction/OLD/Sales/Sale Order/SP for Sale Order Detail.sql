use meiji_rusk
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

--alter table t_dso add dso_bat varchar(100)
--alter table t_dso add dso_mandat datetime
--alter table t_dso add dso_expdat datetime

--alter table t_dso add dso_peti float
--alter table t_dso add dso_crat float

--alter table t_dso drop column dso_bdisper,dso_bdisamt
--update t_dso set dso_bdisper=0,dso_bdisamt =0
--select * from t_dso

--alter table t_dso add dso_despa float,dso_despb float,dso_ret float,dso_usola float,dso_usolb float,dso_sol float,dso_commper float,dso_commamt float

--Insert
alter proc ins_t_dso(@titm_id int,@dso_despa float,@dso_despb float,@dso_ret float,@dso_usola float,@dso_usolb float,@dso_sol float,@dso_rat float,@dso_amt float,@dso_commper float,@dso_commamt float,@dso_namt float,@mso_id int)
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
@mso_qty float,
@lot_id int,
@mdc_id int,
@minv_id int,
@row_id int,
@ddc_qty float
begin
	set @row_id =1
	set @m_yr_id=(select m_yr_id from t_mso where mso_id=@mso_id)
	set @Cur_id=(select cur_id from m_cur where cur_typ='S')
	set @stk_dat=(select mso_dat from t_mso where mso_id=@mso_id)
	set @mdc_id=(select mdc_id from t_mdc where mso_id=@mso_id)
	set @minv_id=(select minv_id from t_minv where mdc_id=@mdc_id)
		
	set @ddc_qty=@dso_despa+@dso_despb	
	set @dso_id=(select max(dso_id)+1 from t_dso)
		if @dso_id is null
			begin
				set @dso_id=1
			end
	insert into t_dso(dso_id,dso_despa,dso_despb,dso_ret,dso_usola,dso_usolb,dso_sol,dso_rat,dso_amt,dso_commper,dso_commamt,dso_namt,mso_id,titm_id,dso_act)
			values(@dso_id,@dso_despa,@dso_despb,@dso_ret,@dso_usola,@dso_usolb,@dso_sol,@dso_rat,@dso_amt,@dso_commper,@dso_commamt,@dso_namt,@mso_id,@titm_id,0)
	
		
		----Delivery Chalan Detail		
		exec ins_t_ddc @ddc_qty,0,@titm_id,null,@mdc_id,null,@lot_id,0,0,null,0,0,'','',@dso_despa,@dso_despb,@dso_ret,@dso_usola,@dso_usolb
			
		----Invoice Detail
		exec ins_t_dinv_dc @minv_id,@mdc_id 
		
		----Invoice
		exec ins_t_dinv 0,0,0,@dso_rat,0,@dso_amt,0,@dso_commper,@dso_commamt,0 ,0 ,0 ,0 ,0 ,0 ,@dso_namt,0,@minv_id,@titm_id,null,null,null,@row_id,@mdc_id,0,0,null,0,'','','',@dso_despa,@dso_despb,@dso_ret,@dso_usola,@dso_usolb
		
end
go	

--Delete
alter proc del_t_dso(@mso_id int)
as
declare 
@mpso_id int,
@mdc_id int,
@minv_id int
begin

	set @mdc_id =(select mdc_id from t_mdc where mso_id=@mso_id)
	set @minv_id =(select minv_id from t_minv where mdc_id=@mdc_id)

	--Invoice DC
	exec del_t_dinv_dc @minv_id
	--Invoice
	exec del_t_dinv @minv_id
	--Delivery Chalan Detail
	exec del_t_ddc @mdc_id
	--Delete Detail Record
	delete from t_dso where mso_id=@mso_id
	
 
end
