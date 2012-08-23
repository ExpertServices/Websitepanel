using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.Installer.Core
{
	class ServiceComponentNotFoundException : Exception
	{
		private string p;

		public ServiceComponentNotFoundException(string p)
			: base(p)
		{
		}
	}
}
