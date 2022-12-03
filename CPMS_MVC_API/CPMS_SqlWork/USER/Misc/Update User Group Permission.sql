--select * from m_men where mensubcat_id is null
--update m_men set mensubcat_id=5 where mensubcat_id is null

--update m_usrgp set usrgp_typ='D' where usrgp_id=1
--update m_usrgp set usrgp_typ='S' where usrgp_id=2
--UPDATE m_men set men_typ='D' where men_id=2001
--UPDATE m_men set men_typ='D' where men_id=2002
--UPDATE m_men set men_typ='D' where men_id=2003
--UPDATE m_men set men_typ='D' where men_id=2004
--UPDATE m_men set men_typ='D' where men_id=2005

--delete from m_gpper

----Only Menu for Develeper & Administrator
--declare @men_id int,@usr_id int
--declare usr cursor for 
--select usrgp_id from m_usrgp where usrgp_typ IN ('D','S')
--OPEN usr
--		FETCH NEXT FROM usr
--		INTO @usr_id
--			WHILE @@FETCH_STATUS = 0
--			BEGIN				
--				declare men cursor for 
--				select men_id from m_men 
--				OPEN men
--						FETCH NEXT FROM men
--						INTO @men_id
--							WHILE @@FETCH_STATUS = 0
--							BEGIN				
--							exec ins_m_gpper '01','01',1,1,1,1,1,@men_id,@usr_id,'','','',''
--							FETCH NEXT FROM men
--									INTO @men_id

--					end
--					CLOSE men
--					DEALLOCATE men
--			FETCH NEXT FROM usr
--					INTO @usr_id

--	end
--	CLOSE usr

--	DEALLOCATE usr


--USER PERMISSION DATE
declare @usr_id int,@per_dt1 datetime,@per_dt2 datetime
declare usr cursor for 
	select usr_id,MIN(per_dt1),MAX(per_dt2) from m_per group by usr_id
OPEN usr
		FETCH NEXT FROM usr
		INTO @usr_id,@per_dt1,@per_dt2
			WHILE @@FETCH_STATUS = 0
			BEGIN				
				update new_usr set per_dt1=@per_dt1,per_dt2=@per_dt2 where usr_id=@usr_id
			FETCH NEXT FROM usr
				INTO @usr_id,@per_dt1,@per_dt2

			end

	CLOSE usr

	DEALLOCATE usr
