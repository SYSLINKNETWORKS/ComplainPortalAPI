----View for Update Detail Voucher

ALTER view [dbo].[v_upd_dvch]
as
select	
		t_dvch.com_id,t_dvch.br_id,mvch_id,mvch_dt,dvch_row,t_dvch.acc_id,acc_nam,dvch_nar,dvch_dr_amt,dvch_cr_amt,typ_id,v_dacc.yr_id
		from t_dvch
		--Join with account description
		inner join v_dacc
		on t_dvch.com_id=v_dacc.com_id
		and t_dvch.br_id=v_dacc.br_id
		and t_dvch.acc_id=v_dacc.acc_id
		and t_dvch.yr_id=v_dacc.yr_id
GO
