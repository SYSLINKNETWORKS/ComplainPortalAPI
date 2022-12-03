USE ZSONS
GO

--
--drop table tbl_bk_con
--create table tbl_bk_con
--(
--com_id char(2),
--br_id char(3),
--yr_id char(2),
--mvch_id char(12),
--typ_id char(2),
--mvch_dt datetime,
--bk_id char(20),
--bk_nam varchar(100),
--acc_id varchar(20),
--acc_nam varchar(250),
--mvch_chq float,
--mvch_chqdat datetime,
--cur_id int,
--cur_snm varchar(25),
--bankstatement float,
--unpresentedpayments float,
--UnpresentedDeposits float,
--BankBalance as bankstatement+unpresenteddeposits-unpresentedpayments,
--openingbalance float,
--receipts float,
--payments float,
--closingbalance as openingbalance+receipts+payments,
--row int
--)
--select * from tbl_bk_con where bk_id='02' order by row
--select * from gl_m_bk where bk_nam like '%habib%'
--exec sp_rpt_bk_con_mfi '01','01','03002003001001',61622,'05/30/2014'


alter proc sp_rpt_bk_con_mfi(@com_id char(2),@m_yr_id char(2),@acc_id char(20),@bk_amt float,@dt1 datetime)
as
begin
delete from tbl_bk_con
	--BK Amt
insert into tbl_bk_con
	select '01' as [com_id],'01' as [br_id],(select yr_id from gl_m_yr where yr_ac='Y') as [yr_id],'' as [mvch_id],'' as [typ_id],@dt1 as [mvch_dt],gl_m_acc.acc_id,bk_nam,acc_id as [AccountID],bk_nam as [Account],'' as [mvch_chq],'' as [mvch_chqdat],gl_m_bk.cur_id,cur_snm,@bk_amt as [bankstatement],0 as [UnpresentedPayments],0 as [UnpresentedDeposits],0 as [openingbalance],0 as [receipts],0 as [payments],0 as [row] from gl_m_bk inner join gl_m_acc on gl_m_bk.acc_no=gl_m_acc.acc_no left join m_cur on gl_m_bk.cur_id=m_cur.cur_id where gl_m_acc.acc_id=@acc_id  
	--Paid & Un-Cleared Chq
insert into tbl_bk_con
	select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,t_mvch.mvch_id,t_mvch.typ_id,t_mvch.mvch_dt,'' as [bk_id],'' as [bk_nam],gl_m_acc.acc_id as [AccountID],acc_nam as [Account],mvch_chq as [mvch_chq],mvch_chqcldat as [mvch_chqdat],t_mvch.cur_id,cur_snm,0 as [bankstatement],dvch_dr_famt as [UnpresentedPayments],0 as [UnpresentedDeposits],0 as [openingbalance],0 as [receipts],0 as [payment],2 as [row] from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and  t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_acc on t_dvch.com_id=gl_m_acc.com_id and t_dvch.acc_no=gl_m_acc.acc_no left join m_cur on t_mvch.cur_id=m_cur.cur_id where t_mvch.typ_id ='04' and mvch_chqst=0 and dvch_dr_famt<>0 and t_mvch.com_id=@com_id and t_mvch.mvch_chqcldat<=@dt1 and mvch_can=0 and mvch_del=0
	update tbl_bk_con set bk_id=(select gl_m_acc.acc_id from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_acc on t_dvch.acc_no=gl_m_acc.acc_no inner join gl_m_bk on t_dvch.acc_no=gl_m_bk.acc_no where t_dvch.com_id=tbl_bk_con.com_id and t_dvch.br_id=tbl_bk_con.br_id and t_mvch.yr_id=tbl_bk_con.yr_id and t_mvch.mvch_id=tbl_bk_con.mvch_id and t_mvch.typ_id=tbl_bk_con.typ_id and dvch_cr_famt<>0  and row=2),   bk_nam=(select bk_nam from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_bk on t_dvch.acc_no=gl_m_bk.acc_no where t_dvch.com_id=tbl_bk_con.com_id and t_dvch.br_id=tbl_bk_con.br_id and t_mvch.yr_id=tbl_bk_con.yr_id and t_mvch.mvch_id=tbl_bk_con.mvch_id and t_mvch.typ_id=tbl_bk_con.typ_id and dvch_cr_famt<>0 and row=2) where row=2
	--Received & Un-Cleared CHq
insert into tbl_bk_con
	select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,t_mvch.mvch_id,t_mvch.typ_id,t_mvch.mvch_dt,'' as [bk_id],'' as [bk_nam],gl_m_acc.acc_id as [AccountID],acc_nam as [Account],mvch_chq as [mvch_chq],mvch_chqcldat as [mvch_chqdat],t_mvch.cur_id,cur_snm,0 as [bankstatement],0 as [UnpresentedPayments],dvch_cr_famt as [UnpresentedDeposits],0 as [openingbalance],0 as [receipts],0 as [payment],3 as [row] from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_acc on t_dvch.acc_no=gl_m_acc.acc_no left join m_cur on t_mvch.cur_id=m_cur.cur_id where t_mvch.typ_id ='03' and mvch_chqst=0 and dvch_cr_famt<>0 and t_mvch.com_id=@com_id and t_mvch.mvch_chqcldat<=@dt1 and mvch_can=0 and mvch_del=0
	update tbl_bk_con set bk_id=(select gl_m_acc.acc_id from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_acc on t_dvch.acc_no=gl_m_acc.acc_no inner join gl_m_bk on t_dvch.acc_no=gl_m_bk.acc_no where t_dvch.com_id=tbl_bk_con.com_id and t_dvch.br_id=tbl_bk_con.br_id and t_mvch.yr_id=tbl_bk_con.yr_id and t_mvch.mvch_id=tbl_bk_con.mvch_id and t_mvch.typ_id=tbl_bk_con.typ_id and dvch_dr_famt<>0  and row=3),   bk_nam=(select bk_nam from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_bk on t_dvch.acc_no=gl_m_bk.acc_no where t_dvch.com_id=tbl_bk_con.com_id and t_dvch.br_id=tbl_bk_con.br_id and t_mvch.yr_id=tbl_bk_con.yr_id and t_mvch.mvch_id=tbl_bk_con.mvch_id and t_mvch.typ_id=tbl_bk_con.typ_id and dvch_dr_famt<>0 and row=3) where row=3
--	Opening Balance of Bank
insert into tbl_bk_con
	select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,'' as [mvch_id],'' as [typ_id],'' as [mvch_dt],gl_m_acc.acc_id,bk_nam,gl_m_acc.acc_id as [AccountID],acc_nam as [Account],'' as [mvch_chq],'' as [mvch_chqdat],t_mvch.cur_id,cur_snm,0 as [bankstatement],0 as [UnpresentedPayments],0 as [UnpresentedDeposits],dvch_dr_famt-dvch_cr_famt as [openingbalance],0 as [receipts],0 as [payment],5 as [row] from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_acc on t_dvch.acc_no=gl_m_acc.acc_no left join m_cur on t_mvch.cur_id=m_cur.cur_id inner join gl_m_bk on t_dvch.acc_no=gl_m_bk.acc_no where t_mvch.com_id=@com_id and t_mvch.yr_id=@m_yr_id  and t_mvch.typ_id='06' and gl_m_acc.acc_id=@acc_id and mvch_can=0 and mvch_del=0
	--Payment
insert into tbl_bk_con
	select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,'' as [mvch_id],'' as [typ_id],'' as [mvch_dt],gl_m_acc.acc_id as [bk_id],bk_nam as [bk_nam],gl_m_acc.acc_id as [AccountID],bk_nam as [Account],'' as [mvch_chq],'' as [mvch_chqdat],gl_m_bk.cur_id,cur_snm,0 as [bankstatement],0 as [UnpresentedPayments],0 as [UnpresentedDeposits],0 as [openingbalance],0 as [receipts],sum(dvch_dr_famt-dvch_cr_famt) as [payment],6 as [row] from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_acc on t_dvch.com_id=gl_m_acc.com_id and t_dvch.acc_no=gl_m_acc.acc_no inner join gl_m_bk on t_dvch.acc_no=gl_m_bk.acc_no left join m_cur on gl_m_bk.cur_id=m_cur.cur_id where t_mvch.typ_id ='04' and t_mvch.com_id=@com_id  and t_mvch.yr_id=@m_yr_id and t_mvch.mvch_chqcldat<=@dt1  and mvch_can=0 and mvch_del=0 group by t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,bk_nam,gl_m_bk.cur_id,cur_snm
	--Service Charges CHq
insert into tbl_bk_con
	select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,'' as [mvch_id],'' as [typ_id],'' as [mvch_dt],gl_m_acc.acc_id,bk_nam,gl_m_acc.acc_id as [AccountID],acc_nam as [Account],'' as [mvch_chq],'' as [mvch_chqdat],t_mvch.cur_id,cur_snm,0 as [bankstatement],0 as [UnpresentedPayments],0 as [UnpresentedDeposits],0 as [openingbalance],0 as [receipts],sum(dvch_dr_famt-dvch_cr_famt) as [payment],6 as [row] from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_acc on t_dvch.acc_no=gl_m_acc.acc_no left join m_cur on t_mvch.cur_id=m_cur.cur_id inner join gl_m_bk on t_dvch.acc_no=gl_m_bk.acc_no where t_mvch.typ_id ='05' and t_mvch.yr_id=@m_yr_id and gl_m_acc.acc_id=@acc_id  and t_mvch.mvch_chqdat<=@dt1  and mvch_can=0 and mvch_del=0 group by t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,bk_nam,t_mvch.cur_id,cur_snm,gl_m_acc.acc_id,acc_nam
	--Receipt
insert into tbl_bk_con
	select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,'' as [mvch_id],'' as [typ_id],'' as [mvch_dt],gl_m_acc.acc_id as [bk_id],bk_nam as [bk_nam],gl_m_acc.acc_id as [AccountID],bk_nam as [Account],'' as [mvch_chq],'' as [mvch_chqdat],gl_m_bk.cur_id,cur_snm,0 as [bankstatement],0 as [UnpresentedPayments],0 as [UnpresentedDeposits],0 as [openingbalance],sum(dvch_dr_famt-dvch_cr_famt) as [receipts],0 as [payment],7 as [row] from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and  t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_bk on t_dvch.acc_no=gl_m_bk.acc_no inner join gl_m_acc on t_dvch.com_id=gl_m_acc.com_id and t_dvch.acc_no =gl_m_acc.acc_no left join m_cur on gl_m_bk.cur_id=m_cur.cur_id where t_mvch.typ_id ='03' and t_mvch.com_id=@com_id and t_mvch.yr_id=@m_yr_id and t_mvch.mvch_chqcldat<=@dt1  and mvch_can=0 and mvch_del=0 group by t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_acc.acc_id,bk_nam,gl_m_bk.cur_id,cur_snm

--insert into tbl_bk_con
--	--Service Charges CHq
--	select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,'' as [mvch_id],'' as [typ_id],'' as [mvch_dt],gl_m_bk.acc_id,bk_nam,t_dvch.acc_id as [AccountID],acc_nam as [Account],'' as [mvch_chq],'' as [mvch_chqdat],t_mvch.cur_id,cur_snm,0 as [Ledger],0 as [UnpresentedPayments],0 as [UnpresentedDeposits],sum(dvch_dr_famt-dvch_cr_famt) as [BankCharges],sum(dvch_dr_famt-dvch_cr_famt) as [Balance],sum(dvch_dr_famt-dvch_cr_famt) as [ledgerBalance],4 as [row] from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.yr_id=t_dvch.yr_id and  t_mvch.mvch_id=t_dvch.mvch_id and t_mvch.typ_id=t_dvch.typ_id inner join gl_m_acc on t_dvch.acc_id=gl_m_acc.acc_id left join m_cur on t_mvch.cur_id=m_cur.cur_id inner join gl_m_bk on t_dvch.acc_id=gl_m_bk.acc_id where t_mvch.typ_id ='05' and t_mvch.com_id=@com_id and t_mvch.br_id=@br_id and t_mvch.yr_id=@m_yr_id  and t_mvch.mvch_dt<=@dt1 group by t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,gl_m_bk.acc_id,bk_nam,t_mvch.cur_id,cur_snm,t_dvch.acc_id,acc_nam
delete from tbl_bk_con where bk_id<>@acc_id
select * from tbl_bk_con order by row
end
--select * from t_dvch inner join t_ where typ_id='03'
--select * from gl_vch_typ

--exec sp_rpt_bk_con_mfi '01','01','01','03002003001002',2000,'09/11/2012'


--select acc_id,dvch_dr_famt,dvch_cr_famt from t_dvch where typ_id='04' and mvch_dt<='09/11/2012'
--select * from gl_vch_typ
--select * from gl_m_bk
--12518507.548
--12518507.548

--Payments 132785.16
--Receipts -185422.79
