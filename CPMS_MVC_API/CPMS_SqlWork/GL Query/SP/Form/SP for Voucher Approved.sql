--SELECT * from t_mvch where mvch_dt between '07/01/2012' and '08/01/2012'
--update t_mvch set mvch_app='Y'

use ZSons
GO
----Voucher Approved

ALTER proc [dbo].[sp_vch_app](@com_id char(2),@br_id char(3),@yr_id char(2),@dt1 datetime,@dt2 datetime, @PU char(1),@vchtyp_ck bit,@vchtyp char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip char(100))
as
declare
@aud_act	char(20)
begin
	if (@PU='Y')
		begin
			set @aud_act='Approved'
		end
	else if (@PU='N')
		begin
			set @aud_act='Un-Approved'
		end
	if (@vchtyp_ck=1)
		begin
		--Approve/ Un-Approve Voucher
			update t_mvch set mvch_app=@PU where com_id=@com_id and br_id =@br_id and mvch_dt between @dt1 and @dt2 and yr_id=@yr_id and typ_id=@vchtyp and mvch_typ<>'S' and mvch_can=0
		end
	else
		begin
		--Approve/ Un-Approve Voucher
			update t_mvch set mvch_app=@PU where com_id=@com_id and br_id =@br_id and mvch_dt between @dt1 and @dt2 and yr_id=@yr_id and mvch_typ<>'S' and mvch_can=0
		end
--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--select * from tbl_aud1 order by aud_dat
