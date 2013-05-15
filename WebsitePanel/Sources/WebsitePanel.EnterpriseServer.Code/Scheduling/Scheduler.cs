// Copyright (c) 2012, Outercurve Foundation.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// - Redistributions of source code must  retain  the  above copyright notice, this
//   list of conditions and the following disclaimer.
//
// - Redistributions in binary form  must  reproduce the  above  copyright  notice,
//   this list of conditions  and  the  following  disclaimer in  the documentation
//   and/or other materials provided with the distribution.
//
// - Neither  the  name  of  the  Outercurve Foundation  nor   the   names  of  its
//   contributors may be used to endorse or  promote  products  derived  from  this
//   software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT  NOT  LIMITED TO, THE IMPLIED
// WARRANTIES  OF  MERCHANTABILITY   AND  FITNESS  FOR  A  PARTICULAR  PURPOSE  ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL,  SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO,  PROCUREMENT  OF  SUBSTITUTE  GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)  HOWEVER  CAUSED AND ON
// ANY  THEORY  OF  LIABILITY,  WHETHER  IN  CONTRACT,  STRICT  LIABILITY,  OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING  IN  ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

using System;
using System.IO;
using System.Threading;
using System.Collections;
using System.Diagnostics;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;

namespace WebsitePanel.EnterpriseServer
{
    public delegate void ScheduleFinished(SchedulerJob schedule);

    public sealed class Scheduler
    {
        public static SchedulerJob nextSchedule = null;

        // main timer and put it to sleep
        static Timer scheduleTimer = new Timer(new TimerCallback(RunNextSchedule),
                                            null,
                                            Timeout.Infinite,
                                            Timeout.Infinite);

        public static void Start()
        {
            // schedule tasks
            ScheduleTasks();
        }

        public static bool IsScheduleActive(int scheduleId)
        {
            Dictionary<int, BackgroundTask> scheduledTasks = TaskManager.GetScheduledTasks();

            ScheduleInfo scheduleInfo = SchedulerController.GetSchedule(scheduleId);

            return scheduledTasks.ContainsKey(scheduleId) || scheduleInfo.LastRun > scheduleInfo.LastFinish;
        }

        public static void StartSchedule(SchedulerJob schedule)
        {
            if (IsScheduleActive(schedule.ScheduleInfo.ScheduleId))
                return;

            // run schedule
            RunSchedule(schedule, false);
        }

        public static void StopSchedule(SchedulerJob schedule)
        {
            Dictionary<int, BackgroundTask> scheduledTasks = TaskManager.GetScheduledTasks();
            if (!scheduledTasks.ContainsKey(schedule.ScheduleInfo.ScheduleId))
                return;

            BackgroundTask activeTask = scheduledTasks[schedule.ScheduleInfo.ScheduleId];
            TaskManager.StopTask(activeTask.TaskId);
        }

        public static void ScheduleTasks()
        {
            nextSchedule = SchedulerController.GetNextSchedule();

            // set timer
            if (nextSchedule != null)
            {
                if (nextSchedule.ScheduleInfo.NextRun <= DateTime.Now)
                {
                    // this will put the timer to sleep
                    scheduleTimer.Change(Timeout.Infinite, Timeout.Infinite);

                    System.Threading.Thread.Sleep(1000);

                    // run immediately
                    RunNextSchedule(null);
                }
                else
                {
                    // set timer
                    TimeSpan ts = nextSchedule.ScheduleInfo.NextRun.Subtract(DateTime.Now);
                    if (ts < TimeSpan.Zero)
                        ts = TimeSpan.Zero; // cannot be negative !

                    // invoke after the timespan
                    scheduleTimer.Change((long)ts.TotalMilliseconds, Timeout.Infinite);
                }
            }
        }

        // call back for the timer function
        static void RunNextSchedule(object obj) // obj ignored
        {
            if (nextSchedule == null)
                return;

            RunSchedule(nextSchedule, true);

            // schedule next task
            ScheduleTasks();
        }

        static void RunSchedule(SchedulerJob schedule, bool changeNextRun)
        {
            try
            {
                // update next run (if required)
                if (changeNextRun)
                {
                    SchedulerController.CalculateNextStartTime(schedule.ScheduleInfo);
                }

                // disable run once task
                if (schedule.ScheduleInfo.ScheduleType == ScheduleType.OneTime)
                    schedule.ScheduleInfo.Enabled = false;

                Dictionary<int, BackgroundTask> scheduledTasks = TaskManager.GetScheduledTasks();
                if (!scheduledTasks.ContainsKey(schedule.ScheduleInfo.ScheduleId))
                    // this task should be run, so
                    // update its last run
                    schedule.ScheduleInfo.LastRun = DateTime.Now;

                // update schedule
                int MAX_RETRY_COUNT = 10;
                int counter = 0;
                while (counter < MAX_RETRY_COUNT)
                {
                    try
                    {
                        SchedulerController.UpdateSchedule(schedule.ScheduleInfo);
                        break;
                    }
                    catch (SqlException)
                    {
                        System.Threading.Thread.Sleep(1000);
                    }

                    counter++;
                }

                // skip execution if the current task is still running
                scheduledTasks = TaskManager.GetScheduledTasks();
                if (!scheduledTasks.ContainsKey(schedule.ScheduleInfo.ScheduleId))
                {
                    // run the schedule in the separate thread
                    schedule.Run();
                }
            }
            catch (Exception Ex)
            {
                try
                {
                    TaskManager.WriteError(string.Format("RunSchedule Error : {0}", Ex.Message));
                }
                catch (Exception)
                {
                }
            }
        }
    }
}
