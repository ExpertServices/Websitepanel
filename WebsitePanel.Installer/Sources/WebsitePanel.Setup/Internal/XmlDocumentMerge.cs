using System;
using System.Collections.Generic;
using System.IO;
using System.Xml;
using System.Xml.XPath;

namespace WebsitePanel.Setup.Internal
{
    public static class XmlDocumentMerge
    {
        const string SuccessFormat = "Success: {0}.";
        const string ErrorFormat = "Error: {0}.";
        const string MergeCompleted = "XmlDocumentMerge completed";
        static XmlDocumentMerge()
        {
            KeyAttributes = new List<string> { "name", "id", "key" };
        }
        public static List<string> KeyAttributes { get; set; }
        public static string Process(string Src, string Dst, string SaveTo = "")
        {
            var Result = string.Empty;
            if (!File.Exists(Src))
                Result = string.Format(ErrorFormat, string.Format("source document [{0}] does not exists", Src));
            else if (!File.Exists(Dst))
                Result = string.Format(ErrorFormat, string.Format("destination document [{0}] does not exists", Dst));
            else
            {
                try
                {
                    var InStream = new FileStream(Src, FileMode.Open, FileAccess.Read);
                    var OutStream = new FileStream(Dst, FileMode.Open, FileAccess.ReadWrite);
                    Result = Process(InStream,
                                     OutStream,
                                     SaveTo);
                    InStream.Close();
                    OutStream.Flush();
                    OutStream.Close();
                }
                catch (Exception ex)
                {
                    Result = string.Format(ErrorFormat, ex.ToString());
                }
            }
            return Result;
        }
        public static string Process(Stream InSrc, Stream OutDst, string SaveTo = "")
        {
            var Result = string.Format(SuccessFormat, MergeCompleted);
            try
            {
                var SrcDoc = new XmlDocument();
                SrcDoc.Load(InSrc);
                var DstDoc = new XmlDocument();
                DstDoc.Load(OutDst);
                var DstNavi = DstDoc.CreateNavigator();
                var DstIterator = DstNavi.SelectChildren(XPathNodeType.All);
                while (DstIterator.MoveNext())
                    Merge(DstIterator.Current.Clone(), SrcDoc, string.Empty);
                if (string.IsNullOrWhiteSpace(SaveTo))
                {
                    OutDst.SetLength(0);
                    DstDoc.Save(OutDst);
                }
                else
                    DstDoc.Save(SaveTo);
            }
            catch (Exception ex)
            {
                Result = string.Format(ErrorFormat, ex.ToString());
            }
            return Result;
        }
        private static string NodePath(string Parent, string Current)
        {
            var Result = string.Empty;
            if (!string.IsNullOrWhiteSpace(Parent) && !string.IsNullOrWhiteSpace(Current))
                Result = string.Format("{0}/{1}", Parent, Current);
            else if (!string.IsNullOrWhiteSpace(Parent))
                Result = Parent;
            else if (!string.IsNullOrWhiteSpace(Current))
                Result = Current;
            return Result;
        }
        private static string NodeView(XPathNavigator Navi)
        {
            foreach (var Attr in KeyAttributes)
            {
                var Value = Navi.GetAttribute(Attr, string.Empty);
                if (!string.IsNullOrWhiteSpace(Value))
                    return string.Format("{0}[@{1}='{2}']", Navi.Name, Attr, Value);
            }
            return Navi.Name;
        }
        private static void Merge(XPathNavigator DstNavi, XmlDocument SrcDoc, string Parent)
        {
            if (DstNavi.NodeType == XPathNodeType.Element)
            {
                var SrcElem = SrcDoc.SelectSingleNode(NodePath(Parent, NodeView(DstNavi)));
                if (SrcElem != null)
                {
                    if (DstNavi.MoveToFirstAttribute())
                    {
                        do
                        {
                            var SrcElemAttr = SrcElem.Attributes[DstNavi.LocalName];
                            if (SrcElemAttr != null)
                                DstNavi.SetValue(SrcElemAttr.Value);
                        }
                        while (DstNavi.MoveToNextAttribute());
                        DstNavi.MoveToParent();
                    }
                }
            }
            else if (DstNavi.NodeType == XPathNodeType.Text)
            {
                var SrcElem = SrcDoc.SelectSingleNode(NodePath(Parent, NodeView(DstNavi)));
                if (SrcElem != null)
                    DstNavi.SetValue(SrcElem.InnerText);
            }
            var Here = NodeView(DstNavi);
            if (DstNavi.MoveToFirstChild())
            {
                do
                {
                    Merge(DstNavi, SrcDoc, NodePath(Parent, Here));
                }
                while (DstNavi.MoveToNext());
                DstNavi.MoveToParent();
            }
            else if (DstNavi.NodeType == XPathNodeType.Element)
            {
                var SrcElem = SrcDoc.SelectSingleNode(NodePath(Parent, Here));
                if (SrcElem != null && !string.IsNullOrWhiteSpace(SrcElem.InnerXml))
                    foreach (XmlNode Child in SrcElem.ChildNodes)
                        DstNavi.AppendChild(Child.CloneNode(true).CreateNavigator());
            }
        }
    }
}
