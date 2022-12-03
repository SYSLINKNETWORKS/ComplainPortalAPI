use phm
go
--alter table t_ddc add ddc_stdsiz float,sca_id int
--alter table t_ddc add constraint FK_DDC_SCAID foreign key (sca_id) references m_Sca(sca_id)
--update t_ddc set ddc_stdsiz=(select master_titm_qty from t_itm where t_itm.titm_id=t_ddc.titm_id),sca_id=(select inner_sca_id from t_itm where t_itm.titm_id=t_ddc.titm_id)

--alter table t_ddc add ddc_taxqty float default 0
--update t_ddc set ddc_taxqty=0

--alter table m_stk add stk_taxqty float default 0
--alter table t_mdc add mdc_cktax bit default 0
--update t_mdc set mdc_cktax=0
--alter table t_ddc add ddc_tax bit default 0
--update t_ddc set ddc_tax=0
--alter table t_ddc add lot_id int
--alter table t_ddc add ddc_bqty float
--alter table t_ddc add ddc_schamt float
--alter table t_ddc add free_titm_id int
--alter table t_ddc add ddc_freeqty float
--alter table t_ddc add ddc_bat varchar(100)
--alter table t_ddc add ddc_mandat datetime
--alter table t_ddc add ddc_expdat datetime
--select * from t_ddc
 

--Insert
alter proc ins_t_ddc(@ddc_qty float,@ddc_stdsiz float,@titm_id int,@itmqty_id int,@mdc_id int,@sca_id int,@lot_id int,@ddc_bqty float,@ddc_schamt float,@free_titm_id int,@ddc_freeqty float,@ddc_bat varchar(100),@ddc_mandat datetime,@ddc_expdat datetime)
as
declare
@ddc_id int,
@wh_id int,
@stk_rat float,
@stk_dat_old datetime,
@stk_dat datetime,
@stk_qty float,
@stk_amt float,
@com_id char(2),
@br_id char(3),
@m_yr_id char(2),
@mdc_no int,
@mso_no int,
@mso_id int,
@cus_nam varchar(250),
@cur_id int,
@cur_rat float,
@stk_des varchar(1000),
@dso_qty float,
@mso_qty float,
@mdc_qty float,
@sca_met float
begin
	set @com_id=(select com_id from t_mdc where mdc_id=@mdc_id)
	set @br_id=(select br_id from t_mdc where mdc_id=@mdc_id)
	set @m_yr_id=(select m_yr_id from t_mdc where mdc_id=@mdc_id)
	set @mdc_no=(select mdc_no from t_mdc where mdc_id=@mdc_id)
	set @wh_id=(select wh_id from t_mdc where mdc_id=@mdc_id)
	set @mso_id=(select mso_id from t_mdc where mdc_id=@mdc_id)
	set @mso_no=(select mso_no from t_mso where mso_id=@mso_id)
	set @cus_nam=(select cus_nam from t_mso inner join m_cus on t_mso.com_id =m_cus.com_id and t_mso.cus_id=m_cus.cus_id where mso_id=@mso_id)
	set @sca_met=(select case sca_met when 0 then 1 else sca_met end as [sca_met] from m_sca where sca_id=@sca_id)
			
			set @ddc_id=(select max(ddc_id)+1 from t_ddc)
				if @ddc_id is null
					begin
						set @ddc_id=1
					end
			insert into t_ddc(ddc_id,ddc_qty,mdc_id,titm_id,itmqty_id,ddc_st,ddc_stdsiz,sca_id,lot_id,ddc_bqty,ddc_schamt,free_titm_id,ddc_freeqty,ddc_bat,ddc_mandat,ddc_expdat)
					values(@ddc_id,@ddc_qty,@mdc_id,@titm_id,@itmqty_id,0,@ddc_stdsiz,@sca_id,@lot_id,@ddc_bqty,@ddc_schamt,@free_titm_id,@ddc_freeqty,@ddc_bat,@ddc_mandat,@ddc_expdat)
					
					

		set @stk_dat_old =DATEADD(DAY,-1,@stk_dat)
		set @stk_rat=0

		set @stk_qty=(isnull((select round(sum(stk_qty),4) from m_stk where stk_dat<=@stk_dat_old and itm_id=@titm_id and m_yr_id=@m_yr_id),0))
		set @stk_qty=@stk_qty+(isnull((select round(sum(stk_qty),4) from m_stk where stk_frm in ('t_itm','GRN','TransFG') and stk_dat=@stk_dat and itm_id=@titm_id and m_yr_id=@m_yr_id),0))
		set @stk_amt=(isnull((select round(sum(stk_amt),4) from m_stk where stk_dat<=@stk_dat_old and itm_id=@titm_id and m_yr_id=@m_yr_id),0))
		set @stk_amt=@stk_amt+(isnull((select round(sum(stk_amt),4) from m_stk where stk_frm in ('t_itm','GRN','TransFG') and stk_dat=@stk_dat and itm_id=@titm_id and m_yr_id=@m_yr_id),0))
		if (@stk_qty<>0)
			begin
				set @stk_rat=round(@stk_amt/@stk_qty,4)
			end
		else
			begin
				set @stk_rat=0
			end

			--Stock	
			set @stk_qty=round(@ddc_qty/@sca_met,2)
			set @stk_des='DC# ' +rtrim(cast(@mdc_no as varchar(100))) + ' Order # '+rtrim(cast(@mso_no as varchar(100)))+ ' Customer: ' +@cus_nam	
			insert into m_stk(com_id,br_id,t_id,itm_id,itmqty_id,stk_stdsiz,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,bd_id,m_yr_id,titm_maf,titm_exp,stk_bat,mso_id,cur_id,stk_currat,stk_des,lot_id) 
				values(@com_id,@br_id,@mdc_id,@titm_id,@itmqty_id,@ddc_stdsiz,-@stk_qty,@stk_rat,'S','I','DC',@stk_dat,@wh_id,null,@m_yr_id,@ddc_mandat,@ddc_expdat,@ddc_bat,@mso_id,@cur_id,@cur_rat,@stk_des,@lot_id)
			
			--Update SO Status
			set @dso_qty=(select sum(dso_qty) from t_dso where mso_id=@mso_id and titm_id=@titm_id and itmqty_id=@itmqty_id)
			set @ddc_qty=(select sum(ddc_qty) from t_ddc where mdc_id=@mdc_id and titm_id=@titm_id and itmqty_id=@itmqty_id)
			if((@dso_qty-@ddc_qty)=0)
				begin
					update t_dso set dso_act=1 where mso_id=@mso_id and titm_id=@titm_id and itmqty_id=@itmqty_id
				end
			set @mso_qty=(select SUM(dso_qty) from t_dso where mso_id=@mso_id )
			set @mdc_qty=(select SUM(ddc_qty) from t_ddc where mdc_id=@mdc_id )
			if((@mso_qty-@mdc_qty)=0)
				begin
					update t_mso set mso_act=1 where mso_id=@mso_id
				end
	
end
go

--Delete
 alter proc del_t_ddc(@mdc_id int)
as
declare
@mso_id int
begin
	set @mso_id=(select mso_id from t_mdc where mdc_id=@mdc_id)
	update t_dso set dso_act=0 where mso_id =@mso_id and titm_id in (select titm_id from t_ddc where mdc_id=@mdc_id) and itmqty_id in (select itmqty_id from t_ddc where mdc_id=@mdc_id) and dso_stdsiz in (select ddc_stdsiz from t_ddc where mdc_id=@mdc_id)
	update t_mso set mso_act=0 where mso_id=@mso_id
	delete from m_stk where t_id=@mdc_id and stk_frm='DC' 
	delete from t_ddc where mdc_id=@mdc_id
end