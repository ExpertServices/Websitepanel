using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.EnterpriseServer.Base.HostedSolution
{
    public class ServiceLevel
    {
        int levelId;
        string levelName;
        string levelDescription;

        public int LevelId
        {
            get { return levelId; }
            set { levelId = value; }
        }

        public string LevelName
        {
            get { return levelName; }
            set { levelName = value; }
        }

        public string LevelDescription
        {
            get { return levelDescription; }
            set { levelDescription = value; }
        }
    }

}
