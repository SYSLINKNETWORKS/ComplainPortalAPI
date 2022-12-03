use zsons
go


--create table t_dsm1 add dsm1_pettikg float,dsm1_titm_id_petti int,dsm1_petti_rat float
--create table t_dsm1 add miss_id int

--update t_dsm1 set dsm1_pettikg=0
--select * from m_stk where stk_frm='GRN' and t_id=651
--select * from t_dsm1 where mdsm1_id=393
--alter table t_dsm1 add dsm1_chlbk varchar(100)

--Insert
alter proc [dbo].[ins_t_dsm1](@dsm1_bat int,@dsm1_rec float,@dsm1_rat float,@dsm1_wstg float,@dsm1_scrp float,@dsm1_chlbk varchar(100),@titm_id int,@sm1_id int,@wh_id int,@miss_id int,@miss_bal float)
as
declare
@dsm1_id int,
@sm1_dat datetime,
@m_yr_id char(2),
@cur_id int,
@titm_id_was int,
@titm_id_scr int
begin

	set @sm1_dat=(select sm1_dat from t_sm1 where sm1_id=@sm1_id)
	set @m_yr_id =(select m_yr_id from t_sm1 where sm1_id=@sm1_id)
	set @cur_id=(select cur_id from m_cur where cur_typ='S')

	set @dsm1_id=(select max(dsm1_id)+1 from t_dsm1)
		if @dsm1_id is null
			begin
				set @dsm1_id=1
			end
			
			
	insert into t_dsm1(dsm1_id,dsm1_bat,dsm1_rec,dsm1_rat,dsm1_wstg,dsm1_scrp,dsm1_chlbk,titm_id,sm1_id,wh_id,miss_id)
		values(@dsm1_id,@dsm1_bat,@dsm1_rec,@dsm1_rat,@dsm1_wstg,@dsm1_scrp,@dsm1_chlbk,@titm_id,@sm1_id,@wh_id,@miss_id)

		
		
				
		if (@miss_bal<=0)
			begin
				update t_miss set miss_st=1 where miss_id=@miss_id
			end
		
		
--Stock

		insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,m_yr_id,cur_id,stk_currat,stk_bat,mso_id) 
			values(@sm1_id,@titm_id,@dsm1_rec,0,@dsm1_rat,'S','R','TransSF1','',@sm1_dat,@wh_id,@m_yr_id,@cur_id,1,@dsm1_bat,null)
--Scrap
		set @titm_id_scr=(select scr_id from t_itm where titm_id=@titm_id)
		insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,m_yr_id,cur_id,stk_currat,stk_bat,mso_id) 
			values(@sm1_id,@titm_id_scr,@dsm1_scrp,0,@dsm1_rat,'S','R','TransSF1','',@sm1_dat,@wh_id,@m_yr_id,@cur_id,1,@dsm1_bat,null)
--Wastage
		set @titm_id_was=(select was_id from t_itm where titm_id=@titm_id)
		insert into m_stk(t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,wh_id,m_yr_id,cur_id,stk_currat,stk_bat,mso_id) 
			values(@sm1_id,@titm_id_was,@dsm1_wstg,0,@dsm1_rat,'S','R','TransSF1','',@sm1_dat,@wh_id,@m_yr_id,@cur_id,1,@dsm1_bat,null)

end
GO
--exec  del_t_dsm1 13

--Delete
alter proc [dbo].[del_t_dsm1](@sm1_id int)
as

begin

	delete from m_stk where stk_frm ='TransSF1' and t_id=@sm1_id 
	
	delete t_dsm1 where sm1_id=@sm1_id
end

go
