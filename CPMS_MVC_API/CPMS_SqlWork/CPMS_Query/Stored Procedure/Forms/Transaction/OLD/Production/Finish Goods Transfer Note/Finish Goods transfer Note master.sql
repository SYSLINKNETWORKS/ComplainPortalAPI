use MEIJI_RUSK
go

--ALTER table t_mfg add mfg_qty float,titm_id int
--alter table t_mfg add constraint FK_MFG_TITMID foreign key (titm_id) references t_itm(titm_id)

--alter table t_mfg add com_id char(2),br_id char(3)
--alter table t_mfg add constraint FK_TMFG_COMID foreign key (com_id) references m_com(com_id)
--alter table t_mfg add constraint FK_TMFG_BRID foreign key (br_id) references m_br(br_id)

--alter table t_mfg add con_id int
--alter table t_mfg add constraint FK_MFG_CONID foreign key (con_id) references m_con(con_id)

--Insert
alter proc [dbo].[ins_t_mfg](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mfg_dat datetime,@mfg_qty float,@mfg_act bit,@mfg_typ char(1),@con_id int,@titm_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mfg_id_out int output)
as
declare
@mfg_id int,
@aud_act char(10),
@mfg_rat float,
@Cur_id int
begin
	set @mfg_rat=1
	set @Cur_id=(select cur_id from m_cur where cur_typ='S')
	set @aud_act='Insert'
	set @mfg_id=(select max(mfg_id)+1 from t_mfg)
		if @mfg_id is null
			begin
				set @mfg_id=1
			end
			
		if(@titm_id=0)
		begin
		set @titm_id=null
		end
				
	insert into t_mfg(m_yr_id,mfg_id,mfg_dat,mfg_act,mfg_typ,mfg_qty,titm_id,con_id )
			values(@m_yr_id,@mfg_id,@mfg_dat,@mfg_act,@mfg_typ,@mfg_qty,@titm_id,@con_id)
		set @mfg_id_out=@mfg_id
	--Stock
	insert into m_stk(com_id,br_id,t_id,itm_id,stk_qty,stk_qtyacc,stk_rat,stk_typ,stk_st,stk_frm,stk_des,stk_dat,m_yr_id,cur_id,stk_currat) 
		values(@com_id,@br_id,@mfg_id,@titm_id,-@mfg_qty,0,@mfg_rat,'S','I','TransFG','',@mfg_dat,@m_yr_id,@cur_id,1)

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

	
end
GO

--Update
alter proc [dbo].[upd_t_mfg](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mfg_id int,@mfg_dat datetime,@mfg_qty float,@mfg_act bit,@mfg_typ char(1),@con_id int,@titm_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Update'
	if(@titm_id=0)
		begin
		set @titm_id=null
		end
	update t_mfg set m_yr_id=@m_yr_id,mfg_dat=@mfg_dat,mfg_act=@mfg_act,mfg_qty=@mfg_qty,mfg_typ=@mfg_typ,titm_id=@titm_id,con_id=@con_id where mfg_id=@mfg_id

	--STOCK
	update m_stk set stk_qty=-@mfg_qty where t_id=@mfg_id and stk_frm='TransFG' and m_yr_id=@m_yr_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
GO



--exec del_t_mfg 13

--Delete
alter proc [dbo].[del_t_mfg](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mfg_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)

begin

	delete m_stk where t_id=@mfg_id and stk_frm='TransFG' and m_yr_id=@m_yr_id
	--Delete Detail FG
	exec del_t_dfg @mfg_id
	--Delete Master FG
	delete t_mfg where mfg_id=@mfg_id
	
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		

