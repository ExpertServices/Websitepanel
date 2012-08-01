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
using System.Collections.Generic;
using System.Text;

namespace WebsitePanel.Providers.HostedSolution
{
    public class LyncUserPlan
    {
        int lyncUserPlanId;
        string lyncUserPlanName;

        bool im;
        bool federation;
        bool conferencing;
        bool enterpriseVoice;
        bool mobility;
        bool mobilityEnableOutsideVoice;
        LyncVoicePolicyType voicePolicy;

        bool isDefault;

        public int LyncUserPlanId
        {
            get { return this.lyncUserPlanId; }
            set { this.lyncUserPlanId = value; }
        }

        public string LyncUserPlanName
        {
            get { return this.lyncUserPlanName; }
            set { this.lyncUserPlanName = value; }
        }

        public bool IM
        {
            get { return this.im; }
            set { this.im = value; }
        }

        public bool IsDefault
        {
            get { return this.isDefault; }
            set { this.isDefault = value; }
        }

        public bool Federation
        {
            get { return this.federation; }
            set { this.federation = value; }
        }

        public bool Conferencing
        {
            get { return this.conferencing; }
            set { this.conferencing = value; }
        }

        public bool EnterpriseVoice
        {
            get { return this.enterpriseVoice; }
            set { this.enterpriseVoice = value; }
        }

        public bool Mobility
        {
            get { return this.mobility; }
            set { this.mobility = value; }
        }

        public bool MobilityEnableOutsideVoice
        {
            get { return this.mobilityEnableOutsideVoice; }
            set { this.mobilityEnableOutsideVoice = value; }
        }

        public LyncVoicePolicyType VoicePolicy
        {
            get { return this.voicePolicy; }
            set { this.voicePolicy = value; }
        }


    }
}
