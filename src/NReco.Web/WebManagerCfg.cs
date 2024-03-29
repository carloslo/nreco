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
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Configuration;

namespace NReco.Web {
	
	/// <summary>
	/// Web manager configuration.
	/// </summary>
	public class WebManagerCfg {

		public string ServiceProviderContextKey { get; set;}

		public string ActionDispatcherName { get; set; }

		public string HttpRoot { get; set; }

		public string LabelFilterName { get; set; }

		public WebManagerCfg() {
			ServiceProviderContextKey = "__service_provider";
			ActionDispatcherName = "webActionDispatcher";
			HttpRoot = null;
			LabelFilterName = null;
		}

	}
}
