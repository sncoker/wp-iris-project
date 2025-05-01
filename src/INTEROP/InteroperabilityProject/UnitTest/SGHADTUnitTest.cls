Class INTEROP.InteroperabilityProject.UnitTest.SGHADTUnitTest Extends LN.UnitTest.RuleSet.HL7
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
/// d ##class(INTEROP.InteroperabilityProject.UnitTest.SGHADTUnitTest).Debug()
/// </example>
Parameter TestSuite = "SGH-HL7ADT";

/// Override for different schema
Parameter HL7Schema = "2.5.1:ADT_A01";

/// Override with name of existing service on production
Parameter SourceBusinessServiceName = "SGHAdtTcpInbound";

/// Override with name of existing business process routing engine on production
Parameter TargetConfigName = "SGHAdtRouter";

/// Primary routing process name on production
Parameter PrimaryRoutingProcessName = "SGHAdtRouter";

/// Secondary routing process name on production
Parameter SecondaryRoutingProcessName = "DataWarehouseHL7Outbound-SGH";

Parameter AssigningAuthority = "SGH";

Parameter NewLine = 10;

Method TestMessageA01()
{
	Set ReturnA01 = ..#PrimaryRoutingProcessName_":TransformA01"
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

/*
Method TestMessageA02()
{
	Set ReturnA02 = ..#SecondaryRoutingProcessName_":TransformA01"
	#dim message as EnsLib.HL7.Message

    // Load new HL7Message per UnitTest
	set ..HL7Message=..GetMessage("SourceMessageA02")
	quit:'$IsObject(..HL7Message) $$$ERROR(5001,"Failed to correlate Xdata for Source Message")
	
	set routingProcess = ..#PrimaryRoutingProcessName
	set message=..HL7Message.%ConstructClone(1)
	do message.PokeDocType(message.DocType)
	do message.SetValueAt("SYSA","MSH:3.1")
	set expectSuccess=1
	set expectReturn="send:"_ReturnA02
	set expectReason="rule#8"
	do ..SendMessageToRouter(message,"TestMessageA02", routingProcess, expectSuccess, expectReturn, expectReason)
}

Method TestMessageA03()
{
	Set ReturnA03 = ..#SecondaryRoutingProcessName_":BCBSSC.EG.ProfSvcs.Router.Base.ADT.TransformA03"
	#dim message as EnsLib.HL7.Message

    // Load new HL7Message per UnitTest
	set ..HL7Message=..GetMessage("SourceMessageA03")
	quit:'$IsObject(..HL7Message) $$$ERROR(5001,"Failed to correlate Xdata for Source Message")
	
	set routingProcess = ..#PrimaryRoutingProcessName
	set message=..HL7Message.%ConstructClone(1)
	do message.PokeDocType(message.DocType)
	do message.SetValueAt("SYSA","MSH:3.1")
	set expectSuccess=1
	set expectReturn="send:"_ReturnA03
	set expectReason="rule#7"
	do ..SendMessageToRouter(message,"TestMessageA03", routingProcess, expectSuccess, expectReturn, expectReason)
}
*/
Method TestMessageA04Routing()
{
	Set ReturnA04 = ..#SecondaryRoutingProcessName_":BCBSSC.EG.ProfSvcs.Router.Base.ADT.TransformA01"
	#dim message as EnsLib.HL7.Message
    
	// Load new HL7Message per UnitTest
	set ..HL7Message=..GetMessage("SourceMessageA04")
	quit:'$IsObject(..HL7Message) $$$ERROR(5001,"Failed to correlate Xdata for Source Message")
	
	set routingProcess = ..#PrimaryRoutingProcessName
	set message=..HL7Message.%ConstructClone(1)
	do message.PokeDocType(message.DocType)
	do message.SetValueAt("SYSA","MSH:3.1")
	set expectSuccess=1
	set expectReturn="send:"_ReturnA04
	set expectReason="rule#8"
	do ..SendMessageToRouter(message,"TestMessageA04", routingProcess, expectSuccess, expectReturn, expectReason)
}

Method TestMessageA05()
{
	Set ReturnA05 = ..#SecondaryRoutingProcessName_":BCBSSC.EG.ProfSvcs.Router.Base.ADT.TransformA01"
	#dim message as EnsLib.HL7.Message

    // Load new HL7Message per UnitTest
	set ..HL7Message=..GetMessage("SourceMessageA05")
	quit:'$IsObject(..HL7Message) $$$ERROR(5001,"Failed to correlate Xdata for Source Message")
	
	set routingProcess = ..#PrimaryRoutingProcessName
	set message=..HL7Message.%ConstructClone(1)
	do message.PokeDocType(message.DocType)
	do message.SetValueAt("SYSA","MSH:3.1")
	set expectSuccess=1
	set expectReturn="send:"_ReturnA05
	set expectReason="rule#8"
	do ..SendMessageToRouter(message,"TestMessageA05", routingProcess, expectSuccess, expectReturn, expectReason)
}

Method TestMessageA06()
{
	Set ReturnA06 = ..#SecondaryRoutingProcessName_":BCBSSC.EG.ProfSvcs.Router.Base.ADT.TransformA01"
	#dim message as EnsLib.HL7.Message

    // Load new HL7Message per UnitTest
	set ..HL7Message=..GetMessage("SourceMessageA06")
	quit:'$IsObject(..HL7Message) $$$ERROR(5001,"Failed to correlate Xdata for Source Message")
	
	set routingProcess = ..#PrimaryRoutingProcessName
	set message=..HL7Message.%ConstructClone(1)
	do message.PokeDocType(message.DocType)
	do message.SetValueAt("SYSA","MSH:3.1")
	set expectSuccess=1
	set expectReturn="send:"_ReturnA06
	set expectReason="rule#8"
	do ..SendMessageToRouter(message,"TestMessageA06", routingProcess, expectSuccess, expectReturn, expectReason)
}

Method TestMessageA08()
{
	Set ReturnA08 = ..#SecondaryRoutingProcessName_":BCBSSC.EG.ProfSvcs.Router.Base.ADT.TransformA01"
	#dim message as EnsLib.HL7.Message

    // Load new HL7Message per UnitTest
	set ..HL7Message=..GetMessage("SourceMessageA08")
	quit:'$IsObject(..HL7Message) $$$ERROR(5001,"Failed to correlate Xdata for Source Message")
	
	set routingProcess = ..#PrimaryRoutingProcessName
	set message=..HL7Message.%ConstructClone(1)
	do message.PokeDocType(message.DocType)
	do message.SetValueAt("SYSA","MSH:3.1")
	set expectSuccess=1
	set expectReturn="send:"_ReturnA08
	set expectReason="rule#8"
	do ..SendMessageToRouter(message,"TestMessageA08", routingProcess, expectSuccess, expectReturn, expectReason)
}

Method TestMessageA13()
{
	Set ReturnA28 = ..#SecondaryRoutingProcessName_":BCBSSC.EG.ProfSvcs.Router.Base.ADT.TransformA01"
	#dim message as EnsLib.HL7.Message

    // Load new HL7Message per UnitTest
	set ..HL7Message=..GetMessage("SourceMessageA13")
	quit:'$IsObject(..HL7Message) $$$ERROR(5001,"Failed to correlate Xdata for Source Message")
	
	set routingProcess = ..#PrimaryRoutingProcessName
	set message=..HL7Message.%ConstructClone(1)
	do message.PokeDocType(message.DocType)
	do message.SetValueAt("SYSA","MSH:3.1")
	set expectSuccess=1
	set expectReturn="send:"_ReturnA13
	set expectReason="rule#8"
	do ..SendMessageToRouter(message,"TestMessageA13", routingProcess, expectSuccess, expectReturn, expectReason)
}

/*
Method TestMessageA31()
{
	Set ReturnA31 = ..#SecondaryRoutingProcessName_":BCBSSC.EG.ProfSvcs.Router.Base.ADT.TransformA01"
	#dim message as EnsLib.HL7.Message

    // Load new HL7Message per UnitTest
	set ..HL7Message=..GetMessage("SourceMessageA31")
	quit:'$IsObject(..HL7Message) $$$ERROR(5001,"Failed to correlate Xdata for Source Message")
	
	set routingProcess = ..#PrimaryRoutingProcessName
	set message=..HL7Message.%ConstructClone(1)
	do message.PokeDocType(message.DocType)
	do message.SetValueAt("SYSA","MSH:3.1")
	set expectSuccess=1
	set expectReturn="send:"_ReturnA31
	set expectReason="rule#8"
	do ..SendMessageToRouter(message,"TestMessageA31", routingProcess, expectSuccess, expectReturn, expectReason)
}
*/
Method TestCorrectAssigningAuthorityForA01()
{
	
	#dim message as EnsLib.HL7.Message
	
    // Load new HL7Message per UnitTest
	set ..HL7Message=..GetMessage("SourceMessageA01")
	quit:'$IsObject(..HL7Message) $$$ERROR(5001,"Failed to correlate Xdata for Source Message")
	
	//source of transform process
	set routingProcess = ..#SecondaryRoutingProcessName
	set message=..HL7Message.%ConstructClone(1)
	do message.PokeDocType(message.DocType)
	do message.SetValueAt("SYSA","MSH:3.1")
	//Check that output has MSH:4 = AssigningAuthority
	set expectSuccess=1
	set expectElement="MSH:4"
	set expectReturnVal="MUSC"
	do ..SendMessageReturnOutput(message,"TestMessageA01", routingProcess, expectSuccess, expectElement, expectReturnVal)
}

Method TestEncounterNumberPresent()
{
	#dim message as EnsLib.HL7.Message
	
    // Load new HL7Message per UnitTest
	set ..HL7Message=..GetMessage("SourceMessageA01")
	quit:'$IsObject(..HL7Message) $$$ERROR(5001,"Failed to correlate Xdata for Source Message")
	
	//source of transform process
	set routingProcess = ..#SecondaryRoutingProcessName
	set message=..HL7Message.%ConstructClone(1)
	do message.PokeDocType(message.DocType)
	do message.SetValueAt("SYSA","MSH:3.1")
	//Check that output has PV1:19 is not empty
	set expectSuccess=1
	set expectElement="PV1:19"
	set expectReturnVal="1197112023"
	do ..SendMessageReturnOutput(message,"TestMessageA01", routingProcess, expectSuccess, expectElement, expectReturnVal)
}

/*
Method TestAL1CodeValueMapped()
{
	Set ReturnA01 = "HS.Gateway.HL7.InboundProcess:ProfSvcs.Router.Base.ADT.Transform01"
	#dim message as EnsLib.HL7.Message

    // Load new HL7Message per UnitTest
	set ..HL7Message=..GetMessage("SourceMessageA01")
	quit:'$IsObject(..HL7Message) $$$ERROR(5001,"Failed to correlate Xdata for Source Message")

	set message=..HL7Message.%ConstructClone(1)
	do message.SetValueAt("SYSC","MSH:3.1")
	set expectSuccess=0
	set expectReturn=""
	set expectReason="rule#1"
	do ..SendMessage(message,"TestMessageC", expectSuccess, expectReturn, expectReason)
}

Method TestDG1CodeValueMapped()
{
	Set ReturnA01 = "HS.Gateway.HL7.InboundProcess:ProfSvcs.Router.Base.ADT.Transform01"
	#dim message as EnsLib.HL7.Message

    // Load new HL7Message per UnitTest
	set ..HL7Message=..GetMessage("SourceMessageA01")
	quit:'$IsObject(..HL7Message) $$$ERROR(5001,"Failed to correlate Xdata for Source Message")

	set message=..HL7Message.%ConstructClone(1)
	do message.SetValueAt("SYSC","MSH:3.1")
	set expectSuccess=0
	set expectReturn=""
	set expectReason="rule#1"
	do ..SendMessage(message,"TestMessageC", expectSuccess, expectReturn, expectReason)
}
*/
Method TestPD1LocationMapped()
{
	Set ReturnA01 = "HS.Gateway.HL7.InboundProcess:BCBSSC.EG.ProfSvcs.Router.Base.ADT.Transform01"
	#dim message as EnsLib.HL7.Message

    // Load new HL7Message per UnitTest
	set ..HL7Message=..GetMessage("SourceMessageA01")
	quit:'$IsObject(..HL7Message) $$$ERROR(5001,"Failed to correlate Xdata for Source Message")

	//source of transform process
	set routingProcess = ..#SecondaryRoutingProcessName

	set message=..HL7Message.%ConstructClone(1)
	do message.SetValueAt("SYSC","MSH:3.1")
	set expectSuccess=0
	set expectReturnVal=message.GetValueAt("PD1:3")
	set expectElement="PV1:39"
	do ..SendMessageReturnOutput(message,"TestPD1Location", routingProcess, expectSuccess, expectElement, expectReturnVal)
}

/****Helper Methods ****/
ClassMethod GetMessage(XDataName As %String) As EnsLib.HL7.Message
{
	#dim SourceMessage as EnsLib.HL7.Message
	set xdata=##class(%Dictionary.CompiledXData).%OpenId(..%ClassName(1)_"||"_XDataName,0)
	quit:'$IsObject(xdata) $$$NULLOREF
	set lines=""
	while 'xdata.Data.AtEnd
	{
		set line=$ZSTRIP(xdata.Data.ReadLine(),"<w")
		continue:line=""
		continue:$Extract(line,1)="<" // ignore opening or closing XML tags and start CData tag
		continue:$Extract(line,1)="]" // ignore ]]> closing CDATA
		set lines=lines_($S($L(lines)=0:"",1:$C(..#NewLine)))_line
	}
	set SourceMessage=##class(EnsLib.HL7.Message).ImportFromString(lines,.tSC)
	quit:$$$ISERR(tSC) $$$NULLOREF
	set SourceMessage.DocType=..#HL7Schema
	set tSC=SourceMessage.PokeDocType(..#HL7Schema)
	quit SourceMessage
}

Method SendMessageToRouter(message As EnsLib.HL7.Message = {..HL7Message}, description As %String = "", routerName As %String = "", expectSuccess As %Boolean = 0, expectReturnValue As %String = "", expectReasonValue As %String = "", mode As %String(DISPLAYLIST=",1,2",VALUELIST=",Exact,Contains") = 2)
{
	// Reinitalise Session??
	Set ..SourceBusinessService.%SessionId=""
	Do ..SourceBusinessService.ForceSessionId()
	
	set tSC=..SourceBusinessService.SendRequestSync(..#TargetConfigName,message,.pResponse,-30,description)
	if $$$ISOK(tSC) $$$TRACE(description_" Sent")
	
	if ..SourceBusinessService.%SessionId="" {
		do ..LogMessage("SessionId not set")
		quit
	} else {
		do ..LogMessage("SessionId was "_..SourceBusinessService.%SessionId)	
	}
	
	do ..LogMessage("Router name is :"_routerName)
	set sessionId=..SourceBusinessService.%SessionId
	// Retry behaviour maybe needed if corresponding process hasn't committed its transaction for rule log entry yet
	set SQLCODE=""

	//CNR - Adding logic to search for specific routerName result if parameter is non-empty
	for i=1:1:20 {
		if routerName="" {
			&SQL(SELECT TOP 1 Reason,ReturnValue INTO :actualReasonValue,:actualReturnValue from Ens_Rule.Log where SessionId=:sessionId ORDER BY ID DESC)
		}
		else {
			&SQL(SELECT TOP 1 Reason,ReturnValue INTO :actualReasonValue,:actualReturnValue from Ens_Rule.Log where SessionId=:sessionId and ConfigName=:routerName ORDER BY ID DESC)
		}
		quit:SQLCODE=0
		// Retry if needed
		hang ((i/10)*2)
	}
	if SQLCODE>0 {
		do ..LogMessage("Reason was empty")
		set actualReasonValue=""
		set actualReturnValue=""
		do $$$AssertEquals("","No record found in Rule Log")
	} else {
		do ..LogMessage("Return Value was "_actualReturnValue)
		do ..LogMessage("Expect Return Value was "_expectReturnValue)
	}
	do ..LogMessage("Expect Success is "_expectSuccess)
	
	// We use RuleLog returnValue has value to decide whether was routed somewhere
	// Reason - May note be empty if fails when there is a Truncate rule at the bottom of the rule set.
	if expectSuccess {
		// expect pass condition
		if mode=1 {
			if $L(expectReturnValue)>0 {
				do $$$AssertEquals(actualReturnValue,expectReturnValue,"Expect Same Return:"_description_":Expected Return="_expectReturnValue_";Actual Return="_actualReturnValue)	
			} else {
				do $$$AssertNotEquals("",returnValue,"Expect Match:"_description_":ReturnValue="_returnValue)
			}
			if $L(expectReasonValue)>0 {
				do $$$AssertEquals(actualReasonValue,expectReasonValue,"Expect Same Reason"_description_":Expected Reason="_expectReasonValue_";Actual Reason="_actualReasonValue)	
			} else {
				do $$$AssertNotEquals("",actualReasonValue,"Expect Match:"_description_":ReasonValue="_actualReasonValue)
			}
		} else {
			// mode=2
			if $L(expectReturnValue)>0 {
				do $$$AssertTrue(actualReturnValue[expectReturnValue,"Expect contains Return:"_description_":Expected Return="_expectReturnValue_";Actual Return="_actualReturnValue)
			} else {
				do $$$AssertEquals("",actualReturnValue,"Expect Match:"_description_":ReturnValue="_actualReturnValue)
			}
			if $L(expectReasonValue)>0 {
				do $$$AssertTrue(actualReasonValue[expectReasonValue,"Expect contains Reason:"_description_":Expected Reason="_expectReasonValue_";Actual Reason="_actualReasonValue)
			} else {
				do $$$AssertEquals("",actualReasonValue,"Expect Match:"_description_":ReasonValue="_actualReasonValue)
			}	
		}
	} else {
		// expect fail condition
		if mode=1 {
			if $L(expectReturnValue)>0 {
				do $$$AssertNotEquals(actualReturnValue,expectReturnValue,"Expect NOT Same Return:"_description_":Expected Return="_expectReturnValue_";Actual Return="_actualReturnValue)
			} else {
				do $$$AssertEquals("",actualReturnValue,"Expect No Match:"_description_":ReturnValue="_actualReturnValue)
			}
			if $L(expectReasonValue)>0 {
				do $$$AssertNotEquals(actualReasonValue,expectReasonValue,"Expect NOT Same Reason:"_description_":Expected Reason="_expectReasonValue_";Actual Reason="_actualReasonValue)
			} else {
				do $$$AssertEquals("",actualReasonValue,"Expect No Match:"_description_":ReasonValue="_actualReasonValue)
			}
		} else {
			// mode=2
			if $L(expectReturnValue)>0 {
				do $$$AssertNotTrue(actualReturnValue[expectReturnValue,"Expect NOT contains Return:"_description_":Expected Return="_expectReturnValue_";Actual Return="_actualReturnValue)
			} else {
				do $$$AssertNotEquals("",actualReturnValue,"Expect No Match:"_description_":ReturnValue="_actualReturnValue)
			}
			if $L(expectReasonValue)>0 {
				do $$$AssertNotTrue(actualReasonValue[expectReasonValue,"Expect NOT contains Reason:"_description_":Expected Reason="_expectReasonValue_";Actual Return="_actualReasonValue)
			} else {
				do $$$AssertNotEquals("",actualReasonValue,"Expect No Match:"_description_":ReasonValue="_actualReasonValue)
			}
		}
	}
}

Method SendMessageReturnOutput(message As EnsLib.HL7.Message = {..HL7Message}, description As %String = "", sourceName As %String = "", expectSuccess As %Boolean = 0, expectElement As %String = "", expectReturnValue As %String = "", mode As %String(DISPLAYLIST=",1,2",VALUELIST=",Exact,Contains") = 2)
{
	// Reinitalise Session??
	Set ..SourceBusinessService.%SessionId=""
	Do ..SourceBusinessService.ForceSessionId()
	
	set tSC=..SourceBusinessService.SendRequestSync(..#TargetConfigName,message,.pResponse,-30,description)
	if $$$ISOK(tSC) $$$TRACE(description_" Sent")
	
	if ..SourceBusinessService.%SessionId="" {
		do ..LogMessage("SessionId not set")
		quit
	} else {
		do ..LogMessage("SessionId was "_..SourceBusinessService.%SessionId)	
	}
	
	do ..LogMessage("Source Config Name name is :"_sourceName)
	set sessionId=..SourceBusinessService.%SessionId
	// Retry behaviour maybe needed if corresponding process hasn't committed its transaction for rule log entry yet
	set SQLCODE=""

	//CNR - Adding logic to search for specific routerName result if parameter is non-empty
	for i=1:1:20 {
		if sourceName="" {
			&SQL(SELECT TOP 1 MessageBodyId INTO :messageBodyId FROM Ens.MessageHeader where SessionId=:sessionId ORDER BY ID DESC)
		}
		else {
			&SQL(SELECT TOP 1 MessageBodyId INTO :messageBodyId FROM Ens.MessageHeader where SessionId=:sessionId and SourceConfigName=:sourceName)		
		}
		quit:SQLCODE=0
		// Retry if needed
		hang ((i/10)*2)
	}
	if SQLCODE>0 {
		do ..LogMessage("No message body id found for Session Id")
		set messageBodyId=""
		do $$$AssertEquals("","No message body id found for Session Id")
	} else {
		do ..LogMessage("Message Body Id was "_messageBodyId)
	}
	
	
	do ..LogMessage("Expect Success is "_expectSuccess)
	// We use the Message body id to check the HL7 output in EnsLib.HL7.Message 
	//Get the Actual Return value for the expectedElement
	if messageBodyId'=""{
		set hl7Body = ##class(EnsLib.HL7.Message).%OpenId(messageBodyId)

		Set tSeparators = "|^~\&"_$Char(13,10)
        Set msgStream = ##class(%Stream.GlobalCharacter).%New()    
        do hl7Body.OutputToLibraryStream(.msgStream, tSeparators) 

		do ..LogMessage("Testing for value "_expectElement)
		set actualReturnValue =  hl7Body.GetValueAt(expectElement)
		do ..LogMessage("Found value "_actualReturnValue)
	}
	else{
		do $$$AssertEquals("","Unable to test output message")
	}

	if expectSuccess {
		// expect pass condition
		if mode=1 {
			if $L(expectReturnValue)>0 {
				do $$$AssertEquals(actualReturnValue,expectReturnValue,"Expect Same Return:"_description_":Expected Return="_expectReturnValue_";Actual Return="_actualReturnValue)	
			} else {
				//CNR: What is happening here? Need to fix this
				do $$$AssertNotEquals("",actualReturnValue,"Expect Match:"_description_":ReturnValue="_actualReturnValue)
			}
		} else {
			// mode=2
			if $L(expectReturnValue)>0 {
				do $$$AssertTrue(actualReturnValue[expectReturnValue,"Expect contains Return:"_description_":Expected Return="_expectReturnValue_";Actual Return="_actualReturnValue)
			} else {
				do $$$AssertEquals("",actualReturnValue,"Expect Match:"_description_":ReturnValue="_actualReturnValue)
			}
		}
	} else {
		// expect fail condition
		if mode=1 {
			if $L(expectReturnValue)>0 {
				do $$$AssertNotEquals(actualReturnValue,expectReturnValue,"Expect NOT Same Return:"_description_":Expected Return="_expectReturnValue_";Actual Return="_actualReturnValue)
			} else {
				do $$$AssertEquals("",actualReturnValue,"Expect No Match:"_description_":ReturnValue="_actualReturnValue)
			}
		} else {
			// mode=2
			if $L(expectReturnValue)>0 {
				do $$$AssertNotTrue(actualReturnValue[expectReturnValue,"Expect NOT contains Return:"_description_":Expected Return="_expectReturnValue_";Actual Return="_actualReturnValue)
			} else {
				do $$$AssertNotEquals("",actualReturnValue,"Expect No Match:"_description_":ReturnValue="_actualReturnValue)
			}

		}
	}
}

XData SourceMessageA01
{
<test><![CDATA[
MSH|^~\&|REGADT|SEATTLEGR|IFENG||199601061253||ADT^A01|000001|P|2.3.1|1||
EVN|A01|199601061000|199601101400|1
PID|||999473857^^^GENHOSP|253763|MASSIE^JAMES^A||19560129|M|||87 MAIN ST^^CAMBRIDGE^MA^02142^||(900)485-5344|(900)485-5344|ENGLISH|S|C|10199925|371-66-9256
PD1|||||||||
NK1||||||
PV1||O|||||0148^ADDISON^JAMES|0148^ADDISON^JAMES|0148^ADDISON^JAMES|AMB|||||||0148^ADDISON^JAMES|S|1400|A|||||||||||||||||GENHOSP
PV2||||||||199601101400|199601101400
DB1|||||||||||
OBX||ST|1010.1^BODY WEIGHT||62|kg
OBX||ST|1010.1^HEIGHT||190|cm
AL1|||||||||||
DG1|||||||||||
DRG|||||||||||
PR1|||||||||||
ROL|||||||||||
GT1|||||||||||
IN1|||||||||||
IN2|||||||||||
IN3|||||||||||
ACC|||||||||||
UB1|||||||||||
UB2|||||||||||
]]></test>
}

XData SourceMessageA04
{
<test><![CDATA[
MSH|^~\&|MT|BMH|||202309080831||ADT^A04|213179274|P|2.4|||AL|NE|
EVN|A04|202309080831||ENREGOUT|EFOYE^Foye^Ebony^C^^^^^^^^^XX|202309080829|
PID|1||D107496^^^^MR^BMH~250-02-2202^^^^SS^BMH~M0-.132296^^^^PI^BMH~M00124133^^^^EMR^BMH~FB54C1DC-A6EC-46A5-8215-E1BAFF42BCC1^^^^PT^BMH||COLLINS^MARY^RICH^^^^L~COLLINS^MARY^^^^^U||19520107|F||W|2 HARVEST LANE^^LADYS ISLAND^SC^29907^^^^SC013||843-522-8761^PRN^H^martieandrod@yahoo.com~843-812-3935^ORN^C||E|M|BA|H04278984|250-02-2202|||NOTHISPANI|
NK1|1|COLLINS^RODERICK|SP^Spouse|2 HARVEST LANE^^BEAUFORT^SC^29907-2014|843-522-8761^PRN^H~843-812-2279^ORN^C||NOK|
NK1|2|R|||||EMP||||||RETIRED|||||||||||||||||||||R|
PV1|1|O|LAB|EL|||RVYGE^Vyge^Robert^G^^^MD^^^^^^XX|||||||2||||CLI||MCR|||||||||||||||||||BMH||REG|||202309080829|
PV2|1||||||||||||||||||||||||EL|||||||||||N|
ROL|1|AD|PP|RVYGE^Vyge^Robert^G^^^MD^^^^^^XX|
ROL|2|AD|AT|RVYGE^Vyge^Robert^G^^^MD^^^^^^XX|
OBX|1|CE|ADM.ETHN^Ethnicity^ADM||A^American||||||F|
OBX|2|TX|ADM.PASYN^May someone from your church come to visit you?^ADM||N||||||F|
OBX|3|TX|ADMDIRECTORY^I wish to have my name listed in the system directory?^ADM||Y||||||F|
AL1|1|MA|000069^No Known Allergies^L^No Known Allergies^^allergy.id|U||20230223|
DG1|1||E78.5^Hyperlipidemia, unspecified^I10|||W|
DRG|40.1^Version 40.1^ICD10|
GT1|1||COLLINS^MARY^RICH||2 HARVEST LANE^^LADYS ISLAND^SC^29907|843-522-8761^PRN^H~843-812-3935^ORN^C|||||S|250-02-2202||||R|
IN1|1|MCR||MEDICARE PART A and B|2300 SPRINGDALE DRIVE^^CAMDEN^SC^29020||855-696-0705||RETIRED||R|20230908||||COLLINS^MARY^RICH|S|19520107|2 HARVEST LANE^^LADYS ISLAND^SC^29907||||||||||20230908|EFOYE||||||1F61P84QR80||||||R^Retired|F||Verified|
IN2|1|250-02-2202||||||||||||||||||||||||||||||||||||||||W|M||||||||||||||||||||843-522-8761|
IN1|2|BCFEP2||BC FEP SECONDARY|P.O. BOX 600601^^COLUMBIA^SC^29260||(888)930-2345|113||||20230908||||COLLINS^RODERICK^N|SP|19491104|2 HARVEST LN^^LADYS ISLAND^SC^29907||||||||||20230908|EFOYE||||||R13601993||||||P^Part Time|M|SEA ISLAND PARKWAY^^LADYS ISLAND^SC^29907|Pending|
IN2|2|251925925||||||||||||||||||||||||||||||||||||||||W|M||||||||||||||||||||843-522-8761|
IN1|3|SP||SELF PAY||||||||20230908|
UB2|1||||||11^20230908|
ACC|202309080830|11^ONSET OF SYMPTOMS ILLNESS|
]]></test>
}

XData SourceMessageA05
{
<test><![CDATA[
MSH|^~\&|MT|BMH|||202309080841||ADT^A05|213179714|P|2.4|||AL|NE|
EVN|A05|202309080841||ENPRESDS|PRATTRAY^Rattray^Patricia^A^^^^^^^^^XX|202309151000|
PID|1||D156389^^^^MR^BMH~257-92-0898^^^^SS^BMH~M1-.51759^^^^PI^BMH~M00049203^^^^EMR^BMH~AE716E9A-5E60-4C99-8440-B85741182D26^^^^PT^BMH||GINN^CATHY^M^^^^L||19531214|F||W|3209 MILL POND RD^^VARNVILLE^SC^29944^^^^SC049||803-842-5505^PRN^C^SKIMANN26@GMAIL.COM~803-942-6945^ORN^C||E|M|BA|H04279002|257-92-0898|||NOTHISPANI|
NK1|1|RHODEN^ELLEN|O^Other Relationship|3209 MILL POND RD^^VARNVILLE^SC^29944|803-942-0956^PRN^C||NOK|
NK1|2|GINN^EVERETT|SP^Spouse|3209 MILL POND RD^^VARNVILLE^SC^29944|803-942-9253^PRN^C||PTN|
NK1|3|R|||||EMP||||||RETIRED|
PV1|1|P|OR|||OR|MHILL^Hill^Mary^W^^^MD^^^^^^XX|||||||||Y||SDC||BC|||||||||||||||||||BMH||PRE|||202309151000|
PV2|1||ECT|||||||||90870||||||||||||||||||||||||N|
ROL|1|AD|AT|MHILL^Hill^Mary^W^^^MD^^^^^^XX|
OBX|1|CE|ADM.ETHN^Ethnicity^ADM||A^American||||||F|
OBX|2|TX|ADM.PASTRC^Comment:^ADM||N||||||F|
AL1|1|DA|F001000491^Sulfa (Sulfonamide Antibiotics)^L^Sulfa (Sulfonamide Antibiotics)^^allergy.id|MO|Rash|20230516|
AL1|2|DA|6470^lorazepam^RXNORM^From Ativan^^allergy.id|MO|Hallucinations|20230516|
AL1|3|DA|2670^codeine^RXNORM^codeine^^allergy.id|U|Unknown|20230516|
AL1|4|DA|8745^promethazine^RXNORM^From Phenergan^^allergy.id|MO|Nightmares|20230516|
AL1|5|DA|1314891^latex^RXNORM^latex^^allergy.id|MO|Other|20230516|
DG1|1||F33.3^Major depressive disorder, recurrent, severe with psychotic symptoms^I10|||W|
DRG|40.1^Version 40.1^ICD10|
GT1|1||GINN^CATHY^ELIZABETH||3209 MILL POND RD^^VARNVILLE^SC^29944|803-842-5505^PRN^C~803-942-6945^ORN^C|||||S|257-92-0898||||R|
IN1|1|BCOOS1||BC OUT OF STATE PRIMARY|P.O. BOX 100300^ATTN: BLUE CARD DEPARTMENT^COLUMBIA^SC^29202||(800)868-2510|212034M3W1|R + L CARRIERS|||20230908||||GINN^EVERETT|SP|19550608|3209 MILL POND RD^^VARNVILLE^SC^29944||||||||||20230908|PRATTRAY||||||RLC791M98717||||||FT^Full Time|M|-^^YEMASSEE^SC^29945|Pending|
IN2|1|257-96-5278||||||||||||||||||||||||||||||||||||||||W|M||||||||||||||||||||803-942-9253|
IN1|2|MCR||MEDICARE PART A and B|2300 SPRINGDALE DRIVE^^CAMDEN^SC^29020||855-696-0705||RETIRED||R|20230908||||GINN^CATHY^ELIZABETH|S|19531214|3209 MILL POND RD^^VARNVILLE^SC^29944||||||||||20230908|PRATTRAY||||||6D20FT5PH27|||||||F||Pending|
IN2|2|257-92-0898||||||||||||||||||||||||||||||||||||||||W|M||||||||||||||||||||803-842-5505|
IN1|3|SP||SELF PAY||||||||20230908|
]]></test>
}

XData SourceMessageA06
{
<test><![CDATA[

]]></test>
}

XData SourceMessageA08
{
<test><![CDATA[
MSH|^~\&|MT|BMH|||202309080909||ADT^A08|213180924|P|2.4|||AL|NE|
EVN|A08|202309080909||EDREGRCR|FVILLANUE^Villanueva^Fidelia^^^^^^^^^^XX|202309050911|
PID|1||D299709^^^^MR^BMH~259-66-2140^^^^SS^BMH~M1-B20131022103326000^^^^PI^BMH~M00357360^^^^EMR^BMH~1007A078-3016-4202-8C49-0289B52ACE3A^^^^PT^BMH||MORGAN^HERMAN^^^^^L||19431015|M||B|2331 CASABLANCA CIRCLE^^PORT ROYAL^SC^29935^^^^SC013||862-307-5101^PRN^C~843-522-0050^ORN^H||E|W|ME|H04274958|259-66-2140|||NOTHISPANI|
NK1|1|JACKSON^ALIYAH|SC^Step Child|2331 CASABLANCA CIRCLE^^PORT ROYAL^SC^29935|917-553-7281^PRN^C||NOK|
NK1|2|FYALL^VERNELL|O^Other Relationship|2331 CASABLANCA CIRCLE^^PORT ROYAL^SC^29935|843-812-4470^PRN^C||PTN|
NK1|3|R|||||EMP||||||RETIRED|
PV1|1|O|MOIC|EL||MOIC|SBAISCH^Baisch^Susanne^T^^^NP^^^^^^XX|||||||2||||RCR||MCR|||||||||||||||||||BMH||REG|||202309050911|
PV2|1||MOIC INJ Retacrit (epoetin alfa-epbx)D63.1/D50.9|||||||||Account Created From H04263315|||||||||||||EL|||||||||||N|
ROL|1|AD|PP|SBAISCH^Baisch^Susanne^T^^^NP^^^^^^XX|
ROL|2|AD|AT|SBAISCH^Baisch^Susanne^T^^^NP^^^^^^XX|
OBX|1|ST|1010.1^WEIGHT^CPT4||74.389|kg|||||F|||202309050927|
OBX|2|ST|1010.3^HEIGHT^CPT4||172.72|cm|||||F|||202309050927|
AL1|1|MA|000069^No Known Allergies^L^NKA^^allergy.id|U||20230629|
DG1|1||D50.9^Iron deficiency anemia, unspecified^I10|||W|
DRG|40.1^Version 40.1^ICD10|
GT1|1||MORGAN^HERMAN||2331 CASABLANCA CIR^^PORT ROYAL^SC^29935|862-307-5101^PRN^C~843-522-0050^ORN^H|||||S|259-66-2140||||R|
IN1|1|MCR||MEDICARE PART A and B|2300 SPRINGDALE DRIVE^^CAMDEN^SC^29020||855-696-0705||RETIRED||R|20230901||Track M1-B20230608125112021||MORGAN^HERMAN|S|19431015|2331 CASABLANCA CIR^^PORT ROYAL^SC^29935||||||||||20230608|ALWILSON||||||3H10AT7DF04|||||||M||NOAUTH|
IN2|1|259-66-2140||||||||||||||||||||||||||||||||||||||||B|W||||||||||||||||||||862-307-5101|
IN1|2|BCFEP2||BC FEP SECONDARY|P.O. BOX 600601^^COLUMBIA^SC^29260||(888)930-2345|111|RETIRED||R|20230901||Track M0-B20230608125133908||MORGAN^HERMAN|S|19431015|2331 CASABLANCA CIR^^PORT ROYAL^SC^29935||||||||||20230608|ALWILSON||||||R60103943||||||R^Retired|M||NOAUTH|
IN2|2|259-66-2140||||||||||||||||||||||||||||||||||||||||B|W||||||||||||||||||||862-307-5101|
IN1|3|TRILIFE||TRICARE FOR LIFE|P.O. BOX 7890^^MADISON^WI^53707-7890||(866)773-0404||USARMY/RET||USARMY/RET|20230901||Track M1-B20230901101613696||MORGAN^HERMAN|S|19431015|2331 CASABLANCA CIR^^PORT ROYAL^SC^29935||||||||||20230901|ALWILSON||||||00246784300||||||R^Retired|M||NOAUTH|
IN2|3|259-66-2140||||||||||||||||||||||||||||||||||||||||B|W||||||||||||||||||||862-307-5101|
IN1|4|SP||SELF PAY||||||||20230901|
UB2|1||||||11^20230905|
ACC|202309050914|11^ONSET OF SYMPTOMS ILLNESS|
]]></test>
}

XData SourceMessageA13
{
<test><![CDATA[

]]></test>
}

}
