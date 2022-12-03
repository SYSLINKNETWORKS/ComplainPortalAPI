USE MFI
GO


--select * from m_stk where stk_qty=0 and stk_frm='t_itm'
--delete from m_stk where stk_qty=0 and stk_frm='t_itm'

--Insert
alter proc [dbo].[ins_m_stkadj](@com_id char(2),@br_id char(3),@stk_dat datetime,@mso_id int,@titm_id int,@stk_qty float,@wh_id int,@bd_id int,@titm_exp datetime,@stk_typ char(1),@stk_st char(1),@stk_frm varchar(100),@row_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@m_yr_id char(2),@stk_id_out int output)
as
declare
@t_id int,
@aud_act char(10),
@stk_rat_old float,
@rat_dat datetime,
@stk_currat float,
@stk_rat float,
@cur_id int
begin
	set @stk_currat=1	
	set @aud_act='Insert'
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
--Rate
--exec ins_t_diss '01','',2,18,1,5,''
		set @stk_rat=isnull((select case when sum(stk_qty)=0 then 0 else round(AVG(isnull(stk_trat,0)),4) end from m_Stk where stk_qty<>0 and m_yr_id=@m_yr_id and stk_frm in ('TransFG') and itm_id=@titm_id and stk_dat<=@stk_dat and m_yr_id=@m_yr_id),0) 

	set @t_id=(select max(t_id)+1 from m_stk)
		if @t_id is null
			begin
				set @t_id=1
			end
			

	insert into m_stk(t_id,stk_dat,itm_id,stk_qty,wh_id,bd_id,titm_exp,stk_typ,stk_st,stk_frm,m_yr_id,cur_id,stk_currat,stk_rat,mso_id )
			values(@t_id,@stk_dat,@titm_id,@stk_qty,@wh_id,@bd_id,@titm_exp,@stk_typ,@stk_st,@stk_frm,@m_yr_id,@cur_id,@stk_currat,@stk_rat,@mso_id)
		set @stk_id_out=@t_id
		
							
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
	
	--GL
	if (@row_id=1)
		begin
			exec sp_voucher_adj @com_id ,@br_id,@m_yr_id ,@stk_dat,@stk_frm ,@usr_id ,@aud_ip ,@aud_des 			
		end
	
end


GO



--exec del_m_stkadj '01','01','01','05/31/2013','stk_dispose','','',1,''
--Delete
alter proc [dbo].[del_m_stkadj](@com_id char(2),@br_id char(3),@m_yr_id char(2),@stk_dat datetime,@stk_frm varchar(100),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mvch_id char(12)
begin
	set @aud_act='Delete'
	
	set @mvch_id=(select distinct mvch_id from m_stk where stk_dat=@stk_dat and m_yr_id=@m_yr_id and stk_frm=@stk_frm)
	--Delete Voucher
	exec del_t_vch @com_id ,@br_id ,@mvch_id ,'05',@m_yr_id ,'C', 0,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip 
	
	--Delete Record
	delete from m_stk where stk_dat=@stk_dat and stk_frm=@stk_frm and m_yr_id=@m_yr_id
	
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
		




