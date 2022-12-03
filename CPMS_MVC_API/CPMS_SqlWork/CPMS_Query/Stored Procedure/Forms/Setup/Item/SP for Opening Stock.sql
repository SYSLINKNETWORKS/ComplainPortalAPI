

USE PHM
GO
--alter table m_stk add cur_id int,stk_currat float
--alter table m_stk add stk_qtyacc float default 0
--alter table m_stk add stk_nqty as stk_qty-stk_qtyacc
--update m_stk set stk_qtyacc=0

--alter table m_stk add constraint FK_MSTK_CURID foreign key (cur_id) references m_cur(cur_id)
--alter table m_stk add stk_trat as stk_rat*stk_currat

--update m_stk set cur_id=(select cur_id from t_mgrn where mgrn_id=t_id), stk_currat=(select mgrn_rat from t_mgrn where mgrn_id=t_id)  where stk_frm='GRN'
--update m_stk set stk_rat=(select dgrn_rat from t_dgrn where mgrn_id=t_id and titm_id=itm_id)  where stk_frm='GRN' and t_id in (1,2,3,4)

--select * from t_mgrn inner join t_dgrn on t_mgrn.mgrn_id=t_dgrn.dgrn_id inner join m_stk on t_mgrn.mgrn_id=m_stk.t_id and t_dgrn.titm_id=m_Stk.itm_id where stk_frm='GRN'
--select * from m_stk where t_id in (1,2,3,4) and stk_frm='GRN' ORDER By t_id


--alter table m_stk add itmqty_id int

--select * from m_Stk

--Stock Opening
alter proc sp_openingstk (@com_id char(2),@br_id char(3),@m_yr_id char(2),@titm_id int,@itmqty_id int,@wh_id int,@bd_id int,@ck_datmaf bit,@titm_maf datetime,@ck_dat bit,@titm_exp datetime,@stk_qty float,@stk_rat float,@cur_id int,@stk_currat float,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@stk_bat varchar(100))
as
declare
@aud_act char(10),
@t_id int,
@stk_dat datetime
begin
	set @t_id=(select max(t_id)+1 from m_Stk)
		if @t_id is null
			begin
				set @t_id=1
			end
	set @aud_act='Insert'
	if (@ck_dat=0)
		begin
			set @titm_exp=null
		end
	if (@ck_datmaf =0)
		begin
			set @titm_maf=null
		end
		
	if (@itmqty_id=0)
		begin
			set @itmqty_id=null
		end
		if (@bd_id=0)
		begin
			set @bd_id=null
		end
	set @stk_dat=(select yr_str_dt from gl_m_yr where yr_ac='Y')
	insert into m_stk(com_id,br_id,t_id,itm_id,itmqty_id,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,stk_dat,wh_id,bd_id,m_yr_id,titm_maf,titm_exp,cur_id,stk_currat,stk_bat) 
	values(@com_id,@br_id,@t_id,@titm_id,@itmqty_id,@stk_qty,@stk_rat,'U','R','t_itm',@stk_dat,@wh_id,@bd_id,@m_yr_id,@titm_maf,@titm_exp,@cur_id,@stk_currat,@stk_bat)


--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end		
go
--exec sp_del_openingstk '01','01','01',5,0,4,'','',1,''
--Delete
alter proc sp_del_openingstk (@com_id char(2),@br_id char(3),@m_yr_id char(2),@itm_id int,@itmsub_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'
	if (@itmsub_id=0)
		begin
			delete from m_stk where stk_frm='t_itm' and com_id=@com_id and br_id=@br_id and m_yr_id=@m_yr_id and itm_id in (select titm_id from t_itm where itm_id=@itm_id)
		end
	else if (@itmsub_id>0)
		begin
			delete from m_stk where stk_frm='t_itm' and com_id=@com_id and br_id=@br_id and m_yr_id=@m_yr_id and itm_id in (select titm_id from t_itm where itm_id=@itm_id) and itm_id in (select titm_id from t_itm where itmsub_id=@itmsub_id) 
		end
	else if (@itmsub_id>0)
		begin
			delete from m_stk where stk_frm='t_itm' and com_id=@com_id and br_id=@br_id and m_yr_id=@m_yr_id and itm_id in (select titm_id from t_itm where itm_id=@itm_id) and itm_id in (select titm_id from t_itm where itmsub_id=@itmsub_id)
		end
	--else if (@bd_id>0)
	--	begin
	--		delete from m_stk where stk_frm='t_itm' and com_id=@com_id and br_id=@br_id and m_yr_id=@m_yr_id and itm_id in (select titm_id from t_itm where itm_id=@itm_id) and bd_id=@bd_id
	--	end
	--else
	--	begin
	--		delete from m_stk where stk_frm='t_itm' and m_yr_id=@m_yr_id and itm_id in (select titm_id from t_itm where itm_id=@itm_id) and itm_id in (select titm_id from t_itm where itmsub_id=@itmsub_id) and itm_id in (select titm_id from t_itm where bd_id=@bd_id)
	--	end

--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end		
