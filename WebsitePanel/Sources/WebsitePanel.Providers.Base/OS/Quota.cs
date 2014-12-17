using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebsitePanel.Providers.OS
{
    public class Quota
    {
        #region Fields

        private int _Size;
        private QuotaType _QuotaType;
        private int _Usage;

        #endregion

        #region Properties

        public int Size
        {
            get { return _Size; }
            set { _Size = value; }
        }

        public QuotaType QuotaType
        {
            get { return _QuotaType; }
            set { _QuotaType = value; }
        }

        public int Usage
        {
            get { return _Usage; }
            set { _Usage = value; }
        }

        #endregion

        #region Constructors

        public Quota()
        {
            _Size = -1;
            _QuotaType = QuotaType.Soft;
            _Usage = -1;
        }

        #endregion
    }
}
