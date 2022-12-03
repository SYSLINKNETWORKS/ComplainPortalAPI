USE meiji_rusk
GO


--alter table t_dfg add dfg_scrp float,dfg_wstg float
--alter table t_dfg add dfg_chlbk varchar(100)
--alter table t_dfg add dfg_actwei float,dfg_actwal float,dfg_actod float
--alter table t_dfg add itmqty_id int
--alter table t_dfg add constraint FK_TDFG_ITMQTYID foreign key (itmqty_id) references m_itmqty(itmqty_id)

--alter table t_dfg add dfg_rej float
--update t_dfg set dfg_rej=0


--Insert
alter proc [dbo].[ins_t_dfg](@titm_id int,@wh_id int,@dfg_chlbk varchar(100),@dfg_bat varchar(100),@dfg_rec float,@dfg_rej float,@dfg_scrp float,@dfg_wstg float,@dfg_actwei float,@dfg_actwal float,@dfg_actod float,@itmqty_id int,@mfg_id int)
as
declare
@dfg_id int,
@dfg_rat float,
@titm_id_scr int,
@titm_id_was int,
@mfg_dat datetime,
@m_yr_id char(2),
@com_id char(2),
@br_id char(3),
@cur_id int

begin

	set @mfg_dat=(select mfg_dat from t_mfg where mfg_id=@mfg_id)
	set @com_id=(select com_id from t_mfg where mfg_id=@mfg_id)
	set @br_id=(select br_id from t_mfg where mfg_id=@mfg_id)
	set @m_yr_id=(select m_yr_id from t_mfg where mfg_id=@mfg_id)
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	set @dfg_rat=(select titmrat_rrat from t_itmrat where titm_id=@titm_id and titmrat_dat=(select MAX(titmrat_dat) from t_itmrat titmrat where t_itmrat.titm_id=titmrat.titm_id and titmrat.titmrat_dat <=@mfg_dat))
	set @dfg_id=(select max(dfg_id)+1 from t_dfg)
		if @dfg_id is null
			begin
				set @dfg_id=1
			end
		if(@itmqty_id=0)
			begin
				set @itmqty_id=null
			end
			
	insert into t_dfg(dfg_id,dfg_bat,dfg_chlbk,dfg_rec,dfg_rej,dfg_scrp,dfg_wstg,dfg_actwei,dfg_actwal,dfg_actod,dfg_rat,titm_id,itmqty_id,mfg_id,wh_id)
		values(@dfg_id,@dfg_bat,@dfg_chlbk,@dfg_rec,@dfg_rej,@dfg_scrp,@dfg_wstg,@dfg_actwei,@dfg_actwal,@dfg_actod,@dfg_rat,@titm_id,@itmqty_id,@mfg_id,@wh_id)
		
--Stock
		insert into m_stk(com_id,br_id,t_id,itm_id,itmqty_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,m_yr_id,cur_id,stk_currat,stk_bat,mso_id) 
			values(@com_id,@br_id,@mfg_id,@titm_id,@itmqty_id,@dfg_rec,0,@dfg_rat,'S','R','TransFG','',@mfg_dat,@wh_id,@m_yr_id,@cur_id,1,@dfg_bat,null)

		insert into m_stk(com_id,br_id,t_id,itm_id,itmqty_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,m_yr_id,cur_id,stk_currat,stk_bat,mso_id) 
			values(@com_id,@br_id,@mfg_id,@titm_id,@itmqty_id,@dfg_rej,0,@dfg_rat,'S','R','TransRej','',@mfg_dat,@wh_id,@m_yr_id,@cur_id,1,@dfg_bat,null)
		

end
GO

--Delete
alter proc [dbo].[del_t_dfg](@mfg_id int)
as
declare
@m_yr_id char(2)
begin
	set @m_yr_id=(select m_yr_id from t_mfg where mfg_id=@mfg_id)
	--Stock 
	delete from m_Stk where stk_frm='TransFG' and t_id=@mfg_id and m_yr_id=@m_yr_id
	delete from m_Stk where stk_frm='TransRej' and t_id=@mfg_id and m_yr_id=@m_yr_id
	delete t_dfg where mfg_id=@mfg_id
end

go
