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


namespace CPMS_MVC_API.Controllers.System_Setup.User
{
    public class New_UserController : ApiController
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
        [Route("~/System_Setup/User/New_User/create")]
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
                    string _usr_nam = Convert.ToString(dataResult.Name);
                    string _usr_pwd = Convert.ToString(dataResult.Password);
                    string _usr_add = Convert.ToString(dataResult.Address);
                    string _usr_pho = Convert.ToString(dataResult.Phone_No);
                    string _usr_mob = Convert.ToString(dataResult.Mobile_No);
                    string _usr_br_id = Convert.ToString(dataResult.Branch_ID);
                    bool _usr_act = Convert.ToBoolean(dataResult.Active);

                    int _usr_id_ins = Convert.ToInt16(strusr[1]);
                    string _com_id = strusr[2], _br_id = strusr[3], _m_yr_id = strusr[4];

                    string usrpwd = func.security(_usr_pwd);

                    //Master
                    int usr_id = func.pkid("new_usr", "usr_id");

                    string str = "";

                    str = System.Configuration.ConfigurationManager.ConnectionStrings["IFS_local"].ToString();
                    if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }
                    cnweb.ConnectionString = str;
                    cmdweb.Connection = cnweb;
                    cmdweb.CommandType = CommandType.Text;
                    cnweb.Open();
                    transweb = cnweb.BeginTransaction();
                    cmdweb.Transaction = transweb;

                    cmdweb.CommandText = "insert into new_usr" +
                                        " (usr_id,usr_no,usr_nam ,usr_pwd,usr_add,usr_pho,usr_mob,com_id ,br_id ,usr_typ ,usr_act,usr_id_ins,ins_dat)" +
                                        " values " +
                                        " (@usr_id,@usr_id,@usr_nam,@usr_pwd,@usr_add,@usr_pho,@usr_mob,@com_id,@br_id,@usr_typ,@usr_act,@usr_id_ins,@ins_dat)";

                    paramweb = cmdweb.Parameters.AddWithValue("@usr_id", usr_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_nam", _usr_nam);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_pwd", usrpwd);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_add", _usr_add);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_pho", _usr_pho);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_mob", _usr_mob);
                    paramweb = cmdweb.Parameters.AddWithValue("@com_id", _com_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_id", _usr_br_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_typ", "U");
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_act", _usr_act);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_id_ins", _usr_id_ins);
                    paramweb = cmdweb.Parameters.AddWithValue("@ins_dat", DateTime.Now);

                    int i = cmdweb.ExecuteNonQuery();
                    if (i > 0)
                    {
                        i = savedetail(usr_id, _usr_id_ins, dataResult);
                        if (i > 0)
                        {
                            transweb.Commit();
                            cnweb.Close();
                            dttblusrgp_ins.Rows.Add(usr_id.ToString(), _usr_nam + " Created", 1);
                        }
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
        [Route("~/System_Setup/User/New_User/edit")]
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
                    int _usr_id = Convert.ToInt16(dataResult.ID);
                    string _usr_nam = Convert.ToString(dataResult.Name);
                    string _usr_add = Convert.ToString(dataResult.Address);
                    string _usr_pho = Convert.ToString(dataResult.Phone_No);
                    string _usr_mob = Convert.ToString(dataResult.Mobile_No);
                    string _usr_br_id = Convert.ToString(dataResult.Branch_ID);
                    bool _usr_act = Convert.ToBoolean(dataResult.Active);
                    int _usr_id_upd = Convert.ToInt16(strusr[1]);

                    string _com_id = strusr[2], _br_id = strusr[3], _m_yr_id = strusr[4];
                    //string usrpwd = func.security(_usr_pwd);


                    //Master

                    string str = "";

                    str = System.Configuration.ConfigurationManager.ConnectionStrings["IFS_local"].ToString();
                    if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }
                    cnweb.ConnectionString = str;
                    cmdweb.Connection = cnweb;
                    cmdweb.CommandType = CommandType.Text;
                    cnweb.Open();
                    transweb = cnweb.BeginTransaction();
                    cmdweb.Transaction = transweb;

                    cmdweb.CommandText = "update new_usr " +
                                         " set usr_nam=@usr_nam,usr_add=@usr_add,usr_pho=@usr_pho,usr_mob=@usr_mob," +
                                         " com_id=@com_id,br_id=@br_id,usr_typ=@usr_typ,usr_act=@usr_act," +
                                         " usr_id_upd=@usr_id_upd,upd_dat=@upd_dat" +
                                         " where usr_id = @usr_id";

                    cmdweb.Parameters.Clear();

                    paramweb = cmdweb.Parameters.AddWithValue("@usr_id", _usr_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_nam", _usr_nam);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_add", _usr_add);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_pho", _usr_pho);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_mob", _usr_mob);
                    paramweb = cmdweb.Parameters.AddWithValue("@com_id", _com_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@br_id", _usr_br_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_typ", "U");
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_act", _usr_act);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_id_upd", _usr_id_upd);
                    paramweb = cmdweb.Parameters.AddWithValue("@upd_dat", DateTime.Now);

                    int i = cmdweb.ExecuteNonQuery();
                    if (i > 0)
                    {
                        i = savedetail(_usr_id, _usr_id_upd, dataResult);
                        if (i > 0)
                        {
                            transweb.Commit();
                            cnweb.Close();
                            dttblusrgp_ins.Rows.Add(_usr_id.ToString(), _usr_nam + " Updated", 1);
                        }
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

        //Delete Start
        [HttpPost]
        [Route("~/System_Setup/User/New_User/delete/{_usr_id}")]
        public async Task<Object> delete(string _usr_id, [FromBody] dynamic dataResult)
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
                    string _usr_nam = func.dsfunc("select usr_nam from new_usr where usr_id=" + _usr_id + "").Tables[0].Rows[0]["usr_nam"].ToString();

                    string str = "";
                    str = System.Configuration.ConfigurationManager.ConnectionStrings["IFS_local"].ToString();
                    if (cnweb.State == ConnectionState.Open) { cnweb.Close(); }
                    cnweb.ConnectionString = str;
                    cmdweb.Connection = cnweb;
                    cmdweb.CommandType = CommandType.Text;
                    cnweb.Open();
                    transweb = cnweb.BeginTransaction();
                    cmdweb.Transaction = transweb;


                    //Detail
                    cmdweb.CommandText = "delete m_dusr where usr_id=@usr_id";
                    cmdweb.Parameters.Clear();
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_id", _usr_id);

                    int i = cmdweb.ExecuteNonQuery();
                    if (i > 0)
                    {
                        cmdweb.CommandText = "delete new_usr where usr_id=@usr_id";
                        cmdweb.Parameters.Clear();
                        paramweb = cmdweb.Parameters.AddWithValue("@usr_id", _usr_id);
                        cmdweb.ExecuteNonQuery();

                        transweb.Commit();
                        cnweb.Close();
                        dttblusrgp_ins.Rows.Add(_usr_id.ToString(), _usr_nam + " Deleted", 1);
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

        //Password Change Start
        [HttpPost]
        [Route("~/System_Setup/User/New_User/ChangePassword")]
        public async Task<Object> ChangePassword([FromBody] dynamic dataResult)
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
                    string _usr_id = Convert.ToString(dataResult.ID);
                    string _usr_nam = Convert.ToString(dataResult.Name);
                    string _usr_pwd = Convert.ToString(dataResult.Password);

                    string usrpwd = func.security(_usr_pwd);

                    //Master
                    cmdweb.Connection = func.con();
                    cmdweb.CommandType = CommandType.Text;
                    cmdweb.CommandText = "update new_usr set usr_pwd=@usr_pwd where usr_id=@usr_id";
                    cmdweb.Parameters.Clear();
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_id", _usr_id);
                    paramweb = cmdweb.Parameters.AddWithValue("@usr_pwd", usrpwd);

                    func.cn.Open();
                    transweb = func.cn.BeginTransaction();
                    cmdweb.Transaction = transweb;
                    int i = cmdweb.ExecuteNonQuery();
                    if (i > 0)
                    {
                        transweb.Commit();
                        cnweb.Close();
                        dttblusrgp_ins.Rows.Add(_usr_id.ToString(), "Password Change User : " + _usr_nam, 1);
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
        //Change Password End

        //Fetch User for Fill Index Start
        [HttpPost]
        [Route("~/System_Setup/User/New_User/GetUser")]
        public async Task<Object> GetUser([FromBody] dynamic dataResult)
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


                    cmdtxt = "select usr_id as [ID],br_nam as [BRANCH_NAME] ," +
                            " case usr_act when 1 then 'Active' else 'In-Active' end as [Active], usr_nam as [NAME] ," +
                             " STUFF((select', '+rtrim(cast(musrgp.usrgp_nam as char(100))) from m_usrgp musrgp inner join m_dusr mdusr on musrgp.usrgp_id=mdusr.usrgp_id where mdusr.usr_id=new_usr.usr_id group by musrgp.usrgp_nam for xml path('')), 1, 1, '') as [Group]" +
                             " from new_usr " +
                             " inner join m_br on new_usr.br_id=m_br.br_id" +
                             " order by usr_nam";

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
            JSONResult = JsonConvert.SerializeObject(dttblgrn_sel);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //Fetch User for Fill Index Eend

        //Fetch Record for Edit Start
        [HttpPost]
        [Route("~/System_Setup/User/New_User/FetchEditUser/{_usr_id}")]
        public async Task<Object> FetchEditUser(string _usr_id, [FromBody] dynamic dataResult)
        {

            var JSONResult = "";

            System.Data.DataTable dttblpo = new System.Data.DataTable();
            dttblpo.Columns.Add("Remarks", typeof(string));
            dttblpo.Columns.Add("status", typeof(int));
            dttblpo.Columns.Add("Result", typeof(object));
            dttblpo.Columns.Add("Result_Group", typeof(object));

            try
            {
                string[] strusr = func.checkuser(dataResult);
                string Menu = dataResult.Menu;
                if (Convert.ToBoolean(strusr[0]))
                {
                    string _m_yr_id = strusr[4];

                    cmdtxt = "select usr_id as [ID] , usr_nam as [NAME] , usr_add as [ADDRESS] ,usr_pho as [PHONE] , usr_mob as [MOBILE] , " +
                             " new_usr.com_id as [COMPANY_ID],com_nam as [COMPANY_NAME], new_usr.br_id as [BRANCH_ID],br_nam as [BRANCH_NAME] ," +
                             " usr_act as [Active],usr_ckbr as [All_Branches], usr_typ as [Type]" +
                             " from new_usr " +
                             " inner join m_com on new_usr.com_id=m_com.com_id " +
                             " inner join m_br on new_usr.br_id=m_br.br_id" +
                             " where new_usr.usr_id='" + _usr_id + "'";


                    DataSet dsuser = func.dsfunc(cmdtxt);
                    if (dsuser.Tables[0].Rows.Count > 0)
                    {
                        cmdtxt = "select m_usrgp.usrgp_id as [ID],usrgp_nam as [Name] from m_usrgp " +
                                    " inner join m_dusr on m_usrgp.usrgp_id=m_dusr.usrgp_id and m_dusr.usr_id='" + _usr_id + "'" +
                                    " where usrgp_act=1";
                        DataSet dsgrp = func.dsfunc(cmdtxt);
                        dttblpo.Rows.Add("OK", 1, dsuser.Tables[0], dsgrp.Tables[0]);
                    }
                    else
                    {
                        dttblpo.Rows.Add("Record not found", 0);
                    }
                }
                else
                {
                    dttblpo.Rows.Add("Invalid User", 0);
                }

            }
            catch (Exception e)
            {
                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblpo.Rows.Add("Error : " + e.Message + innerexp, 0);
            }
            JSONResult = JsonConvert.SerializeObject(dttblpo);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //Fetch Record for Edit End

        //save datails start
        private int savedetail(int _usr_id, int _usr_id_ins, dynamic _dataResult)
        {
            int cksav = 0;
            int _dusr_id = func.pkid("m_dusr", "dusr_id");
            string _usrgp_id_str = "";

            // delete detail
            cmdweb.CommandType = CommandType.Text;
            cmdweb.CommandText = "delete m_dusr where usr_id=@usr_id";
            cmdweb.Parameters.Clear();
            paramweb = cmdweb.Parameters.AddWithValue("@usr_id", _usr_id);
            cmdweb.ExecuteNonQuery();
            //delete detail


            var _ditn_str = _dataResult.Detail.ToString();
            string[] _ditn = _ditn_str.Split('|');
            //Detail Start
            for (int _ditn_cnt = 0; _ditn_cnt < _ditn.Length; _ditn_cnt++)
            {
                int _usrgp_id = func.getid(_ditn[_ditn_cnt]);
                //Detail Insert  Start
                cmdweb.CommandType = CommandType.Text;
                cmdweb.CommandText = " insert into m_dusr" +
                                     " (dusr_id,usr_id,usrgp_id)" +
                                     " values (@dusr_id,@usr_id,@usrgp_id)";
                cmdweb.Parameters.Clear();

                paramweb = cmdweb.Parameters.AddWithValue("@dusr_id", _dusr_id);
                paramweb = cmdweb.Parameters.AddWithValue("@usr_id", _usr_id);
                paramweb = cmdweb.Parameters.AddWithValue("@usrgp_id", _usrgp_id);

                cksav = cmdweb.ExecuteNonQuery();

                if (_usrgp_id_str == "")
                {
                    _usrgp_id_str = _usrgp_id.ToString();
                }
                else
                {
                    _usrgp_id_str += "," + _usrgp_id.ToString();
                }
                _dusr_id += 1;
            }
            //Detail End
 
            return cksav;
        }
        // save datails end

    }
}




