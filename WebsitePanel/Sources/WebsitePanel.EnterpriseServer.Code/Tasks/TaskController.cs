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
                DataProvider.GetBackgroundTask(taskId));

            if (task == null)
            {
                return null;
            }

            task.Params = GetTaskParams(task.Id);

            return task;
        }

        public static List<BackgroundTask> GetScheduleTasks(int scheduleId)
        {
            return ObjectUtils.CreateListFromDataReader<BackgroundTask>(
                DataProvider.GetScheduleBackgroundTasks(scheduleId));
        }

        public static List<BackgroundTask> GetTasks()
        {
            var user = SecurityContext.User;

            return GetTasks(user.IsPeer ? user.OwnerId : user.UserId);
        }

        public static List<BackgroundTask> GetTasks(int actorId)
        {
            return ObjectUtils.CreateListFromDataReader<BackgroundTask>(
                DataProvider.GetBackgroundTasks(actorId));
        }

        public static List<BackgroundTask> GetTasks(Guid guid)
        {
            return ObjectUtils.CreateListFromDataReader<BackgroundTask>(
                DataProvider.GetBackgroundTasks(guid));
        }

        public static List<BackgroundTask> GetProcessTasks(BackgroundTaskStatus status)
        {
            return ObjectUtils.CreateListFromDataReader<BackgroundTask>(
                DataProvider.GetProcessBackgroundTasks(status));
        }

        public static BackgroundTask GetTopTask(Guid guid)
        {
            BackgroundTask task = ObjectUtils.FillObjectFromDataReader<BackgroundTask>(
                DataProvider.GetBackgroundTopTask(guid));

            if (task == null)
            {
                return null;
            }

            task.Params = GetTaskParams(task.Id);

            return task;
        }

        public static int AddTask(BackgroundTask task)
        {
            int taskId = DataProvider.AddBackgroundTask(task.Guid, task.TaskId, task.ScheduleId, task.PackageId, task.UserId,
                                                        task.EffectiveUserId, task.TaskName, task.ItemId, task.ItemName,
                                                        task.StartDate, task.IndicatorCurrent, task.IndicatorMaximum,
                                                        task.MaximumExecutionTime, task.Source, task.Severity, task.Completed,
                                                        task.NotifyOnComplete, task.Status);

            AddTaskParams(taskId, task.Params);

            DataProvider.AddBackgroundTaskStack(taskId);

            return taskId;
        }

        public static void UpdateTaskWithParams(BackgroundTask task)
        {
            if (UpdateTask(task))
            {
                UpdateBackgroundTaskParams(task);
            }
        }

        public static bool UpdateTask(BackgroundTask task)
        {
            if (task.Status == BackgroundTaskStatus.Abort)
            {
                DeleteBackgroundTasks(task.Guid);

                return false;
            }

            if (task.Completed)
            {
                DeleteBackgroundTask(task.Id);

                return false;
            }

            DataProvider.UpdateBackgroundTask(task.Guid, task.Id, task.ScheduleId, task.PackageId, task.TaskName, task.ItemId,
                                              task.ItemName, task.FinishDate, task.IndicatorCurrent,
                                              task.IndicatorMaximum, task.MaximumExecutionTime, task.Source,
                                              task.Severity, task.Completed, task.NotifyOnComplete, task.Status);

            return true;
        }

        public static void UpdateBackgroundTaskParams(BackgroundTask task)
        {
            DataProvider.DeleteBackgroundTaskParams(task.Id);

            AddTaskParams(task.Id, task.Params);
        }

        public static void DeleteBackgroundTasks(Guid guid)
        {
            DataProvider.DeleteBackgroundTasks(guid);
        }

        public static void DeleteBackgroundTask(int id)
        {
            DataProvider.DeleteBackgroundTask(id);
        }

        public static void AddTaskParams(int taskId, List<BackgroundTaskParameter> parameters)
        {
            foreach (BackgroundTaskParameter param in SerializeParams(parameters))
            {
                DataProvider.AddBackgroundTaskParam(taskId, param.Name, param.SerializerValue, param.TypeName);
            }
        }

        public static List<BackgroundTaskParameter> GetTaskParams(int taskId)
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

        public static List<BackgroundTaskLogRecord> GetLogs(BackgroundTask task, DateTime startLogTime)
        {
            if (startLogTime <= task.StartDate)
            {
                startLogTime = task.StartDate;
            }

            List<BackgroundTaskLogRecord> logs = ObjectUtils.CreateListFromDataReader<BackgroundTaskLogRecord>(
                DataProvider.GetBackgroundTaskLogs(task.Id, startLogTime));

            foreach (BackgroundTaskLogRecord log in logs)
            {
                log.TextParameters = ReBuildParametersXml(log.XmlParameters);
            }

            return logs;
        }

        private static List<BackgroundTaskParameter> SerializeParams(List<BackgroundTaskParameter> parameters)
        {
            foreach (BackgroundTaskParameter param in parameters)
            {
                var type = param.Value.GetType();
                param.TypeName = type.FullName;

                XmlSerializer serializer = new XmlSerializer(type);
                MemoryStream ms = new MemoryStream();
                serializer.Serialize(ms, param.Value);

                ms.Position = 0;
                StreamReader sr = new StreamReader(ms);

                param.SerializerValue = sr.ReadToEnd();
            }

            return parameters;
        }

        private static List<BackgroundTaskParameter> DeserializeParams(List<BackgroundTaskParameter> parameters)
        {
            foreach (BackgroundTaskParameter param in parameters)
            {
                XmlSerializer deserializer = new XmlSerializer(Type.GetType(param.TypeName));
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
            var textParameters = new List<string>();

            var xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(parameters);

            if (xmlDoc != null)
            {
                textParameters.AddRange(from XmlNode xmlParameter in xmlDoc.SelectNodes("parameters/parameter") select xmlParameter.Attributes.GetNamedItem("value").Value);
            }

            return textParameters.ToArray();
        }
    }
}

