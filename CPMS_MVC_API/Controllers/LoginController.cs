using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Threading.Tasks;
using System.Data;
using CPMS_MVC_API.BLogic;
using Newtonsoft.Json;


namespace CPMS_MVC_API.Controllers
{
    public class LoginController : ApiController
    {
        Functions func = new Functions();
        DataSet dslog = new DataSet();
        string cmdtxt = "";

        //Login Start
        [HttpPost]
        [Route("~/Login/login/")]
        public async Task<Object> login([FromBody] dynamic dataResult)
        {
            string _user = dataResult.UserName;
            string _password = dataResult.UserPassword;

            string _key = "", _usrid = "0", _usrnam = "", _usreml = "", _usrlogin = _user, _comid = "", _comnam = "", _comeml = "", _brid = "", _brnam = "", _breml = "",
                                _usrckbr = "", _perdt1 = "", _perdt2 = "", _rmk = "", _DatTim = DateTime.Now.ToString(),
                                _usr_header, _usr_wanip;
            int _st = 0;
            var JSONResult = "";
            _usr_header = dataResult.userheader;
            _usr_wanip = dataResult.wanip;

            DataTable dttblusr_login = new System.Data.DataTable();
            dttblusr_login.Columns.Add("Key", typeof(string));
            dttblusr_login.Columns.Add("Name", typeof(string));
            dttblusr_login.Columns.Add("Company_ID", typeof(string));
            dttblusr_login.Columns.Add("Company_Name", typeof(string));
            dttblusr_login.Columns.Add("Company_Email", typeof(string));
            dttblusr_login.Columns.Add("Branch_ID", typeof(string));
            dttblusr_login.Columns.Add("Branch_Name", typeof(string));
            dttblusr_login.Columns.Add("All_Branch", typeof(string));
            dttblusr_login.Columns.Add("Date1", typeof(string));
            dttblusr_login.Columns.Add("Date2", typeof(string));
            dttblusr_login.Columns.Add("Remarks", typeof(string));
            dttblusr_login.Columns.Add("status", typeof(int));
            dttblusr_login.Columns.Add("LoginDateTime", typeof(string));
            dttblusr_login.Columns.Add("UserAgent", typeof(string));
            dttblusr_login.Columns.Add("Wan_IP", typeof(string));
            try
            {
                string enc_pwd = func.security(_password);
                DataSet dsusr = new DataSet();
                cmdtxt = "select usr_id,new_usr.com_id,new_usr.br_id,usr_ckbr,usr_act"+
                    " from new_usr" +
                    " where LOWER(new_usr.usr_nam) = '" + _user.ToLower() + "' and new_usr.usr_pwd = '" + enc_pwd + "'";

                dsusr = func.dsfunc(cmdtxt);
                if (dsusr.Tables[0].Rows.Count > 0)
                {
                    if (Convert.ToBoolean(dsusr.Tables[0].Rows[0]["usr_act"]) == false)
                    {
                        _rmk = "User not active";
                        _st = 0;
                    }
                    else
                    {

                        _usrid = dsusr.Tables[0].Rows[0]["usr_id"].ToString().Trim();
                        _comid = dsusr.Tables[0].Rows[0]["com_id"].ToString().Trim();
                        _brid = dsusr.Tables[0].Rows[0]["br_id"].ToString().Trim();
                        _usrckbr = dsusr.Tables[0].Rows[0]["usr_ckbr"].ToString().Trim();

                        _key = func.security(_usrid + _usrnam + _usrlogin + _DatTim);

                        //Generate Key Start
                        func.cmd.Connection = func.con();
                        func.cmd.CommandType = CommandType.Text;
                        func.cmd.CommandText = "update new_usr set usr_key=@key,usr_header=@usr_header,usr_wanip=@usr_wanip where usr_id=@usr_id";
                        func.cmd.Parameters.Clear();
                        func.param = func.cmd.Parameters.AddWithValue("@key", _key);
                        func.param = func.cmd.Parameters.AddWithValue("@usr_header", _usr_header);
                        func.param = func.cmd.Parameters.AddWithValue("@usr_wanip", _usr_wanip);
                        func.param = func.cmd.Parameters.AddWithValue("@usr_id", _usrid);
                        func.cn.Open();
                        func.trans = func.cn.BeginTransaction();
                        func.cmd.Transaction = func.trans;
                        func.cmd.ExecuteNonQuery();
                        //Generate Key End


                        _rmk = "Login";
                        _st = 1;



                        //Audit Log Start
                        func.cmd.CommandType = CommandType.Text;
                        func.cmd.CommandText = "insert into usr_login_audit(usr_login_audit_key,usr_id,usr_login_audit_rmk,usr_login_audit_status,usr_header,usr_wanip,com_id,br_id,usr_login_ckbr,ins_dat)" +
                                             " values(@usr_login_audit_key,@usr_id,@usr_login_audit_rmk,@usr_login_audit_status,@usr_header,@usr_wanip,@com_id,@br_id,@usr_login_ckbr,@ins_dat)";
                        func.cmd.Parameters.Clear();
                        func.param = func.cmd.Parameters.AddWithValue("@usr_login_audit_key", _key);
                        func.param = func.cmd.Parameters.AddWithValue("@usr_id", _usrid);
                        func.param = func.cmd.Parameters.AddWithValue("@usr_login_audit_rmk", _rmk);
                        func.param = func.cmd.Parameters.AddWithValue("@usr_login_audit_status", _st);
                        func.param = func.cmd.Parameters.AddWithValue("@usr_header", _usr_header);
                        func.param = func.cmd.Parameters.AddWithValue("@usr_wanip", _usr_wanip);
                        func.param = func.cmd.Parameters.AddWithValue("@com_id", _comid);
                        func.param = func.cmd.Parameters.AddWithValue("@br_id", _brid);
                        func.param = func.cmd.Parameters.AddWithValue("@usr_login_ckbr", _usrckbr);
                        func.param = func.cmd.Parameters.AddWithValue("@ins_dat", DateTime.Now);

                        func.cmd.ExecuteNonQuery();
                        //Audit Log End
                        func.trans.Commit();
                        func.cn.Close();
                    }

                }
                else
                {
                    _rmk = "Invalid user or password";
                    _st = 0;
                }
                dttblusr_login.Rows.Add(_key, _usrnam, _comid, _comnam, _comeml, _brid, _brnam, _usrckbr, _perdt1, _perdt2, _rmk, _st, _DatTim, _usr_header, _usr_wanip);
            }
            catch (Exception e)
            {
                if (func.trans != null) { func.trans.Rollback(); }
                if (func.cn.State == ConnectionState.Open) { func.cn.Close(); }

                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                _rmk = e.Message.ToString() + innerexp;
                _st = 0;
                dttblusr_login.Rows.Add("", _usrlogin, "", "", "", "", "", "", "", "", _rmk, _st, _DatTim, "", "");

            }
            JSONResult = JsonConvert.SerializeObject(dttblusr_login);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //Login End

      

        

        //Menu Start
        [HttpPost]
        [Route("~/Login/menu")]
        public async Task<Object> menu([FromBody] dynamic dataResult)
        {
            var JSONResult = "";

            System.Data.DataTable dttbl_menu = new System.Data.DataTable();

            dttbl_menu.Columns.Add("URL", typeof(string));
            dttbl_menu.Columns.Add("menu", typeof(string));
            dttbl_menu.Columns.Add("style_class", typeof(string));
            dttbl_menu.Columns.Add("Remarks", typeof(string));
            dttbl_menu.Columns.Add("status", typeof(int));

            try
            {
                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {
                    string usrgptyp = strusr[8];
                    if (usrgptyp == "S")
                    {
                        dttbl_menu.Rows.Add("Dashboard", "Dashboard", "fa fa-home", "", 1);
                        dttbl_menu.Rows.Add("Customer", "Customer", "fa fa-globe", "", 1);
                        dttbl_menu.Rows.Add("Device", "Device", "fa fa-desktop", "", 1);
                        dttbl_menu.Rows.Add("Device_Parameters", "Parameters", "fa fa-paragraph", "", 1);
                        dttbl_menu.Rows.Add("NewUser", "User", "fa fa-user", "", 1);
                        dttbl_menu.Rows.Add("UserGroup", "User Group", "fa fa-user-secret", "", 1);
                        dttbl_menu.Rows.Add("Reports", "Reports", "fa fa-file-text", "", 1);
                    }
                    else if (usrgptyp == "A")
                    {
                        dttbl_menu.Rows.Add("Dashboard", "Dashboard", "fa fa-home", "", 1);
                        dttbl_menu.Rows.Add("Device_Parameters", "Parameters", "fa fa-paragraph", "", 1);
                        dttbl_menu.Rows.Add("NewUser", "User", "fa fa-user", "", 1);
                        dttbl_menu.Rows.Add("Reports", "Reports", "fa fa-file-text", "", 1);
                    }
                    else
                    {
                        dttbl_menu.Rows.Add("Dashboard", "Dashboard", "fa fa-home", "", 1);
                        dttbl_menu.Rows.Add("Reports", "Reports", "fa fa-file-text", "", 1);
                    }
                }
                else
                {
                    dttbl_menu.Rows.Add("", "", "", "Invalid User", 0);
                }
            }
            catch (Exception e)
            {
                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttbl_menu.Rows.Add("", "", "", e.Message.ToString() + innerexp, 0);
            }
            JSONResult = JsonConvert.SerializeObject(dttbl_menu);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
       
        //Logout Start
        [HttpPost]
        [Route("~/Login/logout")]
        public async Task<object> logout([FromBody] dynamic dataResult)
        {
            var JSONResult = "";
            System.Data.DataTable dttbl_logout = new System.Data.DataTable();
            dttbl_logout.Columns.Add("Remarks", typeof(string));
            dttbl_logout.Columns.Add("status", typeof(int));
            try
            {

                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {
                    string _usr_header = dataResult.userheader;
                    string _usr_wanip = dataResult.wanip;
                    string _key1 = dataResult.Token;

                    string _comid = strusr[2], _brid = strusr[3];



                    //Blank Key Start
                    func.cmd.Connection = func.con();
                    func.cmd.CommandType = CommandType.Text;
                    func.cmd.CommandText = "update new_usr set usr_key=@key,usr_header=@usr_header,usr_wanip=@usr_wanip where usr_id=@usr_id";
                    func.cmd.Parameters.Clear();
                    func.param = func.cmd.Parameters.AddWithValue("@key", "");
                    func.param = func.cmd.Parameters.AddWithValue("@usr_header", _usr_header);
                    func.param = func.cmd.Parameters.AddWithValue("@usr_wanip", _usr_wanip);
                    func.param = func.cmd.Parameters.AddWithValue("@usr_id", strusr[1]);
                    func.cn.Open();
                    func.trans = func.cn.BeginTransaction();
                    func.cmd.Transaction = func.trans;
                    func.cmd.ExecuteNonQuery();
                    //Blank Key End

                    //Audit Log Start
                    func.cmd.CommandType = CommandType.Text;
                    func.cmd.CommandText = "insert into usr_login_audit(com_id,br_id,usr_id,usr_login_audit_key,usr_login_audit_rmk,usr_login_audit_status,usr_header,usr_wanip,ins_dat)" +
                        " values(@com_id,@br_id,@usr_id,@usr_login_audit_key,@usr_login_audit_rmk,@usr_login_audit_status,@usr_header,@usr_wanip,@ins_dat)";
                    func.cmd.Parameters.Clear();
                    func.param = func.cmd.Parameters.AddWithValue("@usr_id", strusr[1]);
                    func.param = func.cmd.Parameters.AddWithValue("@usr_login_audit_key", "");
                    func.param = func.cmd.Parameters.AddWithValue("@usr_login_audit_rmk", "Logout");
                    func.param = func.cmd.Parameters.AddWithValue("@usr_login_audit_status", false);
                    func.param = func.cmd.Parameters.AddWithValue("@usr_header", _usr_header);
                    func.param = func.cmd.Parameters.AddWithValue("@usr_wanip", _usr_wanip);
                    func.param = func.cmd.Parameters.AddWithValue("@com_id", _comid);
                    func.param = func.cmd.Parameters.AddWithValue("@br_id", _brid);
                    func.param = func.cmd.Parameters.AddWithValue("@ins_dat", DateTime.Now);
                    func.cmd.ExecuteNonQuery();
                    //Audit Log End

                    //Audit Log Key Blank Start
                    func.cmd.CommandType = CommandType.Text;
                    func.cmd.CommandText = "update usr_login_audit set usr_login_audit_key='' where usr_id=@usr_id and usr_login_audit_key=@key";
                    func.cmd.Parameters.Clear();
                    func.param = func.cmd.Parameters.AddWithValue("@key", _key1);
                    func.param = func.cmd.Parameters.AddWithValue("@usr_id", strusr[1]);
                    func.cmd.ExecuteNonQuery();
                    //Audit Log Key Blank End

                    func.trans.Commit();
                    func.cn.Close();

                    dttbl_logout.Rows.Add("logout", 1);
                }
                else
                {
                    dttbl_logout.Rows.Add("Invalid User", 0);
                }
            }
            catch (Exception e)
            {
                if (func.trans != null) { func.trans.Rollback(); }
                if (func.cn.State == ConnectionState.Open) { func.cn.Close(); }

                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }

                dttbl_logout.Rows.Add(e.Message.ToString() + innerexp, 0);
            }
            JSONResult = JsonConvert.SerializeObject(dttbl_logout);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //Logout End
        //Password Changed Start
        [HttpPost]
        [Route("~/Login/PasswordChange/")]
        public async Task<Object> PasswordChange([FromBody] dynamic dataResult)
        {
            string _old_password = dataResult.UserPassword;
            string _new_password = dataResult.NewPassword;
            var JSONResult = "";
            DataTable dttblusr_login = new System.Data.DataTable();

            dttblusr_login.Columns.Add("Remarks", typeof(string));
            dttblusr_login.Columns.Add("status", typeof(int));
            try
            {
                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {
                    string _usr_id = strusr[1], _usr_name = strusr[10];
                    string enc_pwd = func.security(_old_password);
                    string enc_new_pwd = func.security(_new_password);
                    DataSet dsusr = new DataSet();
                    cmdtxt = "select usr_id,usr_pwd,usr_nam from new_usr where usr_id='" + _usr_id + "'and new_usr.usr_pwd ='" + enc_pwd + "'";
                    dsusr = func.dsfunc(cmdtxt);

                    if (dsusr.Tables[0].Rows.Count > 0)
                    {
                        func.cmd.Connection = func.con();
                        func.cmd.CommandType = CommandType.Text;
                        func.cmd.CommandText = "update new_usr set usr_pwd=@usr_pwd  where usr_id=@usr_id";
                        func.cmd.Parameters.Clear();
                        func.param = func.cmd.Parameters.AddWithValue("@usr_pwd", enc_new_pwd);
                        func.param = func.cmd.Parameters.AddWithValue("@usr_id", strusr[1]);

                        func.cn.Open();
                        func.trans = func.cn.BeginTransaction();
                        func.cmd.Transaction = func.trans;
                        func.cmd.ExecuteNonQuery();
                        func.trans.Commit();
                        func.cn.Close();
                        dttblusr_login.Rows.Add("Password has been changed", 1);
                    }
                    else
                    {
                        dttblusr_login.Rows.Add("Incorrect Password", 0);
                    }
                }
                else
                {
                    dttblusr_login.Rows.Add("Invalid User", 0);
                }
            }
            catch (Exception e)
            {
                if (func.trans != null) { func.trans.Rollback(); }
                if (func.cn.State == ConnectionState.Open) { func.cn.Close(); }

                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }

                dttblusr_login.Rows.Add("", "", "Error : " + e.Message + innerexp, 0);
            }
            JSONResult = JsonConvert.SerializeObject(dttblusr_login);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //Password Changed End

    }
}
