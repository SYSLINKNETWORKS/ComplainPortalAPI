using System;
using System.Collections.Generic;
//using System.Linq;
//using System.Net;
//using System.Net.Http;
using System.Web.Http;
using System.Data;
using System.Data.SqlClient;
using CPMS_MVC_API.BLogic;
using Newtonsoft.Json;
using System.Threading.Tasks;
//using Google.Apis.Auth.OAuth2;
using Google.Apis.Drive.v3;
//using Google.Apis.Drive.v3.Data;
//using Google.Apis.Services;
//using Google.Apis.Util.Store;
using System.IO;

using Google.Apis.Download;
//using System.Text;
//using System.Web.Mvc;

namespace CPMS_MVC_API.Controllers
{
    public class ComplainController : ApiController
    {
        SqlDataAdapter daweb = new SqlDataAdapter();
        SqlCommand cmdweb = new SqlCommand();
        SqlConnection cnweb = new SqlConnection();
        SqlTransaction transweb = null;
        SqlParameter paramweb = new SqlParameter();
        Functions func = new Functions();
        DataSet dsweb = new DataSet();
        string cmdtxt = "";

        Jira objJira = new Jira();

        //Create Start
        [HttpPost]
        [Route("~/Complain/create")]
        public async Task<Object> create([FromBody] dynamic dataResult)
        {
            System.Data.DataTable dttblusrgp_ins = new System.Data.DataTable();
            dttblusrgp_ins.Columns.Add("Id", typeof(string));
            dttblusrgp_ins.Columns.Add("Remarks", typeof(string));
            dttblusrgp_ins.Columns.Add("status", typeof(int));
            var JSONResult = "";

            try
            {
                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {
                    string str = "";
                    string _com_id = strusr[2], _br_id = strusr[3], _m_yr_id = strusr[4], _com_eml = strusr[7], _br_nam = strusr[8], _br_eml = strusr[9];
                    int _usr_id = Convert.ToInt32(strusr[1]);

                    string _mcomp_comp_by = Convert.ToString(dataResult.Complain_By);
                    string _mcomp_comp = Convert.ToString(dataResult.Complain);
                    string _complainFormsId = Convert.ToString(dataResult.complainFormsId);
                    string _mcomp_rmk = Convert.ToString(dataResult.Remarks);
                    string _mcomp_pr = Convert.ToString(dataResult.Priority);
                    string _mcomp_isstyp = Convert.ToString(dataResult.IssueType);
                    string _mcomp_AttachmentCount = Convert.ToString(dataResult.AttachmentCount);

                    string lblerr = "";

                    str = System.Configuration.ConfigurationManager.ConnectionStrings["IFS_local"].ToString();
                    if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }
                    cnweb.ConnectionString = str;
                    //Master
                    int _mcomp_id = func.pkid("t_mcomp", "mcomp_id");

                    if (_mcomp_comp_by == "_") { _mcomp_comp_by = ""; }
                    if (_mcomp_comp == "_") { _mcomp_comp = ""; }
                    if (_mcomp_rmk == "_") { _mcomp_rmk = ""; }

                    cmdweb.Connection = cnweb;
                    cmdweb.CommandType = CommandType.Text;
                    cmdweb.CommandText = "  insert into t_mcomp" +
                                         " (com_id, br_id, mcomp_id, mcomp_no, mcomp_dat, mcomp_comp, mcomp_typ,mcomp_isstyp, usr_id, mcomp_rmk, mcomp_comp_by,complainFormsId, mcomp_pr,ins_dat)" +
                                         " values" +
                                         " (@com_id, @br_id, @mcomp_id, @mcomp_no, @mcomp_dat, @mcomp_comp, @mcomp_typ,@mcomp_isstyp, @usr_id, @mcomp_rmk, @mcomp_comp_by,@complainFormsId, @mcomp_pr,@ins_dat)";
                    cmdweb.Parameters.Clear();

                    paramweb = cmdweb.Parameters.AddWithValue("@com_id", strusr[2]);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_id", strusr[3]);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_id", _mcomp_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@complainFormsId", _complainFormsId);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_no", _mcomp_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_dat", DateTime.Now.ToString("dd-MMM-yyyy"));
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_comp_by", _mcomp_comp_by);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_comp", _mcomp_comp);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_rmk", _mcomp_rmk);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_typ", "U");
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_isstyp", _mcomp_isstyp);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_id", _usr_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_pr", _mcomp_pr);
                    paramweb = cmdweb.Parameters.AddWithValue("@ins_dat", DateTime.Now);




                    cnweb.Open();
                    transweb = cnweb.BeginTransaction();
                    cmdweb.Transaction = transweb;
                    int i = cmdweb.ExecuteNonQuery();
                    if (i > 0)
                    {


                        savedetail(_mcomp_id, dataResult);

                        string breml = _com_eml + "," + _br_eml;
                        string compbody = "Dear All, <br/>Complain : " + _mcomp_comp;
                        if (_mcomp_rmk != "")
                        {
                            compbody = compbody + "<br/>Remarks : " + _mcomp_rmk;
                        }
                        if (_mcomp_AttachmentCount != "0")
                        {
                            compbody = compbody + "<br/>Attachment(s) : " + _mcomp_AttachmentCount;

                        }

                        compbody = compbody + "<br/><br/>Regards <br/><br/>" + _mcomp_comp_by + "<br/>" + _br_nam;
                        transweb.Commit();
                        cnweb.Close();

                        tryjira(_mcomp_id);
                        func.sendemail(_com_id,_br_id,_br_nam, _mcomp_id, breml, "Ticket # " + _mcomp_id + " Registered", compbody,"R");
                        dttblusrgp_ins.Rows.Add(_mcomp_id.ToString(), "Ticket # " + _mcomp_id + " Registered", 1);
                    }
                }
                else
                {
                    dttblusrgp_ins.Rows.Add("", "Invalid User", 0);
                }
            }
            catch (Exception e)
            {
                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblusrgp_ins.Rows.Add("", "Error : " + e.Message + innerexp, 0);
                if (transweb != null) { transweb.Rollback(); }
                if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }


            }

            JSONResult = JsonConvert.SerializeObject(dttblusrgp_ins);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //Create End

        public void tryjira(int ID)
        {
            string Key = "", url = "", complainSummary = "", complainRemarks = "", username = "", password = "";
            string complainby = "", Complain = "", Complaintype = "", form = "";
            string complainNo = "";
            //cmdtxt = "select br_snam as [Key],mcomp_rmk,mcomp_comp_by,mcomp_comp,'Complain By: ' +mcomp_comp_by+' Complain: '+ mcomp_comp+' Form: '+isnull(complainForms.formName,'')+ ' Complain Type: '+case when mcomp_isstyp='B' then 'Bug/Fixes' when mcomp_isstyp='N' then 'New Requirement' when mcomp_isstyp='C' then 'Changes' end as [complain],com_jiraeml,com_jirapass,com_jiraurl,imgarc_weblink " +
            cmdtxt = " select br_snam as [Key],mcomp_rmk,mcomp_comp_by,mcomp_comp,complainForms.formName, " +
                " case when mcomp_isstyp='B' then 'Bug/Fixes' when mcomp_isstyp='N' then 'New Requirement' when mcomp_isstyp='C' then 'Changes' end as [mcomp_typ], " +
                " 'Complain By: <br> ' +mcomp_comp_by+' Complain: '+ mcomp_comp+' Form: '+isnull(complainForms.formName,'')+  " +
                " ' Complain Type: '+case when mcomp_isstyp='B' then 'Bug/Fixes' when mcomp_isstyp='N' then 'New Requirement' when mcomp_isstyp='C' then 'Changes' end as [complain],com_jiraeml,com_jirapass,com_jiraurl, imgarc_weblink" +
                " from t_mcomp  " +
                " inner join complainForms on t_mcomp.complainFormsId=complainForms.Id " +
                " left join t_dcomp_img on t_mcomp.mcomp_id=t_dcomp_img.mcomp_id " +
                " inner join m_com on t_mcomp.com_id=m_com.com_id " +
                " inner join m_br on t_mcomp.br_id=m_br.br_id " +
                " where t_mcomp.mcomp_id=" + ID + " ";
            DataSet ds = func.dsfunc(cmdtxt);
            if (ds.Tables[0].Rows.Count > 0)
            {
                complainby = ds.Tables[0].Rows[0]["mcomp_comp_by"].ToString();
                Complain = ds.Tables[0].Rows[0]["mcomp_comp"].ToString();
                form = ds.Tables[0].Rows[0]["formName"].ToString();
                Complaintype = ds.Tables[0].Rows[0]["mcomp_typ"].ToString();

                Key = ds.Tables[0].Rows[0]["Key"].ToString();
                url = ds.Tables[0].Rows[0]["com_jiraurl"].ToString();
                complainNo = "Complain No: " + ID.ToString();
                complainSummary = "Complain By : " + complainby + " Complain: " + Complain + " Form: " + form + " Issue Type: " + Complaintype +" Attachment: "+ ds.Tables[0].Rows[0]["imgarc_weblink"].ToString() + "";//ds.Tables[0].Rows[0]["complain"].ToString() + "<br> Remarks: " + ds.Tables[0].Rows[0]["mcomp_rmk"].ToString();
                username = ds.Tables[0].Rows[0]["com_jiraeml"].ToString().Trim();
                password = ds.Tables[0].Rows[0]["com_jirapass"].ToString().Trim();

                // Jira objJira = new Jira();
                objJira.Url = url;//"https://mmc-support.atlassian.net/";
                objJira.JsonString = @"{""fields""      :     {
                                    ""project""     :     {
                                    ""key""         :       ""{0}""                                  },
                                    ""summary""     :       ""{1}""                                           ,
                                    ""description"" :       ""{2}""                                       ,
                                    ""issuetype""   :     { 
                                    ""name""        :       ""Task""                                          }}}";

                objJira.JsonString = objJira.JsonString.Replace("{0}", Key);
                objJira.JsonString = objJira.JsonString.Replace("{1}", complainNo);
                objJira.JsonString = objJira.JsonString.Replace("{2}", complainSummary);

                objJira.UserName = username.Trim();//"salman@mmcgbl.com";
                objJira.Password = password.Trim();//"neWCXbgb95MQfKaOOhhG3880";
                objJira.filePaths = new List<string>() { "FILEPATH1", "FILEPATH2" };
                objJira.AddJiraIssue();

            }
        }

        public void updrec(int _mcomp_id, string jira_issuekey, string jira_issueid)
        {
            string str = "";
            str = System.Configuration.ConfigurationManager.ConnectionStrings["IFS_local"].ToString();
            if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }
            cnweb.ConnectionString = str;
            //Master
            cmdweb.Connection = cnweb;
            cmdweb.CommandType = CommandType.Text;
            cmdweb.CommandText = " update t_mcomp set jira_issuekey=@jira_issuekey,jira_issueid=@jira_issueid " +
                                " where mcomp_id = @mcomp_id";
            cmdweb.Parameters.Clear();

            paramweb = cmdweb.Parameters.AddWithValue("@mcomp_id", _mcomp_id);
            paramweb = cmdweb.Parameters.AddWithValue("@jira_issuekey", jira_issuekey);
            paramweb = cmdweb.Parameters.AddWithValue("@jira_issueid", jira_issueid);

            cnweb.Open();
            transweb = cnweb.BeginTransaction();
            cmdweb.Transaction = transweb;
            int i = cmdweb.ExecuteNonQuery();
            if (i > 0)
            {
                transweb.Commit();
                cnweb.Close();
            }
        }
        //Cancelled Start
        [HttpPost]
        [Route("~/Complain/Cancel")]
        public async Task<Object> Cancel([FromBody] dynamic dataResult)
        {
            System.Data.DataTable dttblusrgp_ins = new System.Data.DataTable();
            dttblusrgp_ins.Columns.Add("Id", typeof(string));
            dttblusrgp_ins.Columns.Add("Remarks", typeof(string));
            dttblusrgp_ins.Columns.Add("status", typeof(int));
            var JSONResult = "";

            try
            {
                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {
                    string str = "";
                    int _usr_id = Convert.ToInt32(strusr[1]);
                    string _com_id = strusr[2], _br_id = strusr[3], _m_yr_id = strusr[4], _usr_nam = strusr[4], _com_eml = strusr[7], _br_nam = strusr[8], _br_eml = strusr[9];

                    int _mcomp_id = Convert.ToInt16(dataResult.ID);
                    bool _mcomp_can = Convert.ToBoolean(dataResult.CK_Cancel);
                    string _mcomp_can_rmk = Convert.ToString(dataResult.Remarks);

                    cmdtxt = "select t_mcomp.br_id,br_nam,mcomp_comp_by,mcomp_comp from t_mcomp inner join m_br on t_mcomp.br_id=m_br.br_id where mcomp_id=" + _mcomp_id + "";
                    DataSet dscom = func.dsfunc(cmdtxt);
                    string _br_id_cus = dscom.Tables[0].Rows[0]["br_id"].ToString();
                    string _br_nam_cus = dscom.Tables[0].Rows[0]["br_nam"].ToString();
                    string _mcomp_comp_by = dscom.Tables[0].Rows[0]["mcomp_comp_by"].ToString();
                    string _mcomp_comp = dscom.Tables[0].Rows[0]["mcomp_comp"].ToString();
                    dscom.Dispose();

                    str = System.Configuration.ConfigurationManager.ConnectionStrings["IFS_local"].ToString();
                    if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }
                    cnweb.ConnectionString = str;
                    //Master

                    cmdweb.Connection = cnweb;
                    cmdweb.CommandType = CommandType.Text;
                    cmdweb.CommandText = " update t_mcomp set mcomp_can=@mcomp_can,mcomp_dat_can=@mcomp_dat_can,mcomp_can_rmk=@mcomp_can_rmk,usr_id_ck=@usr_id" +
                                        " where mcomp_id = @mcomp_id";
                    cmdweb.Parameters.Clear();

                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_id", _mcomp_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_can", _mcomp_can);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_dat_can", DateTime.Now);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_can_rmk", _mcomp_can_rmk);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_id", _usr_id);

                    cnweb.Open();
                    transweb = cnweb.BeginTransaction();
                    cmdweb.Transaction = transweb;
                    int i = cmdweb.ExecuteNonQuery();
                    if (i > 0)
                    {

                        transweb.Commit();
                        cnweb.Close();


                        string checkstatus = "";
                        if (_mcomp_can)
                        {
                            checkstatus = "cancelled";
                            string breml = _com_eml + "," + _br_eml;
                            string compbody = "Dear All, <br/>Complain By : " + _mcomp_comp_by + " Complain : " + _mcomp_comp + " has been cancelled";
                            if (_mcomp_can_rmk != "")
                            {
                                compbody = compbody + "<br/>Remarks : " + _mcomp_can_rmk;
                            }
                            compbody = compbody + "<br/><br/>Regards <br/><br/>" + _usr_nam + "<br/>" + _br_nam;
                            func.sendemail(_com_id, _br_id_cus, _br_nam_cus, _mcomp_id, breml, "Ticket # " + _mcomp_id + " " + checkstatus, compbody, "L");
                        }



                        dttblusrgp_ins.Rows.Add(_mcomp_id.ToString(), "Ticket # " + _mcomp_id + " " + checkstatus, 1);
                    }
                }
                else
                {
                    dttblusrgp_ins.Rows.Add("", "Invalid User", 0);
                }
            }
            catch (Exception e)
            {
                if (transweb != null) { transweb.Rollback(); }
                if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }

                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblusrgp_ins.Rows.Add("", "Error : " + e.Message + innerexp, 0);

            }

            JSONResult = JsonConvert.SerializeObject(dttblusrgp_ins);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //Cancelled End

        //Check by Start
        [HttpPost]
        [Route("~/Complain/checkedby")]
        public async Task<Object> checkedby([FromBody] dynamic dataResult)
        {
            System.Data.DataTable dttblusrgp_ins = new System.Data.DataTable();
            dttblusrgp_ins.Columns.Add("Id", typeof(string));
            dttblusrgp_ins.Columns.Add("Remarks", typeof(string));
            dttblusrgp_ins.Columns.Add("status", typeof(int));
            var JSONResult = "";

            try
            {
                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {
                    string str = "";
                    int _usr_id = Convert.ToInt32(strusr[1]);
                    string _com_id = strusr[2], _br_id = strusr[3], _m_yr_id = strusr[4], _usr_nam = strusr[4], _com_eml = strusr[7], _br_nam = strusr[8], _br_eml = strusr[9];

                    int _mcomp_id = Convert.ToInt16(dataResult.ID);
                    bool _mcomp_ck = Convert.ToBoolean(dataResult.CK_Checked);
                    string _mcomp_ck_rmk = Convert.ToString(dataResult.Remarks);


                    cmdtxt = "select t_mcomp.br_id,br_nam,mcomp_comp_by,mcomp_comp from t_mcomp inner join m_br on t_mcomp.br_id=m_br.br_id where mcomp_id=" + _mcomp_id + "";
                    DataSet dscom = func.dsfunc(cmdtxt);
                    string _br_id_cus = dscom.Tables[0].Rows[0]["br_id"].ToString();
                    string _br_nam_cus = dscom.Tables[0].Rows[0]["br_nam"].ToString();
                    string _mcomp_comp_by = dscom.Tables[0].Rows[0]["mcomp_comp_by"].ToString();
                    string _mcomp_comp = dscom.Tables[0].Rows[0]["mcomp_comp"].ToString();
                    dscom.Dispose();


                    str = System.Configuration.ConfigurationManager.ConnectionStrings["IFS_local"].ToString();
                    if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }
                    cnweb.ConnectionString = str;
                    //Master
                    cmdweb.Connection = cnweb;
                    cmdweb.CommandType = CommandType.Text;
                    cmdweb.CommandText = " update t_mcomp set mcomp_ck=@mcomp_ck,mcomp_dat_ck=@mcomp_dat_ck,mcomp_ck_rmk=@mcomp_ck_rmk,usr_id_ck=@usr_id" +
                                        " where mcomp_id = @mcomp_id";
                    cmdweb.Parameters.Clear();

                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_id", _mcomp_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_ck", _mcomp_ck);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_dat_ck", DateTime.Now);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_ck_rmk", _mcomp_ck_rmk);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_id", _usr_id);

                    cnweb.Open();
                    transweb = cnweb.BeginTransaction();
                    cmdweb.Transaction = transweb;
                    int i = cmdweb.ExecuteNonQuery();
                    if (i > 0)
                    {

                        transweb.Commit();
                        cnweb.Close();
                        string checkstatus = "not checked";
                        if (_mcomp_ck)
                        {
                            checkstatus = "Pending for QC";
                            string compbody = "Dear All, <br/>Complain By : " + _mcomp_comp_by + " Complain : " + _mcomp_comp + " Pending for QC";
                            if (_mcomp_ck_rmk != "")
                            {
                                compbody = compbody + "<br/>Remarks : " + _mcomp_ck_rmk;
                            }
                            compbody = compbody + "<br/><br/>Regards <br/><br/>" + _usr_nam + "<br/>" + _br_nam;
                            func.sendemail(_com_id, _br_id_cus, _br_nam_cus, _mcomp_id, _com_eml, "Ticket # " + _mcomp_id + " " + checkstatus, compbody, "C");
                        }


                        dttblusrgp_ins.Rows.Add(_mcomp_id.ToString(), "Ticket # " + _mcomp_id + " Pending for QC " + checkstatus, 1);
                    }
                }
                else
                {
                    dttblusrgp_ins.Rows.Add("", "Invalid User", 0);
                }
            }
            catch (Exception e)
            {
                if (transweb != null) { transweb.Rollback(); }
                if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }

                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblusrgp_ins.Rows.Add("", "Error : " + e.Message + innerexp, 0);

            }

            JSONResult = JsonConvert.SerializeObject(dttblusrgp_ins);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //Check by End

        //QC by Start
        [HttpPost]
        [Route("~/Complain/QCby")]
        public async Task<Object> QCby([FromBody] dynamic dataResult)
        {
            System.Data.DataTable dttblusrgp_ins = new System.Data.DataTable();
            dttblusrgp_ins.Columns.Add("Id", typeof(string));
            dttblusrgp_ins.Columns.Add("Remarks", typeof(string));
            dttblusrgp_ins.Columns.Add("status", typeof(int));
            var JSONResult = "";

            try
            {
                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {
                    string str = "";
                    int _usr_id = Convert.ToInt32(strusr[1]);
                    string _com_id = strusr[2], _br_id = strusr[3], _usr_nam = strusr[4], _com_eml = strusr[7], _br_nam = strusr[8];

                    int _mcomp_id = Convert.ToInt16(dataResult.ID);
                    bool _mcomp_app = Convert.ToBoolean(dataResult.QC_Checked);
                    string _mcomp_app_rmk = Convert.ToString(dataResult.Remarks);

                    cmdtxt = "select t_mcomp.br_id,br_nam,br_eml,mcomp_comp_by,mcomp_comp from t_mcomp inner join m_br on t_mcomp.br_id=m_br.br_id where mcomp_id=" + _mcomp_id + "";
                    DataSet dscom = func.dsfunc(cmdtxt);
                    string _br_id_cus = dscom.Tables[0].Rows[0]["br_id"].ToString();
                    string _br_nam_cus = dscom.Tables[0].Rows[0]["br_nam"].ToString();
                    string _br_eml = dscom.Tables[0].Rows[0]["br_eml"].ToString();
                    string _mcomp_comp_by = dscom.Tables[0].Rows[0]["mcomp_comp_by"].ToString();
                    string _mcomp_comp = dscom.Tables[0].Rows[0]["mcomp_comp"].ToString();
                    dscom.Dispose();



                    str = System.Configuration.ConfigurationManager.ConnectionStrings["IFS_local"].ToString();
                    if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }
                    cnweb.ConnectionString = str;
                    //Master
                    cmdweb.Connection = cnweb;
                    cmdweb.CommandType = CommandType.Text;
                    cmdweb.CommandText = " update t_mcomp set mcomp_app=@mcomp_app,mcomp_dat_app=@mcomp_dat_app,mcomp_app_rmk=@mcomp_app_rmk,usr_id_app=@usr_id" +
                                        " where mcomp_id = @mcomp_id";
                    cmdweb.Parameters.Clear();

                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_id", _mcomp_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_app", _mcomp_app);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_dat_app", DateTime.Now);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_app_rmk", _mcomp_app_rmk);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_id", _usr_id);

                    cnweb.Open();
                    transweb = cnweb.BeginTransaction();
                    cmdweb.Transaction = transweb;
                    int i = cmdweb.ExecuteNonQuery();
                    if (i > 0)
                    {

                        transweb.Commit();
                        cnweb.Close();
                        string checkstatus = "QC not done";
                        if (_mcomp_app)
                        {
                            checkstatus = " pending for Acknowledgment";// "QC done";
                            string breml = _com_eml + "," + _br_eml;
                            string compbody = "Dear All, <br/>Complain By : " + _mcomp_comp_by + " Complain : " + _mcomp_comp + " pending for Acknowledgment";
                            if (_mcomp_app_rmk != "")
                            {
                                compbody = compbody + "<br/>Remarks : " + _mcomp_app_rmk;
                            }
                            compbody = compbody + "<br/><br/>Regards <br/><br/>" + _usr_nam + "<br/>" + _br_nam;
                            func.sendemail(_com_id, _br_id_cus, _br_nam_cus, _mcomp_id, breml, "Ticket # " + _mcomp_id + checkstatus, compbody, "Q");
                        }


                        dttblusrgp_ins.Rows.Add(_mcomp_id.ToString(), "Ticket # " + _mcomp_id + " " + checkstatus, 1);
                    }
                }
                else
                {
                    dttblusrgp_ins.Rows.Add("", "Invalid User", 0);
                }
            }
            catch (Exception e)
            {
                if (transweb != null) { transweb.Rollback(); }
                if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }

                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblusrgp_ins.Rows.Add("", "Error : " + e.Message + innerexp, 0);

            }

            JSONResult = JsonConvert.SerializeObject(dttblusrgp_ins);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //QC by End


        //QC by Start
        [HttpPost]
        [Route("~/Complain/EditIssueType")]
        public async Task<Object> EditIssueType([FromBody] dynamic dataResult)
        {
            System.Data.DataTable dttblusrgp_ins = new System.Data.DataTable();
            dttblusrgp_ins.Columns.Add("Id", typeof(string));
            dttblusrgp_ins.Columns.Add("Remarks", typeof(string));
            dttblusrgp_ins.Columns.Add("status", typeof(int));
            var JSONResult = "";

            try
            {
                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {
                    string str = "";
                    int _usr_id = Convert.ToInt32(strusr[1]);
                    string _com_id = strusr[2], _br_id = strusr[3], _usr_nam = strusr[4], _com_eml = strusr[7], _br_nam = strusr[8];

                    int _mcomp_id = Convert.ToInt16(dataResult.ID);
                    string _mcomp_issuetyp = dataResult.IssueType;


                    //cmdtxt = "select t_mcomp.br_id,br_nam,br_eml,mcomp_comp_by,mcomp_comp from t_mcomp inner join m_br on t_mcomp.br_id=m_br.br_id where mcomp_id=" + _mcomp_id + "";
                    //DataSet dscom = func.dsfunc(cmdtxt);
                    //string _br_id_cus = dscom.Tables[0].Rows[0]["br_id"].ToString();
                    //string _br_nam_cus = dscom.Tables[0].Rows[0]["br_nam"].ToString();
                    //string _br_eml = dscom.Tables[0].Rows[0]["br_eml"].ToString();
                    //string _mcomp_comp_by = dscom.Tables[0].Rows[0]["mcomp_comp_by"].ToString();
                    //string _mcomp_comp = dscom.Tables[0].Rows[0]["mcomp_comp"].ToString();
                    //dscom.Dispose();



                    str = System.Configuration.ConfigurationManager.ConnectionStrings["IFS_local"].ToString();
                    if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }
                    cnweb.ConnectionString = str;
                    //Master
                    cmdweb.Connection = cnweb;
                    cmdweb.CommandType = CommandType.Text;
                    cmdweb.CommandText = " update t_mcomp set mcomp_isstyp=@mcomp_isstyp" +
                                        " where mcomp_id = @mcomp_id";
                    cmdweb.Parameters.Clear();

                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_id", _mcomp_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_isstyp", _mcomp_issuetyp);

                    cnweb.Open();
                    transweb = cnweb.BeginTransaction();
                    cmdweb.Transaction = transweb;
                    int i = cmdweb.ExecuteNonQuery();
                    if (i > 0)
                    {

                        transweb.Commit();
                        cnweb.Close();

                        dttblusrgp_ins.Rows.Add(_mcomp_id.ToString(), "Ticket # " + _mcomp_id + " " + "Edit", 1);
                    }
                }
                else
                {
                    dttblusrgp_ins.Rows.Add("", "Invalid User", 0);
                }
            }
            catch (Exception e)
            {
                if (transweb != null) { transweb.Rollback(); }
                if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }

                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblusrgp_ins.Rows.Add("", "Error : " + e.Message + innerexp, 0);

            }

            JSONResult = JsonConvert.SerializeObject(dttblusrgp_ins);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //QC by End


        //Acknowledge by Start
        [HttpPost]
        [Route("~/Complain/Acknowledgeby")]
        public async Task<Object> Acknowledgeby([FromBody] dynamic dataResult)
        {
            System.Data.DataTable dttblusrgp_ins = new System.Data.DataTable();
            dttblusrgp_ins.Columns.Add("Id", typeof(string));
            dttblusrgp_ins.Columns.Add("Remarks", typeof(string));
            dttblusrgp_ins.Columns.Add("status", typeof(int));
            var JSONResult = "";

            try
            {
                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {
                    string str = "";
                    int _usr_id = Convert.ToInt32(strusr[1]);
                    string _com_id = strusr[2], _br_id = strusr[3], _m_yr_id = strusr[4], _usr_nam = strusr[4], _com_eml = strusr[7], _br_nam = strusr[8], _br_eml = strusr[9];

                    int _mcomp_id = Convert.ToInt16(dataResult.ID);
                    bool _mcomp_act = Convert.ToBoolean(dataResult.CK_Acknowledge);
                    string _mcomp_act_rmk = Convert.ToString(dataResult.Remarks);
                    bool _mcomp_ck = _mcomp_act;

                    cmdtxt = "select mcomp_comp_by,mcomp_comp from t_mcomp where mcomp_id=" + _mcomp_id + "";
                    DataSet dscom = func.dsfunc(cmdtxt);
                    string _mcomp_comp_by = dscom.Tables[0].Rows[0]["mcomp_comp_by"].ToString();
                    string _mcomp_comp = dscom.Tables[0].Rows[0]["mcomp_comp"].ToString();
                    dscom.Dispose();


                    str = System.Configuration.ConfigurationManager.ConnectionStrings["IFS_local"].ToString();
                    if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }
                    cnweb.ConnectionString = str;
                    //Master

                    cmdweb.Connection = cnweb;
                    cmdweb.CommandType = CommandType.Text;
                    cmdweb.CommandText = " update t_mcomp set mcomp_ck=@mcomp_ck,mcomp_app=@mcomp_app,mcomp_act=@mcomp_act,mcomp_dat_act=@mcomp_dat_act,mcomp_act_rmk=@mcomp_act_rmk,usr_id_act=@usr_id" +
                                        " where mcomp_id = @mcomp_id";
                    cmdweb.Parameters.Clear();

                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_id", _mcomp_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_act", _mcomp_act);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_dat_act", DateTime.Now);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_act_rmk", _mcomp_act_rmk);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_ck", _mcomp_ck);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_app", _mcomp_ck);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_id", _usr_id);

                    cnweb.Open();
                    transweb = cnweb.BeginTransaction();
                    cmdweb.Transaction = transweb;
                    int i = cmdweb.ExecuteNonQuery();
                    if (i > 0)
                    {

                        transweb.Commit();
                        cnweb.Close();
                        string checkstatus = "Ackownledgement not done";
                        string checkstr = " revoke for check again";
                        if (_mcomp_act)
                        {
                            checkstatus = "Ackownledgement done";
                            checkstr = "";
                        }

                        string breml = _com_eml + "," + _br_eml;
                        string compbody = "Dear All, <br/>Complain By : " + _mcomp_comp_by + " Complain : " + _mcomp_comp + " " + checkstatus + " " + checkstr;
                        if (_mcomp_act_rmk != "")
                        {
                            compbody = compbody + "<br/>Remarks : " + _mcomp_act_rmk;
                        }
                        compbody = compbody + "<br/><br/>Regards <br/><br/>" + _usr_nam + "<br/>" + _br_nam;
                        func.sendemail(_com_id, _br_id, _br_nam, _mcomp_id, breml, "Ticket # " + _mcomp_id + " " + checkstatus + " " + checkstr, compbody, "D");

                        dttblusrgp_ins.Rows.Add(_mcomp_id.ToString(), "Ticket # " + _mcomp_id + " " + checkstatus, 1);
                    }
                }
                else
                {
                    dttblusrgp_ins.Rows.Add("", "Invalid User", 0);
                }
            }
            catch (Exception e)
            {
                if (transweb != null) { transweb.Rollback(); }
                if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }

                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblusrgp_ins.Rows.Add("", "Error : " + e.Message + innerexp, 0);

            }

            JSONResult = JsonConvert.SerializeObject(dttblusrgp_ins);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //Ackownledge by End

        //Fetch for Fill Index Start
        [HttpPost]
        [Route("~/Complain/FetchComplain/{_status}")]
        public async Task<Object> FetchComplain(string _Status, [FromBody] dynamic dataResult)
        {

            var JSONResult = "";

            System.Data.DataTable dttblgtpsinn_sel = new System.Data.DataTable();
            dttblgtpsinn_sel.Columns.Add("Remarks", typeof(string));
            dttblgtpsinn_sel.Columns.Add("status", typeof(int));
            dttblgtpsinn_sel.Columns.Add("Record_Insert", typeof(bool));
            dttblgtpsinn_sel.Columns.Add("Result_Count", typeof(object));
            dttblgtpsinn_sel.Columns.Add("Result", typeof(object));
            dttblgtpsinn_sel.Columns.Add("Result_Permission", typeof(object));

            try
            {
                string[] strusr = func.checkuser(dataResult);
                string cre = dataResult.Creteria;


                if (Convert.ToBoolean(strusr[0]))
                {
                    string _usr_id = strusr[1], _com_id = strusr[2], _br_id = strusr[3], _m_yr_id = strusr[4];
                    bool _usrckbr = true;// Convert.ToBoolean(strusr[10]);

                    bool per_new = false;
                    bool per_edit = false;
                    bool per_Check = false;
                    bool per_QC = false;
                    bool per_acknowledge = false;
                    bool per_Cancel = false;

                    DataSet dsper = func.checkuserpermission(_usr_id);
                    for (int percnt = 0; percnt < dsper.Tables[0].Rows.Count; percnt++)
                    {
                        if (dsper.Tables[0].Rows[percnt]["usrgp_nam"].ToString() == "Developer")
                        {
                            per_Check = true;
                            per_QC = true;
                            per_Cancel = true;
                            per_edit = true;
                        }
                        if (dsper.Tables[0].Rows[percnt]["usrgp_nam"].ToString() == "Check")
                        {
                            per_Check = true;
                        }
                        if (dsper.Tables[0].Rows[percnt]["usrgp_nam"].ToString() == "QC")
                        {
                            per_QC = true;
                        }
                        if (dsper.Tables[0].Rows[percnt]["usrgp_nam"].ToString() == "USER")
                        {
                            per_new = true;
                            per_acknowledge = true;
                            _usrckbr = false;
                        }
                        if (dsper.Tables[0].Rows[percnt]["usrgp_nam"].ToString() == "Edit")
                        {
                            per_edit = true;
                        }

                    }
                    //Status Start
                    cmdtxt = "SELECT COUNT(CASE WHEN Checked = 'No' and Cancelled = 'No'  THEN 1 END) AS Checked," +
                           " COUNT(CASE WHEN Checked = 'Yes' and QC = 'No' and Cancelled = 'No'  THEN 1 END) AS QC," +
                           " COUNT(CASE WHEN Checked = 'Yes' and QC = 'Yes' and Acknowledge = 'No' and Cancelled = 'No'  THEN 1 END) AS Acknowledge," +
                           " COUNT(CASE WHEN Cancelled = 'Yes'  THEN 1 END) AS Cancel," +
                           " COUNT(CASE WHEN Status = 'Complete'  THEN 1 END) AS Complete," +
                           " COUNT(*) AS All_Record" +
                           " FROM v_rpt_comp_pg where 1 = 1";
                    if (!_usrckbr)
                    {
                        cmdtxt = cmdtxt + " and [Branch_ID]=" + _br_id + "";
                    }
                    DataSet dscount = func.dsfunc(cmdtxt);
                    //Status End

                    //Get Record Start
                    cmdtxt = "select *," +
                        " '" + per_new + "' as [Permission_New]," +
                        " '" + per_edit + "' as [Permission_Edit]," +
                        " '" + per_Check + "' as [Permission_Check]," +
                        " '" + per_QC + "' as [Permission_QC]," +
                        " '" + per_acknowledge + "' as [Permission_Acknowledge]," +
                        " '" + per_Cancel + "' as [Permission_Cancel]" +
                        " from v_rpt_comp_pg where 1=1" + cre;
                    if (!_usrckbr)
                    {
                        cmdtxt = cmdtxt + " and [Branch_ID]=" + _br_id + "";
                    }
                    if (_Status != "0")
                    {
                        cmdtxt = cmdtxt + " and status='" + _Status + "'";
                    }
                    //else if (_Status == "0")
                    //{
                    //    cmdtxt = cmdtxt + " and status!='Complete'";
                    //}
                    cmdtxt = cmdtxt + " order by [DATE] desc,Ticket asc";
                    //Get Record End

                    DataSet dsrmtn = func.dsfunc(cmdtxt);
                    if (dsrmtn.Tables[0].Rows.Count > 0)
                    {
                        dttblgtpsinn_sel.Rows.Add("OK", 1, per_new, dscount.Tables[0], dsrmtn.Tables[0]);
                    }
                    else
                    {
                        dttblgtpsinn_sel.Rows.Add("Record not found", 1, per_new, dscount.Tables[0], null);
                    }
                }
                else
                {
                    dttblgtpsinn_sel.Rows.Add("Invalid User", 0, 0);
                }

            }
            catch (Exception e)
            {
                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblgtpsinn_sel.Rows.Add("Error : " + e.Message + innerexp, 0, 0);
            }
            JSONResult = JsonConvert.SerializeObject(dttblgtpsinn_sel);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //Fetch for Fill Index End

        //Fetch for Fill Index Start
        [HttpPost]
        [Route("~/Complain/FetchComplainAcknowledgement")]
        public async Task<Object> FetchComplainAcknowledgement([FromBody] dynamic dataResult)
        {

            var JSONResult = "";

            System.Data.DataTable dttblgtpsinn_sel = new System.Data.DataTable();
            dttblgtpsinn_sel.Columns.Add("Remarks", typeof(string));
            dttblgtpsinn_sel.Columns.Add("status", typeof(int));
            dttblgtpsinn_sel.Columns.Add("Result", typeof(object));

            try
            {
                string[] strusr = func.checkuser(dataResult);
                string cre = dataResult.Creteria;


                if (Convert.ToBoolean(strusr[0]))
                {
                    string _usr_id = strusr[1], _com_id = strusr[2], _br_id = strusr[3], _m_yr_id = strusr[4];
                    bool _usrckbr = true;// Convert.ToBoolean(strusr[10]);

                    //Status Start
                    cmdtxt = "SELECT COUNT(CASE WHEN Checked = 'Yes' and QC = 'Yes' and Acknowledge = 'No' and Cancelled = 'No'  THEN 1 END) AS Acknowledge " +
                           " FROM v_rpt_comp_pg where [Branch_ID]=" + _br_id + " and Acknowledge_aging>7  and status='Acknowledge'";
                    DataSet dscount = func.dsfunc(cmdtxt);
                    //Status End

                    

                    if (dscount.Tables[0].Rows.Count > 0)
                    {
                        dttblgtpsinn_sel.Rows.Add("OK", 1, dscount.Tables[0]);
                    }
                    else
                    {
                        dttblgtpsinn_sel.Rows.Add("Record not found", 1, dscount.Tables[0]);
                    }
                }
                else
                {
                    dttblgtpsinn_sel.Rows.Add("Invalid User", 0, 0);
                }

            }
            catch (Exception e)
            {
                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblgtpsinn_sel.Rows.Add("Error : " + e.Message + innerexp, 0, 0);
            }
            JSONResult = JsonConvert.SerializeObject(dttblgtpsinn_sel);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }

        //Fetch Record for Edit Start
        [HttpPost]
        [Route("~/Complain/FetchImage/{_mcomp_id}")]
        public async Task<Object> FetchImage(int _mcomp_id, [FromBody] dynamic dataResult)
        {

            var JSONResult = "";

            System.Data.DataTable dttblimg_sel = new System.Data.DataTable();
            dttblimg_sel.Columns.Add("Remarks", typeof(string));
            dttblimg_sel.Columns.Add("status", typeof(int));
            dttblimg_sel.Columns.Add("Result", typeof(object));

            try
            {
                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {
                    string _ImagePath = System.Configuration.ConfigurationManager.AppSettings["ImagePath"].ToString();
                    cmdtxt = "select mcomp_id, imgarc_fileid as [File_ID],imgarc_nam as [File_Name],imgarc_weblink as [Image],imgarc_ext as [File_Extension],Ticket,Date,Complain_By,Complain,Checked_Remarks,QC_Remarks,Acknowledge_Remarks,Cancelled_Remarks,Status from v_rpt_comp_pg inner join t_dcomp_img on v_rpt_comp_pg.ticket=t_dcomp_img.mcomp_id where Ticket= " + _mcomp_id + "";
                    //imgarc_weblink
                    DataSet dsimg = func.dsfunc(cmdtxt);
                    if (dsimg.Tables[0].Rows.Count > 0)
                    {
                        for(int i = 0; i < dsimg.Tables[0].Rows.Count; i++) 
                        {
                            dsimg.Tables[0].Rows[i]["Image"] = _ImagePath +"//"+ dsimg.Tables[0].Rows[i]["mcomp_id"] + "//" + dsimg.Tables[0].Rows[i]["Image"];
                        }


                        dttblimg_sel.Rows.Add("OK", 1, dsimg.Tables[0]);
                        //                    DriveService service = func.GetService();
                        //                    var fileId = dsimg.Tables[0].Rows[0]["File_ID"].ToString();
                        //                    var request = service.Files.Get(fileId);
                        //                    var stream = new System.IO.MemoryStream();

                        //                    request.MediaDownloader.ProgressChanged +=
                        //(IDownloadProgress progress) =>
                        //{
                        //    switch (progress.Status)
                        //    {
                        //        case DownloadStatus.Downloading:
                        //            {
                        //                Console.WriteLine(progress.BytesDownloaded);
                        //                break;
                        //            }
                        //        case DownloadStatus.Completed:
                        //            {
                        //                Console.WriteLine("Download complete.");
                        //                break;
                        //            }
                        //        case DownloadStatus.Failed:
                        //            {
                        //                Console.WriteLine("Download failed.");
                        //                break;
                        //            }
                        //    }
                        //};
                        //                    request.Download(stream);


                        // dsimg.Tables[0].Rows[0]["Image"] = st; 

                        //DriveService service = func.GetService(); //Get google drive service
                        //for (int filecnt = 0; filecnt < dsimg.Tables[0].Rows.Count; filecnt++)
                        //{
                        //    string fileId = dsimg.Tables[0].Rows[filecnt]["Image1"].ToString();
                        //    var file = await service.Files.Get(fileId).ExecuteAsync();
                        //    dsimg.Tables[0].Rows[filecnt]["Image"] = file.WebViewLink;
                        //}
                        //byte[] bindata = (byte[])dsimg.Tables[0].Rows[0]["Image"];
                        //byte[] BinDate = Byte.Parse(dsimg.Tables[0].Rows[0]["Image"]);
                        //var webClient = new WebClient();
                        //byte[] imageBytes = webClient.DownloadData(dsimg.Tables[0].Rows[0]["Image"].ToString());
                        //System.IO.MemoryStream streamBitmap = new System.IO.MemoryStream(imageBytes);
                        //dsimg.Tables[0].Rows[0]["Image"] = streamBitmap;
                        //Stream st;
                        //FilesResource.GetRequest request;
                        //request = service.Files.Get(dsimg.Tables[0].Rows[0]["File_ID"].ToString());
                        //var r1= service.Files.Export(dsimg.Tables[0].Rows[0]["File_ID"].ToString(), dsimg.Tables[0].Rows[0]["File_Extension"].ToString());
                        //dsimg.Tables[0].Rows[0]["Image"] = request.ExecuteAsStream();


                        ////request.Fields = "id,webViewLink,size";
                        ////request.Fields = "*";
                        ////request.Upload();

                        ////string someUrl = dsimg.Tables[0].Rows[0]["Image"].ToString();
                        ////using (var webClient = new WebClient())
                        ////{
                        ////    byte[] imageBytes = webClient.DownloadData(someUrl);
                        ////    System.IO.MemoryStream streamBitmap = new System.IO.MemoryStream(imageBytes);
                        ////    dsimg.Tables[0].Rows[0]["Image"] = streamBitmap;
                        ////}
                        //Download Start
                        //request.Download(stream);
                        //dsimg.Tables[0].Rows[filecnt]["Image"] = stream;
                        //string FileName = request.Execute().Name;
                        //string FilePath = Path.Combine(HttpContext.Current.Server.MapPath("~/Downloads"), FileName);

                        //MemoryStream stream = new MemoryStream();

                        //request.MediaDownloader.ProgressChanged += (Google.Apis.Download.IDownloadProgress progress) =>
                        //{
                        //    switch (progress.Status)
                        //    {
                        //        case DownloadStatus.Downloading:
                        //            {
                        //                Console.WriteLine(progress.BytesDownloaded);
                        //                break;
                        //            }
                        //        case DownloadStatus.Completed:
                        //            {
                        //                Console.WriteLine("Download complete.");
                        //                SaveStream(stream, FilePath); //Save the file 
                        //                break;
                        //            }
                        //        case DownloadStatus.Failed:
                        //            {
                        //                Console.WriteLine("Download failed.");
                        //                break;
                        //            }
                        //    }
                        //    //Download End
                        //}
                        //};
                        //Byte[] bitmapData = Convert.FromBase64String(sbText.ToString());
                        //System.IO.MemoryStream streamBitmap = new System.IO.MemoryStream(bitmapData);
                        //Stream myStream = streamBitmap;


                        //                            request.Download(stream);
                        //}
                        //dttblimg_sel.Rows.Add("OK", 1, dsimg.Tables[0]);
                    }
                    else
                    {
                        dttblimg_sel.Rows.Add("Record not found", 0);
                    }
                }
                else
                {
                    dttblimg_sel.Rows.Add("Invalid User", 0, null);
                }

            }
            catch (Exception e)
            {
                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblimg_sel.Rows.Add("Error : " + e.Message + innerexp, 0, null);
            }
            JSONResult = JsonConvert.SerializeObject(dttblimg_sel);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //Fetch Record for Edit End

        //Fetch for Fill Index Start
        [HttpPost]
        [Route("~/Complain/FetchEditComplain/{_mcomp_id}")]
        public async Task<Object> FetchEditComplain(int _mcomp_id, [FromBody] dynamic dataResult)
        {

            var JSONResult = "";

            System.Data.DataTable dttblpo = new System.Data.DataTable();
            dttblpo.Columns.Add("Remarks", typeof(string));
            dttblpo.Columns.Add("status", typeof(int));
            dttblpo.Columns.Add("Result", typeof(object));

            try
            {
                string[] strusr = func.checkuser(dataResult);
                string Menu = dataResult.Menu;
                string cre = dataResult.Creteria;

                if (Convert.ToBoolean(strusr[0]))
                {
                    string _com_id = strusr[2], _br_id = strusr[3], _m_yr_id = strusr[4];
                    bool _usrckbr = Convert.ToBoolean(strusr[10]);

                    cmdtxt = "select Ticket,Date,Complain_By,Complain,Checked_Remarks,QC_Remarks,Acknowledge_Remarks,Cancelled_Remarks,Status from v_rpt_comp_pg where Ticket=" + _mcomp_id + "";


                    DataSet dsuser = func.dsfunc(cmdtxt);
                    if (dsuser.Tables[0].Rows.Count > 0)
                    {
                        dttblpo.Rows.Add("OK", 1, dsuser.Tables[0]);
                    }
                    else
                    {
                        dttblpo.Rows.Add("Record not found", 0, null);
                    }
                }
                else
                {
                    dttblpo.Rows.Add("Invalid User", 0, null);
                }

            }
            catch (Exception e)
            {
                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblpo.Rows.Add("Error : " + e.Message + innerexp, 0, null);
            }
            JSONResult = JsonConvert.SerializeObject(dttblpo);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //Fetch for Fill Index End


        //save datails start
        private int savedetail(int _mcomp_id, dynamic _dataResult)
        {



            int cksav = 0;
            int _dcomp_img_id = func.pkid("t_dcomp_img", "dcomp_img_id");



            //Insert Start
            var _dcomp_img_str = _dataResult.Detail.ToString();
            string[] _dgpinn = _dcomp_img_str.Split('|');
            int _dcomp_img_cnt = 0, _att_cnt = 0;
            if (_dcomp_img_str != "")
            {
                //Detail Start
                for (_dcomp_img_cnt = 0; _dcomp_img_cnt < _dgpinn.Length; _dcomp_img_cnt++)
                {
                    _att_cnt++;
                    string _imgarc_nam = _dgpinn[_dcomp_img_cnt];
                    _dcomp_img_cnt++;
                    string _imgarc_img_byt = _dgpinn[_dcomp_img_cnt];
                    _dcomp_img_cnt++;
                    string _imgarc_ext = _dgpinn[_dcomp_img_cnt];
                    string[] _ext = _imgarc_ext.Split('/');
                    //                    string _dcomp_img_file = "Ticket # " + _mcomp_id.ToString() + "-" + _att_cnt.ToString();


                    ////Google Drive Start
                    ////https://docs.google.com/presentation/u/4/d/1lG8aur8oK-dePzt8NRlFzjSYOsnEG4frCuUQ7fdirYE/htmlpresent
                    ////https://qawithexperts.com/article/asp-net/upload-file-to-google-drive-using-google-drive-api-in-aspnet/236
                    //System.Text.StringBuilder sbText = new System.Text.StringBuilder(_imgarc_img_byt, _imgarc_img_byt.Length);
                    //sbText.Replace("\r\n", string.Empty); sbText.Replace(" ", string.Empty);
                    //string imgarc_ext = _imgarc_ext;
                    //Byte[] bitmapData = Convert.FromBase64String(sbText.ToString());
                    //System.IO.MemoryStream streamBitmap = new System.IO.MemoryStream(bitmapData);
                    //Stream myStream = streamBitmap;
                    //DriveService service = func.GetService();


                    //var FileMetaData = new Google.Apis.Drive.v3.Data.File();
                    //FileMetaData.Name = _dcomp_img_file;
                    //FileMetaData.Parents = new List<string> { "1_CRIhCI75-VecuwazYOx7I6d1-d9zK6M" };
                    //FilesResource.CreateMediaUpload request;
                    //request = service.Files.Create(FileMetaData, myStream, imgarc_ext);
                    ////request.Fields = "id,webViewLink,size";
                    //request.Fields = "*";
                    //request.Upload();
                    ////Google Drive End
                    ///
                    string imgarc_ext = _ext.Length > 0 ? "." + _imgarc_ext.Split('/')[1] : ".png";
                    string _dcomp_img_file = _mcomp_id.ToString() + "-" + _att_cnt.ToString()+ imgarc_ext;

                    string filepath = System.Web.Hosting.HostingEnvironment.MapPath("~\\Attachments\\" + _mcomp_id);
                    if (!Directory.Exists(filepath)) { Directory.CreateDirectory(filepath); }
                    _imgarc_nam = _imgarc_nam.Replace(" ", String.Empty);
                    string fullOutputPath = filepath +"\\"+ _imgarc_nam;// _dcomp_img_file;
                    System.Text.StringBuilder sbText = new System.Text.StringBuilder(_imgarc_img_byt, _imgarc_img_byt.Length);
                    sbText.Replace("\r\n", string.Empty); sbText.Replace(" ", string.Empty);
                    Byte[] bitmapData = Convert.FromBase64String(sbText.ToString());

                    //Image image;
                    //using (MemoryStream ms = new MemoryStream(bitmapData))
                    //{
                    //    image = Image.FromStream(ms);
                    //}

                    //image.Save(fullOutputPath, System.Drawing.Imaging.ImageFormat.Png);

                    string filePath = fullOutputPath;
                    System.IO.File.WriteAllBytes(filePath, Convert.FromBase64String(sbText.ToString()));

                    FileInfo fi = new FileInfo(filePath);

                    //Detail Insert  Start
                    cmdweb.CommandType = CommandType.Text;
                    cmdweb.CommandText = " insert into t_dcomp_img(dcomp_img_id,dcomp_img_file,mcomp_id,imgarc_nam,imgarc_ext,imgarc_fileid,imgarc_weblink,imgarc_filesize)" +
                                                        " values(@dcomp_img_id, @dcomp_img_file, @mcomp_id,@imgarc_nam,@imgarc_ext,@imgarc_fileid,@imgarc_weblink,@imgarc_filesize)";
                    cmdweb.Parameters.Clear();

                    paramweb = cmdweb.Parameters.AddWithValue("@dcomp_img_id", _dcomp_img_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@dcomp_img_file", _dcomp_img_file);
                    paramweb = cmdweb.Parameters.AddWithValue("@mcomp_id", _mcomp_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@imgarc_nam", _imgarc_nam);
                    //paramweb = cmdweb.Parameters.AddWithValue("@imgarc_fileid", request.ResponseBody.Id);
                    //paramweb = cmdweb.Parameters.AddWithValue("@imgarc_weblink", request.ResponseBody.WebViewLink);
                    //paramweb = cmdweb.Parameters.AddWithValue("@imgarc_filesize", request.ResponseBody.Size);
                    paramweb = cmdweb.Parameters.AddWithValue("@imgarc_fileid",0);
                    paramweb = cmdweb.Parameters.AddWithValue("@imgarc_weblink", _imgarc_nam);
                    paramweb = cmdweb.Parameters.AddWithValue("@imgarc_filesize", fi.Length);
                    paramweb = cmdweb.Parameters.AddWithValue("@imgarc_ext", imgarc_ext);


                    cksav = cmdweb.ExecuteNonQuery();
                    _dcomp_img_id += 1;
                    //Detail Insert  End
                }
                //Detail End

                cmdweb.CommandType = CommandType.Text;
                cmdweb.CommandText = "update t_mcomp set mcomp_att=@mcomp_att where mcomp_id=@mcomp_id";
                cmdweb.Parameters.Clear();
                paramweb = cmdweb.Parameters.AddWithValue("@mcomp_id", _mcomp_id);
                paramweb = cmdweb.Parameters.AddWithValue("@mcomp_att", _att_cnt);
                cmdweb.ExecuteNonQuery();
            }
            //Insert End
            return cksav;

        }
        // save datails end


        ////Bulk Google Upload Files Start
        //[HttpPost]
        //[Route("~/Complain/DriveGoogleUpload")]
        //public async Task<Object> DriveGoogleUpload([FromBody] dynamic dataResult)
        //{

        //    var JSONResult = "";

        //    System.Data.DataTable dttblpo = new System.Data.DataTable();
        //    dttblpo.Columns.Add("Remarks", typeof(string));
        //    dttblpo.Columns.Add("status", typeof(int));
        //    dttblpo.Columns.Add("Result", typeof(object));

        //    try
        //    {
        //        string[] strusr = func.checkuser(dataResult);
        //        string Menu = dataResult.Menu;
        //        string cre = dataResult.Creteria;

        //        if (Convert.ToBoolean(strusr[0]))
        //        {
        //            cmdtxt = "select dcomp_img_id,dcomp_img_file,imgarc_nam,imgarc_img_byt,imgarc_ext from t_mcomp inner join t_dcomp_img on t_mcomp.mcomp_id= t_dcomp_img.mcomp_id where mcomp_dat between '2016-01-01' and '2016-12-31' and imgarc_img_byt is not null and imgarc_fileid is null order by t_mcomp.mcomp_id";
        //            DataSet dsimg = new DataSet();
        //            dsimg = func.dsfunc(cmdtxt);
        //            if (dsimg.Tables[0].Rows.Count > 0)
        //            {
        //                DriveService service = func.GetService();
        //                //Detail Start
        //                for (int _dcomp_img_cnt = 0; _dcomp_img_cnt < dsimg.Tables[0].Rows.Count; _dcomp_img_cnt++)
        //                {
        //                    string _imgarc_img_byt = dsimg.Tables[0].Rows[_dcomp_img_cnt]["imgarc_img_byt"].ToString();

        //                    System.Text.StringBuilder sbText = new System.Text.StringBuilder(_imgarc_img_byt, _imgarc_img_byt.Length);
        //                    sbText.Replace("\r\n", string.Empty); sbText.Replace(" ", string.Empty);
        //                    string imgarc_ext = dsimg.Tables[0].Rows[_dcomp_img_cnt]["imgarc_ext"].ToString();
        //                    Byte[] bitmapData = Convert.FromBase64String(sbText.ToString());
        //                    System.IO.MemoryStream streamBitmap = new System.IO.MemoryStream(bitmapData);
        //                    Stream myStream = streamBitmap;




        //                    var FileMetaData = new Google.Apis.Drive.v3.Data.File();
        //                    FileMetaData.Name = dsimg.Tables[0].Rows[_dcomp_img_cnt]["dcomp_img_file"].ToString();
        //                    FileMetaData.Parents = new List<string> { "1_CRIhCI75-VecuwazYOx7I6d1-d9zK6M" };
        //                    FilesResource.CreateMediaUpload request;
        //                    request = service.Files.Create(FileMetaData, myStream, imgarc_ext);
        //                    request.Fields = "id,webViewLink,size";
        //                    request.Upload();
        //                    //Google Drive End


        //                    //Detail Insert  Start
        //                    string str = System.Configuration.ConfigurationManager.ConnectionStrings["IFS_local"].ToString();
        //                    if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }
        //                    cnweb.ConnectionString = str;
        //                    cmdweb.Connection = cnweb;

        //                    cnweb.Open();
        //                    transweb = cnweb.BeginTransaction();
        //                    cmdweb.Transaction = transweb;
        //                    cmdweb.CommandType = CommandType.Text;
        //                    cmdweb.CommandText = " update t_dcomp_img set imgarc_fileid=@imgarc_fileid,imgarc_weblink=@imgarc_weblink,imgarc_filesize=@imgarc_filesize where dcomp_img_id=@dcomp_img_id";
        //                    cmdweb.Parameters.Clear();

        //                    paramweb = cmdweb.Parameters.AddWithValue("@dcomp_img_id", dsimg.Tables[0].Rows[_dcomp_img_cnt]["dcomp_img_id"].ToString());
        //                    paramweb = cmdweb.Parameters.AddWithValue("@imgarc_fileid", request.ResponseBody.Id);
        //                    paramweb = cmdweb.Parameters.AddWithValue("@imgarc_weblink", request.ResponseBody.WebViewLink);
        //                    paramweb = cmdweb.Parameters.AddWithValue("@imgarc_filesize", request.ResponseBody.Size);
        //                    cmdweb.ExecuteNonQuery();
        //                    transweb.Commit();
        //                    cnweb.Close();

        //                }
        //            }

        //            dttblpo.Rows.Add("OK", 1, "File Upload");
        //        }
        //        else
        //        {
        //            dttblpo.Rows.Add("Invalid User", 0, null);
        //        }

        //    }
        //    catch (Exception e)
        //    {
        //        string innerexp = "";
        //        if (e.InnerException != null)
        //        {
        //            innerexp = " Inner Error : " + e.InnerException.ToString();
        //        }
        //        dttblpo.Rows.Add("Error : " + e.Message + innerexp, 0, null);
        //    }
        //    JSONResult = JsonConvert.SerializeObject(dttblpo);
        //    return JsonConvert.DeserializeObject<object>(JSONResult);
        //}
        ////Bulk Google Upload Files End

        //private void bulkuploadgdrive()
        //{
        //    cmdtxt = "select dcomp_img_id,dcomp_img_file,imgarc_nam,imgarc_img_byt,imgarc_ext from t_mcomp inner join t_dcomp_img on t_mcomp.mcomp_id= t_dcomp_img.mcomp_id where mcomp_dat>='2020-01-01' and imgarc_img_byt is not null and imgarc_fileid is null order by t_mcomp.mcomp_id";
        //    DataSet dsimg = new DataSet();
        //    dsimg = func.dsfunc(cmdtxt);
        //    if (dsimg.Tables[0].Rows.Count > 0)
        //    {

        //        //Detail Start
        //        for (int _dcomp_img_cnt = 0; _dcomp_img_cnt < dsimg.Tables[0].Rows.Count, _dcomp_img_cnt++)
        //        {
        //            string _imgarc_img_byt = dsimg.Tables[0].Rows[_dcomp_img_cnt]["imgarc_img_byt"].ToString();

        //            System.Text.StringBuilder sbText = new System.Text.StringBuilder(_imgarc_img_byt, _imgarc_img_byt.Length);
        //            sbText.Replace("\r\n", string.Empty); sbText.Replace(" ", string.Empty);
        //            string imgarc_ext = dsimg.Tables[0].Rows[_dcomp_img_cnt]["imgarc_ext"].ToString();
        //            Byte[] bitmapData = Convert.FromBase64String(sbText.ToString());
        //            System.IO.MemoryStream streamBitmap = new System.IO.MemoryStream(bitmapData);
        //            Stream myStream = streamBitmap;
        //            DriveService service = func.GetService();



        //            var FileMetaData = new Google.Apis.Drive.v3.Data.File();
        //            FileMetaData.Name = dsimg.Tables[0].Rows[_dcomp_img_cnt]["dcomp_img_file"].ToString(); ;
        //            FileMetaData.Parents = new List<string> { "1_CRIhCI75-VecuwazYOx7I6d1-d9zK6M" };
        //            FilesResource.CreateMediaUpload request;
        //            request = service.Files.Create(FileMetaData, myStream, imgarc_ext);
        //            request.Fields = "id,webViewLink,size";
        //            request.Upload();
        //            //Google Drive End


        //            //Detail Insert  Start
        //            cmdweb.CommandType = CommandType.Text;
        //            cmdweb.CommandText = " update t_dcomp_img set imgarc_fileid=@imgarc_fileid,imgarc_weblink=@imgarc_weblink,imgarc_filesize=@imgarc_filesize where dcomp_img_id=@dcomp_img_id";
        //            cmdweb.Parameters.Clear();

        //            paramweb = cmdweb.Parameters.AddWithValue("@dcomp_img_id", dsimg.Tables[0].Rows[_dcomp_img_cnt]["dcomp_img_id"].ToString());
        //            paramweb = cmdweb.Parameters.AddWithValue("@imgarc_fileid", request.ResponseBody.Id);
        //            paramweb = cmdweb.Parameters.AddWithValue("@imgarc_weblink", request.ResponseBody.WebViewLink);
        //            paramweb = cmdweb.Parameters.AddWithValue("@imgarc_filesize", request.ResponseBody.Size);
        //            cmdweb.ExecuteNonQuery();
        //        }
        //    }
        //}
    }
}
