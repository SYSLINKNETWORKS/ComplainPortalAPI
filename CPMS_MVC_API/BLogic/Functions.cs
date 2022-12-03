using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Security.Cryptography;
using System.Net;
using System.Net.Mail;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Drive.v3;
using Google.Apis.Drive.v3.Data;
using Google.Apis.Services;
using Google.Apis.Util.Store;
using System.IO;
using System.Data;
using Newtonsoft.Json;
using System.Threading;
//using Quobject.SocketIoClientDotNet.Client;

namespace CPMS_MVC_API.BLogic
{

    public class Functions
    {
        SqlDataAdapter da = new SqlDataAdapter();
        public SqlCommand cmd = new SqlCommand();
        public SqlConnection cn = new SqlConnection();
        public SqlTransaction trans = null;
        public SqlParameter param = new SqlParameter();
        static string[] Scopes = { DriveService.Scope.DriveFile };
        static string ApplicationName = "Drive API .NET Quickstart";


        //Connection Start
        public SqlConnection con()
        {
            string mysqlconstr = ConfigurationManager.ConnectionStrings["IFS_local"].ConnectionString;
            if (cn.State == System.Data.ConnectionState.Open) { cn.Close(); }
            cn.ConnectionString = mysqlconstr;
            return cn;
        }
        //Connection End
        //Get DataSet Start
        public DataSet dsfunc(string cmdtxt)
        {
            DataSet ds = new DataSet();
            ds.Clear();

            cmd.Connection = con();
            cmd.CommandText = cmdtxt;
            // cmd.CommandTimeout = 1440;
            da.SelectCommand = cmd;
            da.Fill(ds);
            return ds;

        }
        //Get DataSet End

        //Get DataSet with SQL Command Start
        public DataSet dsfunc(string cmdtxt, SqlCommand dscmd)
        {
            DataSet ds = new DataSet();
            ds.Clear();

            //cmd.Connection = dscon;
            //cmd.CommandText = cmdtxt;
            dscmd.CommandText = cmdtxt;
            // cmd.CommandTimeout = 1440;
            da.SelectCommand = dscmd;
            da.Fill(ds);
            return ds;

        }
        //Get DataSet with SQL Command End

        //Check User Start
        public string[] checkuser(dynamic dataResult)
        {
            string[] strarr = { "false", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" };
            //bool ckusr = false;
            string key1 = dataResult.Token;
            if (key1 == "") { key1 = "0"; }
            //string cmdtxt = "select usr_id,usr_nam from new_usr" +
            //     " where usr_act=1  and usr_key='" + key1 + "'";//and usr_cklock=0

            //string cmdtxt = "select usr_id,usr_nam,usr_eml,com_id,com_nam,com_eml,br_id,br_nam,br_eml," + 
            //        " per_dt1,per_dt2,m_yr_id,yr_str_dt,yr_end_dt,yr_ac,yr_nam from usr_login_audit" +
            //     " where usr_login_audit_key='" + key1 + "'";//and usr_cklock=0
            string cmdtxt = "select new_usr.usr_id,new_usr.usr_nam,new_usr.usr_eml,new_usr.com_id,com_nam,com_eml,new_usr.br_id,br_nam,br_eml,usr_login_ckbr" +
                        " from usr_login_audit" +
                        " inner join new_usr on usr_login_audit.usr_id = new_usr.usr_id" +
                        " inner join m_com on usr_login_audit.com_id = m_com.com_id" +
                        " inner join m_br on usr_login_audit.br_id = m_br.br_id" +
                        " where usr_login_audit_key='" + key1 + "'";
            DataSet dsusrkey = dsfunc(cmdtxt);
            if (dsusrkey.Tables[0].Rows.Count > 0)
            {
                strarr[0] = "true";
                strarr[1] = dsusrkey.Tables[0].Rows[0]["usr_id"].ToString();
                strarr[2] = dsusrkey.Tables[0].Rows[0]["com_id"].ToString();
                strarr[3] = dsusrkey.Tables[0].Rows[0]["br_id"].ToString();
                strarr[4] = dsusrkey.Tables[0].Rows[0]["usr_nam"].ToString();
                strarr[5] = dsusrkey.Tables[0].Rows[0]["usr_eml"].ToString();
                strarr[6] = dsusrkey.Tables[0].Rows[0]["com_nam"].ToString();
                strarr[7] = dsusrkey.Tables[0].Rows[0]["com_eml"].ToString();
                strarr[8] = dsusrkey.Tables[0].Rows[0]["br_nam"].ToString();
                strarr[9] = dsusrkey.Tables[0].Rows[0]["br_eml"].ToString();
                strarr[10] = dsusrkey.Tables[0].Rows[0]["usr_login_ckbr"].ToString();
                cmdtxt = "select case usrgp_nam when 'Developer' then cast(1 as bit) else cast(0 as bit) end as User_Admin from m_dusr inner join m_usrgp on m_dusr.usrgp_id=m_usrgp.usrgp_id where usr_id=" + dsusrkey.Tables[0].Rows[0]["usr_id"].ToString();
                DataSet dsgp = new DataSet();
                dsgp = dsfunc(cmdtxt);
                strarr[11] = dsgp.Tables[0].Rows[0]["User_Admin"].ToString();
            }
            return strarr;
        }
        //Check User End

        ////Check User IMEI Start
        //public string[] checkuser_imei(dynamic dataResult)
        //{
        //    string[] strarr = { "false", "", "", "" };
        //    //bool ckusr = false;
        //    string key1 = dataResult.Token;
        //    if (key1 == "") { key1 = "0"; }
        //    string cmdtxt = "select m_emppro.emppro_id,emppro_macid,demppro_imei,emppro_st from m_emppro inner join m_demppro_imei on m_emppro.emppro_id=m_demppro_imei.emppro_id" +
        //         " where demppro_imei ='" + key1 + "'";
        //    DataSet dsusrkey = dsfunc(cmdtxt);
        //    if (dsusrkey.Tables[0].Rows.Count > 0)
        //    {
        //        strarr[0] = dsusrkey.Tables[0].Rows[0]["emppro_st"].ToString();
        //        strarr[1] = dsusrkey.Tables[0].Rows[0]["emppro_id"].ToString();
        //        strarr[2] = dsusrkey.Tables[0].Rows[0]["emppro_macid"].ToString();
        //        strarr[3] = dsusrkey.Tables[0].Rows[0]["demppro_imei"].ToString();
        //    }
        //    return strarr;
        //}
        ////Check User IMEI End

        //Get Primary Key Start

        public Int32 pkid(string tblnam, string colnam)
        {
            int pid = 1;
            string cmdtxt = "select max(" + colnam + ")+1 as " + colnam + " from " + tblnam + "";
            DataSet dspk = dsfunc(cmdtxt);
            if (dspk.Tables[0].Rows.Count > 0)
            {
                if (dspk.Tables[0].Rows[0][colnam].ToString().Trim() != "")
                {
                    pid = Convert.ToInt32(dspk.Tables[0].Rows[0][colnam]);
                }
            }
            return pid;
        }

        //Encrypt Password Start

        public string security(string txtbox)
        {
            string secpwd = "";
            SHA1CryptoServiceProvider sha = new SHA1CryptoServiceProvider();
            Byte[] data = System.Text.ASCIIEncoding.Default.GetBytes(txtbox.ToString().Trim());
            secpwd = BitConverter.ToString(sha.ComputeHash(data));
            return secpwd.Substring(0, 50);
        }
        //Encrypt Password End

        //Get ID from []- Start
        public int getid(string txtid)
        {

            int indof = txtid.IndexOf("[", 0) + 1;
            int indend = txtid.IndexOf("]-", 0) - 1;
            int id = Convert.ToInt32(txtid.Substring(indof, indend));
            return id;
        }
        //Get ID from []- End


        //User Permission Start
        public DataSet checkuserpermission(string usrid)
        {
            string cmdtxt = "select usrgp_nam from new_usr" +
                            " inner join m_dusr on new_usr.usr_id = m_dusr.usr_id" +
                            " inner join m_usrgp on m_dusr.usrgp_id = m_usrgp.usrgp_id" +
                            " where new_usr.usr_id = " + usrid + "";
            DataSet dsusrper = dsfunc(cmdtxt);
            return dsusrper;
        }
        //User Permission End

        ////Email Start
        //public int sendemail(string _com_id, int _mcomp_id, string sendto, string subject, string body)
        //{
        //    DataSet dseml = new DataSet();
        //    string cmdtxt = "select com_smtp,com_smtpport,com_smtpssl,com_smtpuid,com_smtppwd,com_smtpfrm from m_com where com_id='" + _com_id + "'";
        //    dseml = dsfunc(cmdtxt);

        //    //DataTable dt_img_sav = new DataTable();
        //    //dt_img_sav.Columns.Add("mcomp_id", typeof(string));
        //    //dt_img_sav.Columns.Add("dcomp_img", typeof(string));
        //    //dt_img_sav.Columns.Add("dcomp_filenam", typeof(string));
        //    //dt_img_sav.Columns.Add("dcomp_typ", typeof(string));

        //    // dt_img_sav = (DataTable)HttpContext.Current.Session["dt_img_sav"];
        //    int cksend = 0;

        //    MailMessage msg = new MailMessage();
        //    msg.Subject = subject;
        //    msg.Body = body.ToString().Trim();

        //    msg.IsBodyHtml = true;

        //    msg.To.Add(sendto);

        //    msg.From = new MailAddress(dseml.Tables[0].Rows[0]["com_smtpfrm"].ToString().Trim());
        //    cmdtxt = "select imgarc_nam,imgarc_img_byt,imgarc_ext from t_dcomp_img where mcomp_id=" + _mcomp_id;
        //    DataSet dsimg = dsfunc(cmdtxt);
        //    if (dsimg.Tables[0].Rows.Count > 0)
        //    {
        //        for (int cnt_att = 0; cnt_att < dsimg.Tables[0].Rows.Count; cnt_att++)
        //        {
        //            string imgarc_nam1 = dsimg.Tables[0].Rows[cnt_att]["imgarc_nam"].ToString();
        //            //string imgarc_nam = imgarc_nam1.Substring(imgarc_nam1.IndexOf('.')+1, (imgarc_nam1.Length- (imgarc_nam1.IndexOf('.')+1)));
        //            string imgarc_nam = imgarc_nam1.Substring(0, (imgarc_nam1.IndexOf('.')));
        //            string Image = dsimg.Tables[0].Rows[cnt_att]["imgarc_img_byt"].ToString();
        //            string imgarc_ext = dsimg.Tables[0].Rows[cnt_att]["imgarc_ext"].ToString();
        //            System.Text.StringBuilder sbText = new System.Text.StringBuilder(Image, Image.Length);
        //            sbText.Replace("\r\n", string.Empty); sbText.Replace(" ", string.Empty);

        //            Byte[] bitmapData = Convert.FromBase64String(sbText.ToString());
        //            System.IO.MemoryStream streamBitmap = new System.IO.MemoryStream(bitmapData);

        //            //byte[] binaryFile = System.Text.Encoding.Default.GetBytes(dsimg.Tables[0].Rows[cnt_att]["imgarc_img_byt"].ToString());
        //            ////Convert.FromBase64String(dsimg.Tables[0].Rows[cnt_att]["imgarc_img_byt"].ToString());
        //            //System.IO.MemoryStream memoryStream = new System.IO.MemoryStream(binaryFile);
        //            ////Attachment att1 = new Attachment(dsimg.Tables[0].Rows[cnt_att]["imgarc_img_byt"].ToString().Trim());
        //            Attachment att1 = new Attachment(streamBitmap, imgarc_nam, imgarc_ext);
        //            msg.Attachments.Add(att1);
        //        }
        //    }
        //    //if (dt_img_sav != null)
        //    //{
        //    //    for (int cnt_att = 0; cnt_att < dt_img_sav.Rows.Count; cnt_att++)
        //    //    {
        //    //        if (dt_img_sav.Rows[cnt_att]["dcomp_typ"].ToString().Trim() != "D")
        //    //        {
        //    //            Attachment att1 = new Attachment(dt_img_sav.Rows[cnt_att]["dcomp_img"].ToString().Trim());
        //    //            msg.Attachments.Add(att1);
        //    //        }
        //    //    }
        //    //}
        //    SmtpClient SmtpServer = new SmtpClient();

        //    SmtpServer.Host = dseml.Tables[0].Rows[0]["com_smtp"].ToString().Trim();
        //    SmtpServer.Port = Convert.ToInt32(dseml.Tables[0].Rows[0]["com_smtpport"]);
        //    SmtpServer.EnableSsl = Convert.ToBoolean(dseml.Tables[0].Rows[0]["com_smtpssl"]);
        //    SmtpServer.Credentials = new System.Net.NetworkCredential(dseml.Tables[0].Rows[0]["com_smtpuid"].ToString().Trim(), dseml.Tables[0].Rows[0]["com_smtppwd"].ToString().Trim());
        //    SmtpServer.Send(msg);

        //    return cksend;


        //}
        ////Email End

        public DriveService GetService()
        {
            UserCredential credential;

            string filepath_credentials = System.Web.Hosting.HostingEnvironment.MapPath("~\\bin\\credentials.json");
            string filepath = System.Web.Hosting.HostingEnvironment.MapPath("~\\bin\\token.json");
            if (!Directory.Exists(filepath))
            {
                Directory.CreateDirectory(filepath);
            }
            using (var stream =
                new FileStream(filepath_credentials, FileMode.Open, FileAccess.Read))
            {
                string credPath = filepath;

                credential = GoogleWebAuthorizationBroker.AuthorizeAsync(
                    GoogleClientSecrets.Load(stream).Secrets,
                    Scopes,
                    "user", // use a const or read it from a config file
                    CancellationToken.None,
                    new FileDataStore(credPath, true)).Result;

            }
            var service = new DriveService(new BaseClientService.Initializer()
            {
                HttpClientInitializer = credential,
                ApplicationName = ApplicationName,
            });

            return service;
        }

        //Email Start
        public int sendemail(string _com_id, string _br_id, string _br_nam, int _mcomp_id, string sendto, string subject, string body, String MSGCAT)
        {
            DataSet dseml = new DataSet();
            string cmdtxt = "select com_smtp,com_smtpport,com_smtpssl,com_smtpuid,com_smtppwd,com_smtpfrm from m_com where com_id='" + _com_id + "'";
            dseml = dsfunc(cmdtxt);


            int cksend = 0;
            string subject_email = subject;
            MailMessage msg = new MailMessage();
            msg.Subject = "[" + _br_nam + "]-" + subject_email;
            msg.Body = body.ToString().Trim();

            msg.IsBodyHtml = true;

            msg.To.Add(sendto);

            msg.From = new MailAddress(dseml.Tables[0].Rows[0]["com_smtpfrm"].ToString().Trim());

            SmtpClient SmtpServer = new SmtpClient();

            SmtpServer.Host = dseml.Tables[0].Rows[0]["com_smtp"].ToString().Trim();
            SmtpServer.Port = Convert.ToInt32(dseml.Tables[0].Rows[0]["com_smtpport"]);
            SmtpServer.EnableSsl = Convert.ToBoolean(dseml.Tables[0].Rows[0]["com_smtpssl"]);
            SmtpServer.Credentials = new System.Net.NetworkCredential(dseml.Tables[0].Rows[0]["com_smtpuid"].ToString().Trim(), dseml.Tables[0].Rows[0]["com_smtppwd"].ToString().Trim());
            SmtpServer.Send(msg);

          //  SendSocket(_br_id, _br_nam, _mcomp_id, MSGCAT, subject);

            return cksend;


        }
        //Email End
        ///Socket Start
        //private void SendSocket(string brid, string brnam, int mcomp_id, string msgcat, string msg)
        //{
        //    //string cmdtxt = "select t_mcomp.br_id,br_nam from t_mcomp inner join m_br on t_mcomp.br_id=m_br.br_id where mcomp_id=" + mcomp_id+"";
        //    //DataSet ds = dsfunc(cmdtxt);
        //    //string brid= ds.Tables[0].Rows[0]["br_id"].ToString().Trim();
        //    //string brnam = ds.Tables[0].Rows[0]["br_nam"].ToString().Trim();


        //    Newtonsoft.Json.Linq.JObject jsonmsg = new Newtonsoft.Json.Linq.JObject();
        //    jsonmsg["branchid"] = brid.Trim();
        //    jsonmsg["branchname"] = brnam;
        //    jsonmsg["messagedate"] = DateTime.Now;
        //    jsonmsg["messagecategory"] = msgcat;
        //    jsonmsg["message"] = msg;
        //    var socket = IO.Socket("https://mmc-attendancechat.herokuapp.com/");
        //    socket.On(Socket.EVENT_CONNECT, () =>
        //    {
        //        socket.Emit("complain_dashboard", jsonmsg);
        //        socket.Disconnect();
        //    });

        //}
        //Fetch Socket End
    }
}