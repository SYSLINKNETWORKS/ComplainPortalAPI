using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Data;
using System.Data.SqlClient;
using CPMS_MVC_API.BLogic;
using Newtonsoft.Json;
using System.Threading.Tasks;

namespace CPMS_MVC_API.Controllers.System_Setup
{
    public class CompanyController : ApiController
    {
        SqlDataAdapter daweb = new SqlDataAdapter();
        SqlCommand cmdweb = new SqlCommand();
        SqlConnection cnweb = new SqlConnection();
        SqlTransaction transweb = null;
        SqlParameter paramweb = new SqlParameter();
        Functions func = new Functions();
        DataSet dsweb = new DataSet();
        string cmdtxt = "";


        //Create Start
        [HttpPost]
        [Route("~/System_Setup/Company/create")]
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
                    string _com_nam = Convert.ToString(dataResult.Name);
                    string _com_snm = Convert.ToString(dataResult.Short_Name);
                    string _com_eml = Convert.ToString(dataResult.Email);

                    string _usr_id = strusr[1];

                    //Master
                    string _com_id = func.pkid("m_com", "com_id").ToString();
                    if (_com_id.Length == 1) { _com_id = "0" + _com_id; }

                    cmdweb.Connection = func.con();
                    cmdweb.CommandType = CommandType.Text;

                    cmdweb.CommandText = "insert into m_com" +
                                         " (com_id,com_nam,com_snm,com_eml,usr_id_ins,ins_Dat)" +
                                         " values" +
                                         " (@com_id,@com_nam,@com_snm,@com_eml,@usr_id_ins,@ins_Dat)";

                    cmdweb.Parameters.Clear();

                    paramweb = cmdweb.Parameters.AddWithValue("@com_id", _com_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@com_nam", _com_nam);
                    paramweb = cmdweb.Parameters.AddWithValue("@com_snm", _com_snm);
                    paramweb = cmdweb.Parameters.AddWithValue("@com_eml", _com_eml);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_id_ins", _usr_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@ins_Dat", DateTime.Now);


                    func.cn.Open();
                    transweb = func.cn.BeginTransaction();
                    cmdweb.Transaction = transweb;
                    int i = cmdweb.ExecuteNonQuery();
                    if (i > 0)
                    {
                        transweb.Commit();
                        cnweb.Close();
                        dttblusrgp_ins.Rows.Add(_com_id.ToString(), "Record # " + _com_id + " Saved", 1);
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
        //Create End


        //Edit Start
        [HttpPost]
        [Route("~/System_Setup/Company/edit")]
        public async Task<Object> edit([FromBody] dynamic dataResult)
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
                    string _com_id = Convert.ToString(dataResult.ID);
                    string _com_nam = Convert.ToString(dataResult.Name);
                    string _com_snm = Convert.ToString(dataResult.Short_Name);
                    string _com_eml = Convert.ToString(dataResult.Email);

                    string _usr_id = strusr[1];

                    //Master

                    cmdweb.Connection = func.con();
                    cmdweb.CommandType = CommandType.Text;
                    cmdweb.CommandText = "update m_com set com_nam=@com_nam,com_snm=@com_snm,com_eml=@com_eml," +
                                         " usr_id_upd=@usr_id_upd,upd_dat=@upd_Dat" +
                                         " where com_id=@com_id";

                    cmdweb.Parameters.Clear();

                    paramweb = cmdweb.Parameters.AddWithValue("@com_id", _com_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@com_nam", _com_nam);
                    paramweb = cmdweb.Parameters.AddWithValue("@com_snm", _com_snm);
                    paramweb = cmdweb.Parameters.AddWithValue("@com_eml", _com_eml);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_id_upd", _usr_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@upd_Dat", DateTime.Now);



                    func.cn.Open();
                    transweb = func.cn.BeginTransaction();
                    cmdweb.Transaction = transweb;
                    int i = cmdweb.ExecuteNonQuery();
                    if (i > 0)
                    {
                        transweb.Commit();
                        cnweb.Close();
                        dttblusrgp_ins.Rows.Add(_com_id.ToString(), "Record # " + _com_id + " Updated", 1);
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
        //Edit End


        //Edit Start
        [HttpPost]
        [Route("~/System_Setup/Company/delete/{_com_id}")]
        public async Task<Object> delete(string _com_id, [FromBody] dynamic dataResult)
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

                    //Master

                    cmdweb.Connection = func.con();
                    cmdweb.CommandType = CommandType.Text;
                    cmdweb.CommandText = "delete from m_com where com_id=@com_id";

                    cmdweb.Parameters.Clear();

                    paramweb = cmdweb.Parameters.AddWithValue("@com_id", _com_id);

                    func.cn.Open();
                    transweb = func.cn.BeginTransaction();
                    cmdweb.Transaction = transweb;
                    int i = cmdweb.ExecuteNonQuery();
                    if (i > 0)
                    {
                        transweb.Commit();
                        cnweb.Close();
                        dttblusrgp_ins.Rows.Add(_com_id.ToString(), "Record # " + _com_id + " Deleted", 1);
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
        //Delete End



        //Fetch User for Fill Index Start
        [HttpPost]
        [Route("~/System_Setup/Company/GetCompany")]
        public async Task<Object> GetCompany([FromBody] dynamic dataResult)
        {

            var JSONResult = "";

            System.Data.DataTable dttblgrn_sel = new System.Data.DataTable();
            dttblgrn_sel.Columns.Add("Remarks", typeof(string));
            dttblgrn_sel.Columns.Add("status", typeof(int));
            dttblgrn_sel.Columns.Add("Result", typeof(object));

            try
            {
                string[] strusr = func.checkuser(dataResult);
                string Menu = dataResult.Menu;
                if (Convert.ToBoolean(strusr[0]))
                {
                    string _usr_id = strusr[1];

                    cmdtxt = "select com_id as [ID],com_nam as [Name],rtrim(com_snm) as [Short_Name],com_eml as [Email]" +
                             " from m_com order by com_nam";

                    DataSet dsgrn = func.dsfunc(cmdtxt);
                    if (dsgrn.Tables[0].Rows.Count > 0)
                    {
                        dttblgrn_sel.Rows.Add("OK", 1, dsgrn.Tables[0]);
                    }
                    else
                    {
                        dttblgrn_sel.Rows.Add("Record not found", 3);
                    }
                }
                else
                {
                    dttblgrn_sel.Rows.Add("Invalid User", 2);
                }

            }
            catch (Exception e)
            {
                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblgrn_sel.Rows.Add("Error : " + e.Message + innerexp, 0);
            }
            JSONResult = JsonConvert.SerializeObject(dttblgrn_sel);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //Fetch User for Fill Index Eend

        //Fetch Record for Edit Start
        [HttpPost]
        [Route("~/System_Setup/Company/FetchEditCompany/{_com_id}")]
        public async Task<Object> FetchEditCompany(string _com_id, [FromBody] dynamic dataResult)
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
                if (Convert.ToBoolean(strusr[0]))
                {
                    string _m_yr_id = strusr[4];

                    cmdtxt = "select com_id as [ID],com_nam as [Name],rtrim(com_snm) as [Short_Name],com_eml as [Email]" +
                             " from m_com" +
                             " where com_id='" + _com_id + "'";



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
        //Fetch Record for Edit End
    }
}
