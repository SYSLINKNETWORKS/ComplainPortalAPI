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
    public class BranchController : ApiController
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
        [Route("~/System_Setup/Branch/create")]
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
                    string _br_nam = Convert.ToString(dataResult.Name);
                    string _br_add = Convert.ToString(dataResult.Address);
                    string _br_pho = Convert.ToString(dataResult.Phone);
                    string _br_mob = Convert.ToString(dataResult.Mobile);
                    string _br_fax = Convert.ToString(dataResult.Fax);
                    string _br_eml = Convert.ToString(dataResult.Email);
                    string _br_web = Convert.ToString(dataResult.Web);
                    string _com_id = Convert.ToString(dataResult.Company_ID);

                    string _usr_id = strusr[1];

                    //Master
                    string _br_id = func.pkid("m_br", "br_id").ToString();
                    if (_br_id.Length == 1) { _br_id = "0" + _br_id; }

                    cmdweb.Connection = func.con();
                    cmdweb.CommandType = CommandType.Text;

                    cmdweb.CommandText = "insert into m_br" +
                                         " (br_id,br_nam,br_add,br_pho,br_mob,br_fax,br_eml,br_web,com_id,br_typ,usr_id_ins,ins_Dat)" +
                                         " values" +
                                         " (@br_id,@br_nam,@br_add,@br_pho,@br_mob,@br_fax,@br_eml,@br_web,@com_id,@br_typ,@usr_id_ins,@ins_Dat)";

                    cmdweb.Parameters.Clear();

                    paramweb = cmdweb.Parameters.AddWithValue("@br_id", _br_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_nam", _br_nam);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_add", _br_add);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_pho", _br_pho);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_mob", _br_mob);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_fax", _br_fax);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_eml", _br_eml);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_web", _br_web);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_typ", 'U');
                    paramweb = cmdweb.Parameters.AddWithValue("@com_id", _com_id);
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
                        dttblusrgp_ins.Rows.Add(_br_id.ToString(), "Record # " + _br_id + " Saved", 1);
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
        [Route("~/System_Setup/Branch/edit")]
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
                    string _br_id = Convert.ToString(dataResult.ID);
                    string _br_nam = Convert.ToString(dataResult.Name);
                    string _br_add = Convert.ToString(dataResult.Address);
                    string _br_pho = Convert.ToString(dataResult.Phone);
                    string _br_mob = Convert.ToString(dataResult.Mobile);
                    string _br_fax = Convert.ToString(dataResult.Fax);
                    string _br_eml = Convert.ToString(dataResult.Email);
                    string _br_web = Convert.ToString(dataResult.Web);
                    string _com_id = Convert.ToString(dataResult.Company_ID);

                    string _usr_id = strusr[1];

                    //Master

                    cmdweb.Connection = func.con();
                    cmdweb.CommandType = CommandType.Text;
                    cmdweb.CommandText = "update m_br set br_nam=@br_nam,br_add=@br_add,br_pho=@br_pho,br_mob=@br_mob,br_fax=@br_fax,br_eml=@br_eml,br_web=@br_web,com_id=@com_id,br_typ=@br_typ," +
                                         " usr_id_upd=@usr_id_upd,upd_dat=@upd_Dat" +
                                         " where br_id=@br_id";

                    cmdweb.Parameters.Clear();

                    paramweb = cmdweb.Parameters.AddWithValue("@br_id", _br_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_nam", _br_nam);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_add", _br_add);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_pho", _br_pho);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_mob", _br_mob);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_fax", _br_fax);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_eml", _br_eml);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_web", _br_web);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_typ", 'U');
                    paramweb = cmdweb.Parameters.AddWithValue("@com_id", _com_id);
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
                        dttblusrgp_ins.Rows.Add(_br_id.ToString(), "Record # " + _br_id + " Updated", 1);
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
        [Route("~/System_Setup/Branch/delete/{_br_id}")]
        public async Task<Object> delete(string _br_id, [FromBody] dynamic dataResult)
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
                    cmdweb.CommandText = "delete from m_br where br_id=@br_id";

                    cmdweb.Parameters.Clear();

                    paramweb = cmdweb.Parameters.AddWithValue("@br_id", _br_id);

                    func.cn.Open();
                    transweb = func.cn.BeginTransaction();
                    cmdweb.Transaction = transweb;
                    int i = cmdweb.ExecuteNonQuery();
                    if (i > 0)
                    {
                        transweb.Commit();
                        cnweb.Close();
                        dttblusrgp_ins.Rows.Add(_br_id.ToString(), "Record # " + _br_id + " Deleted", 1);
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
        [Route("~/System_Setup/Branch/GetBranch")]
        public async Task<Object> GetBranch([FromBody] dynamic dataResult)
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
                    string _m_yr_id = strusr[4];

                    cmdtxt = "select br_id as [ID],m_com.com_nam as [Company],br_nam as [Name],br_add as [Address]," +
                             " br_pho as [Phone],br_mob as [Mobile],br_fax as [Fax],br_eml as [Email],br_web as [WebSite]," +
                             " m_br.com_id as [Company ID]" +
                             " from m_br" +
                             " inner join m_com on m_com.com_id=m_br.com_id";

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
        [Route("~/System_Setup/Branch/FetchEditBranch/{_br_id}")]
        public async Task<Object> FetchEditBranch(string _br_id, [FromBody] dynamic dataResult)
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

                    cmdtxt = "select br_id as [ID],m_com.com_nam as [Company],br_nam as [Name],br_add as [Address]," +
                             " br_pho as [Phone],br_mob as [Mobile],br_fax as [Fax],br_eml as [Email],br_web as [WebSite]," +
                             " m_br.com_id as [Company ID]" +
                             " from m_br" +
                             " inner join m_com on m_com.com_id=m_br.com_id" +
                             " where m_br.br_id='" + _br_id + "'";



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
