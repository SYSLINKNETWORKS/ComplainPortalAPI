USE [NATHI]
GO

/****** Object:  StoredProcedure [dbo].[ins_t_ditn]    Script Date: 05/18/2015 16:49:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--alter table t_ditn add com_id char(2)

--alter table t_ditn add br_id char(3)


ALTER proc [dbo].[ins_t_ditn](@com_id char(2),@br_id char(3),@titm_id int,@wh_id int,@wh_id_trans int,@ditn_qty int,@mitn_id int,@ditn_rmk varchar(1000))
as
declare
--@mso_id int,
@ditn_id int,
@qty float,
@stk_dat datetime,
@m_yR_id char(2),
@stk_rat float,
@stk_qty float,
@stk_amt float,
@stk_dat_old datetime
begin

	set @m_yR_id=(select m_yr_id from t_mitn where mitn_id=@mitn_id)
	--set @mso_id =(select mso_id from t_mso where com_id=@com_id and br_id=@br_id and m_yr_id=@m_yR_id and mso_no=@mso_no)
	--set @wh_id_trans =(select wh_id from m_wh where wh_id=@wh_id_trans)
	--set @ditn_exp=(select distinct titm_exp from m_stk where com_id=@com_id and br_id=@br_id and m_yr_id=@m_yR_id and itm_id=@titm_id and stk_bat=@ditn_bat)
	--set @ditn_maf=(select distinct stk_maf from m_stk where  com_id=@com_id and br_id=@br_id and m_yr_id=@m_yR_id and itm_id=@titm_id and stk_bat=@ditn_bat)
	set @stk_dat=(select mitn_dat from t_mitn where mitn_id=@mitn_id)
	set @ditn_id=(select max(ditn_id)+1 from t_ditn)
	
		if @ditn_id is null
			begin
				set @ditn_id=1
			end
		
		
			
	insert into t_ditn(com_id,br_id,titm_id,ditn_id,wh_id,wh_id_trans,ditn_qty,mitn_id,ditn_rmk)
			values(@com_id,@br_id,@titm_id,@ditn_id,@wh_id,@wh_id_trans,@ditn_qty,@mitn_id,@ditn_rmk)	


	--Stock
		set @stk_dat_old =DATEADD(DAY,-1,@stk_dat)
		set @stk_rat=0

		set @stk_qty=(isnull((select round(sum(stk_qty),4) from m_stk where stk_dat<=@stk_dat_old and itm_id=@titm_id and m_yr_id=@m_yr_id and wh_id=@wh_id),0))
		set @stk_qty=@stk_qty+(isnull((select round(sum(stk_qty),4) from m_stk where stk_frm in ('t_itm','GRN','ITN') and stk_dat=@stk_dat and itm_id=@titm_id and m_yr_id=@m_yr_id and wh_id=@wh_id),0))
		set @stk_amt=(isnull((select round(sum(stk_qty*stk_rat),4) from m_stk where stk_dat<=@stk_dat_old and itm_id=@titm_id and m_yr_id=@m_yr_id and wh_id=@wh_id),0))
		set @stk_amt=@stk_amt+(isnull((select round(sum(stk_qty*stk_rat),4) from m_stk where stk_frm in ('t_itm','GRN','ITN') and stk_dat=@stk_dat and itm_id=@titm_id and m_yr_id=@m_yr_id and wh_id=@wh_id),0))
		if (@stk_qty<>0)
			begin
				set @stk_rat=round(@stk_amt/@stk_qty,4)
			end
		else
			begin
				set @stk_rat=0
			end
	
	insert into m_stk(com_id,br_id,m_yr_id,t_id,stk_dat,itm_id,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,wh_id) 
		values(@com_id,@br_id,@m_yr_id,@mitn_id,@stk_dat,@titm_id,-@ditn_qty,@stk_Rat,'S','I','ITN',@wh_id)
	
	insert into m_stk(com_id,br_id,m_yr_id,t_id,itm_id,stk_dat,stk_qty,stk_rat,stk_typ,stk_st,stk_frm,wh_id) 
		values(@com_id,@br_id,@m_yr_id,@mitn_id,@titm_id,@stk_dat,@ditn_qty,@stk_Rat,'S','R','ITN',@wh_id_trans)
	
	
end


GO



--Delete
ALTER proc [dbo].[del_t_ditn](@com_id char(2),@br_id char(3),@mitn_id int)
as
declare
@m_yr_id int
begin
	delete from m_stk where t_id=@mitn_id and stk_frm='ITN' and com_id=@com_id and br_id=@br_id 
	
	delete from t_ditn where mitn_id=@mitn_id and com_id=@com_id and br_id=@br_id 
end

GO


