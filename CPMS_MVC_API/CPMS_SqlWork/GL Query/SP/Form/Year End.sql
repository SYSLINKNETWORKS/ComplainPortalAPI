USE ZSONS
GO
--exec PL_year_end '01','01','01','02',''

alter proc PL_year_end (@com_id char(3),@br_id char(3),@m_yr_id_old char(2),@m_yr_id char(2),@mvch_tax bit,@pl_acc char(20))
as
declare 
@dvch_dr_famt float,
@dvch_cr_famt float,
@dvch_dr_diff float,
@dvch_cr_diff float,
@cur_id int,
@mvch_id int,
@pl_acc_no int
begin
	--Non- Tax
	set @pl_acc_no=(select acc_no from gl_m_acc where com_id=@com_id and acc_id=@pl_acc)
	set @dvch_dr_famt=(select case when sum(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0))>= 0 then sum(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0)) else 0 end from t_mvch inner join t_dvch on t_mvch.com_id=t_Dvch.com_id and t_mvch.br_id=t_Dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_acc on t_dvch.com_id=gl_m_acc.com_id and t_dvch.acc_no=gl_m_acc.acc_no where t_mvch.com_id=@com_id and left(acc_id,2) in ('04','05') and mvch_can=0 and yr_id=@m_yr_id_old and mvch_tax=@mvch_tax)
	set @dvch_cr_famt=(select case when sum(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0))< 0 then -(sum(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0))) else 0 end from t_mvch inner join t_dvch on t_mvch.com_id=t_Dvch.com_id and t_mvch.br_id=t_Dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_acc on t_dvch.com_id=gl_m_acc.com_id and t_dvch.acc_no=gl_m_acc.acc_no where t_mvch.com_id=@com_id and left(acc_id,2) in ('04','05')  and mvch_can=0 and yr_id=@m_yr_id_old and mvch_tax=@mvch_tax)
	set @dvch_dr_famt=@dvch_dr_famt+isnull((select case when sum(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0))>= 0 then sum(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0)) else 0 end from t_mvch inner join t_dvch on t_mvch.com_id=t_Dvch.com_id and t_mvch.br_id=t_Dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_acc on t_dvch.com_id=gl_m_acc.com_id and t_dvch.acc_no=gl_m_acc.acc_no where t_mvch.com_id=@com_id and acc_id=@pl_acc and mvch_can=0 and yr_id=@m_yr_id_old and mvch_tax=@mvch_tax),0)
	set @dvch_cr_famt=@dvch_cr_famt+isnull((select case when sum(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0))< 0 then -(sum(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0))) else 0 end from t_mvch inner join t_dvch on t_mvch.com_id=t_Dvch.com_id and t_mvch.br_id=t_Dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_acc on t_dvch.com_id=gl_m_acc.com_id and t_dvch.acc_no=gl_m_acc.acc_no where t_mvch.com_id=@com_id and acc_id=@pl_acc and mvch_can=0 and yr_id=@m_yr_id_old and mvch_tax=@mvch_tax),0)
	if ((@dvch_dr_famt-@dvch_cr_famt)>=0)
		begin
			set @dvch_dr_famt=@dvch_dr_famt-@dvch_cr_famt
			set @dvch_cr_famt=0
		end
	else if ((@dvch_dr_famt-@dvch_cr_famt)<0)
		begin
			set @dvch_dr_famt=0
			set @dvch_cr_famt=-(@dvch_dr_famt-@dvch_cr_famt)			
		end	
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	set @mvch_id=(select t_mvch.mvch_no from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_Dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_acc on t_mvch.com_id=gl_m_acc.com_id and t_dvch.acc_no= gl_m_acc.acc_no where acc_id=@pl_acc and yr_id=@m_yr_id  and mvch_tax=@mvch_tax)
	delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_id 
	delete from t_mvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_id 

	exec sp_voucher_openingvch @com_id,@br_id ,@m_yr_id,@pl_acc_no,@pl_acc,@cur_id,1,@mvch_tax,@dvch_dr_famt,@dvch_cr_famt,'','','',''

	set @dvch_dr_diff=@dvch_dr_famt+isnull((select case when sum(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0))>= 0 then sum(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0)) else 0 end   from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_Dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no where t_mvch.com_id=@com_id and yr_id=@m_yr_id and mvch_tax=@mvch_tax),0)
	set @dvch_cr_diff=@dvch_cr_famt+isnull((select case when sum(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0))< 0 then -(sum(isnull(dvch_dr_amt,0)-isnull(dvch_cr_amt,0))) else 0 end   from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_Dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no where t_mvch.com_id=@com_id and yr_id=@m_yr_id and mvch_tax=@mvch_tax),0)
	

end
--select * from t_dvch where acc_id='02003001094' and yr_id='01'


go
--update m_sys set pl_acc='01003'

--Opening Balances
--Opening Balances
alter proc ins_opening(@com_id char(2),@br_id char(3),@m_yr_id_old char(2),@m_yr_id char(2),@mvch_tax bit)
as
declare
@acc_id char(20),
@cur_id int,
@currat_rat float,
@dvch_dr_amt float,
@dvch_cr_amt float,
@dvch_dr_famt float,
@dvch_cr_famt float,
@acc_no int
begin
delete from t_dvch where com_id=@com_id and mvch_no in (select mvch_no from  t_mvch where com_id=@com_id and yr_id=@m_yr_id and mvch_tax=@mvch_tax)
delete from t_mvch where com_id=@com_id and typ_id='06' and yr_id=@m_yr_id and mvch_tax=@mvch_tax

	declare LOCALCUR cursor for 	
			SELECT t_dvch.acc_no,gl_m_acc.acc_id,t_mvch.cur_id,
			case when sum(dvch_dr_famt-dvch_cr_famt)>=0 then round(sum(dvch_dr_famt-dvch_cr_famt),4) else 0 end as [dvch_dr_amt],
			case when sum(dvch_dr_famt-dvch_cr_famt)<0 then -round(sum(dvch_dr_famt-dvch_cr_famt),4) else 0 end as [dvch_cr_amt]
			from t_mvch 
			inner join t_dvch 
			on t_mvch.com_id=t_dvch.com_id 
			and t_mvch.br_id=t_dvch.br_id 
			and t_mvch.mvch_no=t_dvch.mvch_no
			inner join gl_m_acc
			on t_dvch.acc_no=gl_m_acc.acc_no
			where t_mvch.yr_id=@m_yr_id_old
			 and mvch_tax=@mvch_tax and mvch_can=0
			and  left(gl_m_acc.acc_id,2) in ('01','02','03')
			group by t_mvch.cur_id,t_dvch.acc_no,gl_m_acc.acc_id 			
			order by acc_id
			OPEN LOCALCUR
			FETCH NEXT FROM LOCALCUR
			INTO @acc_no,@acc_id,@cur_id,@dvch_dr_famt,@dvch_cr_famt
				WHILE @@FETCH_STATUS = 0
				BEGIN
					if (@currat_rat is null)
						begin
							set @currat_rat=1
						end
			
					exec sp_voucher_openingvch @com_id,@br_id ,@m_yr_id,@acc_no,@acc_id,@cur_id,@currat_rat,@mvch_tax,@dvch_dr_famt,@dvch_cr_famt,'','','',''
					FETCH NEXT FROM LOCALCUR
					INTO @acc_no,@acc_id,@cur_id,@dvch_dr_famt,@dvch_cr_famt
				end
				CLOSE LOCALCUR
				DEALLOCATE LOCALCUR
	
end	

go
--Stock
create proc ins_inv_opening(@com_id char(2),@br_id char(3),@m_yr_id char(2),@m_yr_id_old char(2),@stk_tax bit)
as
declare 
@t_id int,
@stk_dat datetime,
@cur_id int,
@itm_id int,
@itm_cat char(1)
begin
	delete from m_stk where m_yr_id=@m_yr_id and stk_frm='t_itm' and stk_tax=@stk_tax
		set @cur_id=(select cur_id from m_cur where cur_typ='S')
		set @stk_dat=(select yr_str_dt from gl_m_yr where yr_id=@m_yr_id)
		set @t_id=(select MAX(t_id)+1 from m_stk)
		if @t_id is null
			begin
				set @t_id=1
			end

	declare curitem cursor for 	
		select itm_id,itm_cat from m_itm 
		OPEN curitem
			FETCH NEXT FROM curitem
			INTO @itm_id,@itm_cat
				WHILE @@FETCH_STATUS = 0
				BEGIN
				
				if (@itm_cat='F')
					begin
						insert into m_stk (t_id,itm_id,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_qtyacc,stk_bat,mso_id,stk_batst,titm_maf,stk_actrat,stk_foh,itmqty_id,stk_stdsiz,stk_taxqty,stk_tax)
						select @t_id,titm_id,round(SUM(isnull(stk_qty,0)),4),case when sum(stk_qty)>0 then round(AVG(isnull(stk_trat,0)),4) else 0 end,'U','R','t_itm',@stk_dat,isnull(wh_id,(select top 1 wh_id from m_itm where itm_id=t_itm.itm_id)),m_stk.bd_id,@m_yr_id,titm_exp,@cur_id,1,0,m_stk.stk_bat,m_stk.mso_id,0,@stk_dat,0,0,itmqty_id,stk_stdsiz,SUM(stk_taxqty),@stk_tax 
						from t_itm 
						inner join m_stk 
						on t_itm.titm_id=m_stk.itm_id
						where t_itm.itm_id=@itm_id
						and m_yr_id=@m_yr_id_old
						and stk_tax=@stk_tax
						group by titm_id,wh_id,m_Stk.bd_id,t_itm.itm_id,m_stk.stk_bat,m_Stk.mso_id,titm_exp,itmqty_id,stk_stdsiz
						having sum(stk_qty)<>0
					end
				else if(@itm_cat ='G')
					begin
						insert into m_stk (t_id,itm_id,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_qtyacc,stk_bat,mso_id,stk_batst,titm_maf,stk_actrat,stk_foh,itmqty_id,stk_stdsiz,stk_taxqty,stk_tax)
						select @t_id,titm_id,round(SUM(isnull(stk_qty,0)),4),case when sum(stk_qty)>0 then round(AVG(isnull(stk_trat,0)),4) else 0 end,'U','R','t_itm',@stk_dat,isnull(wh_id,(select top 1 wh_id from m_itm where itm_id=t_itm.itm_id)),m_stk.bd_id,@m_yr_id, null ,@cur_id,1,0,null,null,0,null,0,0,itmqty_id,stk_stdsiz,SUM(Stk_taxqty),@stk_tax 
						from t_itm 
						inner join m_itmsub
						on t_itm.itmsub_id=m_itmsub.itmsub_id 
						inner join m_itmsubmas
						on m_itmsub.itmsubmas_id =m_itmsubmas.itmsubmas_id
						left join m_stk 
						on t_itm.titm_id=m_stk.itm_id
						and m_yr_id=@m_yr_id_old
						where t_itm.itm_id=@itm_id and itmsubmas_expact =0
						and stk_tax=@stk_tax
						group by titm_id,wh_id,m_Stk.bd_id,t_itm.itm_id,itmqty_id,stk_stdsiz
						having SUM(stk_qty)<>0
						--With Expiry
						insert into m_stk (t_id,itm_id,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_qtyacc,stk_bat,mso_id,stk_batst,titm_maf,stk_actrat,stk_foh,itmqty_id,stk_stdsiz,stk_taxqty,stk_tax)
						select @t_id,titm_id,round(SUM(isnull(stk_qty,0)),4),case when sum(stk_qty)>0 then round(AVG(isnull(stk_trat,0)),4) else 0 end,'U','R','t_itm',@stk_dat,isnull(wh_id,(select top 1 wh_id from m_itm where itm_id=t_itm.itm_id)),t_itm.bd_id,@m_yr_id,titm_exp,@cur_id,1,0,null,null,0,null,0,0,itmqty_id,stk_stdsiz,SUM(stk_taxqty),@stk_tax 
						from t_itm 
						inner join m_itmsub
						on t_itm.itmsub_id=m_itmsub.itmsub_id 
						inner join m_itmsubmas
						on m_itmsub.itmsubmas_id =m_itmsubmas.itmsubmas_id
						left join m_stk 
						on t_itm.titm_id=m_stk.itm_id
						and m_yr_id=@m_yr_id_old
						where t_itm.itm_id=@itm_id and itmsubmas_expact=1
						and stk_tax=@stk_tax
						group by titm_id,wh_id,m_Stk.bd_id,t_itm.itm_id,t_itm.bd_id ,itmsubmas_expact,titm_exp,itmqty_id,stk_stdsiz
						having sum(stk_qty)<>0
					end
				else
					begin		
						insert into m_stk (t_id,itm_id,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,bd_id,m_yr_id,titm_exp,cur_id,stk_currat,stk_qtyacc,stk_bat,mso_id,stk_batst,titm_maf,stk_actrat,stk_foh,itmqty_id,stk_stdsiz,stk_taxqty,stk_tax)
						select @t_id,titm_id,round(SUM(isnull(stk_qty,0)),4),case when sum(stk_qty)>0 then (select round(avg(stk_trat),4) from m_stk mstk where m_yr_id=@m_yr_id and itm_id=t_itm.titm_id and stk_frm in ('t_itm','GRN')) else 0 end,'U','R','t_itm',@stk_dat,isnull(wh_id,(select top 1 wh_id from m_itm where itm_id=t_itm.itm_id)),null,@m_yr_id,null,@cur_id,1,0,null,null,0,null,0,0,itmqty_id,stk_stdsiz,SUM(stk_taxqty),@stk_tax 
						from t_itm 
						left join m_stk 
						on t_itm.titm_id=m_stk.itm_id
						and m_yr_id=@m_yr_id_old
						where t_itm.itm_id=@itm_id 
						and stk_tax=@stk_tax
						group by titm_id,wh_id,m_Stk.bd_id,t_itm.itm_id,itmqty_id,stk_stdsiz
						having sum(stk_qty)<>0
					end
			FETCH NEXT FROM curitem
					INTO @itm_id,@itm_cat
				end
				CLOSE curitem
				DEALLOCATE curitem
end
go
alter proc PL_YR_END(@com_id char(3),@br_id char(3),@yr_old_id char(2),@yr_new_id char(2),@pl_acc char(20))
as
--Non Tax
exec ins_opening @com_id,@br_id,@yr_old_id,@yr_new_id,0
exec PL_year_end @com_id,@br_id,@yr_old_id,@yr_new_id,@pl_acc,0
exec ins_inv_opening @com_id,@br_id,@yr_new_id,yr_old_id ,0
--Taxable
exec ins_opening @com_id,@br_id,@yr_old_id,@yr_new_id,1
exec PL_year_end @com_id,@br_id,@yr_old_id,@yr_new_id,@pl_acc,1
exec ins_inv_opening @com_id,@br_id,@yr_new_id,yr_old_id ,1

