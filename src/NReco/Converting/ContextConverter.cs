#region License
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
using System.Collections;
using System.Collections.Generic;
using System.Text;
using NReco.Collections;

namespace NReco.Converting {

	/// <summary>
	/// Context converter.
	/// </summary>
    public class ContextConverter : ITypeConverter
    {

		public ContextConverter() {
		}

		public virtual bool CanConvert(Type fromType, Type toType) {
			if (!typeof(Context).IsAssignableFrom(fromType))
				return false;
			if (toType == typeof(IDictionary) )
				return true;
			if (toType==typeof(IDictionary<string,object>))
				return true;
			return false;
		}

		public virtual object Convert(object o, Type toType) {
			if (o is Context) {
				if (toType == typeof(IDictionary))
					return new DictionaryWrapper<string,object>(
							new ObjectDictionaryWrapper(o) );
				if (toType == typeof(IDictionary<string,object>)) {
					return new ObjectDictionaryWrapper(o);
				}
			}
			throw new InvalidCastException();
		}

	}

}
