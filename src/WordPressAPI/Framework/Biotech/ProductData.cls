Class WordPressAPI.Framework.Biotech.ProductData Extends %RegisteredObject
{

ClassMethod InsertSampleData() As %Status
{
    Set sc = $$$OK
    
    // Check if ProductClass table exists, create if it doesn't
    If '##class(%Dictionary.CompiledClass).%ExistsId("WordPressAPI.Framework.Biotech.ProductClass") {
        Set sc = ##class(WordPressAPI.Framework.Biotech.ProductClass).%BuildIndices()
        If $$$ISERR(sc) Return sc
    }
    
    // Check if Product table exists, create if it doesn't
    If '##class(%Dictionary.CompiledClass).%ExistsId("WordPressAPI.Framework.Biotech.Product") {
        Set sc = ##class(WordPressAPI.Framework.Biotech.Product).%BuildIndices()
        If $$$ISERR(sc) Return sc
    }
    
    // First, create product classes with correct IDs
    Set productClasses("Avidin-Biotin Reagents") = 1
    Set productClasses("Cell Line Lysates") = 2
    Set productClasses("ELISA Kits") = 3
    Set productClasses("Isotype Controls") = 4
    Set productClasses("Monoclonal Antibodies") = 5
    Set productClasses("Polyclonal Antibodies") = 6
    Set productClasses("Recombinant Proteins") = 7
    Set productClasses("Secondary Antibodies") = 8
    Set productClasses("Substrates and Assay Reagents") = 9
    
    Set className = ""
    For {
        Set className = $Order(productClasses(className))
        Quit:className=""
        
        Set productClass = ##class(WordPressAPI.Framework.Biotech.ProductClass).%New()
        Set productClass.CID = productClasses(className)
        Set productClass.ClassName = className
        Set sc = productClass.%Save()
        If $$$ISERR(sc) Quit
    }
    If $$$ISERR(sc) Return sc
    
    // Now create products with correct product class assignments
    Set products = [
        {
            "ProductName": "Recombinant Mouse TNF-alpha Protein",
            "CatalogNumber": "RM-TNFa-050",
            "Target": "Tumor Necrosis Factor alpha",
            "HostSpecies": "Mouse",
            "Applications": "Cell Culture, Bioassays",
            "CitationPMID": "PMID:987654",
            "ProductClass": "Recombinant Proteins"
        },
        {
            "ProductName": "Anti-Human CD3 Monoclonal Antibody (Clone UCHT1)",
            "CatalogNumber": "MHCD3-100",
            "Target": "CD3",
            "HostSpecies": "Mouse",
            "Applications": "Flow Cytometry, IHC",
            "CitationPMID": "PMID:234567",
            "ProductClass": "Monoclonal Antibodies"
        },
        {
            "ProductName": "Goat Anti-Rabbit IgG (H+L) Secondary Antibody, HRP Conjugated",
            "CatalogNumber": "GAR-IgGHRP-020",
            "Target": "Rabbit IgG (Heavy + Light Chain)",
            "HostSpecies": "Goat",
            "Applications": "Western Blot, ELISA",
            "CitationPMID": "PMID:345678",
            "ProductClass": "Secondary Antibodies"
        },
        {
            "ProductName": "Human IL-6 ELISA Kit",
            "CatalogNumber": "EHIL6-96",
            "Target": "Interleukin-6",
            "HostSpecies": "Human",
            "Applications": "Quantification of Human IL-6",
            "CitationPMID": "PMID:456789",
            "ProductClass": "ELISA Kits"
        },
        {
            "ProductName": "Recombinant Human VEGF-A Protein",
            "CatalogNumber": "RH-VEGFA-025",
            "Target": "Vascular Endothelial Growth Factor A",
            "HostSpecies": "Human",
            "Applications": "Angiogenesis Assays, Cell Signaling Studies",
            "CitationPMID": "PMID:567890",
            "ProductClass": "Recombinant Proteins"
        },
        {
            "ProductName": "Anti-Mouse IgG Isotype Control (Clone MOPC-21)",
            "CatalogNumber": "MMIC-100",
            "Target": "IgG1, kappa Isotype",
            "HostSpecies": "Mouse",
            "Applications": "Flow Cytometry, IHC Control",
            "CitationPMID": "N/A",
            "ProductClass": "Isotype Controls"
        },
        {
            "ProductName": "TMB Substrate Solution",
            "CatalogNumber": "TMB-100",
            "Target": "Horseradish Peroxidase (HRP)",
            "HostSpecies": "N/A",
            "Applications": "ELISA Substrate",
            "CitationPMID": "N/A",
            "ProductClass": "Substrates and Assay Reagents"
        },
        {
            "ProductName": "Rabbit Anti-TGF-beta Polyclonal Antibody",
            "CatalogNumber": "RP-TGFb-100",
            "Target": "Transforming Growth Factor beta",
            "HostSpecies": "Rabbit",
            "Applications": "Western Blot, IHC",
            "CitationPMID": "PMID:678901",
            "ProductClass": "Polyclonal Antibodies"
        },
        {
            "ProductName": "Biotinylated Anti-Human TNF-alpha Antibody",
            "CatalogNumber": "BH-TNFa-050",
            "Target": "Tumor Necrosis Factor alpha",
            "HostSpecies": "Human",
            "Applications": "ELISA, Western Blot",
            "CitationPMID": "PMID:789012",
            "ProductClass": "Avidin-Biotin Reagents"
        },
        {
            "ProductName": "Jurkat Cell Lysate",
            "CatalogNumber": "CL-JURKAT",
            "Target": "Multiple",
            "HostSpecies": "Human",
            "Applications": "Western Blot Standard",
            "CitationPMID": "N/A",
            "ProductClass": "Cell Line Lysates"
        }
    ]
    
    For i=1:1:products.%Size() {
        Set product = ##class(WordPressAPI.Framework.Biotech.Product).%New()
        Set productData = products.%Get(i-1)  // Arrays are 0-based in ObjectScript
        Set product.ProductName = productData.ProductName
        Set product.CatalogNumber = productData.CatalogNumber
        Set product.Target = productData.Target
        Set product.HostSpecies = productData.HostSpecies
        Set product.Applications = productData.Applications
        Set product.CitationPMID = productData.CitationPMID
        
        // Find the corresponding product class
        Set classId = $get(productClasses(productData.ProductClass))
        If classId="" {
            Set sc = $$$ERROR($$$GeneralError, "Product class not found: "_productData.ProductClass)
            Quit
        }
        Set productClass = ##class(WordPressAPI.Framework.Biotech.ProductClass).%OpenId(classId)
        If '$IsObject(productClass) {
            Set sc = $$$ERROR($$$GeneralError, "Product class not found with ID: "_classId)
            Quit
        }
        Set product.ProductClass = productClass
        
        Set sc = product.%Save()
        If $$$ISERR(sc) Quit
    }
    
    Return sc
}

}
