
--select * from m_men where men_nam='setupstandardexpenses'

--alter table m_men add men_typ varchar(1000)

USE ZSONS
GO
--delete from m_per
--delete from m_men
	--Menu
	insert into m_men  (men_id,men_nam,men_category,men_typ) values(2001,'setupmenumodule','Form','Others')
	insert into m_men  (men_id,men_nam,men_category,men_typ) values(2002,'setupmenucategory','Form','Others')
	insert into m_men  (men_id,men_nam,men_category,men_typ) values(2003,'setupmenusubcategory','Form','Others')
	insert into m_men  (men_id,men_nam,men_category,men_typ) values(2004,'setupmenu','Form','Others')
	insert into m_men  (men_id,men_nam,men_category,men_typ) values(2005,'setupmmenu','Form','Others')

----Setup
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(1,'msetup','Form','Others')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(2,'setupcompany','Form','Others')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(3,'setupbranch','Form','Others')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(4,'setupsecurity','Form','Others')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(7,'setupuser','Form','Others')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(8,'setupusersecurity','Form','Others')
	insert into m_men  (men_id,men_nam,men_category,men_typ) values(2006,'setupusergroup','Form','Others')
	insert into m_men  (men_id,men_nam,men_category,men_typ) values(2007,'setupusergrouppermission','Form','Others')
	insert into m_men  (men_id,men_nam,men_category,men_typ) values(2008,'setupuserchangepassword','Form','Others')

--insert into m_men  (men_id,men_nam,men_category,men_typ) values(9,'setupbank','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(10,'setupbanktype','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(11,'setupbankaccount','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(12,'setupchequebookinventory','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(13,'setupgl','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(14,'setupfinancialyear','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(15,'setupchartofaccount','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(16,'setupdepartment','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(17,'setupopeningvoucher','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(18,'setupexit','Form','Others')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(82,'setupbackup','Form','Others')

--insert into m_men  (men_id,men_nam,men_category,men_typ) values(81,'setupstandardcosting','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(83,'setuppettycash','Form','Others')



----Transaction
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(19,'mtransaction','Form','Others')
insert into m_men  (men_id,men_nam,men_category,men_typ) values(152,'transactionarchive','Form','Others')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(20,'transactiongl','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(21,'transactionvouchercashreceipt','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(22,'transactionvouchercashpayment','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(23,'transactionvoucherbankreceipt','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(24,'transactionvoucherbankpayment','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(25,'transactionvoucherjournal','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(26,'transactionapproved','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(27,'transactionyearend','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(70,'transactionbankreconciliation','Form','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(84,'transactionvoucherpettycash','Form','GL')

----Reports
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(28,'mreport','Report','Others')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(29,'reportgl','Report','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(30,'reportchartofaccount','Report','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(31,'reportvoucher','Report','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(32,'reportcashbankbook','Report','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(33,'reportchqprint','Report','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(34,'reportgeneralledger','Report','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(35,'reporttrialbalance','Report','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(36,'reporttrialbalancesixcolumns','Report','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(37,'reportprofitloss','Report','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(38,'reportbalancesheet','Report','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(71,'reportcashflow','Report','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(72,'reportbankreconciliationMFI','Report','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(73,'reportbankposition','Report','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(74,'reportmonthlyexpense','Report','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(175,'reportcostofgoodssold','Report','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(176,'reportpettycashjournal','Report','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(177,'reportcashflow','Report','GL')




----MultiFood
----Setup
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(39,'setupitem','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(40,'setupscale','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(41,'setupitembrand','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(42,'setupitemcategory','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(69,'setupitemsubcategory','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(85,'setupitemqty','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(43,'setupitemdetail','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(44,'setupitemopeningstock','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(980,'setupinventory','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(45,'setupsalesanddistribution','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(47,'setupsuppliercategory,men_typ','Form','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(981,'setuppurchase','Form','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(48,'setupsupplier','Form','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(51,'setupwarehouse','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(52,'setupcurrency','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(53,'setupcurrencyrate','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(86,'setupitemsubcategorymaster','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(962,'setupstandardcost','Form','Standard Cost')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(963,'setupstandardcostcategory','Form','Standard Cost')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(964,'setupstandardcostcategoryaccount','Form','Standard Cost')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(965,'setupstandardexpenses','Form','Standard Cost')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(967,'setupstandardcostpacking','Form','Standard Cost')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(968,'setupstandardcostrawmaterial','Form','Standard Cost')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(969,'setupitemendingstock','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(970,'setupstandardcategorymaster','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(971,'setupstandardcategory','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(972,'setupitemrate','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(973,'setupitemdiscount','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(992,'setupsupplieropeningform','Form','Purchase')


--Setup Sales
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(974,'setupsales','Form','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(49,'setupcustomercategory','Form','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(50,'setupcustomer','Form','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(975,'setupcountry','Form','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(976,'setupcity','Form','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(977,'setupsector','Form','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(978,'setupzone','Form','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(979,'setupsalesmanzone','Form','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(991,'setupcustomeropeningform','Form','Sales')


--insert into m_men  (men_id,men_nam,men_category,men_typ) values(507,'setupport','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(508,'setupshipline','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(509,'setupcontainertype','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(504,'setupcontainersize','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(505,'setuptermsconditions','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(506,'setupvessel','Form','Sales & Distribution')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(510,'setupnature','Form','Sales & Distribution')

----Setup Payroll
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(801,'setuppayroll','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(802,'setupdatabasepath','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(804,'setupimportuser','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(805,'setuppayrollimportdata','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(806,'setuppayrollroster','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(807,'setuppayrollloancategory','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(808,'setuppayrollallowances','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(809,'setuppayrollemployeeprofile','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(810,'setuppayrollemployeecategory','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(811,'setuppayrollemployeesubcategory','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(812,'setuppayrollmachinecompany','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(813,'setuppayrollmachine','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(814,'setuppayrollsalaryincreament','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(815,'setuppayrollinoutcategory','Form','Payroll')


----
------Transaction
----Payroll
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(901,'transactionpayroll','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(902,'transactionimportattendance','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(903,'transactionpayrollbonus','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(904,'transactionpayrollholiday','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(905,'transactionpayrolladvance','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(906,'transactionpayrolllateapproval','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(907,'transactionpayrollabsentapproval','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(908,'transactionpayrollloan','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(909,'transactionpayrollattendancesearch','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(910,'transactionpayrollsalarygenerate','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(911,'transactioninouteditor','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(912,'transactionloanreceive','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(913,'transactionpayrolldepartmentovertime','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(914,'transactionpayrolldepartmentemployeeovertime','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(915,'transactioninouteditorapproval','Form','Payroll'
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(916,'transactionnighthours','Form','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(917,'transactionnightapproval','Form','Payroll')




------Reports Payroll
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(950,'reportattendence','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(951,'reportdailyattendence','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(952,'reportovertime','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(953,'reportemployeeprofile','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(954,'reportmonthattendence','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(955,'reportpayroll','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(956,'reportsalary','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(957,'reportadvance','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(958,'reportabsent','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(959,'reportloan','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(960,'reportemployeedateofjoin','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(961,'reportloanreceive','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(751,'reportpayroll','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(752,'reportattendence','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(753,'reportdailyattendence','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(754,'reportovertime','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(755,'reportemployeeprofile','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(756,'reportmonthattendence','Report','Payroll')--
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(757,'reportspayrollemployeeresign','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(758,'reportinouteditor','Report','Payroll')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(759,'reportnightovertime','Report','Payroll')




----Purchase
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(54,'transactionpurchases','Form','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(55,'transactionrequisition','Form','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(56,'transactionpurchasesorder','Form','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(57,'transactionsupplieradvancepayment','Form','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(58,'transactiongrn','Form','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(59,'transactionbill','Form','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(60,'transactionpayment','Form','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(61,'transactiondebitnote','Form','Purchase')

--Sales
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(62,'transactionsales','Form','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(64,'transactioncustomeradvancepayment','Form','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(65,'transactiondc','Form','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(66,'transactioninvoice','Form','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(67,'transactionreceiving','Form','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(68,'transactioncreditnote','Form','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(68,'transactioncreditnote','Form','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(75,'transactionsalesestimate','Form','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(76,'transactionsalesagreement','Form','Sales')


----Inventory
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(501,'transactioninventory','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(502,'transactionrawmaterialtransfernote','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(503,'transactionfinishgoodstransfernote','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(511,'transactionpackingmaterialadjustment','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(512,'transactionrawmaterialreturn','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(513,'transactionpackingmaterialreturn','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(514,'transactionstockadjustment','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(515,'transactionfinishgoodsdisposal','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(516,'transactionrawmaterialsupplementtransfernote','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(517,'transactionrawmaterialpattitransfernote','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(518,'transactionfinishgoodpattitransfernote','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(519,'transactionsemifinishgoodtransfernote','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(520,'transactionstockadjustmentmonthly','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(521,'transactionsemifinishgoodtransfernotepetti','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(522,'transactionprintexpiry','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(523,'transactionstockvaluation','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(524,'transactiongatepass','Form','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(525,'transactionfinishgoodmonthlyadjustment','Form','Inventory')


----Reports
----Purchase
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(101,'reportpurchase','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(102,'reportpurchaserequisition','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(103,'reportpurchaserequisitionsummary','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(104,'reportpurchaseorder','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(105,'reportpurchaseordersummary','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(106,'reportpurchasegrn','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(107,'reportpurchasegrnsummary','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(108,'reportpurchasebill','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(109,'reportpurchasebillsummary','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(110,'reportpurchasepayment','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(111,'reportsupplieroutstanding','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(112,'reportpurchaseregister','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(113,'reportpurchaseregisteritemwise','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(114,'reportpurchaseregistersummary','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(115,'reportsupplieraging','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(116,'reportdebitnote','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(117,'reportsupplierdue','Report','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(119,'reportsupplieradvance','Report','Purchase')


----Sales
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(301,'reportsales','Report','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(302,'reportcustomeroutstanding','Report','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(303,'reportsalesestimate','Report','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(304,'reportsaleorder','Report','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(305,'reportdeliverychallan','Report','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(306,'reportinvoice','Report','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(307,'reportreceipt','Report','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(308,'reportcreditnote','Report','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(309,'reportcustomeradvance','Report','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(310,'reportaggreement','Report','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(311,'reportitemrate','Report','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(312,'reportitemdiscount','Report','Sales')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(313,'reportcustomeraging','Report','Sales')

--update m_men set men_nam='reportsalesestimate' where men_id=303
----Production 
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(601,'msetupproduction','Form','Production')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(602,'setuprecipes','Form','Production')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(603,'setupstandardbatchqty','Form','Production')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(604,'setupchallanbook','Form','Sales & Distribution')


----Production Reports
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(701,'reportproduction','Report','Production')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(702,'reportbatchissuereceived','Report','Production')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(703,'reportrawmaterialissue','Report','Production')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(704,'reportrawmaterialrequired','Report','Production')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(705,'reportpackingmaterialrequired','Report','Production')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(706,'reportrecipe','Report','Production')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(707,'reportpackingmaterialissue','Report','Production')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(708,'reportfinishgoodstransfernote','Report','Production')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(709,'reportrawmaterialreturn','Report','Production')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(710,'reportpackingmaterialreturn','Report','Production')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(711,'reportrawmaterialspplemantary','Report','Production')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(712,'reportstardardbatchqty','Report','Production')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(713,'reportmandarequired','Report','Production')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(714,'reportfinishgoodscontractor','Report','Production')



----Invenetory Report
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(401,'reportinventory','Report','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(402,'reportinventoryitem','Report','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(403,'reportinventorystocksummary','Report','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(404,'reportperformainvoice','Report','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(405,'reportinventorystockledger','Report','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(406,'reportminimumqty','Report','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(407,'reportinventorystockmovement','Report','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(408,'reportinventoryfinishgoodsstockadjustment','Report','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(409,'reportinventorystockadjustmentmonthly','Report','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(410,'reportfinishgoodsdisposal','Report','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(411,'reportstocksaleordersummary','Report','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(412,'reportprintexpiry','Report','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(413,'reportitemdetail','Report','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(414,'reportinventorystockvaluation','Report','Inventory')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(415,'reportinventorystockadjustmentmonthlyfinishgoods','Report','Inventory')



----Standard Cost Report
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(966,'reportstandardcost','Report','Standard Cost')

----
----Gadgets
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(201,'bi','Form','Others')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(202,'gadgetcashbank','Gadget','GL')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(203,'gadgetpurchaserequisition','Gadget','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(204,'gadgetpurchaseorder','Gadget','Purchase')
--insert into m_men  (men_id,men_nam,men_category,men_typ) values(205,'gadgetpurchasegrn','Gadget','Purchase')


--Only Menu 
declare @men_id int,@usr_id int
declare usr cursor for 
select usr_id from new_usr where usr_id not in (1,3)
OPEN usr
		FETCH NEXT FROM usr
		INTO @usr_id
			WHILE @@FETCH_STATUS = 0
			BEGIN				
				declare men cursor for 
				select men_id from m_men where men_id not in (select men_id from m_per where usr_id=@usr_id)
				OPEN men
						FETCH NEXT FROM men
						INTO @men_id
							WHILE @@FETCH_STATUS = 0
							BEGIN				
							exec ins_m_per '01','01',0,0,0,0,0,@men_id,@usr_id,'','',1,''
							FETCH NEXT FROM men
									INTO @men_id

					end
					CLOSE men
					DEALLOCATE men
			FETCH NEXT FROM usr
					INTO @usr_id

	end
	CLOSE usr

	DEALLOCATE usr
GO

--Only Menu for ABDUL SATTAR & ARSHAD GODIL
declare @men_id int,@usr_id int
declare usr cursor for 
select usr_id from new_usr where usr_id in (1,3)
OPEN usr
		FETCH NEXT FROM usr
		INTO @usr_id
			WHILE @@FETCH_STATUS = 0
			BEGIN				
				declare men cursor for 
				select men_id from m_men where men_id not in (select men_id from m_per where usr_id=@usr_id)
				OPEN men
						FETCH NEXT FROM men
						INTO @men_id
							WHILE @@FETCH_STATUS = 0
							BEGIN				
							exec ins_m_per '01','01',1,1,1,1,1,@men_id,@usr_id,'','',1,''
							FETCH NEXT FROM men
									INTO @men_id

					end
					CLOSE men
					DEALLOCATE men
			FETCH NEXT FROM usr
					INTO @usr_id

	end
	CLOSE usr

	DEALLOCATE usr
