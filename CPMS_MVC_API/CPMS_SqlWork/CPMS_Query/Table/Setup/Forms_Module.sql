use CPMS
go

--insert into complainForms(Id,formName,Type,Active) values (1,'Sales','S',1)
--insert into complainForms(Id,formName,Type,Active) values (2,'Purchase','S',1)
--insert into complainForms(Id,formName,Type,Active) values (3,'Sale and Distribution','S',1)
--insert into complainForms(Id,formName,Type,Active) values (4,'Payroll','S',1)
--insert into complainForms(Id,formName,Type,Active) values (5,'GL','S',1)
--alter table m_com add com_jiraeml varchar(100),com_jirapass varchar(max),com_jiraurl varchar(max)
--update m_com set com_jiraeml='salman@mmcgbl.com',com_jirapass='neWCXbgb95MQfKaOOhhG3880',com_jiraurl='https://mmc-support.atlassian.net/'
--alter table t_mcomp add jira_issuekey varchar(100),jira_issueid int

create table complainForms(
Sno int identity(1001,1),
Id int,
formName varchar(100),
Type char(1),
Active bit
)

--Constraint
--Not Null
alter table complainForms alter column Id int not null

--Primary Key
alter table complainForms add constraint PK_complainForms_complainFormsID primary key (Id)



--select * from t_mcomp
--alter table t_mcomp add complainFormsId int
--alter table m_br add br_snam varchar(100)
--select * from m_br
--update m_br set br_snam='SSC' where br_id='01'
--update m_br set br_snam='PHM' where br_id='02'
--update m_br set br_snam='Nathi' where br_id='03'
--update m_br set br_snam='MFI' where br_id='04'
--update m_br set br_snam='ST' where br_id='05'
--update m_br set br_snam='AYT' where br_id='06'
--update m_br set br_snam='KMC' where br_id='07'
--update m_br set br_snam='PA' where br_id='08'
--update m_br set br_snam='AM' where br_id='09'
--update m_br set br_snam='PkA' where br_id='10'
--update m_br set br_snam='NBP' where br_id='11'
--update m_br set br_snam='AJ' where br_id='12'
--update m_br set br_snam='MAB' where br_id='13'
--update m_br set br_snam='ADN' where br_id='14'
--update m_br set br_snam='SSC' where br_id='15'
--update m_br set br_snam='FC' where br_id='16'
--update m_br set br_snam='KI' where br_id='17'
--update m_br set br_snam='MFH' where br_id='18'
--update m_br set br_snam='CS' where br_id='19'
--update m_br set br_snam='KVTC' where br_id='22'
--update m_br set br_snam='FC' where br_id='24'
--update m_br set br_snam='CSB' where br_id='26'