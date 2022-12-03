use zsons
go


declare @men_id int,@module_id int,@men_typ varchar(250)
declare  curmenmod  cursor for
	select men_id,men_typ from m_men 
	OPEN curmenmod
		FETCH NEXT FROM curmenmod
				INTO @men_id,@men_typ
			WHILE @@FETCH_STATUS = 0
			BEGIN
			set @module_id=(select module_id from m_module where module_nam=@men_typ)
			update m_men set module_id=@module_id where men_id=@men_id
			
--print @men_nam
--print @men_typ
--print @mencat_id
--print @mensubcat_id

				FETCH NEXT FROM curmenmod
				INTO @men_id,@men_typ
	end
	CLOSE curmenmod
	DEALLOCATE curmenmod
	GO

