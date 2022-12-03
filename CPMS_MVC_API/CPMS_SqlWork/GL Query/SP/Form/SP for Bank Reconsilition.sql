USE PHM
GO
--alter table t_mvch add mvch_chqcldat datetime
--update t_mvch set mvch_chqcldat=mvch_chqdat
--Update
alter proc upd_t_bkcon(@com_id char(2),@br_id char(3),@yr_id char(2),@mvch_id varchar(12),@typ_id char(2),@mvch_chqcldat datetime,@mvch_chq int,@mvch_chqst bit,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Insert'
	update t_mvch set mvch_chqcldat=@mvch_chqcldat,mvch_chqst=@mvch_chqst where mvch_id=@mvch_id and typ_id=@typ_id and mvch_chq=@mvch_chq and com_id=@com_id and br_id=@br_id and yr_id=@yr_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end

go
