Class INTEROP.InteroperabilityProject.UnitTest.GHADTUnitTest Extends LN.UnitTest.RuleSet.HL7
{

/// <pre>
/// Copyright (c) Alex Woodhead 2022
/// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
/// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
/// License MIT
/// Source: https://github.com/alexatwoodhead/UnitTest_RuleSet
/// Version: 1.0
/// </pre>]]>
/// To run a Unit Test from console.
/// <example>
/// d ##class(INTEROP.InteroperabilityProject.UnitTest.GHADTUnitTest).Debug()
/// </example>
Parameter TestSuite = "GH-HL7ADT";

/// Override for different schema
Parameter HL7Schema = "2.5.1:ADT_A01";

/// Override with name of existing service on production
Parameter SourceBusinessServiceName = "GHAdtTcpInbound";

/// Override with name of existing business process routing engine on production
Parameter TargetConfigName = "GHAdtRouter";

/// Primary routing process name on production
Parameter PrimaryRoutingProcessName = "GHAdtRouter";

/// Secondary routing process name on production
Parameter SecondaryRoutingProcessName = "DataWarehouseHL7Outbound-GH";

Parameter AssigningAuthority = "GH";

Parameter NewLine = 10;

Method TestMessageA01()
{
        Set ReturnA01 = ..#PrimaryRoutingProcessName_":DataWarehouseHL7Outbound-GH"
        #dim message as EnsLib.HL7.Message

        // Load new HL7Message per UnitTest
        set ..HL7Message=..GetMessage("SourceMessageA01")
        quit:'$IsObject(..HL7Message) $$$ERROR(5001,"Failed to correlate Xdata for Source Message")
        set routingProcess = ..#PrimaryRoutingProcessName

        set message=..HL7Message.%ConstructClone(1)
        do message.PokeDocType(message.DocType)
        do message.SetValueAt("SYSA","MSH:3.1")

        set expectSuccess=1
        set expectReturn="send:"_ReturnA01
        set expectReason="rule#8"
        
        do ..SendMessageToRouter(message,"TestMessageA01",routingProcess, expectSuccess, expectReturn, expectReason)
}

XData SourceMessageA01
{
<test><![CDATA[
        MSH|^~\&|AccMgr|1|||20050110045504+0700||ADT^A01|599102|P|2.3||| 
        EVN|A01|20050110045502+0700||||| 
        PID|1||10006579^^^1^MR^1||DUCK^DONALD^D||19241010|M||1|111 DUCK ST^^FOWL^CA^999990000^^M|1|8885551212|8885551212|1|2||40007716^^^AccMgr^VN^1|123121234|||||||||||NO 
        NK1|1|DUCK^HUEY|SO|3583 DUCK RD^^FOWL^CA^999990000|8885552222||Y|||||||||||||| 
        PV1|1|I|PREOP^101^1^1^^^S|3|||37^DISNEY^WALT^^^^^^AccMgr^^^^CI|||01||||1|||37^DISNEY^WALT^^^^^^AccMgr^^^^CI|2|40007716^^^AccMgr^VN|4|||||||||||||||||||1||G|||20050110045502+0700|||||| 
        GT1|1|8291|DUCK^DONALD^D||111^DUCK ST^^FOWL^CA^999990000|8885551212||19241010|M||1|123121234||||#Cartoon Ducks Inc|111^DUCK ST^^FOWL^CA^999990000|8885551212||PT| 
        DG1|1|I9|71596^OSTEOARTHROS NOS-L/LEG ^I9|OSTEOARTHROS NOS-L/LEG ||A| 
        IN1|1|MEDICARE|3|MEDICARE|||||||Cartoon Ducks Inc|19891001|||4|DUCK^DONALD^D|1|19241010|111^DUCK ST^^FOWL^CA^999990000|||||||||||||||||123121234A||||||PT|M|111 DUCK ST^^FOWL^CA^999990000|||||8291 
        IN2|1||123121234|Cartoon Ducks Inc|||123121234A|||||||||||||||||||||||||||||||||||||||||||||||||||||||||8885551212 
        IN1|2|NON-PRIMARY|9|MEDICAL MUTUAL CALIF.|PO BOX 94776^^HOLLYWOOD^CA^441414776||8003621279|PUBSUMB|||Cartoon Ducks Inc||||7|DUCK^DONALD^D|1|19241010|111 DUCK ST^^FOWL^CA^999990000|||||||||||||||||056269770||||||PT|M|111^DUCK ST^^FOWL^CA^999990000|||||8291 
        IN2|2||123121234|Cartoon Ducks Inc||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||8885551212 
        IN1|3|SELF PAY|1|SELF PAY|||||||||||5||1
]]></test>
}

}
