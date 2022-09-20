pageextension 81700 "FDD Customer List" extends "Customer List" //22
{
    layout
    {
        addfirst(factboxes)
        {
            part(FDDDragAndDropFactbox; "FDD Drag & Drop Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(18), "No." = field("No.");
            }
        }
    }
}
