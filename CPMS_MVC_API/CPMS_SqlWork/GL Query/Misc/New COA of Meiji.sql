
[ins_m_acc](@com_id char(2),@br_id varchar(2),@yr_id char(2),@acc_nam varchar(100),@acc_cid varchar(20),@acc_oid varchar(20),@acc_obal money,@acc_typ char(1),@acc_id_out varchar(20) output)
--Assets
exec ins_m_acc '01','01','01','Fixed Assets','01','01002',0,'U',''
exec ins_m_acc '01','01','01','Current Assets','01','01001',0,'U',''
--Fixed Assets
exec ins_m_acc '01','01','01','Fixed Assets at cost','01001','01002002',6009913,'U',''
exec ins_m_acc '01','01','01','Accumulated Depreciation','01001','01002001',-737878,'U',''
--Fixed Assets
exec ins_m_acc '01','01','01','Stock-in-Trade','01002','',0,'U',''
exec ins_m_acc '01','01','01','Trade debts','01002','01001005',0,'U',''
exec ins_m_acc '01','01','01','Loans:Advances & Payments','01002','',0,'U',''
exec ins_m_acc '01','01','01','Other Receivables','01002','',0,'U',''
exec ins_m_acc '01','01','01','Cash & Bank Balances','01002','',0,'U',''
--Equity
exec ins_m_acc '01','01','01','Capital','02','03001',-4849068,'U',''
exec ins_m_acc '01','01','01','Drawing','02','02001001',1917031,'U',''
exec ins_m_acc '01','01','01','Profit/ (Loss)','02','',-2426166,'U',''
--Liabilities
exec ins_m_acc '01','01','01','Current Liabilities','03','02001',0,'U',''
exec ins_m_acc '01','01','01','Long Term Liabilities','03','02002',0,'U',''
--Current Liabilities
exec ins_m_acc '01','01','01','Trade Creditors (Payable to Suppliers)','03001','02001008',0,'U',''
exec ins_m_acc '01','01','01','Salaries & Wages Payable','03001','02001003',1279000,'U',''
exec ins_m_acc '01','01','01','Accrued Expenses','03001','02001007003',426249,'U',''
exec ins_m_acc '01','01','01','Loan','03001','02001002',6000,'U',''

--Stock in Trade
exec ins_m_acc '01','01','01','Raw-Material','01002001','',1147125,'U',''
exec ins_m_acc '01','01','01','Ingredient','01002001','',514765,'U',''
exec ins_m_acc '01','01','01','Packing Material','01002001','',1368836,'U',''
exec ins_m_acc '01','01','01','Finished goods','01002001','',93413,'U',''

--Trade Debts
--Run the Query for customer chart of account

--Loans, Advances and Prepayments
exec ins_m_acc '01','01','01','Loan To Staff','01002003','01001011',166685,'U',''
exec ins_m_acc '01','01','01','Advances To Staff','01002003','01001003',42500,'U',''
exec ins_m_acc '01','01','01','Advances To Workers','01002003','01001004',137500,'U',''
exec ins_m_acc '01','01','01','Syslink Network','01002003','01001008',30000,'U',''

--Other Receivables
exec ins_m_acc '01','01','01','Mr. Shakil (Comdum Sales)','01002004','',335400,'U',''
exec ins_m_acc '01','01','01','Sh. Rizwan Corp.','01002004','01001005061',20000,'U',''
exec ins_m_acc '01','01','01','Mr. Ahmed Ali','01002004','01001010',100000,'U',''

--Cash and Bank Balances
update m_sys set bk_acc_id ='01002005'
exec ins_m_bk '01','01','01','Bank Al-Habib Ltd','','','','','','','02011610841',1603,1000,25,'02','U',''
exec ins_m_bk '01','01','01','Soneri Bank Ltd (Co s current Account)','','','','','','','0081-007728-01-5',386067,0,0,'02','U',''
exec ins_m_bk '01','01','01','Soneri Bank Ltd (C/A Mr. Ahmed Ali)','','','','','','','',10000,0,0,'02','U',''
exec ins_m_acc '01','01','01','Cash-in-Hand','01002005','01001002',268382,'U',''
update gl_br_acc set acc_oid ='01001001002' where acc_id ='01002005001'
update gl_br_acc set acc_oid ='01001001001' where acc_id ='01002005002'
update gl_br_acc set acc_oid ='01001010' where acc_id ='01002005003'

--Trade Creditors
exec ins_m_acc '01','01','01','Raw Material','03001001','',0,'U',''
exec ins_m_acc '01','01','01','Packing Material','03001001','',0,'U',''
exec ins_m_acc '01','01','01','Ingredients','03001001','',0,'U',''
exec ins_m_acc '01','01','01','Finished Goods-Rusk','03001001','',0,'U',''

--Raw Material (Trade Creditors)
exec ins_m_acc '01','01','01','Karachi Flour Mills','03001001001','02001008016',710000,'U',''
exec ins_m_acc '01','01','01','Classic Flour Mills','03001001001','02001008005',725500,'U',''
exec ins_m_acc '01','01','01','Salman Maqbool','03001001001','02001008022',732375,'U',''

--Packing Material (Trade Creditors)
exec ins_m_acc '01','01','01','Al-Fahad Printing Servies','03001001002','02001008001',970214,'U',''
exec ins_m_acc '01','01','01','Abbasi Traders','03001001002','02001008002',7440,'U',''
exec ins_m_acc '01','01','01','Muhammadi Advertising Printers','03001001002','02001008017',7580,'U',''
exec ins_m_acc '01','01','01','Daniyal Packages','03001001002','02001008006',-11582,'U',''

--Ingredients (Trade Creditors)
exec ins_m_acc '01','01','01','Gilani & Co.','03001001003','02001008010',69023,'U',''
exec ins_m_acc '01','01','01','Jamil Stores','03001001003','02001008015',48850,'U',''
exec ins_m_acc '01','01','01','Sharif Malik','03001001003','02001008025',55750,'U',''
exec ins_m_acc '01','01','01','Indoor Oil','03001001003','02001008012',154200,'U',''
exec ins_m_acc '01','01','01','I.R Enterprises','03001001003','02001008013',35808,'U',''
exec ins_m_acc '01','01','01','Yousuf Stores','03001001003','02001008023',107500,'U',''
exec ins_m_acc '01','01','01','Sona Corporation','03001001003','02001008021',45000,'U',''
exec ins_m_acc '01','01','01','Bake Servies','03001001003','02001008004',-500,'U',''
exec ins_m_acc '01','01','01','Pearl Enterprises','03001001003','02001008020',5000,'U',''
exec ins_m_acc '01','01','01','Al-Huda Traders','03001001003','02001008003',8600,'U',''
exec ins_m_acc '01','01','01','Danish Traders','03001001003','02001008007',60000,'U',''
exec ins_m_acc '01','01','01','Chaman Stores','03001001003','02001008027',12960,'U',''

--Finished Goods (Trade Creditors)
exec ins_m_acc '01','01','01','Mehran Food Products','03001001004','02001008024',293577,'U',''

--Expenses
exec ins_m_acc '01','01','01','Cost of Goods Sold','05','',0,'U',''
exec ins_m_acc '01','01','01','Operating Expenses','05','',0,'U',''

--Cost of Goods Sold
exec ins_m_acc '01','01','01','Raw Material','05001','',0,'U',''
exec ins_m_acc '01','01','01','Manufacturing Expenses','05001','',0,'U',''
exec ins_m_acc '01','01','01','Finished Goods','05001','',0,'U',''

--Raw Material (COGS)
exec ins_m_acc '01','01','01','Purchases','05001001','05063',53767802,'U',''

--Manufacturing Expenses (COGS)
exec ins_m_acc '01','01','01','Salaries and Wages','05001002','05035003',2702382,'U',''
exec ins_m_acc '01','01','01','Overtime','05001002','05049',470144,'U',''
exec ins_m_acc '01','01','01','Gas Expenses','05001002','05019',1799872,'U',''
exec ins_m_acc '01','01','01','Electricity Expenses','05001002','05014',458264,'U',''
exec ins_m_acc '01','01','01','Factory Rent','05001002','05016',525000,'U',''
exec ins_m_acc '01','01','01','Diesel Expenses','05001002','05041',236771,'U',''
exec ins_m_acc '01','01','01','Consumables','05001002','05011',56415,'U',''
exec ins_m_acc '01','01','01','Genertor Expenses','05001002','05018',10660,'U',''
exec ins_m_acc '01','01','01','Labour Quarter Rent','05001002','05024',84000,'U',''
exec ins_m_acc '01','01','01','Labour Food Expenses','05001002','05008',86800,'U',''
exec ins_m_acc '01','01','01','Ice & Water Expenses','05001002','05020',239210,'U',''
exec ins_m_acc '01','01','01','Repair & Maintenance (Manufacturing)','05001002','',0,'U',''
exec ins_m_acc '01','01','01','Depreciation (Manufacturing)','05001002','',553393,'U',''

--Repair & Maintenance (Manfacturing)
exec ins_m_acc '01','01','01','Plant & Machinery','05001002012','05029',179700,'U',''
exec ins_m_acc '01','01','01','Factory Premises','05001002012','05030',93062,'U',''

--Finished Goods (COGS)
exec ins_m_acc '01','01','01','Purchased (Rusk)','05001003','05065',4465159,'U',''

--Operating Expenses
exec ins_m_acc '01','01','01','Administrative Expenses','05002','',0,'U',''
exec ins_m_acc '01','01','01','Selling & Distribution Expenses','05002','',0,'U',''

--Administrative Expenses
exec ins_m_acc '01','01','01','Salaries & Allowances','05002001','05033001',1398831,'U',''
exec ins_m_acc '01','01','01','Eidi','05002001','05012',500,'U',''
exec ins_m_acc '01','01','01','Entertainment Expenses','05002001','05015',74554,'U',''
exec ins_m_acc '01','01','01','Printing & Stationery','05002001','05028',77925,'U',''
exec ins_m_acc '01','01','01','Telephone Expenses','05002001','05034',2780,'U',''
exec ins_m_acc '01','01','01','Mobile Phone Expenses','05002001','05026',3350,'U',''
exec ins_m_acc '01','01','01','Charity & Donation','05002001','05008',21150,'U',''
exec ins_m_acc '01','01','01','Travelling Expenses','05002001','05013',6000,'U',''
exec ins_m_acc '01','01','01','Computer Expenses','05002001','05009',37305,'U',''
exec ins_m_acc '01','01','01','Consultancy Fee','05002001','05010',52000,'U',''
exec ins_m_acc '01','01','01','Robbery Expenses','05002001','05032',58300,'U',''
exec ins_m_acc '01','01','01','Medical Expenses','05002001','05027',800,'U',''
exec ins_m_acc '01','01','01','Newspaper','05002001','05066',450,'U',''
exec ins_m_acc '01','01','01','Inspection','05002001','05022',76800,'U',''
exec ins_m_acc '01','01','01','Income-Tax','05002001','05021',50000,'U',''
exec ins_m_acc '01','01','01','EOBI','05002001','05054',14400,'U',''
exec ins_m_acc '01','01','01','SESSI','05002001','05056',16400,'U',''
exec ins_m_acc '01','01','01','Car Maint-Executive','05002001','05050',33765,'U',''
exec ins_m_acc '01','01','01','Trade License','05002001','05053',2880,'U',''
exec ins_m_acc '01','01','01','Fax Expenses','05002001','05055',20,'U',''
exec ins_m_acc '01','01','01','Bank Charges','05002001','05046',1355,'U',''
exec ins_m_acc '01','01','01','With-Holding Tax','05002001','05047',1020,'U',''
exec ins_m_acc '01','01','01','Repair & Maintenances (Office)','05002001','05031',4705,'U',''
exec ins_m_acc '01','01','01','Miscellaneous','05002001','05042',4670,'U',''
exec ins_m_acc '01','01','01','Depreciation (Administrative)','05002001','',110693,'U',''

--Selling & Distribution Expenses
exec ins_m_acc '01','01','01','Salaries & Allowances','05002002','05033002',1607148,'U',''
exec ins_m_acc '01','01','01','Petrol & C.N.G','05002002','05005',1436689,'U',''
exec ins_m_acc '01','01','01','Market Commission','05002002','05025',11770184,'U',''
exec ins_m_acc '01','01','01','Commission on Sales','05002002','05027',2194470,'U',''
exec ins_m_acc '01','01','01','Advertising & Sales Promotion','05002002','05004',186590,'U',''
exec ins_m_acc '01','01','01','Free Sampling & Discount','05002002','05003',174151,'U',''
exec ins_m_acc '01','01','01','Delivery Van Expenses','05002002','05036',396658,'U',''
exec ins_m_acc '01','01','01','Delivery Van Rent','05002002','05038',2009607,'U',''
exec ins_m_acc '01','01','01','Van Insurance Permium','05002002','05007',500,'U',''
exec ins_m_acc '01','01','01','Fuel','05002002','05017',638345,'U',''
exec ins_m_acc '01','01','01','Carriage & Cartrage','05002002','05006',5705,'U',''
exec ins_m_acc '01','01','01','Loading & Unloading','05002002','05040',45453,'U',''
exec ins_m_acc '01','01','01','Vehicle-Tax','05002002','05044',37193,'U',''
exec ins_m_acc '01','01','01','Delivery Expenses-Rusk','05002002','05048',5300,'U',''
exec ins_m_acc '01','01','01','Toll-Tax','05002002','05035',1050,'U',''
exec ins_m_acc '01','01','01','Rate Difference','05002002','05043',3645,'U',''
exec ins_m_acc '01','01','01','Depreciation (Selling & Distribution)','05002002','',73792,'U',''


--Renvenue
exec ins_m_acc '01','01','01','Sales','04','',0,'U',''
exec ins_m_acc '01','01','01','Other Income','04','',0,'U',''

--Sales
exec ins_m_acc '01','01','01','Bread','04001','04001',83825832,'U',''

--Other Income
exec ins_m_acc '01','01','01','Sales of Refrection','04002','04003',3779993,'U',''
exec ins_m_acc '01','01','01','Sales of Bardana','04002','04006',169651,'U',''
exec ins_m_acc '01','01','01','Miscellaneous Sales','04002','04005',433141,'U',''
exec ins_m_acc '01','01','01','Sales of UPS','04002','',2800,'U',''





select * from rough.dbo.gl_m_acc where acc_nam like '%salEs%'
select * from gl_m_acc where acc_nam like '%other%'
select * from rough.dbo.gl_m_acc where left(acc_id,2)='04'

update gl_br_acc set acc_obal=6000 where acc_id='03001004'
select gl_m_acc.acc_id,acc_nam,acc_oid,acc_obal from gl_m_acc
	inner join gl_br_acc 
	on gl_m_acc.acc_id=gl_br_acc.acc_id

select * from rough.dbo.t_dvch
inner join gl_m_acc
	on rough.dbo.t_dvch.acc_id=gl_m_acc.acc_cid
select * from gl_m_acc

select * from gl_m_acc where acc_cid not in (select distinct acc_id from rough.dbo.t_dvch )
select distinct ''''+rtrim(acc_id) +''''+','from rough.dbo.t_dvch where acc_id in (select acc_oid from gl_br_acc)
select distinct acc_cid from gl_m_acc
--21632
select * from gl_br_acc where acc_oid not in 
(
'02001008016',
'01002003',
'02001008007',
'05039',
'01001005040',
'01001005028',
'02001008015',
'01001005045',
'01001005060',
'02001008001',
'04006',
'05011',
'01001005080',
'02001002',
'01001005065',
'05004',
'01001005070',
'01001005008',
'05032',
'02001008014',
'02001008019',
'05038',
'05005',
'02001008002',
'02001008025',
'01001005053',
'01001008',
'01001005072',
'01001005043',
'04005',
'01001005061',
'05036',
'05051002',
'02001008006',
'02001003',
'01001005014',
'05008',
'05051003',
'01001005063',
'05010',
'05015',
'01001009',
'01001005049',
'01001005041',
'01001005069',
'01001005010',
'02001008004',
'05027',
'05033001',
'01001005047',
'05066',
'04003',
'05048',
'01001005042',
'05063',
'04001',
'02001008003',
'05035',
'01001005031',
'02001008027',
'05041',
'02001009001',
'01001005076',
'01001005062',
'02001008012',
'05040',
'01001005024',
'01001005054',
'02001008029',
'05024',
'05016',
'01001005074',
'01001005078',
'05029',
'01001005079',
'01001005064',
'01001006',
'01001005011',
'05014',
'01001005004',
'01002001',
'01001005017',
'05009',
'01001005001',
'01001005058',
'01001005044',
'02001008024',
'01001005007',
'01001005030',
'05031',
'01001005068',
'05054',
'05050',
'01002002',
'01001005029',
'05047',
'01001005036',
'05013',
'02001008023',
'01001005077',
'01001005013',
'05069',
'02001008022',
'01001005039',
'05017',
'05028',
'01001005038',
'01001005050',
'01001005057',
'02001008020',
'02001008028',
'05025',
'01001005081',
'01001005002',
'01001004',
'01001005009',
'01001011',
'01001007',
'02001008021',
'01001005052',
'01001005006',
'05033002',
'01002004',
'05030',
'05022',
'01001005071',
'02001008026',
'02001001',
'05056',
'01001003',
'05051004',
'05068',
'05019',
'01001005034',
'01001005003',
'05033003',
'01001005051',
'02001008005',
'01001001001',
'01001002',
'02001008010',
'02001008017',
'02001005',
'01001005023',
'05045',
'05020',
'01001005005',
'05051001',
'01001005021',
'02001007003',
'01001005035',
'05006',
'02001008009',
'02001008013',
'01001005026',
'05046',
'05049',
'05003',
'05037',
'01001005046',
'01001005022'
)
