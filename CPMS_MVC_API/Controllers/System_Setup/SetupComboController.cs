using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using System.Web.Http;
using CPMS_MVC_API.BLogic;
using Newtonsoft.Json;

namespace CPMS_MVC_API.Controllers.System_Setup
{
    public class SetupComboController : ApiController
    {
        Functions func = new Functions();
        DataSet dsweb = new DataSet();
        string cmdtxt = "";

        //Fetch Company Start
        [HttpGet]
        [Route("~/SetupCombo/FillCompany/{_srch?}/{_key?}")]
        public string FillCompany(  String _srch,  string _key)
        {

            var JSONResult = "";
            dynamic dataResult = new { Token = _key };

            System.Data.DataTable dttblgrn_sel = new System.Data.DataTable();
            dttblgrn_sel.Columns.Add("Remarks", typeof(string));
            dttblgrn_sel.Columns.Add("status", typeof(int));
            dttblgrn_sel.Columns.Add("Result", typeof(object));

            try
            {
                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {
                    string _usr_id = strusr[1], _br_id = strusr[3];

                    cmdtxt = "select rtrim(com_id) as [ID],com_nam as [Company] from m_com where rtrim(com_nam) like '%" + _srch + "%' order by com_nam";

                    DataSet dsgrn = func.dsfunc(cmdtxt);
                    if (dsgrn.Tables[0].Rows.Count > 0)
                    {
                        dttblgrn_sel.Rows.Add("OK", 1, dsgrn.Tables[0]);
                    }
                    else
                    {
                        dttblgrn_sel.Rows.Add("Record not found", 3, null);
                    }
                }
                else
                {
                    dttblgrn_sel.Rows.Add("Invalid User", 2, null);
                }

            }
            catch (Exception e)
            {
                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblgrn_sel.Rows.Add("Error : " + e.Message + innerexp, 0, null);
            }
            //JSONResult = JsonConvert.SerializeObject(dttblgrn_sel);
            //return JsonConvert.DeserializeObject<object>(JSONResult);
            return JsonConvert.SerializeObject(dttblgrn_sel);
        }
        //Fetch Company End

        //Fetch Branch Start
        [HttpGet]
        [Route("~/SetupCombo/FillBranch/{_srch?}/{_key?}")]
        public string FillBranch( String _srch,  string _key)
        {

            var JSONResult = "";
            dynamic dataResult = new { Token = _key };

            System.Data.DataTable dttblgrn_sel = new System.Data.DataTable();
            dttblgrn_sel.Columns.Add("Remarks", typeof(string));
            dttblgrn_sel.Columns.Add("status", typeof(int));
            dttblgrn_sel.Columns.Add("Result", typeof(object));

            try
            {
                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {
                    string _usr_id = strusr[1], _br_id = strusr[3];

                    cmdtxt = "select rtrim(br_id) as [ID],br_nam as [Branch] from m_br where rtrim(br_nam) like '%" + _srch + "%' order by br_nam";

                    DataSet dsgrn = func.dsfunc(cmdtxt);
                    if (dsgrn.Tables[0].Rows.Count > 0)
                    {
                        dttblgrn_sel.Rows.Add("OK", 1, dsgrn.Tables[0]);
                    }
                    else
                    {
                        dttblgrn_sel.Rows.Add("Record not found", 3, null);
                    }
                }
                else
                {
                    dttblgrn_sel.Rows.Add("Invalid User", 2, null);
                }

            }
            catch (Exception e)
            {
                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblgrn_sel.Rows.Add("Error : " + e.Message + innerexp, 0, null);
            }
            //JSONResult = JsonConvert.SerializeObject(dttblgrn_sel);
            //return JsonConvert.DeserializeObject<object>(JSONResult);
            return JsonConvert.SerializeObject(dttblgrn_sel);
        }
        //Fetch Branch End


        //Fetch User Group Start
        [HttpGet]
        [Route("~/SetupCombo/FillUserGroup/{_srch?}/{_key?}")]
        public string FillUserGroup( String _srch,  string _key)
        {

            var JSONResult = "";
            dynamic dataResult = new { Token = _key };

            System.Data.DataTable dttblgrn_sel = new System.Data.DataTable();
            dttblgrn_sel.Columns.Add("Remarks", typeof(string));
            dttblgrn_sel.Columns.Add("status", typeof(int));
            dttblgrn_sel.Columns.Add("Result", typeof(object));

            try
            {
                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {
                    string _usr_id = strusr[1];

                    cmdtxt = "select usrgp_id as [ID],rtrim(usrgp_nam) +' 'as [Name]" +
                             " from m_usrgp" +
                             " where usrgp_nam like '%" + _srch + "%' order by usrgp_nam";

                    DataSet dsgrn = func.dsfunc(cmdtxt);
                    if (dsgrn.Tables[0].Rows.Count > 0)
                    {
                        dttblgrn_sel.Rows.Add("OK", 1, dsgrn.Tables[0]);
                    }
                    else
                    {
                        dttblgrn_sel.Rows.Add("Record not found", 3, null);
                    }
                }
                else
                {
                    dttblgrn_sel.Rows.Add("Invalid User", 2, null);
                }

            }
            catch (Exception e)
            {
                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblgrn_sel.Rows.Add("Error : " + e.Message + innerexp, 0, null);
            }
            //JSONResult = JsonConvert.SerializeObject(dttblgrn_sel);
            //return JsonConvert.DeserializeObject<object>(JSONResult);
            return JsonConvert.SerializeObject(dttblgrn_sel);
        }
        //Fetch User Group End

        [HttpGet]
        [Route("~/SetupCombo/FillFormModule/{_srch?}/{_key?}")]
        public async Task<Object> FillFormModule( String _srch,  string _key)
        {

            dynamic dataResult = new { Token = _key };
            System.Data.DataTable dttblgrn_sel = new System.Data.DataTable();
            dttblgrn_sel.Columns.Add("Remarks", typeof(string));
            dttblgrn_sel.Columns.Add("status", typeof(int));
            dttblgrn_sel.Columns.Add("Result", typeof(object));
            var JSONResult = "";

            try
            {
                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {
                    cmdtxt = " select Id,formName from complainForms " +
                             " where Active=1 and formName like '%" + _srch + "%'";

                    DataSet dsrmtn = func.dsfunc(cmdtxt);
                    if (dsrmtn.Tables[0].Rows.Count > 0)
                    {
                        dttblgrn_sel.Rows.Add("OK", 1, dsrmtn.Tables[0]);
                    }
                    else
                    {
                        dttblgrn_sel.Rows.Add("Record not found", 0, null);
                    }
                }
                else
                {
                    dttblgrn_sel.Rows.Add("Invalid User", 0, null);
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
    }
}
