// Copyright (c) 2015, Outercurve Foundation.
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
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using WebsitePanel.Setup.Actions;

namespace WebsitePanel.Setup

{
    /// <summary>
    /// Release 1.2.1
    /// </summary>
    public class EnterpriseServer121 : EnterpriseServer
    {
        public static new object Install(object obj)
        {
            //
            return EnterpriseServer.InstallBase(obj, "1.2.1");
        }

        public static new DialogResult Uninstall(object obj)
        {
            return EnterpriseServer.Uninstall(obj);
        }

        public static new DialogResult Setup(object obj)
        {
            return EnterpriseServer.Setup(obj);
        }

        public static new DialogResult Update(object obj)
        {
            return UpdateBase(obj, "1.2.1", "1.2.0", true);
        }
    }

    /// <summary>
    /// Release 1.2.0
    /// </summary>
    public class EnterpriseServer120 : EnterpriseServer
    {
        public static new object Install(object obj)
        {
            //
            return EnterpriseServer.InstallBase(obj, "1.1.0");
        }

        public static new DialogResult Uninstall(object obj)
        {
            return EnterpriseServer.Uninstall(obj);
        }

        public static new DialogResult Setup(object obj)
        {
            return EnterpriseServer.Setup(obj);
        }

        public static new DialogResult Update(object obj)
        {
            return UpdateBase(obj, "1.2.0", "1.1.2,1.2.0", true, new InstallAction(ActionTypes.SwitchEntServer2AspNet40));
        }
    }

    /// <summary>
    /// Release 1.1.0
    /// </summary>
    public class EnterpriseServer110 : EnterpriseServer
    {
        public static new object Install(object obj)
        {
            return EnterpriseServer.InstallBase(obj, "1.1.0");
        }

        public static new DialogResult Uninstall(object obj)
        {
            return EnterpriseServer.Uninstall(obj);
        }

        public static new DialogResult Setup(object obj)
        {
            return EnterpriseServer.Setup(obj);
        }

        public static new DialogResult Update(object obj)
        {
            return UpdateBase(obj, "1.1.0", "1.0.2", true);
        }
    }

    /// Release 1.0.2
    /// </summary>
    public class EnterpriseServer102 : EnterpriseServer101
    {
        public static new object Install(object obj)
        {
            return EnterpriseServer101.InstallBase(obj, "1.0.0");
        }

        public static new DialogResult Uninstall(object obj)
        {
            return EnterpriseServer101.Uninstall(obj);
        }

        public static new DialogResult Setup(object obj)
        {
            return EnterpriseServer101.Setup(obj);
        }

        public static new DialogResult Update(object obj)
        {
            return UpdateBase(obj, "1.0.0", "1.0.1", true);
        }
    }

    /// <summary>
    /// Release 1.0.1
    /// </summary>
    public class EnterpriseServer101 : EnterpriseServer10
    {
        public static new object Install(object obj)
        {
            return EnterpriseServer10.InstallBase(obj, "1.0.0");
        }

        public static new DialogResult Uninstall(object obj)
        {
            return EnterpriseServer10.Uninstall(obj);
        }

        public static new DialogResult Setup(object obj)
        {
            return EnterpriseServer10.Setup(obj);
        }

        public static new DialogResult Update(object obj)
        {
            return UpdateBase(obj, "1.0.0", "1.0", true);
        }
    }

    /// <summary>
    /// Release 1.0
    /// </summary>
    public class EnterpriseServer10 : EnterpriseServer
    {
        public static new object Install(object obj)
        {
            return EnterpriseServer.InstallBase(obj, "1.0.0");
        }

        public static new DialogResult Uninstall(object obj)
        {
            return EnterpriseServer.Uninstall(obj);
        }

        public static new DialogResult Setup(object obj)
        {
            return EnterpriseServer.Setup(obj);
        }
    }
}
