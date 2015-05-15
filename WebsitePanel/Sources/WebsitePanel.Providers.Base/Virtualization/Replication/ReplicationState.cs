
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.Providers.Virtualization
{
    public enum ReplicationState
    {
        Disabled,
        Error,
        FailOverWaitingCompletion,
        FailedOver,
        NotApplicable,
        ReadyForInitialReplication,
        InitialReplicationInProgress,
        Replicating,
        Resynchronizing,
        ResynchronizeSuspended,
        Suspended,
        SyncedReplicationComplete,
        WaitingForInitialReplication,
        WaitingForStartResynchronize,
    }
}
