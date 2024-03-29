﻿#region License
/*
 * NReco library (http://nreco.googlecode.com/)
 * Copyright 2008,2009 Vitaliy Fedorchenko
 * Distributed under the LGPL licence
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#endregion

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using NReco;
using NReco.Logging;
using Lucene.Net;
using Lucene.Net.Documents;

namespace NReco.Lucene {
	
	/// <summary>
	/// Composes lucene Document from abstract data context.
	/// </summary>
	public class DocumentComposer : IProvider<object,Document> {
		
		static ILog log = LogManager.GetLogger(typeof(DocumentComposer));

		public const string UidFieldName = "uid";

		public FieldDescriptor[] Fields { get; set; }

		public IProvider<object, string> UidProvider { get; set; }

		public Document Provide(object context) {
			var doc = new Document();
			var uid = UidProvider.Provide(context);
			if (uid == null)
				return null; // no UID - no document
			doc.Add(new Field(UidFieldName, uid, Field.Store.YES, Field.Index.NOT_ANALYZED_NO_NORMS));
			foreach (var fldDescr in Fields) {
				try {
					var value = fldDescr.Provider.Provide(context);
					var fld = new Field(fldDescr.Name, value, fldDescr.CalcStore(), fldDescr.CalcIndex() );
					if (fldDescr.Boost.HasValue)
						fld.SetBoost(fldDescr.Boost.Value);
					doc.Add(fld);
				} catch (Exception ex) {
					log.Write( LogEvent.Error, "Cannot compose field (name={2}) for document (UID={0}): {1}", uid, ex, fldDescr.Name);
					throw new Exception(String.Format( "Cannot compose field (name={2}) for document (UID={0}): {1}", uid,ex.Message,fldDescr.Name),ex);
				}
				
			}
			return doc;
		}

		public class FieldDescriptor {
			public string Name { get; set; }
			public bool Store { get; set; }
			public bool Compress { get; set; }
			public bool Index { get; set; }
			public bool Analyze { get; set; }
			public bool Normalize { get; set; }
			public float? Boost { get; set; }

			public IProvider<object, string> Provider { get; set; }

			internal Field.Store CalcStore() {
				return Store ? (Compress ? Field.Store.COMPRESS : Field.Store.YES) : Field.Store.NO;
			}

			internal Field.Index CalcIndex() {
				if (!Index) return Field.Index.NO;
				if (Analyze)
					return Normalize ? Field.Index.ANALYZED : Field.Index.ANALYZED_NO_NORMS;
				else
					return Normalize ? Field.Index.NOT_ANALYZED : Field.Index.NOT_ANALYZED_NO_NORMS;
			}
		}

	}

}
