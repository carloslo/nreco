using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using NUnit.Framework;
using NReco;
using NReco.Composition;
using NReco.Collections;
using NReco.OGNL;

namespace NReco.Tests {

	[TestFixture]
	public class OgnlTests {

		[Test]
		public void Ognl() {
			OgnlExprProvider ognlPrv = new OgnlExprProvider();
			var cntx = new Dictionary<string,object>();
			cntx["a"] = 7;
			object res = ognlPrv.Provide(new ExpressionContext<string>("@Convert@ToInt32(\"2\")+#a",cntx) ); 
			Assert.AreEqual(9,res);

			EvalOgnlCode evalOgnl = new EvalOgnlCode();
			IProvider<IDictionary<string,object>,bool> evalOgnlCond = evalOgnl;
			evalOgnl.Code = "null";
			Assert.AreEqual(false, evalOgnlCond.Provide(cntx) );
			evalOgnl.Code = "#a==7";
			Assert.AreEqual(true, evalOgnlCond.Provide(cntx) );
		}




	}
}
