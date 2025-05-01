/// 
Class INTEROP.InteroperabilityProject.SWC.SWCAdtRoutingRule.SWCAdtRouter Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.HL7.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="" production="IRISAPPPKG.FoundationProduction">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="Route to SWC Data Warehouse" disabled="false">
<constraint name="source" value="SWCAdtTcpInbound"></constraint>
<constraint name="docCategory" value="2.5.1"></constraint>
<constraint name="docName" value="ADT_A01"></constraint>
<when condition="1" comment="">
<send transform="" target="DataWarehouseHL7Outbound-SWC"></send>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
