USE zsons
GO

----Menu Module

declare @module_nam varchar(250)
declare  module  cursor for
		select distinct men_typ from m_men
	OPEN module
		FETCH NEXT FROM module
				INTO @module_nam
			WHILE @@FETCH_STATUS = 0
			BEGIN
				exec ins_m_module @module_nam,1,'U',''
				FETCH NEXT FROM module
				INTO @module_nam
	end
	CLOSE module
	DEALLOCATE module
	GO


