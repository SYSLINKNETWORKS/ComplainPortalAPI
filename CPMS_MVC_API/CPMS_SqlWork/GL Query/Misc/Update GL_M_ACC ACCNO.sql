

declare @acc_no int,@acc_id char(20)
declare  insvoucher  cursor for
	select acc_id from gl_m_Acc
	OPEN insvoucher
		FETCH NEXT FROM insvoucher
		INTO @acc_id
			WHILE @@FETCH_STATUS = 0
			BEGIN
			set @acc_no=(select MAX(acc_no)+1 from gl_m_acc)
			if (@acc_no is null)
				begin
					set @acc_no=1
				end
			update gl_m_acc set acc_no=@acc_no where acc_id=@acc_id
		
			FETCH NEXT FROM insvoucher
			into @acc_id
	end
	CLOSE insvoucher
	DEALLOCATE insvoucher
	GO

