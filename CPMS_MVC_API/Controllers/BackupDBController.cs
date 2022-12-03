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
using System.IO;
using ICSharpCode.SharpZipLib.Zip;
using Microsoft.SqlServer.Management.Smo;
using System.Web;
using System.Net.Http.Headers;

namespace CPMS_MVC_API.Controllers
{
    public class BackupDBController : ApiController
    {
        SqlCommand cmd = new SqlCommand();
        SqlParameter param = new SqlParameter();
        SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();
        DataTable dt = new DataTable();
        Functions func = new Functions();

        //Create Backup Start
        [HttpPost]
        [Route("~/BackupDB/DBBackupCreate")]
        public async Task<Object> DBBackupCreate([FromBody] dynamic dataResult)
        {
            DataTable dttblusrgp_ins = new DataTable();

            dttblusrgp_ins.Columns.Add("Remarks", typeof(string));
            dttblusrgp_ins.Columns.Add("status", typeof(int));
            var JSONResult = "";
            string strdata, strsrv, name1;
            try
            {
                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {

                    string filepath = System.Web.Hosting.HostingEnvironment.MapPath("~\\db_backup");
                    //Check Folder
                    if (!Directory.Exists(filepath))
                    {
                        Directory.CreateDirectory(filepath);
                        //Directory.CreateDirectory(Server.MapPath("~\\db_backup"));
                    }
                    string str = System.Configuration.ConfigurationManager.ConnectionStrings["IFS_local"].ToString();
                    string[] _str = str.Split(';');
                    int SRV_index = _str[0].IndexOf('=') + 1;
                    int DB_index = _str[1].IndexOf('=') + 1;

                    strsrv = _str[0].Substring(SRV_index, _str[0].Length - SRV_index); // System.Configuration.ConfigurationManager.ConnectionStrings["IFS_local"].ToString();
                    strdata = _str[1].Substring(DB_index, _str[1].Length - DB_index);// "pagey";// System.Configuration.ConfigurationManager.ConnectionStrings["IFS_local"].ToString();

                    name1 = strdata + "_" + DateTime.Now.Year + DateTime.Now.Month.ToString("d2") + DateTime.Now.Day.ToString("d2") + "_" + DateTime.Now.Hour.ToString("d2") + DateTime.Now.Minute.ToString("d2") + DateTime.Now.Second + DateTime.Now.Millisecond;


                    string name = name1 + ".BAK";


                    SqlConnection sqlcon = new SqlConnection(func.con().ConnectionString);
                    Microsoft.SqlServer.Management.Common.ServerConnection srv = new Microsoft.SqlServer.Management.Common.ServerConnection();
                    srv.ConnectionString = func.con().ConnectionString;

                    Server op_srv = new Server(srv);
                    DatabaseCollection dbcollection = op_srv.Databases;

                    Database db = default(Database);
                    db = op_srv.Databases[strdata];

                    Backup bkp = new Backup();

                    bkp.Devices.AddDevice(filepath + "\\" + name, DeviceType.File);
                    bkp.Database = strdata;
                    bkp.Action = BackupActionType.Database;
                    bkp.Initialize = true;
                    bkp.PercentCompleteNotification = 1;
                    bkp.SqlBackup(op_srv);

                    //Zip
                    FastZip fz = new FastZip();
                    fz.CreateZip(filepath + "\\" + name1 + ".ZIP", filepath, false, name);

                    //Delete BAK
                    FileInfo fi = new FileInfo(filepath + "\\" + name1 + ".BAK");
                    fi.Delete();

                    dttblusrgp_ins.Rows.Add("Backup Complete : " + name1, 1);
                }
                else
                {
                    dttblusrgp_ins.Rows.Add("Invalid User", 0);
                }
            }
            catch (Exception e)
            {
                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblusrgp_ins.Rows.Add("Error : " + e.Message + innerexp, 0);
            }
            JSONResult = JsonConvert.SerializeObject(dttblusrgp_ins);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //Create Backup End

        //Show Backup Start
        [HttpPost]
        [Route("~/BackupDB/DBBackupShow")]
        public async Task<Object> DBBackupShow([FromBody] dynamic dataResult)
        {
            DataTable dttblusrgp_ins = new DataTable();

            dttblusrgp_ins.Columns.Add("Remarks", typeof(string));
            dttblusrgp_ins.Columns.Add("status", typeof(int));
            dttblusrgp_ins.Columns.Add("Result", typeof(object));
            var JSONResult = "";
            string strdata, strsrv, name1;
            try
            {
                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {
                    DataTable dt_file = new DataTable();
                    dt_file.Columns.Add("SNO", typeof(int));
                    dt_file.Columns.Add("DATE", typeof(string));
                    dt_file.Columns.Add("TIME", typeof(string));
                    dt_file.Columns.Add("FILE", typeof(string));
                    dt_file.Columns.Add("MB", typeof(double));


                    string filepath = System.Web.Hosting.HostingEnvironment.MapPath("~\\db_backup");
                    string[] filePaths = Directory.GetFiles(filepath);
                    if (filePaths.Length > 0)
                    {
                        int sno = 1;
                        for (int i = 0; i < filePaths.Length; i++)
                        {

                            DataRow dr = dt_file.NewRow();
                            DateTime filedate = new DateTime();
                            filedate = File.GetLastWriteTime(filepath + "\\" + Path.GetFileName(filePaths[i]));
                            FileInfo finfo = new FileInfo(filepath + "\\" + Path.GetFileName(filePaths[i]));
                            double filesize = (finfo.Length / 1024) / 1024;
                            dt_file.Rows.Add(sno, filedate.ToString("dd - MMM - yyyy"), filedate.ToShortTimeString(), Path.GetFileName(filePaths[i]), Convert.ToDouble(filesize));
                            sno += 1;
                        }
                    }
                    if (dt_file.Rows.Count > 0)
                    {
                        dttblusrgp_ins.Rows.Add("No of Backup found : " + dt_file.Rows.Count.ToString(), 1, dt_file);
                    }
                    else
                    {
                        dttblusrgp_ins.Rows.Add("Backup not found", 0, null);
                    }
                }
                else
                {
                    dttblusrgp_ins.Rows.Add("Invalid User", 0, null);
                }
            }
            catch (Exception e)
            {
                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblusrgp_ins.Rows.Add("Error : " + e.Message + innerexp, 0, null);
            }
            JSONResult = JsonConvert.SerializeObject(dttblusrgp_ins);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //Show Backup End


        //Delete Backup File Start
        [HttpPost]
        [Route("~/BackupDB/DBBackupDelete")]
        public async Task<Object> DBBackupDelete([FromBody] dynamic dataResult)
        {
            DataTable dttblusrgp_ins = new DataTable();

            dttblusrgp_ins.Columns.Add("Remarks", typeof(string));
            dttblusrgp_ins.Columns.Add("status", typeof(int));
            var JSONResult = "";
            string strdata, strsrv, name1;
            try
            {
                string[] strusr = func.checkuser(dataResult);
                if (Convert.ToBoolean(strusr[0]))
                {
                    string _FileName = dataResult.FileName;
                    if (_FileName.Trim() == "")
                    {
                        dttblusrgp_ins.Rows.Add("File not found", 0);
                    }
                    else
                    {
                        string filepath = System.Web.Hosting.HostingEnvironment.MapPath("~\\db_backup");
                        string FileName = filepath + "//" + _FileName;
                        System.IO.FileInfo fi = new FileInfo(FileName);
                        fi.Delete();
                        dttblusrgp_ins.Rows.Add("Backup : " + _FileName + " Deleted", 1);
                    }
                }
                else
                {
                    dttblusrgp_ins.Rows.Add("Invalid User", 0);
                }
            }
            catch (Exception e)
            {
                string innerexp = "";
                if (e.InnerException != null)
                {
                    innerexp = " Inner Error : " + e.InnerException.ToString();
                }
                dttblusrgp_ins.Rows.Add("Error : " + e.Message + innerexp, 0);
            }
            JSONResult = JsonConvert.SerializeObject(dttblusrgp_ins);
            return JsonConvert.DeserializeObject<object>(JSONResult);
        }
        //Delete Backup File End

      

    }
}
