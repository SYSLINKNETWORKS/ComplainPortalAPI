create view v_gl_yr_end
as
	select com_id,br_id,yr_id,acc_oid,gl_m_acc.acc_id,acc_nam,
						case when (acc_obal>=0) then acc_obal else 0 end as [dvch_dr_amt],
						case when (acc_obal<0) then acc_obal else 0 end as [dvch_Cr_amt],
						'O' as [Tag]
			 from gl_br_acc
			--Join with Chart of Account
			inner join gl_m_acc
			on gl_br_acc.acc_id=gl_m_acc.acc_id
--			where gl_m_acc.acc_id='01001005001'
union
	select 
		com_id,br_id,yr_id,'' as [acc_oid],rpt_t_vch.acc_id,acc_nam,sum(dvch_dr_amt) as [dvch_dr_amt],sum(dvch_cr_amt) as [dvch_cr_amt],'T' as [Tag]

			from rpt_t_vch
			--Join with Chart of Account
			inner join gl_m_acc
			on rpt_t_vch.acc_id=gl_m_acc.acc_id
			--Where
--			where gl_m_acc.acc_id='01001005001'
--			and yr_id='01'
--			where mvch_dt <=@dt1
			--Group by
			group by com_id,br_id,rpt_t_vch.acc_id,acc_nam,yr_id


--select acc_id,yr_id,sum(dvch_dr_amt),sum(dvch_cr_amt) from v_gl_tb group by acc_id,yr_id
--select * from v_gl_yr_end where acc_id='01001005001'
--select com_id,br_id,'' as [acc_oid],rpt_t_vch.acc_id,sum(dvch_dr_amt) as [dvch_dr_amt],sum(dvch_cr_amt) as [dvch_cr_amt] from rpt_t_vch where acc_id='01001005001' 			group by com_id,br_id,rpt_t_vch.acc_id
--select sum(dvch_Dr_amt),sum(dvch_cr_amt) from t_dvch where yr_id=01 and acc_id='01001005001'
