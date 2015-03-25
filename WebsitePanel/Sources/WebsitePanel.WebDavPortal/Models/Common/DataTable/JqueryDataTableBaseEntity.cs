using System.Collections;
using System.Collections.Generic;

namespace WebsitePanel.WebDavPortal.Models.Common.DataTable
{
    public abstract class JqueryDataTableBaseEntity 
    {
        public abstract dynamic this[int index]
        {
            get; 
        }
    }
}