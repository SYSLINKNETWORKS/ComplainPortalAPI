----SP for Balance Sheet

--exec sp_rpt_bl '05/30/2009','01','01','01'

alter proc [dbo].[sp_rpt_bl](@dt1 datetime,@com_id char(2),@br_id char(3),@yr_id char(2))
as
select  com_id,br_id,acc_id,acc_nam,acc_cid,
		L1_accid, L1_nam,
		L2_accid, L2_nam,
		L3_accid, L3_nam,
		L4_accid, L4_nam,
		L5_accid, L5_nam,
		L6_accid, L6_nam,
		L7_accid, L7_nam,
		acc_lvl,
		 case when (sum(dvch_dr_amt)+sum(dvch_cr_amt))>=0 then sum(dvch_dr_amt)+sum(dvch_cr_amt) else 0 end as [dvch_dr_amt] ,
		 case when (sum(dvch_dr_amt)+sum(dvch_cr_amt))<0 then sum(dvch_dr_amt)+sum(dvch_cr_amt) else 0 end as [dvch_cr_amt] ,
		Tag,[Type] 
	 from rpt_t_obl
		where
		mvch_dt<=@dt1
		and com_id=@com_id
		and br_id=@br_id
		and yr_id=@yr_id
	--Group by
	group by com_id,br_id,acc_id,acc_nam,acc_cid,acc_lvl,tag,[Type],
				L1_accid,L1_nam,
				L2_accid,L2_nam,
				L3_accid,L3_nam,
				L4_accid,L4_nam,
				L5_accid,L5_nam,
				L6_accid,L6_nam,
				L7_accid,L7_nam

union
select com_id,br_id,acc_id,acc_nam,acc_cid,
		L1_accid,L1_nam,
		L2_accid,L2_nam,
		L3_accid,L3_nam,
		L4_accid,L4_nam,
		L5_accid,L5_nam,
		L6_accid,L6_nam,
		L7_accid,L7_nam,
		acc_lvl,
		 case when (sum(dvch_dr_amt)+sum(dvch_cr_amt))>=0 then sum(dvch_dr_amt)+sum(dvch_cr_amt) else 0 end as [dvch_dr_amt] ,
		 case when (sum(dvch_dr_amt)+sum(dvch_cr_amt))<0 then sum(dvch_dr_amt)+sum(dvch_cr_amt) else 0 end as [dvch_cr_amt] ,
		Tag,[Type]  from rpt_pl_obl
		--Where
		where mvch_dt<=@dt1
		and com_id=@com_id
		and br_id=@br_id
		and yr_id=@yr_id
		--Group By
		group by com_id,br_id,acc_id,acc_nam,acc_cid,
				L1_accid,L1_nam,
				L2_accid,L2_nam,
				L3_accid,L3_nam,
				L4_accid,L4_nam,
				L5_accid,L5_nam,
				L6_accid,L6_nam,
				L7_accid,L7_nam,
				acc_lvl,tag,[type]

GO


