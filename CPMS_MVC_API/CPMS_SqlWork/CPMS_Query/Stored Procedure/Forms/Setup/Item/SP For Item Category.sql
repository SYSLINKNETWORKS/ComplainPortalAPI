
USE Meiji_Rusk
GO

--declare @acc_cid char(20),@writm_nam char(250),@wracc_id char(20),@cur_id int,@com_id char(2),@br_id char(2),@yr_id char(2),@itm_id int,@itm_nam varchar(250)
--set @cur_id=2
--set @com_id='01'
--set @br_id='01'
--set @yr_id ='01'
--set @itm_id=8
--set @itm_nam=(select itm_nam from m_itm where itm_id=@itm_id)
--			set @acc_cid =(select wip_ret_acc from m_sys)
--			set @writm_nam='WIP Return of '+@itm_nam
--			exec ins_m_acc @com_id,@br_id,@yr_id,@cur_id,@writm_nam,@acc_cid,'','S',@acc_id_out=@wracc_id output
--			--WIP Return Account
--			update m_itm set wracc_id=@wracc_id where itm_id=@itm_id


--exec ins_m_itm '01','01','01','Semi Finish','E','U',1,''
--alter table m_itm add eacc_id int
--alter table m_itm add weacc_id int

--alter table m_sys add wipe_acc int,stockintrade_closing_acc int
--alter table m_sys add stockintrade_closing_acc int

--select * from gl_m_acc where acc_id='03002004008005'
--select * from gl_m_acc where acc_id='03002005'
--select * from gl_m_acc where acc_id =(select wip_ret_acc from m_sys)
--update m_sys set wipe_acc=1855,stockintrade_closing_acc=1854
--update m_sys set wip_ret_acc=435

--alter table m_itm add titm_bar varchar(100)


--Insert
alter proc [dbo].[ins_m_itm](@com_id char(2),@br_id char(3),@yr_id char(2),@itm_nam varchar(250),@itm_cat char(1),@itm_typ char(1),@itm_act bit,@itm_id_out int output)
as
declare
@itm_id int,
@oacc_id int,
@eacc_id int,
@pacc_id int,
@sacc_id int,
@cacc_id int,
@wacc_id int,
@woacc_id int,
@weacc_id int,
@acc_cid int,
@wracc_id int,
@oitm_nam varchar(250),
@eitm_nam varchar(250),
@pitm_nam varchar(250),
@sitm_nam varchar(250),
@citm_nam varchar(250),
@witm_nam varchar(250),
@woitm_nam varchar(250),
@writm_nam varchar(250),
@weitm_nam varchar(250),
@cur_id int

begin
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	set @itm_id=(select max(itm_id)+1 from m_itm)
		if @itm_id is null
			begin
				set @itm_id=1
			end
			PRINT 'INSERT DATA'
	insert into m_itm(itm_id,itm_nam,itm_cat,itm_act,itm_typ )
			values(@itm_id,@itm_nam,@itm_cat,@itm_act,@itm_typ)
		set @itm_id_out=@itm_id
	--Chart of Accounts
	if (@itm_cat<>'O')
		begin
		PRINT 'CHART OF ACCOUNTS'
			--Opening Account
			set @acc_cid =(select stockintrade_acc from m_sys)
			set @oitm_nam='Stock in Trade of ' +@itm_nam
			exec ins_m_acc @com_id,@br_id,@cur_id,@oitm_nam,@acc_cid,'','S',1,'','','','','',@acc_no_out=@oacc_id output
			update m_itm set aacc_id=@oacc_id where itm_id=@itm_id
			--Closing/Ending Account
			set @acc_cid =(select stockintrade_closing_acc from m_sys)
			set @eitm_nam='Closing Stock of ' +@itm_nam
			exec ins_m_acc @com_id,@br_id,@cur_id,@eitm_nam,@acc_cid,'','S',1,'','','','','',@acc_no_out=@eacc_id output
			--Cost of Goods Sold Account
			set @acc_cid =(select cogs_acc from m_sys)
			set @citm_nam='COGS of '+@itm_nam
			exec ins_m_acc @com_id,@br_id,@cur_id,@citm_nam,@acc_cid,'','S',1,'','','','','',@acc_no_out=@cacc_id output
			--Sale Account
			set @acc_cid =(select sale_acc from m_sys)
			set @sitm_nam='Sales of '+@itm_nam
			exec ins_m_acc @com_id,@br_id,@cur_id,@sitm_nam,@acc_cid,'','S',1,'','','','','',@acc_no_out=@sacc_id output
			--WIP 
			set @acc_cid =(select wip_acc from m_sys)
			set @witm_nam='WIP of '+@itm_nam
			exec ins_m_acc @com_id,@br_id,@cur_id,@witm_nam,@acc_cid,'','S',1,'','','','','',@acc_no_out=@wacc_id output
			--WIP Opening
			set @acc_cid =(select wipo_acc from m_sys)
			set @woitm_nam='Stock in Trade of WIP of '+@itm_nam
			exec ins_m_acc @com_id,@br_id,@cur_id,@woitm_nam,@acc_cid,'','S',1,'','','','','',@acc_no_out=@woacc_id output
			--WIP Closing
			set @acc_cid =(select wipe_acc from m_sys)
			set @weitm_nam='Closing of WIP of '+@itm_nam
			exec ins_m_acc @com_id,@br_id,@cur_id,@weitm_nam,@acc_cid,'','S',1,'','','','','',@acc_no_out=@weacc_id output
			--WIP Return
			set @acc_cid =(select wip_ret_acc from m_sys)
			set @writm_nam='WIP Return of '+@itm_nam
			exec ins_m_acc @com_id,@br_id,@cur_id,@writm_nam,@acc_cid,'','S',1,'','','','','',@acc_no_out=@wracc_id output
		end
	else 
		begin
			--Opening Account
			set @acc_cid =(select stockintrade_acc from m_sys)
			set @oitm_nam='Stock in Trade of ' +@itm_nam
			exec ins_m_acc @com_id,@br_id,@cur_id,@oitm_nam,@acc_cid,'','S',1,'','','','','',@acc_no_out=@oacc_id output
			update m_itm set aacc_id=@oacc_id where itm_id=@itm_id
			--Purchase Account
			set @acc_cid =(select purchase_acc from m_sys)
			set @pitm_nam ='Purchases of '+@itm_nam
			exec ins_m_acc @com_id,@br_id,@cur_id,@pitm_nam,@acc_cid,'','S',1,'','','','','',@acc_no_out=@pacc_id output
			update m_itm set aacc_id=@pacc_id where itm_id=@itm_id
		end
	--Update record for chart of account
	--Opening Account
	update m_itm set oacc_id=@oacc_id where itm_id=@itm_id
	--Closing Account
	update m_itm set eacc_id=@eacc_id where itm_id=@itm_id
	--COGS Account
	update m_itm set cacc_id=@cacc_id where itm_id=@itm_id
	--Sale Account
	update m_itm set sacc_id=@sacc_id where itm_id=@itm_id
	--Purchase Account
	update m_itm set pacc_id=@pacc_id where itm_id=@itm_id
	--WIP Account
	update m_itm set wacc_id=@wacc_id where itm_id=@itm_id
	--WIP Opening Account
	update m_itm set woacc_id=@woacc_id where itm_id=@itm_id
	--WIP Closing Account
	update m_itm set weacc_id=@weacc_id where itm_id=@itm_id
	--WIP Return Account
	update m_itm set wracc_id=@wracc_id where itm_id=@itm_id
end
GO
--delete gl_br_acc where acc_id in (select acc_id from gl_m_Acc where acc_cid='05001008')
--delete gl_m_acc where acc_cid='05001008'

--Update
alter proc [dbo].[upd_m_itm](@com_id char(2),@br_id char(3),@yr_id char(2),@itm_cat char(1),@itm_id int,@itm_nam varchar(250),@itm_act bit,@itm_typ char(1))
as
declare
@oacc_id int,
@oacc_cid int,
@eacc_id int,
@eacc_cid int,
@pacc_id int,
@pacc_cid int,
@sacc_id int,
@sacc_cid int,
@cacc_id int,
@cacc_cid int,
@wacc_id int,
@wacc_cid int,
@woacc_id int,
@woacc_cid int,
@weacc_id int,
@weacc_cid int,
@wracc_id int,
@wracc_cid int,
@oitm_nam varchar(250),
@eitm_nam varchar(250),
@pitm_nam varchar(250),
@sitm_nam varchar(250),
@citm_nam varchar(250),
@witm_nam varchar(250),
@woitm_nam varchar(250),
@weitm_nam varchar(250),
@writm_nam varchar(250),
@itm_obal float,
@Cur_id int
begin
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	set @oacc_id=(select oacc_id from m_itm where itm_id=@itm_id)
	set @oacc_cid =(select stockintrade_acc from m_sys)
	set @eacc_id=(select eacc_id from m_itm where itm_id=@itm_id)
	set @eacc_cid =(select stockintrade_closing_acc from m_sys)
	set @pacc_id=(select pacc_id from m_itm where itm_id=@itm_id)
	set @pacc_cid =(select purchase_acc from m_sys)
	set @sacc_id=(select sacc_id from m_itm where itm_id=@itm_id)
	set @sacc_cid =(select sale_acc from m_sys)
	set @cacc_id=(select cacc_id from m_itm where itm_id=@itm_id)
	set @cacc_cid =(select cogs_acc from m_sys)
	set @wacc_id=(select wacc_id from m_itm where itm_id=@itm_id)
	set @wacc_cid =(select wip_acc from m_sys)
	set @woacc_id=(select woacc_id from m_itm where itm_id=@itm_id)
	set @woacc_cid =(select wipo_acc from m_sys)
	set @wracc_id=(select wracc_id from m_itm where itm_id=@itm_id)
	set @wracc_cid =(select wip_ret_acc from m_sys)
	set @weacc_id=(select weacc_id from m_itm where itm_id=@itm_id)
	set @weacc_cid =(select wipe_acc from m_sys)

	update m_itm set itm_nam=@itm_nam,itm_typ=@itm_typ,itm_act=@itm_act where itm_id=@itm_id
--Chart of Accounts
	set @oitm_nam='Stock in Trade of ' +@itm_nam
	set @eitm_nam='Closing Stock of ' +@itm_nam
	set @pitm_nam='Purchases of ' +@itm_nam
	set @sitm_nam='Sales of ' +@itm_nam
	set @citm_nam='COGS of ' +@itm_nam
	set @witm_nam='WIP of '+@itm_nam
	set @weitm_nam='Closing WIP of '+@itm_nam
	set @woitm_nam='Stock in Trade of WIP of '+@itm_nam
	set @writm_nam='WIP Return of '+@itm_nam

	if (@itm_cat<>'O')
			begin
				exec upd_m_acc @com_id,@br_id,@cur_id,@oacc_id,@oitm_nam,@oacc_cid,'','S',1,'','','','',''
				exec upd_m_acc @com_id,@br_id,@cur_id,@eacc_id,@eitm_nam,@eacc_cid,'','S',1,'','','','',''
				exec upd_m_acc @com_id,@br_id,@cur_id,@sacc_id,@sitm_nam,@sacc_cid,'','S',1,'','','','',''
				exec upd_m_acc @com_id,@br_id,@cur_id,@cacc_id,@citm_nam,@cacc_cid,'','S',1,'','','','',''
				exec upd_m_acc @com_id,@br_id,@cur_id,@wacc_id,@witm_nam,@wacc_cid,'','S',1,'','','','',''
				exec upd_m_acc @com_id,@br_id,@cur_id,@woacc_id,@woitm_nam,@woacc_cid,'','S',1,'','','','',''
				exec upd_m_acc @com_id,@br_id,@cur_id,@weacc_id,@weitm_nam,@weacc_cid,'','S',1,'','','','',''
				exec upd_m_acc @com_id,@br_id,@cur_id,@wracc_id,@writm_nam,@wracc_cid,'','S',1,'','','','',''
			end
	else
			begin
				exec upd_m_acc @com_id,@br_id,@cur_id,@oacc_id,@oitm_nam,@oacc_cid,'','S',1,'','','','',''
			end		
end
GO

--exec del_m_itm '01','01',2
--select * from gl_m_acc
--select * from m_itm

--exec [del_m_itm] '01','01',10

--Delete
alter proc [dbo].[del_m_itm](@com_id char(2),@br_id char(3),@itm_id int)
as
declare
@oacc_id int,
@eacc_id int,
@pacc_id int, 
@sacc_id int,
@cacc_id int,
@wacc_id int,
@woacc_id int,
@weacc_id int
begin
	set @oacc_id=(select oacc_id from m_itm where itm_id=@itm_id)
	set @eacc_id=(select eacc_id from m_itm where itm_id=@itm_id)
	set @pacc_id=(select pacc_id from m_itm where itm_id=@itm_id)
	set @sacc_id=(select sacc_id from m_itm where itm_id=@itm_id)
	set @cacc_id=(select cacc_id from m_itm where itm_id=@itm_id)
	set @wacc_id=(select wacc_id from m_itm where itm_id=@itm_id)
	set @woacc_id=(select woacc_id from m_itm where itm_id=@itm_id)
	set @weacc_id=(select weacc_id from m_itm where itm_id=@itm_id)
--Chart of Accounts
	exec del_m_acc @com_id,@br_id,@oacc_id,'','','',''
	exec del_m_acc @com_id,@br_id,@eacc_id,'','','',''
	exec del_m_acc @com_id,@br_id,@pacc_id,'','','',''
	exec del_m_acc @com_id,@br_id,@sacc_id,'','','',''
	exec del_m_acc @com_id,@br_id,@cacc_id,'','','',''
	exec del_m_acc @com_id,@br_id,@wacc_id,'','','',''
	exec del_m_acc @com_id,@br_id,@woacc_id,'','','',''
	exec del_m_acc @com_id,@br_id,@weacc_id,'','','',''

	delete m_itm where itm_id=@itm_id
end
		
		

