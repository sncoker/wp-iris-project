Class INTEROP.InteroperabilityProject.SGH.Transform.AdtTransform Extends Ens.DataTransformDTL [ DependsOn = EnsLib.HL7.Message ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

/// Revision number of this class
Parameter SrcVer = 4;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='EnsLib.HL7.Message' sourceDocType='2.5.1:ADT_A01' targetDocType='2.5.1:ADT_A01' create='copy' language='objectscript' >
<annotation>Custom transform logic for SGH.</annotation>
<assign value='source.{PD1:PatientPrimaryFacility().OrganizationName}' property='target.{PV1:AssignedPatientLocation.Facility}' action='set' />
</transform>
}

}
