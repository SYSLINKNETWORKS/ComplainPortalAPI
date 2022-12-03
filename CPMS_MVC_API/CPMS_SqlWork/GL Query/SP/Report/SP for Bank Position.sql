USE ZSONS
GO
--
--drop table tbl_bk_pos
--create table tbl_bk_pos
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
--chq_amt float,
--deposit float,
--balance as chq_amt+deposit,
--row int
--)

--exec sp_rpt_bk_pos '01','01','01','03002003001002','09/12/2014'

alter proc sp_rpt_bk_pos(@com_id char(2),@m_yr_id char(2),@acc_id char(20),@dt1 datetime)
as
delete from tbl_bk_pos
--Outstanding Deposits not Cleared
insert into tbl_bk_pos
--select * from tbl_bk_pos

--Outstanding Deposit Chq Not Cleared
select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,t_mvch.mvch_id,t_mvch.typ_id,t_mvch.mvch_dt,'','',acc_id,acc_nam,mvch_chq,mvch_chqdat,t_mvch.cur_id,cur_snm,0 as [ChqAmt],dvch_cr_famt as [Deposit],1 as [row] from t_mvch 
inner join t_dvch 
on t_mvch.com_id=t_dvch.com_id 
and t_mvch.br_id=t_dvch.br_id 
and t_mvch.mvch_no=t_dvch.mvch_no
inner join gl_m_acc
on t_dvch.com_id=gl_m_acc.com_id
and t_dvch.acC_no=gl_m_acc.acc_no
left join m_cur
on t_mvch.cur_id=m_cur.cur_id
where t_mvch.typ_id='03'
and t_mvch.mvch_dt<=@dt1
and mvch_chqst=0
and dvch_cr_famt<>0
 and mvch_can=0 and mvch_del=0
	update tbl_bk_pos set bk_id=(select distinct acc_id from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_bk on t_dvch.com_id=gl_m_bk.com_id and t_dvch.acc_no=gl_m_bk.acc_no inner join gl_m_acc on gl_m_bk.com_id=gl_m_acc.com_id and gl_m_bk.acc_no =gl_m_acc.acc_no where t_dvch.com_id=tbl_bk_pos.com_id and t_dvch.br_id=tbl_bk_pos.br_id and t_mvch.yr_id=tbl_bk_pos.yr_id and t_mvch.mvch_id=tbl_bk_pos.mvch_id and t_mvch.typ_id=tbl_bk_pos.typ_id and dvch_dr_famt<>0  and row=1),   bk_nam=(select distinct bk_nam from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_bk on t_dvch.com_id=gl_m_bk.com_id and t_dvch.acc_no=gl_m_bk.acc_no inner join gl_m_acc on gl_m_bk.com_id=gl_m_acc.com_id and gl_m_bk.acc_no =gl_m_acc.acc_no where t_dvch.com_id=tbl_bk_pos.com_id and t_dvch.br_id=tbl_bk_pos.br_id and t_mvch.yr_id=tbl_bk_pos.yr_id and t_mvch.mvch_id=tbl_bk_pos.mvch_id and t_mvch.typ_id=tbl_bk_pos.typ_id and dvch_dr_famt<>0  and row=1) where row=1
----Outstanding Payment Chq Not Cleared
insert into tbl_bk_pos
select t_mvch.com_id,t_mvch.br_id,t_mvch.yr_id,t_mvch.mvch_id,t_mvch.typ_id,t_mvch.mvch_dt,'','',acc_id,acc_nam,mvch_chq,mvch_chqdat,t_mvch.cur_id,cur_snm,-dvch_dr_famt as [ChqAmt],0 as [Deposit],2 as [Row] from t_mvch 
inner join t_dvch 
on t_mvch.com_id=t_dvch.com_id 
and t_mvch.br_id=t_dvch.br_id 
and t_mvch.mvch_no=t_dvch.mvch_no
inner join gl_m_acc
on t_dvch.com_id=gl_m_acc.com_id 
and t_dvch.acC_no=gl_m_acc.acc_no
left join m_cur
on t_mvch.cur_id=m_cur.cur_id
where t_mvch.typ_id='04'
and t_mvch.mvch_dt<=@dt1
and mvch_chqst=0
and dvch_dr_famt<>0
 and mvch_can=0 and mvch_del=0
 	update tbl_bk_pos set bk_id=(select distinct acc_id from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_bk on t_dvch.com_id=gl_m_bk.com_id and t_dvch.acc_no=gl_m_bk.acc_no inner join gl_m_acc on gl_m_bk.com_id=gl_m_acc.com_id and gl_m_bk.acc_no =gl_m_acc.acc_no where t_dvch.com_id=tbl_bk_pos.com_id and t_dvch.br_id=tbl_bk_pos.br_id and t_mvch.yr_id=tbl_bk_pos.yr_id and t_mvch.mvch_id=tbl_bk_pos.mvch_id and t_mvch.typ_id=tbl_bk_pos.typ_id and dvch_cr_famt<>0  and row=2),   bk_nam=(select distinct bk_nam from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no inner join gl_m_bk on t_dvch.com_id=gl_m_bk.com_id and t_dvch.acc_no=gl_m_bk.acc_no inner join gl_m_acc on gl_m_bk.com_id=gl_m_acc.com_id and gl_m_bk.acc_no =gl_m_acc.acc_no where t_dvch.com_id=tbl_bk_pos.com_id and t_dvch.br_id=tbl_bk_pos.br_id and t_mvch.yr_id=tbl_bk_pos.yr_id and t_mvch.mvch_id=tbl_bk_pos.mvch_id and t_mvch.typ_id=tbl_bk_pos.typ_id and dvch_cr_famt<>0 and row=2) where row=2
delete from tbl_bk_pos where bk_id<>@acc_id
select * from tbl_bk_pos
