/// 
Class INTEROP.InteroperabilityProject.SGH.SGHAdtRoutingRule.SGHAdtRouter Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.HL7.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="" production="IRISAPPPKG.FoundationProduction">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="Route to SGH Data Warehouse" disabled="false">
<constraint name="source" value="SGHAdtTcpInbound"></constraint>
<constraint name="docCategory" value="2.5.1"></constraint>
<constraint name="docName" value="ADT_A01"></constraint>
<when condition="1" comment="">
<send transform="" target="DataWarehouseHL7Outbound-SGH"></send>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
