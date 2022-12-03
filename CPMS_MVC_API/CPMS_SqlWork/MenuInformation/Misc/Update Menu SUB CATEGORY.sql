USE zsons
GO

declare @men_id int,@men_nam varchar(250),@men_category varchar(250),@mencat_id int,@mensubcat_id int
declare  curmen  cursor for
	select men_id,men_nam,men_category from m_men where men_nam like '%Report%' --and men_id=800
	OPEN curmen
		FETCH NEXT FROM curmen
				INTO @men_id,@men_nam,@men_category
			WHILE @@FETCH_STATUS = 0
			BEGIN
			set @mencat_id=(select mencat_id from m_mencat where mencat_nam=@men_category)
			set @mensubcat_id=(select mensubcat_id from m_mensubcat where mencat_id=@mencat_id and mensubcat_nam='Transaction')
			update m_men set mensubcat_id =@mensubcat_id where men_id=@men_id
--print @men_nam
--print @men_category
--print @mencat_id
--print @mensubcat_id

				FETCH NEXT FROM curmen
				INTO @men_id,@men_nam,@men_category
	end
	CLOSE curmen
	DEALLOCATE curmen
	GO


--select * from m_men where mensubcat_id is null
--update m_men set mensubcat_id=5 where mensubcat_id is null
