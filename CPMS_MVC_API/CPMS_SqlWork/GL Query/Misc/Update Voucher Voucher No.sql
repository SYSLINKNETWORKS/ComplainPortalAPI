

declare @com_id char(2),@br_id char(3),@yr_id char(2),@typ_id char(2),@mvch_no int,@mvch_id char(12)
declare  insvoucher  cursor for
	select com_id,br_id,yr_id,typ_id,mvch_id from t_mvch
	OPEN insvoucher
		FETCH NEXT FROM insvoucher
		INTO @com_id,@br_id,@yr_id,@typ_id,@mvch_id
			WHILE @@FETCH_STATUS = 0
			BEGIN
			set @mvch_no=(select MAX(mvch_no)+1 from t_mvch where com_id=@com_id and br_id=@br_id )
			if (@mvch_no is null)
				begin
					set @mvch_no=1
				end
			update t_mvch set mvch_no=@mvch_no where com_id=@com_id and br_id=@br_id and yr_id=@yr_id and mvch_id=@mvch_id and typ_id=@typ_id
			update t_dvch set mvch_no=@mvch_no where com_id=@com_id and br_id=@br_id and yr_id=@yr_id and mvch_id=@mvch_id and typ_id=@typ_id
		
			FETCH NEXT FROM insvoucher
			into @com_id,@br_id,@yr_id,@typ_id,@mvch_id
	end
	CLOSE insvoucher
	DEALLOCATE insvoucher
	GO

