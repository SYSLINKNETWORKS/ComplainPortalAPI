USE ZSONS
GO
--select * from m_stk where itm_id=650 and m_yr_id='02'
--exec sp_trans_inv '01','01','02','01',5
--select titm_id,SUM(stk_qty) from m_stk inner join t_itm on m_stk.itm_id=t_itm.titm_id where m_yr_id='02' and stk_frm='t_itm' and t_itm.itm_id=5 group by titm_id having SUM(stk_qty)<0

--select * from m_stk where m_yr_id='02' and stk_frm='t_itm' and itm_id in (select titm_id from t_itm where itm_id=3)
--select * from m_stk where itm_id=68 and m_yr_id='02'

alter proc sp_trans_inv(@com_id char(2),@br_id char(3),@m_yr_id char(2),@m_yr_id_old char(2),@itm_id int)
as
declare 
@t_id int,
@stk_dat datetime,
@cur_id int,
@itm_cat char(1)
begin
	delete from m_stk where m_yr_id=@m_yr_id and stk_frm='t_itm' and itm_id in (select titm_id from t_itm where itm_id=@itm_id)
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	set @stk_dat=(select yr_str_dt from gl_m_yr where yr_id=@m_yr_id)
	set @t_id=(select MAX(t_id)+1 from m_stk)
	set @itm_cat=(select itm_Cat from m_itm where itm_id=@itm_id)
		if @t_id is null
			begin
				set @t_id=1
			end
	if (@itm_cat='F')
		begin
			insert into m_stk (t_id,itm_id,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_qtyacc,stk_bat,mso_id,stk_batst,titm_maf,stk_actrat,stk_foh)
			select @t_id,titm_id,round(SUM(isnull(stk_qty,0)),4),case when sum(stk_qty)>0 then round(AVG(isnull(stk_trat,0)),4) else 0 end,'U','R','t_itm',@stk_dat,isnull(wh_id,(select top 1 wh_id from m_itm where itm_id=t_itm.itm_id)),m_stk.bd_id,@m_yr_id,titm_exp,@cur_id,1,0,m_stk.stk_bat,m_stk.mso_id,0,@stk_dat,0,0 
			from t_itm 
			inner join m_stk 
			on t_itm.titm_id=m_stk.itm_id
			where t_itm.itm_id=@itm_id
			and m_yr_id=@m_yr_id_old
			group by titm_id,wh_id,m_Stk.bd_id,t_itm.itm_id,m_stk.stk_bat,m_Stk.mso_id,titm_exp
			having sum(stk_qty)<>0
		end
	else if(@itm_cat ='G')
		begin
			insert into m_stk (t_id,itm_id,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_qtyacc,stk_bat,mso_id,stk_batst,titm_maf,stk_actrat,stk_foh)
			select @t_id,titm_id,round(SUM(isnull(stk_qty,0)),4),case when sum(stk_qty)>0 then round(AVG(isnull(stk_trat,0)),4) else 0 end,'U','R','t_itm',@stk_dat,isnull(wh_id,(select top 1 wh_id from m_itm where itm_id=t_itm.itm_id)),m_stk.bd_id,@m_yr_id, null ,@cur_id,1,0,null,null,0,null,0,0 
			from t_itm 
			inner join m_itmsub
			on t_itm.itmsub_id=m_itmsub.itmsub_id 
			inner join m_itmsubmas
			on m_itmsub.itmsubmas_id =m_itmsubmas.itmsubmas_id
			left join m_stk 
			on t_itm.titm_id=m_stk.itm_id
			and m_yr_id=@m_yr_id_old
			where t_itm.itm_id=@itm_id and itmsubmas_expact =0
			group by titm_id,wh_id,m_Stk.bd_id,t_itm.itm_id
			having SUM(stk_qty)<>0
			--With Expiry
			insert into m_stk (t_id,itm_id,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_qtyacc,stk_bat,mso_id,stk_batst,titm_maf,stk_actrat,stk_foh)
			select @t_id,titm_id,round(SUM(isnull(stk_qty,0)),4),case when sum(stk_qty)>0 then round(AVG(isnull(stk_trat,0)),4) else 0 end,'U','R','t_itm',@stk_dat,isnull(wh_id,(select top 1 wh_id from m_itm where itm_id=t_itm.itm_id)),t_itm.bd_id,@m_yr_id,titm_exp,@cur_id,1,0,null,null,0,null,0,0 
			from t_itm 
			inner join m_itmsub
			on t_itm.itmsub_id=m_itmsub.itmsub_id 
			inner join m_itmsubmas
			on m_itmsub.itmsubmas_id =m_itmsubmas.itmsubmas_id
			left join m_stk 
			on t_itm.titm_id=m_stk.itm_id
			and m_yr_id=@m_yr_id_old
			where t_itm.itm_id=@itm_id and itmsubmas_expact=1
			group by titm_id,wh_id,m_Stk.bd_id,t_itm.itm_id,t_itm.bd_id ,itmsubmas_expact,titm_exp
			having sum(stk_qty)<>0
		end
	else
		begin		
			insert into m_stk (t_id,itm_id,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_qtyacc,stk_bat,mso_id,stk_batst,titm_maf,stk_actrat,stk_foh)
			select @t_id,titm_id,round(SUM(isnull(stk_qty,0)),4),case when sum(stk_qty)>0 then (select round(avg(stk_trat),4) from m_stk mstk where m_yr_id=@m_yr_id and itm_id=t_itm.titm_id and stk_frm in ('t_itm','GRN')) else 0 end,'U','R','t_itm',@stk_dat,isnull(wh_id,(select top 1 wh_id from m_itm where itm_id=t_itm.itm_id)),null,@m_yr_id,null,@cur_id,1,0,null,null,0,null,0,0 
			from t_itm 
			left join m_stk 
			on t_itm.titm_id=m_stk.itm_id
			and m_yr_id=@m_yr_id_old
			where t_itm.itm_id=@itm_id 
			group by titm_id,wh_id,m_Stk.bd_id,t_itm.itm_id
			having sum(stk_qty)<>0
		end
end

