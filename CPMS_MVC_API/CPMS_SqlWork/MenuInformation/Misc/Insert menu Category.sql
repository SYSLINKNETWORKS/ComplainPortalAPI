USE zsons
GO

----Menu Category
declare @mencat_nam varchar(250)
declare  mencat  cursor for
		select distinct men_category from m_men
	OPEN mencat
		FETCH NEXT FROM mencat
				INTO @mencat_nam
			WHILE @@FETCH_STATUS = 0
			BEGIN
				exec ins_m_mencat @mencat_nam,1,'U',''
				FETCH NEXT FROM mencat
				INTO @mencat_nam
	end
	CLOSE mencat
	DEALLOCATE mencat
	GO


