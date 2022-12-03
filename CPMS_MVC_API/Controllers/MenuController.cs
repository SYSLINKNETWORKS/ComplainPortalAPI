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


namespace CPMS_MVC_API.Controllers.Menu
{
    public class MenuController : ApiController
    {
        SqlDataAdapter daweb = new SqlDataAdapter();
        SqlCommand cmdweb = new SqlCommand();
        SqlConnection cnweb = new SqlConnection();
        SqlTransaction transweb = null;
        SqlParameter paramweb = new SqlParameter();
        Functions func = new Functions();
        string cmdtxt = "";
        //Fetch Chart of Account Details Record
        [HttpPost]
        [Route("~/Menu/FetchMenu")]
        public async Task<Object> FetchMenu([FromBody] dynamic dataResult)
        {

            var JSONResult = "";
            System.Data.DataTable dttblusergp = new System.Data.DataTable();
            dttblusergp.Columns.Add("Remarks", typeof(string));
            dttblusergp.Columns.Add("status", typeof(int));
            dttblusergp.Columns.Add("Result_Information", typeof(object));
            DataSet ds_menu = new DataSet();
            try
            {

                string[] strusr = func.checkuser(dataResult);
                string menid = dataResult.menid;

                if (Convert.ToBoolean(strusr[0]))
                {
                    DataTable dtinfo = new DataTable();
                    dtinfo.Columns.Add("Company_Name", typeof(string));
                    dtinfo.Columns.Add("Branch_ID", typeof(string));
                    dtinfo.Columns.Add("Branch_Name", typeof(string));
                    dtinfo.Columns.Add("User_Name", typeof(string));
                    dtinfo.Columns.Add("User_Admin", typeof(string));
                    dtinfo.Columns.Add("Version", typeof(string));

                    dtinfo.Rows.Add(strusr[6], strusr[3].Trim(), strusr[8], strusr[4], strusr[11], typeof(CPMS_MVC_API.WebApiApplication).Assembly.GetName().Version.ToString());
                    dttblusergp.Rows.Add("OK", 1, dtinfo);
                }
                else
                {
                    dttblusergp.Rows.Add("Invalid User", 0);
                }

            }
            catch (Exception e)
            {
                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblusergp.Rows.Add("Error : " + e.Message + innerexp, 0);
            }
            JSONResult = JsonConvert.SerializeObject(dttblusergp);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
    }
}
