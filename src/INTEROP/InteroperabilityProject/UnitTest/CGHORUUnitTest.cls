Class INTEROP.InteroperabilityProject.UnitTest.CGHORUUnitTest Extends LN.UnitTest.RuleSet.HL7
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
/// d ##class(INTEROP.InteroperabilityProject.UnitTest.CGHORUUnitTest).Debug()
/// </example>
Parameter TestSuite = "CGH-HL7ORU";

/// Override for different schema
Parameter HL7Schema = "2.5.1:ORU_R01";

/// Override with name of existing service on production
Parameter SourceBusinessServiceName = "CGHOruTcpInbound";

/// Override with name of existing business process routing engine on production
Parameter TargetConfigName = "CGHOruRouter";

/// Primary routing process name on production
Parameter PrimaryRoutingProcessName = "CGHOruRouter";

/// Secondary routing process name on production
Parameter SecondaryRoutingProcessName = "DataWarehouseHL7Outbound-CGH";

Parameter AssigningAuthority = "CGH";

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
MSH|^~\&|MESA_RPT_MGR|UVMC|iFW|XYZ|||ORU^R01|MESA3b|P|2.4||||||||
PID|||CR3^^^ADT1||CRTHREE^PAUL|||||||||||||PatientAcct||||||||||||
PD1||||GERM|
PV1||1|CE||||12345^SMITH^BARON^H|||||||||||
OBR||1234567|||||20010501141500.0000|||||||||||||||||ABC|F||||||||||||||||||
OBX|1|HD|13579.000^WNL^LOINC^^^||1.113654.1.2001.30.2.1||||||F||||||
OBX|2|TX|SR Text||Radiology Report History Cough Findings PA evaluation of the chest demonstrates the lungs to be expanded and clear.  Conclusions Normal PA chest x-ray.||||||F||||||
CTI|study1|^1|^10_EP1
]]></test>
}

}
