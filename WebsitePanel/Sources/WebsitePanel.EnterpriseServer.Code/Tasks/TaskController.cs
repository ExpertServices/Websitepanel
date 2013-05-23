using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Serialization;

namespace WebsitePanel.EnterpriseServer
{
    public class TaskController
    {
        public static BackgroundTask GetTask(string taskId)
        {
            BackgroundTask task = ObjectUtils.FillObjectFromDataReader<BackgroundTask>(
                DataProvider.GetBackgroundTask(SecurityContext.User.UserId, taskId));

            task.Params = GetTaskParams(task.Id);

            return task;
        }

        public static List<BackgroundTask> GetTasks()
        {
            return ObjectUtils.CreateListFromDataReader<BackgroundTask>(
                DataProvider.GetBackgroundTasks(SecurityContext.User.UserId));
        }

        public static BackgroundTask GetTopTask()
        {
            BackgroundTask task = ObjectUtils.FillObjectFromDataReader<BackgroundTask>(
                DataProvider.GetBackgroundTopTask(SecurityContext.User.UserId));

            task.Params = GetTaskParams(task.Id);

            return task;
        }

        public static void AddTask(BackgroundTask task)
        {
            int taskId = DataProvider.AddBackgroundTask(task.TaskId, task.ScheduleId, task.PackageId, task.UserId,
                                                        task.EffectiveUserId, task.TaskName, task.ItemId, task.ItemName,
                                                        task.StartDate, task.IndicatorCurrent, task.IndicatorMaximum,
                                                        task.MaximumExecutionTime, task.Source, task.Severity, task.Completed,
                                                        task.NotifyOnComplete, task.Status);

            AddTaskParams(taskId, task.Params);

            DataProvider.AddBackgroundTaskStack(taskId);
        }

        public static void UpdateTask(BackgroundTask task)
        {
            DataProvider.UpdateBackgroundTask(task.Id, task.ScheduleId, task.PackageId, task.TaskName, task.ItemId,
                                              task.ItemName, task.FinishDate, task.IndicatorCurrent,
                                              task.IndicatorMaximum, task.MaximumExecutionTime, task.Source,
                                              task.Severity, task.Completed, task.NotifyOnComplete, task.Status);

            AddTaskParams(task.Id, task.Params);

            if (task.Completed)
            {
                DeleteTaskStack(task.Id);
            }
        }

        public static void DeleteTaskStack(int taskId)
        {
            DataProvider.DeleteBackgroundTaskParams(taskId);
        }

        public static void AddTaskParams(int taskId, IList<BackgroundTaskParameter> parameters)
        {
            foreach (BackgroundTaskParameter param in SerializeParams(parameters))
            {
                DataProvider.AddBackgroundTaskParam(taskId, param.Name, param.SerializerValue);
            }
        }

        public static IList<BackgroundTaskParameter> GetTaskParams(int taskId)
        {
            List<BackgroundTaskParameter> parameters = ObjectUtils.CreateListFromDataReader<BackgroundTaskParameter>(
                DataProvider.GetBackgroundTaskParams(taskId));

            return DeserializeParams(parameters);
        }

        public static void AddLog(BackgroundTaskLogRecord log)
        {
            DataProvider.AddBackgroundTaskLog(log.TaskId, log.Date, log.ExceptionStackTrace, log.InnerTaskStart,
                                              log.Severity, log.Text, log.TextIdent, BuildParametersXml(log.TextParameters));
        }

        public static List<BackgroundTaskLogRecord> GetLogs(int taskId, DateTime startLogTime)
        {
            List<BackgroundTaskLogRecord> logs = ObjectUtils.CreateListFromDataReader<BackgroundTaskLogRecord>(
                DataProvider.GetBackgroundTaskLogs(taskId, startLogTime));

            foreach (BackgroundTaskLogRecord log in logs)
            {
                log.TextParameters = ReBuildParametersXml(log.XmlParameters);
            }
            
            return logs;
        }

        private static IList<BackgroundTaskParameter> SerializeParams(IList<BackgroundTaskParameter> parameters)
        {
            foreach (BackgroundTaskParameter param in parameters)
            {
                XmlSerializer serializer = new XmlSerializer(param.Value.GetType());
                MemoryStream ms = new MemoryStream();
                serializer.Serialize(ms, param.Value);

                ms.Position = 0;
                StreamReader sr = new StreamReader(ms);

                param.SerializerValue = sr.ReadToEnd();
            }

            return parameters;
        }

        private static IList<BackgroundTaskParameter>  DeserializeParams(IList<BackgroundTaskParameter> parameters)
        {
            foreach (BackgroundTaskParameter param in parameters)
            {
                XmlSerializer deserializer = new XmlSerializer(param.Value.GetType());
                StringReader sr = new StringReader(param.SerializerValue);

                param.Value = deserializer.Deserialize(sr);
            }

            return parameters;
        }

        private static string BuildParametersXml(string[] parameters)
        {
            XmlDocument xmlDoc = new XmlDocument();
            XmlElement nodeProps = xmlDoc.CreateElement("parameters");

            if (parameters != null)
            {
                foreach (string parameter in parameters)
                {
                    XmlElement nodeProp = xmlDoc.CreateElement("parameter");
                    nodeProp.SetAttribute("value", parameter);
                    nodeProps.AppendChild(nodeProp);
                }
            }
            return nodeProps.OuterXml;
        }

        private static string[] ReBuildParametersXml(string parameters)
        {
            string[] textParameters = new string[] {};

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(parameters);

            if (xmlDoc != null)
            {
                int index = 0;
                foreach (XmlNode xmlParameter in xmlDoc.SelectNodes("parameters/parameter"))
                {
                    textParameters[index] = xmlParameter.Attributes.GetNamedItem("value").Value;
                    index++;
                }
            }

            return textParameters;
        }
    }
}
