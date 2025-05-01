Class IRISAPPPKG.FoundationProduction Extends Ens.Production [ Not ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="IRISAPPPKG.FoundationProduction" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>

  <Item Name="CGHOruTcpInbound" Category="CGH ORU" ClassName="EnsLib.HL7.Service.TCPService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5.1</Setting>
    <Setting Target="Host" Name="TargetConfigNames">CGHOruRouter</Setting>
  </Item>
  <Item Name="GHAdtTcpInbound" Category="GH ADT" ClassName="EnsLib.HL7.Service.TCPService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5.1</Setting>
    <Setting Target="Host" Name="TargetConfigNames">GHAdtRouter</Setting>
  </Item>
    <Item Name="SGHAdtTcpInbound" Category="SGH ADT" ClassName="EnsLib.HL7.Service.TCPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5.1</Setting>
    <Setting Target="Host" Name="TargetConfigNames">SGHAdtRouter</Setting>
  </Item>
    <Item Name="SHHAdtTcpInbound" Category="SHH ADT" ClassName="EnsLib.HL7.Service.TCPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5.1</Setting>
    <Setting Target="Host" Name="TargetConfigNames">SHHAdtRouter</Setting>
  </Item>
  <Item Name="SWCAdtTcpInbound" Category="SWC ADT" ClassName="EnsLib.HL7.Service.TCPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5.1</Setting>
    <Setting Target="Host" Name="TargetConfigNames">SWCAdtRouter</Setting>
  </Item>


  <Item Name="CGHOruRouter" Category="CGH ORU" ClassName="EnsLib.HL7.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">INTEROP.InteroperabilityProject.CGH.CGHOruRoutingRule.CGHOruRouter</Setting>
  </Item>
  <Item Name="GHAdtRouter" Category="GH ADT" ClassName="EnsLib.HL7.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">INTEROP.InteroperabilityProject.GH.GHAdtRoutingRule.GHAdtRouter</Setting>
  </Item>
    <Item Name="SGHAdtRouter" Category="SGH ADT" ClassName="EnsLib.HL7.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">INTEROP.InteroperabilityProject.SGH.SGHAdtRoutingRule.SGHAdtRouter</Setting>
  </Item>
  <Item Name="SHHAdtRouter" Category="SHH ADT" ClassName="EnsLib.HL7.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">INTEROP.InteroperabilityProject.SHH.SHHAdtRoutingRule.SHHAdtRouter</Setting>
  </Item>
  <Item Name="SWCAdtRouter" Category="SWC ADT" ClassName="EnsLib.HL7.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">INTEROP.InteroperabilityProject.SWC.SWCAdtRoutingRule.SWCAdtRouter</Setting>
  </Item>


  <Item Name="DataWarehouseHL7Outbound-CGH" Category="CGH ORU" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="DataWarehouseHL7Outbound-GH" Category="GH ADT" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="DataWarehouseHL7Outbound-SGH" Category="SGH ADT" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="DataWarehouseHL7Outbound-SHH" Category="SHH ADT" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="DataWarehouseHL7Outbound-SWC" Category="SWC ADT" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
