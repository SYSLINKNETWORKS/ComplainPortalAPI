USE NATHI
go

--select * from t_mclaim
--select * from t_dclaim

--alter table t_dclaim add wh_id_rec int
--alter table t_dclaim add wh_id_iss int
--alter table t_dclaim add constraint FK_TDCLAIM_WHIDREC foreign key (wh_id_rec) references m_wh(wh_id)
--alter table t_dclaim add constraint FK_TDCLAIM_WHIDISS foreign key (wh_id_iss) references m_wh(wh_id)

--Insert
alter proc ins_t_dclaim(@titm_id_rec int,@dclaim_qtyrec float,@titm_id_iss int,@dclaim_qtyiss float,@mclaim_id int,@wh_id_rec int,@wh_id_iss int)
as
declare
@dclaim_id int,
@com_id char(2),
@br_id char(3),
@m_yr_id char(2),
@stk_dat datetime
begin	
		set @dclaim_id=(select max(dclaim_id)+1 from t_dclaim)
		set @stk_dat=(select mclaim_dat from t_mclaim where mclaim_id=@mclaim_id)
		set @com_id=(select com_id from t_mclaim where mclaim_id=@mclaim_id)
		set @br_id=(select br_id from t_mclaim where mclaim_id=@mclaim_id)
		set @m_yr_id=(select m_yr_id from t_mclaim where mclaim_id=@mclaim_id)
		
		if @dclaim_id is null
			begin
				set @dclaim_id=1
			end
	
	insert into t_dclaim(dclaim_id,titm_id_rec,dclaim_qtyrec,titm_id_iss,dclaim_qtyiss,mclaim_id,wh_id_rec,wh_id_iss)
			values(@dclaim_id,@titm_id_rec,@dclaim_qtyrec,@titm_id_iss,@dclaim_qtyiss,@mclaim_id,@wh_id_rec,@wh_id_iss)
			
	--Item Received		
	insert into m_stk(com_id,br_id,t_id,itm_id,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,m_yr_id) 
			values(@com_id,@br_id,@mclaim_id,@titm_id_rec,@dclaim_qtyrec,0,'S','R','TransclaimR',@stk_dat,@wh_id_rec,@m_yr_id)
	
	--Item Received		
	insert into m_stk(com_id,br_id,t_id,itm_id,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,m_yr_id) 
			values(@com_id,@br_id,@mclaim_id,@titm_id_iss,-@dclaim_qtyiss,0,'S','I','TransclaimI',@stk_dat,@wh_id_iss,@m_yr_id)
	
end

go	


--Delete
alter proc del_t_dclaim(@mclaim_id int)
as
begin
	delete from m_stk where t_id=@mclaim_id and stk_frm='TransclaimI'
	delete from m_stk where t_id=@mclaim_id and stk_frm='TransclaimR'
	delete from t_dclaim where mclaim_id=@mclaim_id

end

		


