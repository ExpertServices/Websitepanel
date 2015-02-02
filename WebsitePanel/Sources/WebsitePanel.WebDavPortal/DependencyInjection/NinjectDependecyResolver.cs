using Ninject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebsitePanel.WebDavPortal.DependencyInjection
{
    public class NinjectDependecyResolver : IDependencyResolver
    {
        IKernel kernal;

        public NinjectDependecyResolver()
        {
            kernal = new StandardKernel(new NinjectSettings { AllowNullInjection = true });
            AddBindings();
        }

        public object GetService(Type serviceType)
        {
            return kernal.TryGet(serviceType);
        }

        public IEnumerable<object> GetServices(Type serviceType)
        {
            return kernal.GetAll(serviceType);
        }

        private void AddBindings()
        {
            PortalDependencies.Configure(kernal);
        }
    }
}